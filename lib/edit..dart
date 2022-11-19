// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/utills.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'filter.dart';

const String url =
    "https://media.idownloadblog.com/wp-content/uploads/2018/09/iPhone-XS-advertising-wallpaper-any-iPhone-2-768x1365.png";

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.selectedImage});
  final String selectedImage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  saveToGallery(BuildContext context) {
    {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery.'),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Oajoo imagee editing",
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    saveToGallery(context);
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Screenshot(
            controller: screenshotController,
            child: Center(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Container(
                        // ignore: sort_child_properties_last
                        alignment: Alignment.center,
                        child: Image.file(
                          File(
                            widget.selectedImage,
                          ),
                          height: 300,
                        )),
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/g.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
