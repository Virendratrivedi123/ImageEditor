// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_typing_uninitialized_variables

// ignore: unused_import
import 'dart:math' as math;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:flutter/services.dart';
import 'package:image/paint.dart';
import 'package:image/frames.dart';
// ignore: unused_import
import 'package:image/effects.dart';
// ignore: unused_import
import 'package:image/stickers.dart';
import 'package:image/main.dart';
import 'package:image/view.dart';
// ignore: unused_import
import 'package:flutter_painter/flutter_painter.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unnecessary_import, unused_import
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';

import 'default.dart';
import 'imagetext.dart';

@immutable
class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  // bool _isVisible = true;

  // @override
  // void initState() {
  //   super.initState();
  //   pickImage();
  // }

  File? image;
  var controller;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File? imageTemp = File(image.path);
      // imageTemp = await cropimage(imagefile: imageTemp);

      setState(() => this.image = imageTemp);

      // Navigator.pop(context);
    } on PlatformException {
      // ignore: avoid_print
      // print('Failed to pick image: $e');
    }
  }

  Future pickImage2() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File? imageTemp = File(image.path);
      // imageTemp = await cropimage(imagefile: imageTemp);

      setState(() => this.image = imageTemp);

      Navigator.pop(context);
    } on PlatformException {
      // ignore: avoid_print
      // print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
      // ignore: empty_catches
    } on PlatformException {}
  }

  Future pickImageC2() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
      Navigator.pop(context);
      // ignore: empty_catches
    } on PlatformException {}
  }

  Future<File?> cropimage({required File imagefile}) async {
    CroppedFile? croppedimage =
        await ImageCropper().cropImage(sourcePath: imagefile.path);
    if (croppedimage == null) return null;
    return File(croppedimage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "image editing",
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  File? imageTemp = File(image!.path);
                  imageTemp = await cropimage(imagefile: imageTemp);

                  setState(() => image = imageTemp);
                },
                child: const Icon(
                  Icons.crop,
                  size: 26.0,
                ),
              )),
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
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  showAlignedDialog(
                      context: context,
                      builder: _localDialogBuilder,
                      followerAnchor: Alignment.topLeft,
                      targetAnchor: Alignment.topRight,
                      barrierColor: Colors.transparent,
                      avoidOverflow: true);
                },
                child: const Icon(Icons.edit),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  showAlignedDialog(
                      context: context,
                      builder: _localDialogBuilder2,
                      followerAnchor: Alignment.topLeft,
                      targetAnchor: Alignment.topRight,
                      barrierColor: Colors.transparent,
                      avoidOverflow: true);
                },
                child: const Icon(Icons.more_vert),
              )),
        ],
      ),
      // appBar: _appBar,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(top: 0, left: 0),
                      child: Image.network(
                        'https://logos.textgiraffe.com/logos/logo-name/Edit-designstyle-jungle-m.png',
                        width: 140,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 0),
                      alignment: Alignment.bottomLeft,
                      child: const Text("Image Editor",
                          style: TextStyle(
                              fontFamily: "PlayfairDisplay",
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
                // Image.network(
                //   'https://logos.textgiraffe.com/logos/logo-name/Edit-designstyle-jungle-m.png',
                //   width: 10,
                // ),
                ),
            ListTile(
              leading: const Icon(
                Icons.emoji_emotions,
                color: Colors.blue,
              ),
              title: const Text('stickers'),
              onTap: () async {
                File? file = image;
                if (file != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdvancedExample(
                        selectedImage: file.path,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.color_lens,
                color: Colors.blue,
              ),
              title: const Text('effects'),
              onTap: () async {
                File? file = image;
                if (file != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyApp(
                        selectedImage: file.path,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
                leading: const Icon(
                  Icons.color_lens,
                  color: Colors.blue,
                ),
                title: const Text('Draw'),
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlutterPainterExample2(),
                    ),
                  );
                }),
            ListTile(
              leading: const Icon(
                Icons.filter_frames,
                color: Colors.blue,
              ),
              title: const Text('Frames'),
              onTap: () async {
                File? file = image;
                if (file != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Carousel(
                        selectedImage: file.path,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_album,
                color: Colors.blue,
              ),
              title: const Text('Gallery'),
              onTap: () {
                pickImage2();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_enhance,
                color: Colors.blue,
              ),
              title: const Text('Camera'),
              onTap: () {
                pickImageC2();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Text'),
              onTap: () {
                addNewDialog2(context);
              },
            ),
          ],
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(
              top: 0.0,
            ),
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Center(
                  child: image != null
                      ? Image.file(
                          image!,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )
                      : Image.network(
                          'https://static.wikia.nocookie.net/just-because/images/0/0c/NoImage_Available.png/revision/latest?cb=20170601005615',
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                ),
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - 96;
                            texts[i].left = off.dx;
                          });
                        },
                      ),
                    ),
                  ),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                              fontSize: 0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(
                                0.3,
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 0.0, left: 310),
        // alignment: Alignment.bottomRight,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: () {
                pickImage();
              },
              child: const Icon(
                Icons.photo_album,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    // ignore: unnecessary_cast
  }

  WidgetBuilder get _localDialogBuilder2 {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 80,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        pickImage2();
                      },
                      child: const Text("Gallery")),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        pickImageC2();
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Camera")),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        {
                          File? file = image;
                          if (file != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdvancedExample(
                                  selectedImage: file.path,
                                ),
                              ),
                            );
                          }
                        }
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Stickers")),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        {
                          File? file = image;
                          if (file != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyApp(
                                  selectedImage: file.path,
                                ),
                              ),
                            );
                          }
                        }
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Effects")),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 80,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        addNewDialog2(context);
                      },
                      child: const Text("Text-write")),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        increaseFontSize();
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Text-increase")),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        decreaseFontSize();
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Text-decrease")),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              'Text Modification',
                            ),
                            actions: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.yellow),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.yellow,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.purple),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.purple,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.pink),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.pink,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.green),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.black),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.black,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.blue),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.blue,
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                        onTap: () =>
                                            changeTextColor(Colors.red),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                        //Navigator.of(context).pop();
                      },
                      child: const Text("Text-color")),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }

  // ignore: unused_element
  AppBar get _appBar => AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Visibility(
          // visible: _isVisible,
          child: Container(
        margin: const EdgeInsets.only(
          top: 50.0,
        ),
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ),
              onPressed: () => saveToGallery(context),
              tooltip: 'Save Image',
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: increaseFontSize,
              tooltip: 'Increase font size',
            ),
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.black,
              ),
              onPressed: decreaseFontSize,
              tooltip: 'Decrease font size',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_left,
                color: Colors.black,
              ),
              onPressed: alignLeft,
              tooltip: 'Align left',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_center,
                color: Colors.black,
              ),
              onPressed: alignCenter,
              tooltip: 'Align Center',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_right,
                color: Colors.black,
              ),
              onPressed: alignRight,
              tooltip: 'Align Right',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_bold,
                color: Colors.black,
              ),
              onPressed: boldText,
              tooltip: 'Bold',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_italic,
                color: Colors.black,
              ),
              onPressed: italicText,
              tooltip: 'Italic',
            ),
            IconButton(
              icon: const Icon(
                Icons.space_bar,
                color: Colors.black,
              ),
              onPressed: addLinesToText,
              tooltip: 'Add New Line',
            ),
            Tooltip(
              message: 'Red',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.red),
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'White',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.white),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Black',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.black),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Blue',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.blue),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Yellow',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.yellow),
                  child: const CircleAvatar(
                    backgroundColor: Colors.yellow,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Green',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.green),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Orange',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.orange),
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Tooltip(
              message: 'Pink',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.pink),
                  child: const CircleAvatar(
                    backgroundColor: Colors.pink,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      )));
}
