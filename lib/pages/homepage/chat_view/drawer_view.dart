import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.sizeOf(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: isMobile ? sizes.width * 0.9 : sizes.width * 0.5,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "UI Engine",
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () => drawerController.hideDrawer(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(child: ListView(children: [
                  ],
                )),
              SizedBox(
                height: 104,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message...',
                                ),
                              ),
                            ),
                            IconButton.filled(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_upward),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text("Gemini 2.5 Flash"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
