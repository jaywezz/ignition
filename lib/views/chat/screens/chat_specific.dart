import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/views/chat/widgets/chat_input.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/bg.png',
                ),
                fit: BoxFit.cover),
            borderRadius:
            BorderRadius.only(bottomLeft: Radius.circular(30))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              padding: const EdgeInsets.only(left: 15, right: 10),
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Row(
                  children: [
                    ChatTextField(
                      radius: 30.0,
                      height: 47,
                      width: MediaQuery.of(context).size.width * 0.77,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 47,
                      width: 47,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Styles.blueishColor),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Shikwekwe Olosho",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyMedium!
                      .copyWith(
                      fontSize: 16,
                      color: Styles.deepBlueColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    //print(MediaQuery.of(context).size.height * 0.228);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1, color: Styles.inputFillColor)),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Styles.deepBlueColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            color: Styles.greyColor.withOpacity(0.2),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: Color(0XFFA4A5A9).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Today",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall!
                                    .copyWith(
                                    fontSize: 10,
                                    color: Color(0XFFA4A5A9)),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            color: Styles.greyColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0XFFEAEAEA)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Are you in a position to get there in 20 minutes or less? I would\nlike you tobe honest.",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodySmall!
                                        .copyWith(
                                        color: Color(0XFF77838F),
                                        fontSize: 9),
                                  ),
                                ),
                              ),
                              Text("08:24 AM",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodySmall!
                                      .copyWith(
                                    color: Color(0XFF77838F),
                                    fontSize: 8,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height:
                                MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:  Styles.blueishColor
                                        .withOpacity(0.4)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Are you in a position to get there in 20 minutes or less? I would.",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodySmall!
                                              .copyWith(
                                              color:
                                              Color(0XFF77838F),
                                              fontSize: 9),
                                        ),
                                        Text(
                                          "I would like you tobe honest.",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodySmall!
                                              .copyWith(
                                              color:
                                              Color(0XFF77838F),
                                              fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text("08:24 AM",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodySmall!
                                      .copyWith(
                                    color: Color(0XFF77838F),
                                    fontSize: 8,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}

