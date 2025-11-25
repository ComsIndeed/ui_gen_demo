# Flowserract 🌀

> **⚠️ Work In Progress** - This project is under active development and not yet production-ready.

A production-grade **Generative UI** application built with Flutter that takes user prompts and generates UI layouts in real-time using LLM streaming.

## ✨ The Magic

Flowserract leverages [`llm_json_stream`](https://pub.dev/packages/llm_json_stream) to parse partial JSON from LLMs *as it arrives*. This enables:

- **Progressive UI Building** — Components visually "pop in" while text is still generating
- **No Waiting** — Users see the UI materialize in real-time rather than waiting for completion
- **Streaming-First Architecture** — Built from the ground up for streaming experiences

## 🎯 Project Vision

### Originally
A demo showcasing the `llm_json_stream` parser package capabilities.

### Now
Evolving into a **fully functional no-code/low-code platform** with:

- **Dynamic State Management** — Generated UIs handle complex state, not just static views
- **Data Persistence** — Integration with local (SQLite/Isar/Hive) and cloud databases (Supabase/Firebase)
- **Interactive Logic** — Components with real `onPressed` events and data manipulation

## 🏗️ Architecture

```
lib/
├── main.dart                          # App entry point with Provider setup
├── aesthetics/                        # Custom painters & visual effects
├── constants/                         # App-wide constants
├── modules/
│   └── streaming_ui_engine/           # Core streaming UI service
├── pages/
│   ├── homepage/                      # Main chat interface
│   ├── settings_page/                 # API key & configuration
│   └── widget_catalog_page/           # Component showcase
├── services/
│   ├── ai_service.dart                # Gemini API integration
│   ├── chat_view_provider.dart        # Chat state management
│   ├── widget_service.dart            # Generated widget management
│   └── ...
└── widgets/
    ├── accumulating_stream_builder.dart   # Stream accumulation widget
    └── generative_widgets/                # AI-generated component library
        ├── generative_button.dart
        ├── generative_card.dart
        ├── generative_column.dart
        ├── generative_row.dart
        ├── generative_text.dart
        └── generative_textfield.dart
```

## 🧩 Generative Widget Catalog

| Category | Component | Description |
|----------|-----------|-------------|
| **Essential** | `GenerativeButton` | Interactive buttons (Filled, Elevated, Danger variants) |
| **Essential** | `GenerativeText` | Markdown-formatted text display |
| **Essential** | `GenerativeTextField` | User text input fields |
| **Layout** | `GenerativeCard` | Container card for components |
| **Layout** | `GenerativeColumn` | Vertical stack layout |
| **Layout** | `GenerativeRow` | Horizontal stack layout |

## 🤔 Current Technical Dilemma: Scripting

For generated UIs to have real logic, we're evaluating three approaches:

| Approach | Pros | Cons |
|----------|------|------|
| **Interpreted Dart** (hetu_script/dart_eval) | Native feel, familiar syntax | Runtime overhead, complexity |
| **Lua** | Lightweight, fast, battle-tested | Foreign to Flutter ecosystem |
| **JSON Logic** | Safe, sandboxed, serializable | Verbose, potentially limiting |

## 🛠️ Tech Stack

- **Flutter** ^3.9.2
- **State Management**: Provider + Flutter Bloc
- **LLM Integration**: Google Generative AI (Gemini)
- **JSON Streaming**: [`llm_json_stream`](https://pub.dev/packages/llm_json_stream) ^0.2.1
- **UI Enhancements**: Flutter Animate, Responsive Framework, Google Fonts
- **Secure Storage**: Flutter Secure Storage

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- A Google AI (Gemini) API key

### Installation

```bash
# Clone the repository
git clone https://github.com/ComsIndeed/ui_gen_demo.git
cd ui_gen_demo

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

1. Launch the app
2. Navigate to **Settings**
3. Enter your Gemini API key
4. Start generating UIs!

## 📝 License

*TBD*

## 🔗 Related

- [`llm_json_stream`](https://pub.dev/packages/llm_json_stream) — The streaming JSON parser powering this project

---

<p align="center">
  <i>Built with 💜 and streaming JSON</i>
</p>
