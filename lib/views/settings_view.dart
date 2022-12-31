import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pouch/controllers/settings_view_controller.dart';
import 'package:pouch/themes/text_themes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: Get.width * 0.5,
              height: Get.width * 0.5,
              child: InkWell(
                onTap: (() => SettingsViewController.easterEgg()),
                borderRadius: BorderRadius.circular(16),
                
                child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/splash.png'),
                ),
              ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Pouch', style: TextThemes.headingOneW),
            Text('Subscriptions Manager App', style: TextThemes.headingThreeW),
            Text('Version 0.0.4', style: TextThemes.headingFourW),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 72,
                  width: Get.width * 0.3,
                  child: ElevatedButton(
                    onPressed: ()=> SettingsViewController.import(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload, size: 32),
                        Text('Import Data'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 72,
                  width: Get.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () => SettingsViewController.export(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.download, size: 32),
                        Text('Export Data'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(height: 16),
            Text('Developed by: Srilal S. Siriwardhane', style: TextThemes.headingThreeW),
          ],
        ),
      ),
    );
  }
}
