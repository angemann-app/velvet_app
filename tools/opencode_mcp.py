"""MCP-Server (stdio) für Claude Code: gibt Routineaufgaben an OpenCode ab.

Claude Code ruft das Werkzeug `opencode_auftrag` auf, OpenCode erledigt den Auftrag mit dem kostenlosen Modell
(Einstellungen und Rechte in ~/.config/opencode/opencode.jsonc) und Claude bekommt nur die Antwort und eine
Übersicht der geänderten Dateien zurück. Prüfen, committen und veröffentlichen bleibt bei Claude Code.

Nur Standardbibliothek. Eingetragen in .mcp.json.
"""
import json
import os
import subprocess
import sys
from pathlib import Path

OPENCODE = os.environ.get("OPENCODE_EXE", r"C:\TOOLS\opencode\opencode.exe")
STANDARD_ORDNER = Path(__file__).resolve().parent.parent
# Nur Projektordner, nie private Inhalte oder Schlüssel.
ERLAUBT = [Path(r"C:\TOOLS\workspace").resolve()]
MAX_ANTWORT = 12000

WERKZEUG = {
    "name": "opencode_auftrag",
    "description": (
        "Gibt eine klar abgegrenzte Routineaufgabe an OpenCode (kostenloses Cloud-Modell) ab, etwa Tests anpassen, "
        "mechanische Umbenennungen oder Übersetzungen von App-Texten. Nie für Fantasie-Texte, Rückmeldungen, Schlüssel "
        "oder private Inhalte. OpenCode committet nicht; das Ergebnis immer mit git diff prüfen."
    ),
    "inputSchema": {
        "type": "object",
        "properties": {
            "auftrag": {"type": "string", "description": "Vollständiger Auftrag: Ziel, erlaubte Dateien, Prüfbefehl."},
            "ordner": {"type": "string", "description": "Arbeitsordner (Standard: dieses Repository)."},
            "minuten": {"type": "integer", "description": "Zeitlimit in Minuten (Standard 15, höchstens 45)."},
        },
        "required": ["auftrag"],
    },
}


def _git(ordner, *args):
    try:
        return subprocess.run(["git", *args], cwd=ordner, capture_output=True, text=True, encoding="utf-8",
                              errors="replace", timeout=60).stdout.strip()
    except Exception as e:  # noqa: BLE001
        return f"(git nicht lesbar: {e})"


def _auftrag(argumente):
    ordner = Path(argumente.get("ordner") or STANDARD_ORDNER).resolve()
    if not any(ordner == e or e in ordner.parents for e in ERLAUBT):
        return f"Abgelehnt: {ordner} liegt nicht unter {', '.join(map(str, ERLAUBT))}.", True
    minuten = max(1, min(int(argumente.get("minuten") or 15), 45))
    vorher = set(_git(ordner, "status", "--porcelain").splitlines())
    try:
        lauf = subprocess.run(
            [OPENCODE, "run", "--standalone", "--auto", argumente["auftrag"]],
            cwd=ordner, capture_output=True, text=True, encoding="utf-8", errors="replace",
            timeout=minuten * 60, stdin=subprocess.DEVNULL,
        )
        antwort, fehler = lauf.stdout.strip(), lauf.returncode != 0
        if fehler:
            antwort += f"\n\n(Exit-Code {lauf.returncode})\n{lauf.stderr.strip()[-2000:]}"
    except subprocess.TimeoutExpired:
        antwort, fehler = f"Zeitlimit von {minuten} Minuten überschritten.", True
    if len(antwort) > MAX_ANTWORT:
        antwort = "…\n" + antwort[-MAX_ANTWORT:]
    nachher = set(_git(ordner, "status", "--porcelain").splitlines())
    neu = sorted(nachher - vorher)
    bericht = [antwort or "(keine Antwort)", "", "Geänderte Dateien durch diesen Auftrag:"]
    bericht += neu or ["(keine)"]
    bericht += ["", "git diff --stat:", _git(ordner, "diff", "--stat") or "(leer)"]
    return "\n".join(bericht), fehler


def _antwort(id_, ergebnis=None, fehler=None):
    nachricht = {"jsonrpc": "2.0", "id": id_}
    if fehler is not None:
        nachricht["error"] = fehler
    else:
        nachricht["result"] = ergebnis
    sys.stdout.write(json.dumps(nachricht, ensure_ascii=False) + "\n")
    sys.stdout.flush()


def main():
    sys.stdin.reconfigure(encoding="utf-8")
    sys.stdout.reconfigure(encoding="utf-8")
    for zeile in sys.stdin:
        if not zeile.strip():
            continue
        try:
            anfrage = json.loads(zeile)
        except json.JSONDecodeError:
            continue
        methode, id_ = anfrage.get("method"), anfrage.get("id")
        if id_ is None:  # Benachrichtigung, z. B. notifications/initialized
            continue
        if methode == "initialize":
            _antwort(id_, {
                "protocolVersion": anfrage.get("params", {}).get("protocolVersion", "2025-06-18"),
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "opencode", "version": "1.0"},
            })
        elif methode == "ping":
            _antwort(id_, {})
        elif methode == "tools/list":
            _antwort(id_, {"tools": [WERKZEUG]})
        elif methode == "tools/call":
            params = anfrage.get("params", {})
            if params.get("name") != WERKZEUG["name"]:
                _antwort(id_, fehler={"code": -32602, "message": "Unbekanntes Werkzeug"})
                continue
            text, ist_fehler = _auftrag(params.get("arguments", {}))
            _antwort(id_, {"content": [{"type": "text", "text": text}], "isError": ist_fehler})
        else:
            _antwort(id_, fehler={"code": -32601, "message": f"Unbekannte Methode {methode}"})


if __name__ == "__main__":
    main()
