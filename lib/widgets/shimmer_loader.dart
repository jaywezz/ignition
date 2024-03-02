import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatefulWidget {
  final double height, width;
  const ShimmerLoader({Key? key, required this.height, required this.width}) : super(key: key);

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> {
  @override
  Widget build(BuildContext context) {

      return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.2),
                // border: Border.all(color: Colors.grey.shade300),
                borderRadius:
                BorderRadius.all(Radius.circular(5))),
            height: widget.height,
            width: widget.width,
          )
      );
    }
}
