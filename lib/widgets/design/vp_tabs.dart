import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/vp_tokens.dart';

/// Reiter im Magazinstil: Text mit Linie darunter statt Kästen mit Rundung (docs/konzepte/designsystem-magazin.md).
class VpTabs {
  /// Eine Reiterleiste für einen `TabController` (zweite Ebene: Unterbereiche). Die [tabs] liefert der Aufrufer
  /// (`Tab(child: …)`), Rahmen, Rundung und Farben kommen von hier.
  static Widget leiste({
    required TabController controller,
    required List<Widget> tabs,
    ValueChanged<int>? onTap,
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(VpAbstand.l, VpAbstand.s, VpAbstand.l, VpAbstand.s),
  }) {
    return Padding(
      padding: margin,
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabs,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: AppTheme.akzentTief, width: VpLinie.akzent)),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppTheme.linie,
        dividerHeight: VpLinie.haar,
        labelColor: AppTheme.tinte,
        unselectedLabelColor: AppTheme.tinteStumm,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
        overlayColor: WidgetStatePropertyAll(AppTheme.akzentLeise),
      ),
    );
  }
}

/// Kapitelleiste der ersten Ebene („01 Körper · 02 Gedanken · 03 Coach“): Serif-Nummern, darunter eine Linie mit Akzentstrich
/// unter dem gewählten Kapitel.
class VpKapitelLeiste extends StatelessWidget {
  final List<String> titel;
  final int index;
  final ValueChanged<int> onChanged;

  const VpKapitelLeiste({super.key, required this.titel, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final typo = context.vp.typo;
    return Container(
      padding: const EdgeInsets.fromLTRB(VpAbstand.l, VpAbstand.s, VpAbstand.l, 0),
      child: Row(children: [
        for (var i = 0; i < titel.length; i++)
          Expanded(
            child: Semantics(
              button: true,
              selected: i == index,
              child: InkWell(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.only(top: VpAbstand.s, bottom: VpAbstand.s),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == index ? AppTheme.akzentTief : AppTheme.linie,
                        width: i == index ? VpLinie.akzent : VpLinie.haar,
                      ),
                    ),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('0${i + 1}', style: typo.zahl.copyWith(fontSize: 13, color: i == index ? AppTheme.akzentTief : AppTheme.tinteStumm)),
                    const SizedBox(height: 2),
                    Text(
                      titel[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typo.titel.copyWith(
                        fontSize: 17,
                        fontWeight: i == index ? FontWeight.w600 : FontWeight.w400,
                        color: i == index ? AppTheme.tinte : AppTheme.tinteStumm,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
