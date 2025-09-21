import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:renbo/utils/theme.dart';

class WhiteNoiseSynthesizerScreen extends StatefulWidget {
  const WhiteNoiseSynthesizerScreen({super.key});

  @override
  _WhiteNoiseSynthesizerScreenState createState() =>
      _WhiteNoiseSynthesizerScreenState();
}

class _WhiteNoiseSynthesizerScreenState
    extends State<WhiteNoiseSynthesizerScreen> {
  final List<String> _noiseFrequencies = [
    'white',
    'pink',
    'brown',
  ];

  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {
    'white': 0.0,
    'pink': 0.0,
    'brown': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _initPlayers();
  }

  void _initPlayers() async {
    for (var frequency in _noiseFrequencies) {
      final player = AudioPlayer();
      await player.setSource(AssetSource('audio/${frequency}_noise.mp3'));
      await player.setReleaseMode(ReleaseMode.loop);
      _players[frequency] = player;
    }
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  void _updateVolume(String frequency, double newVolume) async {
    setState(() {
      _volumes[frequency] = newVolume;
    });

    final player = _players[frequency];
    if (player != null) {
      await player.setVolume(newVolume);
      if (newVolume > 0 && player.state != PlayerState.playing) {
        await player.resume();
      } else if (newVolume == 0 && player.state == PlayerState.playing) {
        await player.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White Noise Synthesiser'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkGray,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Mix your desired frequency:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _noiseFrequencies.length,
                itemBuilder: (context, index) {
                  final frequency = _noiseFrequencies[index];
                  return _buildVolumeSlider(frequency);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(String frequency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${frequency.toUpperCase()} Noise',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          Slider(
            value: _volumes[frequency]!,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: _volumes[frequency]!.toStringAsFixed(1),
            onChanged: (value) => _updateVolume(frequency, value),
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
