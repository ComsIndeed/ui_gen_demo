import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ui_gen_demo/services/chat_view_provider.dart';
import 'package:ui_gen_demo/services/ai_service.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key, required this.drawerController});

  final AdvancedDrawerController drawerController;

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  final _messageController = TextEditingController();
  String _selectedModel = 'gemini-flash-latest';
  List<String> _models = ['gemini-flash-latest'];

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    final aiService = AiService();
    try {
      final models = await aiService.listModels();
      if (mounted) {
        setState(() {
          _models = models;
          if (_models.isNotEmpty && !_models.contains(_selectedModel)) {
            _selectedModel = _models.first;
          }
        });
      }
    } catch (e) {
      // If API key not set or other error, keep default model
      if (mounted) {
        setState(() {
          _models = ['gemini-flash-latest'];
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final provider = context.read<ChatViewProvider>();
      provider.sendMessage(message, modelName: _selectedModel);
      _messageController.clear();
      // widget.drawerController.hideDrawer(); // Keep drawer open to see logs or maybe close it? User didn't specify.
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.sizeOf(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Consumer<ChatViewProvider>(
      builder: (context, provider, child) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: isMobile ? sizes.width * 0.9 : sizes.width * 0.5,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Riverstream",
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      icon: Icon(Icons.settings),
                    ),
                    IconButton(
                      onPressed: () => widget.drawerController.hideDrawer(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.messageWidgets.length,
                    itemBuilder: (context, index) {
                      return provider.messageWidgets[index];
                    },
                  ),
                ),
                SizedBox(
                  height: 128,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type a message...',
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              IconButton.filled(
                                onPressed: _sendMessage,
                                icon: Icon(Icons.arrow_upward),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            initialValue: _selectedModel,
                            onSelected: (String value) {
                              setState(() {
                                _selectedModel = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              _models.sort();
                              return _models.map((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        if (value.contains('preview'))
                                          WidgetSpan(
                                            child: const Icon(
                                              Icons.science,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                        TextSpan(
                                          text: value
                                              .replaceAll('-', ' ')
                                              .split(' ')
                                              .map(
                                                (word) => word.isNotEmpty
                                                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                                    : '',
                                              )
                                              .join(' '),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            child: Chip(
                              label: Text.rich(
                                TextSpan(
                                  children: [
                                    if (_selectedModel.contains('preview'))
                                      WidgetSpan(
                                        child: const Icon(
                                          Icons.science,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    TextSpan(
                                      text: _selectedModel
                                          .replaceAll('-', ' ')
                                          .split(' ')
                                          .map(
                                            (word) => word.isNotEmpty
                                                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                                : '',
                                          )
                                          .join(' '),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
