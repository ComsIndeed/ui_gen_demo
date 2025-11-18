import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(width: double.infinity),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ComsIndeed UI Generation App (Think of a name later)",
              style: GoogleFonts.anta(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Expanded(child: ListView.builder(itemBuilder: ))
        ],
      ),
    );
  }
}
