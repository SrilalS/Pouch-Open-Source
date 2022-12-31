import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pouch/layout.dart';
import 'package:pouch/models/exchange_rates.dart';
import 'package:pouch/objectbox-models/objectbox.g.dart';
import 'package:pouch/plugins/storage.dart';
import 'package:pouch/routes/routes.dart';
import 'package:pouch/themes/main_theme.dart';

late Admin admin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();
  await ExchangeRates.updateRates();
  runApp(const Pouch());
}

class Pouch extends StatelessWidget {
  const Pouch({super.key});

  @override
  Widget build(BuildContext context) {
    

    
    if (Admin.isAvailable()) {
      //admin = Admin(Storage.objectBox.store);
    }

    return GetMaterialApp(
      title: 'Pouch',
      theme: MainTheme.mainTheme,
      themeMode: ThemeMode.dark,
      home: const LayOut(),
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }
}
