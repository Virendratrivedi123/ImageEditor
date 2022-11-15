// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:flutter/services.dart';
import 'package:image/filter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'edit..dart';
import 'home.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          fontFamily: 'PlayfairDisplay',
          appBarTheme: const AppBarTheme(
            elevation: 0, // This removes the shadow from all App Bars.
          )),
      home: const MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _ExampleInstagramFilterSelectionState();
}

class _ExampleInstagramFilterSelectionState extends State<MyApp> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File? imageTemp = File(image.path);
      imageTemp = await cropimage(imagefile: imageTemp);

      setState(() => this.image = imageTemp);
    } on PlatformException {
      // ignore: avoid_print
      // print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

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
        // ignore: unnecessary_cast
        final color = value as Color;
        return Column(
          children: [
            Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.only(top: 50, left: 20),
                // Border width
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.rectangle),
                child: image != null
                    ? Image.file(
                        image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        color: color.withOpacity(0.5),
                        colorBlendMode: BlendMode.color,
                      )
                    : Image.network(
                        'https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        color: color.withOpacity(0.5),
                        colorBlendMode: BlendMode.color,
                      )),
            Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 100,
                  margin: const EdgeInsets.only(top: 50, left: 10),
                  child: MaterialButton(
                      color: Colors.blue,
                      child: const Text(" Gallery",
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: '',
                            fontWeight: FontWeight.w500,
                          )),
                      onPressed: () {
                        pickImage();
                      }),
                ),
                Container(
                  height: 50,
                  width: 100,
                  margin: const EdgeInsets.only(top: 50, left: 180),
                  child: MaterialButton(
                      color: Colors.blue,
                      child: const Text(" Camera",
                          style: TextStyle(
                              fontFamily: "PlayfairDisplay",
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickImageC();
                      }),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 100,
              margin: const EdgeInsets.only(top: 50, left: 10),
              child: MaterialButton(
                color: Colors.blue,
                child: const Text(" next",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp2(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
        // image != null
        //     ? Image.file(
        //         image!,
        //         width: 100,
        //         height: 100,
        //         fit: BoxFit.cover,
        //         color: color.withOpacity(0.5),
        //         colorBlendMode: BlendMode.color,
        //       )
        //     : Image.network(
        //         'https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg',
        //         width: 100,
        //         height: 100,
        //         fit: BoxFit.cover,
        //         color: color.withOpacity(0.5),
        //         colorBlendMode: BlendMode.color,
        //       );
      },
    );
  }

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
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
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
                _buildSelectionRing(itemSize),
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
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

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

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
