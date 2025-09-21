import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

import '../services/journal_storage.dart';
import '../models/journal_entry.dart';
import 'journal_entries.dart';

class JournalScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String emotion;
  const JournalScreen({Key? key, required this.selectedDate, required this.emotion}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // Controllers and Services
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // State variables
  File? pickedImage;
  String? recordedAudioPath;
  bool isRecording = false;
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }
  
  // Save journal entry
  void _saveEntry() {
    final text = _controller.text.trim();
    if (text.isEmpty && pickedImage == null && recordedAudioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write, record, or add an image before saving.'),
        ),
      );
      return;
    }
    final entry = JournalEntry(
      content: text,
      timestamp: DateTime.now(),
      emotion: widget.emotion,
      imagePath: pickedImage?.path,
      audioPath: recordedAudioPath,
    );
    JournalStorage.addEntry(entry);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const JournalEntriesPage()),
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = File(image.path));
    }
  }

  // Record audio
  Future<void> _startStopRecording() async {
    if (isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        isRecording = false;
        recordedAudioPath = path;
      });
      if (path != null) await _audioPlayer.setFilePath(path);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording stopped')));
    } else {
      if (await _audioRecorder.hasPermission()) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final path = '${documentsDir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          isRecording = true;
          recordedAudioPath = null;
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording started')));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission denied')));
      }
    }
  }

  // Speech-to-Text: Start listening
  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    }
  }

  // Speech-to-Text: Stop listening
  Future<void> _stopListening() async {
    setState(() => _isListening = false);
    await _speechToText.stop();
  }

  // Text-to-Speech: Read text aloud
  Future<void> _speakText() async {
    if (_controller.text.isNotEmpty) {
      await _flutterTts.speak(_controller.text);
    }
  }

  // UI Widget for immediate audio playback
  Widget _buildAudioPlayerControls() {
    if (recordedAudioPath == null) return const SizedBox.shrink();
    return Container( /* ... a bunch of code ... */ );
  }

  // UI Widget for the "Recording..." indicator
  Widget _buildRecordingIndicator() {
    if (!isRecording) return const SizedBox.shrink();
    return Container( /* ... a bunch of code ... */ );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: Text("Journaling - ${widget.emotion}", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Start writing here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (pickedImage != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.file(pickedImage!, fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRecordingIndicator(),
            _buildAudioPlayerControls(),
            const SizedBox(height: 16),
            // Row for Voice Journal and Image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _startStopRecording,
                  icon: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.white),
                  label: Text(isRecording ? 'Stop Recording' : 'Voice Journal', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: isRecording ? Colors.red : const Color(0xFF568F87)),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text('Add Image', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF568F87)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // **RESTORED**: Row for Speech-to-Text and Text-to-Speech
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(_isListening ? Icons.mic_off : Icons.keyboard_voice, color: Colors.white),
                  label: Text(_isListening ? 'Stop Typing' : 'Voice Typing', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: _isListening ? Colors.blue : const Color(0xFF568F87)),
                ),
                ElevatedButton.icon(
                  onPressed: _speakText,
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  label: const Text('Read Aloud', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF568F87)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF568F87),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: _saveEntry,
              child: const Text("Save Entry"),
            ),
          ],
        ),
      ),
    );
  }
}