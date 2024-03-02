import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/views/chat/screens/chat_specific.dart';
import 'package:soko_flow/views/chat/widgets/chat_profile_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Chat",
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
                    print(MediaQuery.of(context).size.width * 0.06);
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
                        Icons.arrow_back_ios,
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
                      GestureDetector(
                        onTap: () {
                          Get.to(ChattingScreen());
                        },
                        child: const ChatCard(
                          name: "Shikwekwe Olosho",
                          message: "How much will you charge for 12 people?",
                        ),
                      ),
                      const SizedBox(
                        height: 9.5,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Styles.greyColor.withOpacity(0.3),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ChatCard(
                        name: "Shikwekwe Wesley",
                        message: "How much will you charge for 12 people?",
                      ),
                      const SizedBox(
                        height: 9.5,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Styles.greyColor.withOpacity(0.3),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}

