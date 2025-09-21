import 'package:flutter/material.dart';

// Sticker model
class Sticker {
  final String assetPath;
  Sticker({required this.assetPath});
}

// Example stickers
final List<Sticker> stickers = [
  Sticker(assetPath: 'assets/stickers/happy.png'),
  Sticker(assetPath: 'assets/stickers/sad.png'),
  Sticker(assetPath: 'assets/stickers/star.png'),
  Sticker(assetPath: 'assets/stickers/happy-panda.png'),
  Sticker(assetPath: 'assets/stickers/happy-cat.png'),
  Sticker(assetPath: 'assets/stickers/astonished.png'),
  Sticker(assetPath: 'assets/stickers/calm.png'),
  Sticker(assetPath: 'assets/stickers/celeb.png'),
  Sticker(assetPath: 'assets/stickers/cozy.png'),
  Sticker(assetPath: 'assets/stickers/dancing.png'),
  Sticker(assetPath: 'assets/stickers/heart-cat.png'),
  Sticker(assetPath: 'assets/stickers/hi.png'),
  Sticker(assetPath: 'assets/stickers/sad-cat.png'),
  Sticker(assetPath: 'assets/stickers/sleepy.png'),

];

class StickerDemoScreen extends StatelessWidget {
  const StickerDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sticker Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, index) {
                  final sticker = stickers[index];
                  return Image.asset(
                    sticker.assetPath,
                    width: 50,
                    height: 50,
                  );
                },
              ),
            );
          },
          child: const Text("Stickers"),
        ),
      ),
    );
  }
}
