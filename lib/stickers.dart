// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, sort_child_properties_last, duplicate_ignore

import 'dart:io';
// ignore: unused_import
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:stick_it/stick_it.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class AdvancedExample extends StatefulWidget {
  const AdvancedExample({
    Key? key,
    required this.selectedImage,
  }) : super(key: key);
  static String routeName = 'advanced-example';
  static String routeTitle = 'Stickers';
  final String selectedImage;
  @override
  _AdvancedExampleState createState() => _AdvancedExampleState();
}

class _AdvancedExampleState extends State<AdvancedExample> {
  /// background image of the stick it class
  final String _background =
      'https://images.unsplash.com/photo-1545147986-a9d6f2ab03b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80';

  /// used for getting images either from gallery or camera
  final _picker = ImagePicker();

  /// reference used for calling the exportImage function
  late StickIt _stickIt;

  /// the image picked by a user as file
  File? _image;

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).size.height / 4;
    double rightPadding = MediaQuery.of(context).size.width / 12;
    double boxSize = 56.0;
    _stickIt = StickIt(
      // ignore: sort_child_properties_last

      child: _image == null
          ? Image.file(
              File(
                widget.selectedImage,
              ),
              fit: BoxFit.cover,
            )
          : Image.file(_image!, fit: BoxFit.cover),

      stickerList: [
        Image.network(
          "https://i.imgur.com/btoI5OX.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.network(
          "https://i.imgur.com/EXTQFt7.png",
        ),
        Image.network(
          "https://i.imgur.com/c4Ag5yt.png",
        ),
        Image.network(
          "https://i.imgur.com/GhpCJuf.png",
        ),
        Image.network(
          "https://i.imgur.com/XVMeluF.png",
        ),
        Image.network(
          "https://i.imgur.com/mt2yO6Z.png",
        ),
        Image.network(
          "https://i.imgur.com/rw9XP1X.png",
        ),
        Image.network(
          "https://i.imgur.com/pD7foZ8.png",
        ),
        Image.network(
          "https://i.imgur.com/13Y3vp2.png",
        ),
        Image.network(
          "https://i.imgur.com/ojv3yw1.png",
        ),
      ],
      key: UniqueKey(),
      panelHeight: 175,
      panelBackgroundColor: Colors.white,
      panelStickerBackgroundColor: Theme.of(context).primaryColorLight,
      stickerSize: 100,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context)
            ..pop()
            ..pop(),
        ),
        title: const Text(
          "Stickers",
        ),
      ),
      body: Stack(
        children: [
          _stickIt,
          Positioned(
            bottom: bottomPadding,
            right: rightPadding,
            child: Column(
              children: [
                ////////////////////////////////////////////////////////
                //               SAVE IMAGE TO GALLERY                //
                ////////////////////////////////////////////////////////
                CircularIconButton(
                  onTap: () async {
                    final image = await _stickIt.exportImage();
                    final directory = await getApplicationDocumentsDirectory();
                    final path = directory.path;
                    final uniqueIdentifier = const Uuid().v1();
                    final file =
                        await File('$path/$uniqueIdentifier.png').create();
                    file.writeAsBytesSync(image);
                    GallerySaver.saveImage(file.path, albumName: 'Stick It')
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Image saved in the gallery album 'Stick It', go take a look!"),
                      ));
                    });
                  },
                  boxColor: Theme.of(context).primaryColorDark,
                  boxWidth: boxSize,
                  boxHeight: boxSize,
                  iconWidget: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ////////////////////////////////////////////////////////
                //                  SELECT BACKGROUND                 //
                ////////////////////////////////////////////////////////
                CircularIconButton(
                  onTap: () {
                    generateModal(context);
                  },
                  boxWidth: boxSize,
                  boxHeight: boxSize,
                  iconWidget: const Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  boxColor: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method that either opens the gallery to pick an image or the camera to take a photo.
  /// Requires a [ImageSource] for the wanted selection. Updates listeners when a photo got selected.
  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  /// Generates a modal in which the user can either pick a picture from
  /// gallery or create a pic with the camera of the mobile phone.
  void generateModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 128,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ////////////////////////////////////////////////////////
                //                  IMAGE FROM GALLERY                //
                ////////////////////////////////////////////////////////
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          // ignore: sort_child_properties_last
                          child: const Text('Select img from gallery'),
                          width: 200,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 2,
                  indent: 64,
                  endIndent: 64,
                ),
                ////////////////////////////////////////////////////////
                //                 IMAGE FROM CAMERA                  //
                ////////////////////////////////////////////////////////
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const SizedBox(
                          // ignore: sort_child_properties_last
                          child: Text('Select img from camera'),
                          width: 200,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircularIconButton extends StatelessWidget {
  final double _boxElevation;
  final double _boxHeight;
  final double _boxWidth;
  final Color _boxColor;
  final Icon _iconWidget;
  final void Function()? _onTap;

  const CircularIconButton({
    Key? key,
    required iconWidget,
    boxElevation,
    boxHeight,
    boxWidth,
    boxColor,
    onTap,
  })  : _iconWidget = iconWidget,
        _boxColor = boxColor ?? Colors.black,
        _boxElevation = boxElevation ?? 8,
        _boxHeight = boxHeight ?? 56,
        _boxWidth = boxWidth ?? 56,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: _boxColor,
        elevation: _boxElevation,
        child: InkWell(
          child: SizedBox(
              width: _boxWidth, height: _boxHeight, child: _iconWidget),
          onTap: _onTap,
        ),
      ),
    );
  }
}
