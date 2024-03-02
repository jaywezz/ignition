import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
//import 'package:soko_flow/views/customers/customer_details.dart';

class OrderSummaryCard extends StatelessWidget {
  OrderSummaryCard({Key? key, this.children, this.action}) : super(key: key);
  var children;
  var action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //action();
        //Navigate.instance.toRoute(const CustomerDetailsScreen());
      },
      child: Card(
        elevation: 5,
        child: Container(
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 3,
                child: Center(
                    child: Container(
                  //height: Responsive.isMobile(context) ? 80 : 100,
                  //width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('Monster Blue Ice 25OML'),
                          Text('Monster Blue Ice 25OML')
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ),
              Flexible(
                //flex,
                child: Container(
                  width: 450,
                  height: 1,
                  color: Colors.black38,
                ),
              ),
              Flexible(
                flex: 3,
                child: Center(
                    child: Container(
                  //height: Responsive.isMobile(context) ? 80 : 100,
                  //width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('Monster Blue Ice 25OML'),
                          Text('Monster Blue Ice 25OML')
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ),
              Flexible(
                //flex,
                child: Container(
                  width: 450,
                  height: 1,
                  color: Colors.black38,
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Sub Total'),
                          Expanded(child: Container()),
                          Text(
                            'Ksh 14,320',
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
                          Text('Tax'),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Container()),
                          Text(
                            'Ksh 704',
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
                          Text('Shipping'),
                          Expanded(child: Container()),
                          Text(
                            'Ksh 2,400',
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
                          Text('Total'),
                          Expanded(child: Container()),
                          Text(
                            'Ksh 18,640',
                            style: Styles.normalText(context)
                                .copyWith(fontWeight: FontWeight.w600),
                            maxLines: 3,
                          )
                        ],
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
