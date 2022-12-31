import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pouch/themes/main_theme.dart';
import 'package:pouch/views/settings_view.dart';
import 'package:pouch/views/subcriptions_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class LayOut extends StatelessWidget {
  const LayOut({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt currentIndex = 0.obs;
    PageController pageController = PageController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MainTheme.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (value) {
            currentIndex.value = value;
          },
          children: const [
            SubscriptionsView(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => SalomonBottomBar(
            currentIndex: currentIndex.value,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            onTap: (index) {
              currentIndex.value = index;
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutExpo);
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Settings'),
              ),
            ],
          )),
    );
  }
}
