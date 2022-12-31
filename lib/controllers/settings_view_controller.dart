import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pouch/controllers/subscriptions_view_controller.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/plugins/storage.dart';
import 'package:pouch/utilities/utilities.dart';
import 'package:share_plus/share_plus.dart';

class SettingsViewController {
  static int tapsCount = 0;
  static void easterEgg() {
    tapsCount++;
    if (tapsCount > 7) {
      Get.snackbar(
        'Mars First!',
        'Mars First! #TheExpanse',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        shouldIconPulse: false,
        margin: const EdgeInsets.all(8),
        icon: const Icon(Icons.rocket, size: 28, color: Colors.white),
      );
      tapsCount = 0;
    }
  }

  static void saveImportedData(List<Subscription> subscriptions) {
    List<Subscription> currentSubscriptions = Storage.subStore.getAll();
    for (Subscription subscription in subscriptions) {
      if(currentSubscriptions.where((element) => element.id == subscription.id).isNotEmpty){
        subscription.save();
      } else {
        subscription.id = 0;
        subscription.save();
      }
    }
    Get.back();
    Get.snackbar(
      'Import Successful',
      'Imported ${subscriptions.length} Subscriptions',
      backgroundColor: Colors.white,
      colorText: Colors.black,
      shouldIconPulse: false,
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.check, color: Colors.green),
    );
  }

  static void confirmImport(Map importJSON) async {
    List<Subscription> subscriptions = [];
    for (Map<String, dynamic> element in importJSON['data']) {
      subscriptions.add(Subscription.fromJson(element));
    }

    int version = importJSON['version'];
    DateTime exportedTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(importJSON['timestamp']);

    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utilities.headerMaker('Confirm Import'),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                'Backup your current data before importing. This will replace all your current overlapping data with the imported data. Are you sure you want to continue?'),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Imported Data Timestamp: $exportedTimeStamp'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Imported Data Version: $version'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => saveImportedData(subscriptions),
                  child: const Text('Import'),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ));
  }

  static void import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path.toString());
      String fileContent = await file.readAsString();
      Map importJSON = jsonDecode(fileContent);
      confirmImport(importJSON);
    }
  }

  static void export() {
    List<Subscription> subscriptions =
        SubscriptionsViewController.subscriptions;
    Map exportJSON = {
      'version': 1,
      'type': 'pouch_export',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'timestamp_format': 'milliseconds_since_epoch',
      'timestamp_human': DateTime.now().toString(),
      'data': []
    };
    for (Subscription element in subscriptions) {
      exportJSON['data'].add(element.toJson());
    }
    List<int> list = jsonEncode(exportJSON).codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    DateTime now = DateTime.now();
    String fileName =
        '${now.minute}-${now.hour}-${now.day}-${now.month}-${now.year}-pouch_export.json';
    XFile file =
        XFile.fromData(bytes, mimeType: 'application/json', name: fileName);
    Share.shareXFiles([file], subject: 'Pouch Export');
    Get.snackbar(
      'Export Successful',
      'Exported ${subscriptions.length} Subscriptions',
      backgroundColor: Colors.white,
      colorText: Colors.black,
      shouldIconPulse: false,
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.check, color: Colors.green),
    );
  }
}
