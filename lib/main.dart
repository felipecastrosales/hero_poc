import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const HeroPOC());
}

class HeroPOC extends StatelessWidget {
  const HeroPOC({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hero POC',
      home: HeroWidget(),
    );
  }
}

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final images = List.generate(
      20,
      (index) => Image.network(
        'https://picsum.photos/1000?random=$index',
        fit: BoxFit.contain,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero POC'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final heroTag = 'hero-flutter-logo-$index';

            return InkWell(
              onTap: () {
                context.pushPageBuilder(
                  pageBuilder: (_, __, ___) => HeroPage(
                    heroTag: heroTag,
                    heroImage: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: images[index],
                    ),
                  ),
                  isOpaque: false,
                );
              },
              child: Hero(
                tag: heroTag,
                child: images[index],
                placeholderBuilder: (_, __, ___) => images[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeroPage extends StatelessWidget {
  const HeroPage({
    super.key,
    required this.heroTag,
    required this.heroImage,
  });

  final String heroTag;
  final Widget heroImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: GestureDetector(
            onTap: context.pop,
          ),
        ),
        Container(
          height: context.height * 0.5,
          width: context.width * 0.5,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Hero(
            tag: heroTag,
            child: heroImage,
          ),
        ),
        Positioned(
          top: 50,
          left: 50,
          child: GestureDetector(
            onTap: context.pop,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}

extension BuildContextX on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  void pop<T>([T? result]) => Navigator.pop(this, result);
  Future<T?> push<T>(Route<T> route) => Navigator.push(this, route);
  Future<T?> pushPageBuilder<T>({
    required Widget Function(
      BuildContext,
      Animation<double>,
      Animation<double>,
    ) pageBuilder,
    bool isOpaque = false,
  }) =>
      push<T>(
        PageRouteBuilder(
          pageBuilder: pageBuilder,
          opaque: isOpaque,
        ),
      );
}
