// ignore_for_file: camel_case_types

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/utills.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.selectedImage,
  }) : super(key: key);
  final String selectedImage;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
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

  late PageController _pageController;

  List<String> images = [
    "assets/images/op2.png",
    "assets/images/g.png",
    "assets/images/l.png",
    // "assets/images/r.png",
    "assets/images/mm.png",
    "assets/images/sd.png",
    "assets/images/ff.png"
  ];

  int activePage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "imagee editing",
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    saveToGallery(context);
                  },
                  child: const Icon(
                    Icons.save,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                SizedBox(
                  // width: MediaQuery.of(context).size.width,
                  height: 650,
                  child: PageView.builder(
                      itemCount: images.length,
                      pageSnapping: true,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        bool active = pagePosition == activePage;
                        return slider(images, pagePosition, active);
                      }),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(images.length, activePage))
              ],
            )));
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 40;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
                // ignore: sort_child_properties_last
                alignment: Alignment.center,
                child: Image.file(
                  File(
                    widget.selectedImage,
                  ),
                  height: 400,
                )),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(images[pagePosition]),
              )),
            ),
          ],
        ),
      ),
      // decoration: BoxDecoration(
      //     image: DecorationImage(image: AssetImage(images[pagePosition]))),
      // child: Image.network(
      //   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSe8IQrpci_lb0KcKSoTutxeFX25kDxHk2SfcDguEUp&s",
      // ),
    );
  }
}

imageAnimation(PageController animation, images, pagePosition) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, widget) {
      print(pagePosition);

      return SizedBox(
        width: 200,
        height: 200,
        child: widget,
      );
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Image.network(images[pagePosition]),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
