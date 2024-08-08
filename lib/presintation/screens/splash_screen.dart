import 'package:bashkatep/presintation/screens/admin_screen.dart';
import 'package:bashkatep/presintation/screens/home_screen.dart';
import 'package:bashkatep/presintation/screens/login.dart';
import 'package:bashkatep/presintation/screens/superAdmin/dashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/animation.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the screen when the video is initialized
        _controller.play();
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            setState(() {
              _isVideoFinished = true;
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
                aspectRatio: 16 / 9 * 0.5, // Adjust the aspect ratio as needed
                child: _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : const Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child:
                                CircularProgressIndicator())) // Loading indicator for video initialization
                ),
          ),
          if (_isVideoFinished)
            FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child:
                              CircularProgressIndicator())); // Loading indicator for data loading
                } else if (snapshot.hasError) {
                  return const Text('Error loading data');
                } else {
                  return const Center(child: Text('Data loaded successfully'));
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      final tokenBox = Hive.box('token');
      final roleBox = Hive.box('userRole');
      final clientBox = Hive.box('clientId');
      final clientId = clientBox.get('clientId');

      final userToken = tokenBox.get('token');
      final userRole = roleBox.get('userRole');

      debugPrint("splash userToken: $userToken");
      debugPrint("splash userRole: $userRole");

      if (userToken != null && userRole != null) {
        if (userRole == 'super_admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        } else if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminScreen(
                clientId: clientId,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }
}
