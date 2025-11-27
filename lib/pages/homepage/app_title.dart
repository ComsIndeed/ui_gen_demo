import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_gen_demo/constants/app_constants.dart';

class AppTitle extends StatelessWidget {
  final double scale;

  const AppTitle({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppConstants.appLogoPath,
          width: 80 * scale,
          height: 80 * scale,
        ),
        SizedBox(width: 8 * scale),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Flow',
                style: GoogleFonts.inter().copyWith(
                  fontSize: 40 * scale,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: 'serract',
                style: GoogleFonts.inter().copyWith(
                  fontSize: 40 * scale,
                  fontWeight: FontWeight.w600,
                  color: Color.lerp(
                    Theme.of(context).colorScheme.onSurface,
                    Colors.grey,
                    0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
