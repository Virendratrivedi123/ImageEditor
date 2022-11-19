// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:flutter/services.dart';
import 'package:image/demo.dart';
import 'package:image/demo2.dart';
import 'package:image/edit..dart';
// ignore: unused_import
import 'package:image/home.dart';
import 'package:image/view.dart';
import 'package:flutter_painter/flutter_painter.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unnecessary_import
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';

import 'imagetext.dart';

@immutable
class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  bool _isVisible = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  List<String> materialAmountList = [];
  List<String> imageLinks = [
    "https://i.imgur.com/btoI5OX.png",
    "https://i.imgur.com/EXTQFt7.png",
    "https://i.imgur.com/EDNjJYL.png",
    "https://i.imgur.com/uQKD6NL.png",
    "https://i.imgur.com/cMqVRbl.png",
    "https://i.imgur.com/1cJBAfI.png",
    "https://i.imgur.com/eNYfHKL.png",
    "https://i.imgur.com/c4Ag5yt.png",
    "https://i.imgur.com/GhpCJuf.png",
    "https://i.imgur.com/XVMeluF.png",
    "https://i.imgur.com/mt2yO6Z.png",
    "https://i.imgur.com/rw9XP1X.png",
    "https://i.imgur.com/pD7foZ8.png",
    "https://i.imgur.com/13Y3vp2.png",
    "https://i.imgur.com/ojv3yw1.png",
    "https://i.imgur.com/f8ZNJJ7.png",
    "https://i.imgur.com/BiYkHzw.png",
    "https://i.imgur.com/snJOcEz.png",
    "https://i.imgur.com/b61cnhi.png",
    "https://i.imgur.com/FkDFzYe.png",
    "https://i.imgur.com/P310x7d.png",
    "https://i.imgur.com/5AHZpua.png",
    "https://i.imgur.com/tmvJY4r.png",
    "https://i.imgur.com/PdVfGkV.png",
    "https://i.imgur.com/1PRzwBf.png",
    "https://i.imgur.com/VeeMfBS.png",
  ];
  File? image;
  var controller;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File? imageTemp = File(image.path);
      imageTemp = await cropimage(imagefile: imageTemp);

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

  Future<File?> cropimage({required File imagefile}) async {
    CroppedFile? croppedimage =
        await ImageCropper().cropImage(sourcePath: imagefile.path);
    if (croppedimage == null) return null;
    return File(croppedimage.path);
  }

  final _filters = [
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];

  final _filterColor = ValueNotifier<Color>(Colors.white);

  void _onFilterChanged(Color value) {
    _filterColor.value = value;
  }

  void addSticker() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => SelectStickerImageDialog(
              imagesLinks: imageLinks,
            ));
    if (imageLink == null) return;
    controller.addImage(
        await NetworkImage(imageLink).image, const Size(100, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildPhotoWithFilter(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWithFilter() {
    return ValueListenableBuilder(
      valueListenable: _filterColor,
      builder: (context, value, child) {
        final color = value;
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
                    onTap: () {
                      addNewDialog(context);
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 26.0,
                    ),
                  )),
              // Padding(
              //     padding: const EdgeInsets.only(right: 20.0),
              //     child: GestureDetector(
              //       onTap: () {
              //         increaseFontSize;
              //       },
              //       child: const Icon(Icons.add),
              //     )),
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
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      increaseFontSize();
                    },
                    child: const Icon(Icons.add),
                  )),
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      decreaseFontSize();
                    },
                    child: const Icon(Icons.remove),
                  )),
              // Padding(
              //     padding: const EdgeInsets.only(right: 10.0),
              //     child: GestureDetector(
              //       onTap: () async {
              //         File? file = image;
              //         if (file != null) {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (context) => AdvancedExample(
              //                 selectedImage: file.path,
              //               ),
              //             ),
              //           );
              //         }
              //       },
              //       child: const Icon(Icons.color_lens),
              //     )),
              Container(
                padding: const EdgeInsets.only(right: 5.0),
                height: 20,
                width: 20,
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: ListView(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(top: 20, left: 40),
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    onTap: () => changeTextColor(Colors.yellow),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.yellow,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin:
                                    const EdgeInsets.only(top: 20, left: 50),
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    onTap: () => changeTextColor(Colors.red),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin:
                                    const EdgeInsets.only(top: 20, left: 50),
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    onTap: () => changeTextColor(Colors.blue),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.blue,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin:
                                    const EdgeInsets.only(top: 20, left: 50),
                                height: 40,
                                width: 40,
                                child: GestureDetector(
                                    onTap: () => changeTextColor(Colors.black),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ])),
                  ),
                  child: const Icon(Icons.more_vert),
                ),
              ),
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
                // ListTile(
                //   leading: const Icon(
                //     Icons.emoji_emotions,
                //     color: Colors.blue,
                //   ),
                //   title: const Text('frames'),
                //   onTap: () async {
                //     File? file = image;
                //     if (file != null) {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => HomePage(
                //             selectedImage: file.path,
                //           ),
                //         ),
                //       );
                //     }
                //   },
                // ),
                ListTile(
                  leading: const Icon(
                    Icons.color_lens,
                    color: Colors.blue,
                  ),
                  title: const Text('Draw'),
                  onTap: () async {
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FlutterPainterExample2(),
                        ),
                      );
                    }
                  },
                ),
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
                    pickImage();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_enhance,
                    color: Colors.blue,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImageC();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  title: const Text('Text'),
                  onTap: () {
                    addNewDialog(context);
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
                height: MediaQuery.of(context).size.height * 0.75,
                child: Stack(
                  children: [
                    Center(
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: 600,
                              color: color.withOpacity(0.5),
                              colorBlendMode: BlendMode.color,
                            )
                          : Image.network(
                              'https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg',
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              color: color.withOpacity(0.5),
                              colorBlendMode: BlendMode.color,
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
                                  fontSize: 20,
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
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          // floatingActionButton: Container(
          //   margin: const EdgeInsets.only(top: 750.0, left: 0),
          //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       FloatingActionButton(
          //         backgroundColor: Colors.black,
          //         onPressed: () {
          //           showToast;
          //         },
          //         child: const Icon(
          //           Icons.photo_album,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        );
        // ignore: unnecessary_cast
      },
    );
  }

  AppBar get _appBar => AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Visibility(
          visible: _isVisible,
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
  Widget _buildFilterSelector() {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: _filters,
    );
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 34.0),
  });

  final List<Color> filters;
  final void Function(Color selectedColor) onFilterChanged;
  final EdgeInsets padding;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  Color itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      widget.onFilterChanged(widget.filters[page]);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildShadowGradient(itemSize),
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                // _buildSelectionRing(itemSize),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

//
  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onFilterSelected: () => _onFilterTapped(i),
              color: itemColor(i),
            ),
        ],
      ),
    );
  }

  // Widget _buildSelectionRing(double itemSize) {
  //   return IgnorePointer(
  //     child: Padding(
  //       padding: widget.padding,
  //       child: SizedBox(
  //         width: itemSize,
  //         height: itemSize,
  //         child: const DecoratedBox(
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             border: Border.fromBorderSide(
  //               BorderSide(width: 6.0, color: Colors.white),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up from the perspective
    // of the scroll paging system. We also use this size for the width and
    // height of a single item.
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction, e.g., 0.0,
    // or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    // index 1 is active, and the user has scrolled 30% towards the item at
    // index 2.
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment.
    // At most, we paint 3 items to the left of the active item.
    final min = math.max(0, active.floor() - 3).toInt();

    // Index of the last item we need to paint at this moment.
    // At most, we paint 3 items to the right of the active item.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.color,
    this.onFilterSelected,
  });

  final Color color;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.network(
              'https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-texture.jpg',
              color: color.withOpacity(0.5),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({Key? key, this.imagesLinks = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: imagesLinks.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () => Navigator.pop(context, imageLink),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: Image.network(imageLink),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
