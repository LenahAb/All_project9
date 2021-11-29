import 'package:flutter/material.dart';
class  BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  final ImageProvider image;

  const BackgroundImageWidget({
    Key?key,
  required this.image,
  required this.child,}): super(key: key);

  @override
  Widget build(BuildContext context)=>
  Container(
  decoration: BoxDecoration(
  image: DecorationImage(image: image,
      fit: BoxFit.cover),
  ),

  child: child,
  );
  }

