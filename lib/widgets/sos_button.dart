import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/sos/sos_modal.dart';

class SosButton extends StatelessWidget {
  final double size;

  const SosButton({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            SosModal.show(context);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.rose.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.rose.withOpacity(0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.rose.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: AppTheme.rose,
                  size: size * 0.45,
                ),
                const SizedBox(width: 5),
                const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
