import 'package:flutter/material.dart';
import 'package:manzoma/core/navigation/navigation_service.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // بعد 5 ثواني روح على صفحة اللوج إن
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        NavigationService.goToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ImageSequenceAnimator(
          "assets/images/manzoma_animation", // folder
          "manzoma animation_", // fileName prefix
          1, // suffixStart
          5, // suffixCount (00001)
          "png", // extension
          52, // frameCount (عدد الصور)
          fps: 24, // معدل الإطارات
          isLooping: false,
          isAutoPlay: true,
          isBoomerang: true,
          onFinishPlaying: (animator) {
            print("Animation finished ✅");
          },
        ),
      ),
    );
  }
}
