import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatCard extends StatefulWidget {
  final String name;
  final String message;
  const ChatCard({Key? key, required this.name, required this.message}) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05322,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05322,
                width: MediaQuery.of(context).size.width * 0.1121,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/wespic.jpeg"))),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.034,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name ?? "",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge!
                            .copyWith(
                          color: Color(0XFF77838F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                      ),
                      Text(
                        "08:24 AM",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodySmall!
                            .copyWith(
                          color: Color(0XFF77838F),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.006201,
                  ),
                  Text(
                    widget.message?? "",
                    style:
                    Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                      color: Color(0XFF77838F),
                      fontSize: 9,
                    ),
                  ),
                ],
              )
            ],
          ),
          // Container(
          //   height: 1,
          //   width: MediaQuery.of(context).size.width,
          //   color: AppColors.greyishColor,
          // )
        ],
      ),
    );
  }
}

