package org.velvetpulse.app;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** Health-Connect-Typen isoliert laden, damit Android 7 weiter starten kann. */
public final class SchlafdatenLeser {
    public static final String BERECHTIGUNG = "android.permission.health.READ_SLEEP";
    public interface Antwort {
        void fertig(List<Map<String, Object>> daten);
        void fehler(String code);
    }
    public static boolean verfuegbar(Context context) {
        return Build.VERSION.SDK_INT >= 34 && Api34.verfuegbar(context);
    }
    public static void einstellungen(Activity activity) {
        if (Build.VERSION.SDK_INT >= 34) Api34.einstellungen(activity);
    }
    public static void lesen(Activity activity, long start, long ende, Antwort antwort) {
        if (Build.VERSION.SDK_INT < 34) { antwort.fehler("nicht_verfuegbar"); return; }
        Api34.lesen(activity, start, ende, antwort);
    }

    @TargetApi(34)
    private static final class Api34 {
        static boolean verfuegbar(Context c) {
            return c.getSystemService(android.health.connect.HealthConnectManager.class) != null;
        }
        static void einstellungen(Activity a) {
            Intent intent = new Intent(android.health.connect.HealthConnectManager.ACTION_MANAGE_HEALTH_PERMISSIONS);
            intent.putExtra(Intent.EXTRA_PACKAGE_NAME, a.getPackageName());
            a.startActivity(intent);
        }
        static void lesen(Activity a, long start, long ende, Antwort antwort) {
            if (start < 0 || ende <= start || ende - start > 31L * 24 * 3600 * 1000 || ende > System.currentTimeMillis() + 1000) {
                antwort.fehler("ungueltiger_zeitraum"); return;
            }
            android.health.connect.HealthConnectManager manager = a.getSystemService(android.health.connect.HealthConnectManager.class);
            if (manager == null) { antwort.fehler("nicht_verfuegbar"); return; }
            ExecutorService executor = Executors.newSingleThreadExecutor();
            new LeseLauf(a, manager, executor, start, ende, antwort).seite(-1);
        }

        private static final class LeseLauf {
            final Activity activity;
            final android.health.connect.HealthConnectManager manager;
            final ExecutorService executor;
            final long start, ende;
            final Antwort antwort;
            final List<Map<String, Object>> records = new ArrayList<>();
            int seiten = 0;
            LeseLauf(Activity a, android.health.connect.HealthConnectManager m, ExecutorService e, long s, long bis, Antwort r) {
                activity = a; manager = m; executor = e; start = s; ende = bis; antwort = r;
            }
            void fehler(String code) {
                executor.shutdown();
                activity.runOnUiThread(() -> antwort.fehler(code));
            }
            void seite(long token) {
                if (++seiten > 20) { fehler("zu_viele_daten"); return; }
                android.health.connect.ReadRecordsRequestUsingFilters.Builder<android.health.connect.datatypes.SleepSessionRecord> b =
                    new android.health.connect.ReadRecordsRequestUsingFilters.Builder<>(android.health.connect.datatypes.SleepSessionRecord.class)
                    .setTimeRangeFilter(new android.health.connect.TimeInstantRangeFilter.Builder()
                        .setStartTime(java.time.Instant.ofEpochMilli(start)).setEndTime(java.time.Instant.ofEpochMilli(ende)).build())
                    .setPageSize(500).setAscending(true);
                if (token >= 0) b.setPageToken(token);
                try {
                    manager.readRecords(b.build(), executor,
                        new android.os.OutcomeReceiver<android.health.connect.ReadRecordsResponse<android.health.connect.datatypes.SleepSessionRecord>, android.health.connect.HealthConnectException>() {
                        @Override public void onResult(android.health.connect.ReadRecordsResponse<android.health.connect.datatypes.SleepSessionRecord> result) {
                            try {
                                for (android.health.connect.datatypes.SleepSessionRecord r : result.getRecords()) {
                                    if (r.getEndTime().toEpochMilli() > ende) continue;
                                    if (records.size() >= 500) { fehler("zu_viele_daten"); return; }
                                    Map<String, Object> row = new HashMap<>();
                                    row.put("id", r.getMetadata().getId());
                                    row.put("quelle", r.getMetadata().getDataOrigin().getPackageName());
                                    row.put("geaendertMs", r.getMetadata().getLastModifiedTime().toEpochMilli());
                                    row.put("startMs", r.getStartTime().toEpochMilli());
                                    row.put("endeMs", r.getEndTime().toEpochMilli());
                                    row.put("offsetStartMin", r.getStartZoneOffset() == null ? null : r.getStartZoneOffset().getTotalSeconds() / 60);
                                    row.put("offsetEndeMin", r.getEndZoneOffset() == null ? null : r.getEndZoneOffset().getTotalSeconds() / 60);
                                    List<Map<String, Object>> phases = new ArrayList<>();
                                    if (r.getStages().size() > 10000) { fehler("zu_viele_daten"); return; }
                                    for (android.health.connect.datatypes.SleepSessionRecord.Stage s : r.getStages()) {
                                        Map<String, Object> phase = new HashMap<>();
                                        phase.put("startMs", s.getStartTime().toEpochMilli());
                                        phase.put("endeMs", s.getEndTime().toEpochMilli());
                                        phase.put("typ", s.getType());
                                        phases.add(phase);
                                    }
                                    row.put("phasen", phases);
                                    records.add(row);
                                }
                                if (result.getNextPageToken() >= 0) { seite(result.getNextPageToken()); return; }
                                executor.shutdown();
                                activity.runOnUiThread(() -> antwort.fertig(records));
                            } catch (Exception error) { fehler("datenfehler"); }
                        }
                        @Override public void onError(android.health.connect.HealthConnectException error) {
                            fehler("lesefehler");
                        }
                    });
                } catch (SecurityException error) { fehler("berechtigung_fehlt"); }
                  catch (Exception error) { fehler("lesefehler"); }
            }
        }
    }
}
