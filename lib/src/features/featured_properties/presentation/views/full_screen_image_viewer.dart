import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_home/src/constants/screen.dart';
import 'package:dream_home/src/theme/pellet.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({super.key, required this.imageUrl, required this.tag});
  final String imageUrl;
  final String tag;
  @override
  Widget build(BuildContext context) {
    final height = ScreenSize.height(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 5,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pellet.kDark,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Center(
              child: SizedBox(
                height: height * 50,
                child: Hero(
                  tag: tag,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
