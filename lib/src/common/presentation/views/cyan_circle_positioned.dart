import 'package:dream_home/src/constants/screen.dart';
import 'package:dream_home/src/theme/pellet.dart';
import 'package:flutter/widgets.dart';

/// [CyanPositionedCircle] is a cyan circle positioned at the
/// mid-bottom right of the welcome screen.
class CyanPositionedCircle extends StatelessWidget {
  const CyanPositionedCircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize.height(context);
    final width = ScreenSize.width(context);
    return Positioned(
      top: height * 57,
      left: width * 85,
      child: Container(
        width: width * 35,
        height: height * 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Pellet.kSecondaryColor,
        ),
      ),
    );
  }
}
