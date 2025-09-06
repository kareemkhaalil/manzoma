import 'package:flutter/material.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              FlutterLocalization.instance.getString(context, 'reportsScreen'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(FlutterLocalization.instance.getString(context, 'reportsScreenDescription')),
          ],
        ),
      ),
    );
  }
}
