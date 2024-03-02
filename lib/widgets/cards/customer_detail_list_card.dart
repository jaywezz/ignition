import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
//import 'package:soko_flow/views/customers/customer_details.dart';

class CustomerDetailListCard extends StatelessWidget {
  CustomerDetailListCard({Key? key, this.children, this.action})
      : super(key: key);
  var children;
  var action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        action();
        //Navigate.instance.toRoute(const CustomerDetailsScreen());
      },
      child: Card(
        elevation: 5,
        child: Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 2,
                child: Center(
                    child: Container(
                  height: Responsive.isMobile(context) ? 80 : 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 5,
                          left: 5,
                          right: 5,
                          child: Container(
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Styles.appPrimaryColor,
                            ),
                          )),
                      Container(
                        height: Responsive.isMobile(context) ? 80 : 100,
                        width: 100,
                        //width: Responsive.isMobile(context) ? 250 : 350,
                        decoration: BoxDecoration(
                            color: Styles.appBackgroundColor,
                            border: Border.all(
                                color: Styles.appPrimaryColor, width: 4)),
                      ),
                    ],
                  ),
                )),
              ),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.shop, color: Styles.appPrimaryColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Shop',
                            style: Styles.normalText(context)
                                .copyWith(fontWeight: FontWeight.w600),
                            maxLines: 3,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.location_on,
                              color: Styles.appPrimaryColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '23 Olenguruone Rd, Nairobi Kenya',
                            style: Styles.smallGreyText(context),
                            maxLines: 3,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.person, color: Styles.appPrimaryColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Owner:Jason Stathanm',
                            style: Styles.smallGreyText(context),
                            maxLines: 3,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.money, color: Styles.appPrimaryColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Credit Limit: 3,789',
                            style: Styles.smallGreyText(context),
                            maxLines: 3,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Styles.appBackgroundColor,
                  height: Responsive.isMobile(context) ? 40 : 60,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Call',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: defaultPadding(context) * 1.2,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 1,
                        color: Colors.black,
                      ),
                      Text(
                        'Message',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: defaultPadding(context) * 1.2,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
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
