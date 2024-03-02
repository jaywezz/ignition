import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';

import '../../routes/route_helper.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static final orderHelp = [
    'Can I change details of a customer I have recently added',
    'Can I delete a Customer?',
    'Can I change customer Locations from the one automatically filled by geolocator?',
    'Can I add a customer when not in their premise location?',
    'My customer didnt get added',
    'Geolocator not working',
    'How do I checkin to a customer',
    'How do I checkin to a customer',
    'How to perform van sales',
    'How to add new sales order',
    'My stocklift not showing up in customers van sales?',
    'Why is completing a van sale taking longer than expected?',
    'Mpesa payment popup not showing up?',
  ];
  static final paymentHelp = [
    'Can Customers pay with cash?',
    'How can I change  payment method?',
    'How do I request invoice for an order?',
    'Are there any gift cards? ',
    'How do I use Sokoflow points?',
    'How do I view and download receipts',
    'Customer was charged wrong amount',
    'I have an unrecongnized charge',
  ];
  static final salesHelp = [
    'Can I change quantities in customer van sales?',
    'Can I change my email address?',
    'Can I change my password?',
    'Can I change my phone number?',
    'Can I change my profile picture?',
    'Can I delete my account?',
    'Can I delete my account?',
  ];
  static final accountHelp = [
    'Can I change quantities in customer van sales?',
    'Can I change my email address?',
    'Can I change my password?',
    'Can I change my phone number?',
    'Can I change my profile picture?',
    'Can I delete my account?',
    'Can I delete my account?',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        //color: Styles.appBackgroundColor,
        child: Container(
          padding: EdgeInsets.only(
              top: defaultPadding(context) * 3,
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
          child: Column(
            children: [
              SizedBox(
                height: defaultPadding(context),
              ),
              Stack(
                children: [
                  Material(
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Styles.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Help',
                      style: Styles.heading2(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () => Get.toNamed(RouteHelper.getInitial()),
                        child: Icon(
                          Icons.home_sharp,
                          size: defaultPadding(context) * 2,
                          color: Styles.appPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Card(
                            child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ExpandablePanel(
                                  header: Text(
                                    'Help with Customers',
                                    style: Styles.heading4(context),
                                  ),
                                  collapsed: Container(
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                                  expanded: Text(
                                    List.generate(orderHelp.length,
                                            (index) => orderHelp[index])
                                        .join('\n\n'),
                                    style: TextStyle(fontSize: 18),
                                  ))),
                        )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Card(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ExpandablePanel(
                                header: Text('Help with  Sales',
                                    style: Styles.heading4(context)),
                                collapsed: Container(
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                                expanded: Text(
                                  List.generate(salesHelp.length,
                                          (index) => accountHelp[index])
                                      .join('\n\n'),
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Card(
                            child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ExpandablePanel(
                                  header: Text('Help with Payment Options',
                                      style: Styles.heading4(context)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                                  expanded: Text(
                                    List.generate(paymentHelp.length,
                                            (index) => paymentHelp[index])
                                        .join('\n\n'),
                                    style: TextStyle(fontSize: 18),
                                  ))),
                        )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Card(
                            child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ExpandablePanel(
                                  header: Text('Help with My Account',
                                      style: Styles.heading4(context)),
                                  collapsed: Container(
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                                  expanded: Text(
                                    List.generate(accountHelp.length,
                                            (index) => paymentHelp[index])
                                        .join('\n\n'),
                                    style: TextStyle(fontSize: 18),
                                  ))),
                        )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
