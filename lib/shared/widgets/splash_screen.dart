import 'package:flutter/material.dart';
import 'package:manzoma/core/navigation/navigation_service.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';

import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _folder = 'assets/images/manzoma_animation';
  static const String _prefix = 'manzoma animation_';
  static const int _suffixDigits = 5; // 00001
  static const int _suffixStart = 1;
  static const double _frameCount = 52;
  static const double _fps = 24;

  bool _assetsReady = false;
  bool _navigated = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();

    // حضّر الصور بعد أول فريم علشان يبقى عندنا MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _warmUpFrames(context);
      if (!mounted) return;
      setState(() => _assetsReady = true);

      // مؤقت احتياطي لو لأي سبب onFinishPlaying متناداش
      const forward = _frameCount / _fps; // ~2.17s
      const boomerangTotal = forward * 2; // رايح جاي
      _fallbackTimer = Timer(
          Duration(milliseconds: (boomerangTotal * 1000).round() + 1200),
          _navigateOnce);
    });
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _warmUpFrames(BuildContext context) async {
    // كبر شوية الكاش للصور عشان سلسلة الفريمات
    PaintingBinding.instance.imageCache.maximumSize = 300; // عدد الصور
    PaintingBinding.instance.imageCache.maximumSizeBytes = 256 << 20; // 256MB

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final logicalWidth = MediaQuery.of(context).size.width;
    // فك ترميز الصور على عرض مناسب للشاشة (يوفّر حجم ويقلل الـjank)
    final targetDecodeWidth =
        (logicalWidth * devicePixelRatio).clamp(360.0, 1080.0).round();

    // حمل الفريمات على دفعات علشان ما نحملش الـUI Thread فجأة
    const chunkSize = 8;
    List<Future<void>> pending = [];
    for (int i = 0; i < _frameCount; i++) {
      final index = _suffixStart + i;
      final path =
          '$_folder/$_prefix${index.toString().padLeft(_suffixDigits, '0')}.png';
      final provider = ResizeImage(AssetImage(path), width: targetDecodeWidth);
      pending.add(precacheImage(provider, context));
      if (pending.length >= chunkSize) {
        await Future.wait(pending);
        pending.clear();
      }
    }
    if (pending.isNotEmpty) await Future.wait(pending);
  }

  void _navigateOnce() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _fallbackTimer?.cancel();
    NavigationService.goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    // في الديباچ شغّل سموذ أنيميشن قد يقل، الريليز هيفرق كتير
    // timeDilation = 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _assetsReady
            ? RepaintBoundary(
                child: ImageSequenceAnimator(
                  _folder,
                  _prefix,
                  _suffixStart,
                  _suffixDigits,
                  'png',
                  _frameCount,
                  fps: _fps,
                  isLooping: false,
                  isAutoPlay: true,
                  isBoomerang: true,
                  onFinishPlaying: (animator) {
                    // هيتنادى بعد ما يخلص (رايح + جاي)
                    _navigateOnce();
                  },
                ),
              )
            : const SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
      ),
    );
  }
}
