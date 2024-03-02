import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
//import 'package:soko_flow/views/customers/customer_details.dart';

class OrderListCard extends StatelessWidget {
  OrderListCard({Key? key, this.children, this.action}) : super(key: key);
  var children;
  var action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pressed order details");
        action();

        // Navigate.instance.toRoute(const CustomerDetailsScreen());
      },
      child: Card(
        elevation: 5,
        child: Container(
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            children[0],
                            style: Styles.heading2(context),
                          ),
                          Text(
                            children[1],
                            style: Styles.heading4(context)
                          ),
                        ],

                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Delivery Date: ${children[2].toString()}",
                        style: Styles.smallGreyText(context),
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          padding: EdgeInsets.all(defaultPadding(context) * 0.2),
          width: double.infinity,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultPadding(context))),
      ),
    );
  }
}
