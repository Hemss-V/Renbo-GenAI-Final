import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/journal_entry.dart';

class JournalDetailScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalDetailScreen({required this.entry, Key? key}) : super(key: key);

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  late final AudioPlayer _audioPlayer;
  bool _audioAvailable = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Check if the audio file exists and set the source
    if (widget.entry.audioPath != null &&
        File(widget.entry.audioPath!).existsSync()) {
      _audioPlayer.setFilePath(widget.entry.audioPath!);
      _audioAvailable = true;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildAudioPlayer() {
    if (!_audioAvailable) {
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text("Audio file not found.", style: TextStyle(color: Colors.red)),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final playing = playerState?.playing;
              if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 48.0,
                  onPressed: _audioPlayer.play,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 48.0,
                  onPressed: _audioPlayer.pause,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            iconSize: 48.0,
            onPressed: () {
              _audioPlayer.stop();
              _audioPlayer.seek(Duration.zero);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.entry.content.isEmpty ? "No text content." : widget.entry.content),
            const SizedBox(height: 8),
            Text(widget.entry.emotion ?? "No mood"),
            Text(widget.entry.timestamp.toString()),
            if (widget.entry.audioPath != null) _buildAudioPlayer(),
          ],
        ),
      ),
    );
  }
}