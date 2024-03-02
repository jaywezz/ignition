import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class AnimatedCircularProgressIndicator extends StatelessWidget {
  const AnimatedCircularProgressIndicator({
    Key? key,
    required this.percentage,
    required this.label,
  }) : super(key: key);
  final double percentage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Responsive.isMobile(context)
              ? defaultPadding(context) * 8
              : defaultPadding(context) * 9,
          width: Responsive.isMobile(context)
              ? defaultPadding(context) * 8
              : defaultPadding(context) * 9,
          child: AspectRatio(
            aspectRatio: 1,
            child: TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: 0,
                  end: percentage,
                ),
                duration: defaultDuration,
                builder: (context, double value, child) => Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          color: Styles.appBackgroundColor,
                          value: value,
                          //valueColor: Color(0x00ffffff),
                          strokeWidth: defaultPadding(context),
                          //color: primaryColor,
                          backgroundColor: Colors.grey.withOpacity(.3),
                        ),
                        Center(
                          child: Text(
                            (value * 100).toInt().toString() + '%',
                            style: Styles.buttonText2(context),
                          ),
                        ),
                      ],
                    )),
          ),
        ),
        SizedBox(
          height: defaultPadding(context) / 2,
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.buttonText1(context),
        ),
      ],
    );
  }
}
