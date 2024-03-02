import 'package:flutter/material.dart';
import 'package:soko_flow/configs/styles.dart';

class GlobalMethod {
  Future<void> showDialogg(String title, Widget widget, String canclButtntxt,
      String okButtntxt, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: Styles.heading2(context),
            ),
            content: widget,
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black, width: 0.5),
                              right:
                                  BorderSide(color: Colors.black, width: 1))),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            canclButtntxt,
                            style: Styles.heading3(context)
                                .copyWith(color: Colors.black26),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5),
                      )),
                      child: TextButton(
                          onPressed: () {
                            fct();
                          },
                          child: Text(okButtntxt,
                              style: Styles.heading3(context)
                                  .copyWith(color: Styles.appPrimaryColor))),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
