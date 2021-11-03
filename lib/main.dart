import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {

  final imageUrl = 'http://wx2.sinaimg.cn/large/0073Cjx6gy1gvikkl1dr4g606o06ongl02.gif';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue demo extended image')),
      body: Center(
          child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___){
            return _ImagePage(imageUrl: imageUrl,);
          }));
        },
        child: Hero(
          tag: "imageHero",
          child: ExtendedImage.network(
            imageUrl,
            width: 400,
            height: 400,
          ),
        ),
      )),
    );
  }
}

class _ImagePage extends StatelessWidget{

  final String imageUrl;

  const _ImagePage({Key? key, required this.imageUrl}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedImageGesturePageView'),
      ),
      body: ExtendedImageSlidePage(
        slideAxis: SlideAxis.vertical,
        slideType: SlideType.onlyImage,
        slidePageBackgroundHandler: slidePageBackgroundHandler,
        child: ExtendedImageGesturePageView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ExtendedImage.network(
              imageUrl,
              fit: BoxFit.contain,
              enableSlideOutPage: true,
              mode: ExtendedImageMode.gesture,
              heroBuilderForSlidingPage: (image){
                return Hero(tag: 'imageHero', child: image);
              },
              initGestureConfigHandler: (ExtendedImageState state) {
                return GestureConfig(
                  //you must set inPageView true if you want to use ExtendedImageGesturePageView
                  inPageView: true,
                  initialScale: 1.0,
                  maxScale: 5.0,
                  animationMaxScale: 6.0,
                  initialAlignment: InitialAlignment.center,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color slidePageBackgroundHandler(Offset offset, Size pageSize) {
    double opacity = offset.dy.abs() / (pageSize.height / 2.0);
    return Colors.black.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
  }

}
