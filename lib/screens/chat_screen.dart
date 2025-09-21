import 'package:flutter/material.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/chat_bubble.dart';
import 'hotlines_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // State for Speech-to-Text
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  // State for Text-to-Speech
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  void _initSpeechToText() async {
    await _speechToText.initialize(
      onError: (e) => debugPrint('STT Error: $e'),
    );
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add user message to UI immediately
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final classifiedResponse = await _geminiService.generateAndClassify(text);

      if (classifiedResponse.isHarmful && mounted) {
        _showHotlineSuggestion();
      }

      // Add the bot's response to the chat.
      if (mounted) {
        setState(() {
          _messages.add({'sender': 'bot', 'text': classifiedResponse.response});
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': 'I couldn\'t get a response. Try again. 😞',
          });
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showHotlineSuggestion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Text("You’re Not Alone"),
          ],
        ),
        content: const Text(
          "It sounds like you’re going through a really tough time. "
          "Please consider reaching out to a professional for immediate help.\n\n"
          "Would you like to see a list of mental wellness hotlines now?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Not Now"),
          ),
  
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HotlinesScreen()),
              );
            },
            child: const Text("View Hotlines"),
          ),
        ],
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.hasPermission;
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
            if (result.finalResult) {
              _speechToText.stop();
              setState(() => _isListening = false);
              _sendMessage();
            }
          },
        );
      }
    }
  }

  void _speakText(String text) {
    _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat with Renbot',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSender = message['sender'] == 'user';
                return Row(
                  mainAxisAlignment:
                      isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ChatBubble(
                        text: message['text']!,
                        isSender: isSender,
                      ),
                    ),
                    if (!isSender)
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 20),
                        onPressed: () => _speakText(message['text']!),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _isListening ? 'Listening...' : 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightGray,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: _isListening
                  ? AppTheme.secondaryColor
                  : AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic,
                  color: Colors.white),
              onPressed: _toggleListening,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}