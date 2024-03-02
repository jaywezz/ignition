import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/reconcile_controller.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class ReconcileCartList extends StatefulWidget {
  final String warehouse;
  final List<ReconcileCart>? reconcileCartList;

  const ReconcileCartList({Key? key,this.reconcileCartList, required this.warehouse}) : super(key: key);

  @override
  State<ReconcileCartList> createState() => _ReconcileCartListState();
}

class _ReconcileCartListState extends State<ReconcileCartList> {

  // var cartcontroller = Get.find<AddToCartController>();
  // TextEditingController qtyController = TextEditingController();
  List<TextEditingController>? _qtycontrollers = [];

  @override
  Widget build(BuildContext context) {
    print(widget.reconcileCartList);
    return GetBuilder<ReconcileController>(
      builder: (reconcileCart) {
        return SingleChildScrollView(
          child:  ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount:  reconcileCart.reconcileCartList.length,
              itemBuilder: (context, ind) {
                _qtycontrollers!.add(TextEditingController());
                _qtycontrollers![ind].text = widget.reconcileCartList![ind].qty.toString();
                return Card(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width *.4,
                                        child: Text(
                                          reconcileCart.reconcileCartList[ind].latestAllocationModel!.productName!,
                                          style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: 10,),


                                    ],
                                  ),
                                  SizedBox(height: 6,),
                                  Text(
                                    "Unit: ${reconcileCart.reconcileCartList[ind].latestAllocationModel!.skuCode!}",
                                    style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                                  ),

                                  Text(
                                    "Price: Ksh. ${reconcileCart.reconcileCartList[ind].latestAllocationModel!.wholeSalePrice!}",
                                    style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                                  ),
                                  Text(
                                    "Total: Ksh. ${(int.parse(reconcileCart.reconcileCartList[ind].latestAllocationModel!.wholeSalePrice!)) * (reconcileCart.reconcileCartList[ind].qty!)}",
                                    style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Styles.appPrimaryColor),
                                  ),

                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  reconcileCart.reconcileCartList[ind].qty !=0?  IconButton(icon: Icon(Icons.remove),onPressed: (){
                                    var data = ReconcileCart(
                                        latestAllocationModel: reconcileCart.reconcileCartList[ind].latestAllocationModel!,
                                        qty: reconcileCart.reconcileCartList[ind].qty! - 1,
                                    );
                                    _qtycontrollers![ind].text = (reconcileCart.reconcileCartList[ind].qty! - 1).toString();
                                    reconcileCart.addVanSalesCart(data);

                                  },
                                  ):Container(),
                                  Container(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _qtycontrollers![ind],
                                      // initialValue:  widget.cartProductList![ind].qty.toString(),

                                      onChanged: (String value){
                                        // print("controller text: ${textEditingController.text}");
                                        print(value);
                                        if(int.parse(value) > 0){
                                          if(int.parse(value) > int.parse(reconcileCart.reconcileCartList[ind].latestAllocationModel!.currentQty!.toString())){
                                            print("greater");
                                            Fluttertoast.showToast(
                                                msg: "Quantity cannot be more than ${reconcileCart.reconcileCartList[ind].latestAllocationModel!.currentQty!}",
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_LONG,
                                                webPosition: 'top',
                                                gravity: ToastGravity.TOP,
                                                backgroundColor:Colors.redAccent
                                            );

                                            // _qtycontrollers![ind].text = (int.parse(_qtycontrollers![ind].text)).toString();
                                            _qtycontrollers![ind].clear();
                                          }else{
                                            var data = ReconcileCart(
                                                latestAllocationModel:reconcileCart.reconcileCartList[ind].latestAllocationModel,
                                                qty: int.parse(value),
                                            );
                                            reconcileCart.addVanSalesCart(data);
                                            print("value");
                                          }
                                        }
                                        _qtycontrollers![ind].selection = TextSelection.fromPosition(TextPosition(offset: _qtycontrollers![ind].text.length));

                                        // _debouncer.run(() {
                                        //   print(value);
                                        // });
                                      },
                                      textAlign: TextAlign.center,
                                      cursorHeight: 15,
                                      cursorColor:
                                      Styles.appPrimaryColor,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Styles
                                                  .appPrimaryColor),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Styles
                                                  .appPrimaryColor),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  IconButton(icon: Icon(Icons.add),onPressed: (){
                                    if(reconcileCart.reconcileCartList[ind].qty! + 1 > int.parse(reconcileCart.reconcileCartList[ind].latestAllocationModel!.currentQty!.toString())){
                                      print("greater");
                                      Fluttertoast.showToast(
                                          msg: "Quantity cannot be more than ${reconcileCart.reconcileCartList[ind].latestAllocationModel!.currentQty!}",
                                          textColor: Colors.white,
                                          toastLength: Toast.LENGTH_LONG,
                                          webPosition: 'top',
                                          gravity: ToastGravity.TOP,
                                          backgroundColor:Colors.redAccent
                                      );

                                      _qtycontrollers![ind].text = (int.parse(_qtycontrollers![ind].text)).toString();
                                    }else{
                                      var data = ReconcileCart(
                                          latestAllocationModel: reconcileCart.reconcileCartList[ind].latestAllocationModel,
                                          qty: widget.reconcileCartList![ind].qty! + 1,
                                      );
                                      _qtycontrollers![ind].text = (reconcileCart.reconcileCartList[ind].qty! + 1).toString();
                                      reconcileCart.addVanSalesCart(data);
                                    }

                                  })
                                ],
                              ),

                            ],
                          ),
                          // IconButton(icon: Icon(Icons.delete, color: Colors.grey, size: 20,),onPressed: (){
                          //
                          // })
                        ],
                      ),
                    ),
                    width: Responsive.isMobile(context) ? 250 : 350,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      // borderRadius: BorderRadius.circular(defaultPadding(context))
                    ),
                  ),
                );
              }),
          // child: Card(
          //     child: Container(
          //       padding: EdgeInsets.symmetric(
          //           horizontal: defaultPadding(context),
          //           vertical: defaultPadding(context) / 2),
          //       // child: Column(
          //       //   children: [
          //       //     Row(
          //       //       mainAxisAlignment: MainAxisAlignment.start,
          //       //       children: [
          //       //         Expanded(
          //       //           flex: 3,
          //       //           child: Container(
          //       //             decoration: BoxDecoration(
          //       //                 border: Border(
          //       //                     right: BorderSide(
          //       //                         width: 2, color: Colors.grey.withOpacity(.5)))),
          //       //             child: Text(
          //       //               'Product',
          //       //               style: Styles.heading3(context),
          //       //             ),
          //       //           ),
          //       //         ),
          //       //         Expanded(
          //       //           flex: 1,
          //       //           child: Container(
          //       //             decoration: BoxDecoration(
          //       //                 border: Border(
          //       //                     right: BorderSide(
          //       //                         width: 2, color: Colors.grey.withOpacity(.5)))),
          //       //             child: Center(
          //       //               child: Text(
          //       //                 'SKU',
          //       //                 style: Styles.heading3(context),
          //       //               ),
          //       //             ),
          //       //           ),
          //       //         ),
          //       //         Expanded(
          //       //           flex: 1,
          //       //           child: Container(
          //       //             decoration: BoxDecoration(
          //       //                 border: Border(
          //       //                     right: BorderSide(
          //       //                         width: 2, color: Colors.grey.withOpacity(.5)))),
          //       //             child: Center(
          //       //               child: Text(
          //       //                 'Qty',
          //       //                 style: Styles.heading3(context),
          //       //               ),
          //       //             ),
          //       //           ),
          //       //         ),
          //       //         Expanded(
          //       //           flex: 1,
          //       //           child: Center(
          //       //             child: Text(
          //       //               'Amt',
          //       //               style: Styles.heading3(context),
          //       //             ),
          //       //           ),
          //       //         ),
          //       //       ],
          //       //     ),
          //       //     Container(
          //       //       height: 1,
          //       //       color: Colors.grey.withOpacity(.5),
          //       //     ),
          //       //     ListView.separated(
          //       //         physics: NeverScrollableScrollPhysics(),
          //       //         separatorBuilder: (context, index) => Divider(
          //       //           color: Styles.appPrimaryColor,
          //       //         ),
          //       //         shrinkWrap: true,
          //       //         itemCount: 1,
          //       //         itemBuilder: (context, index) {
          //       //
          //       //           List data = mycustomers[index]['types']['data'];
          //       //           return Row(
          //       //             mainAxisAlignment: MainAxisAlignment.start,
          //       //             crossAxisAlignment: CrossAxisAlignment.start,
          //       //             children: [
          //       //               Expanded(
          //       //                 flex: 3,
          //       //                 child: Container(
          //       //                   decoration: BoxDecoration(
          //       //                       border: Border(
          //       //                           right: BorderSide(
          //       //                               width: 2,
          //       //                               color: Colors.grey.withOpacity(.5)))),
          //       //                   child: Column(
          //       //                     mainAxisAlignment: MainAxisAlignment.start,
          //       //                     crossAxisAlignment: CrossAxisAlignment.start,
          //       //                     children: [
          //       //                       SizedBox(
          //       //                         height: defaultPadding(context) / 2,
          //       //                       ),
          //       //                       // Text(
          //       //                       //   mycustomers[index]['productName'],
          //       //                       //   style: Styles.heading3(context),
          //       //                       // ),
          //       //                       ListView.builder(
          //       //                           physics: NeverScrollableScrollPhysics(),
          //       //                           shrinkWrap: true,
          //       //                           itemCount: widget.cartProductList!.length,
          //       //                           itemBuilder: (context, ind) {
          //       //                             return Text(
          //       //                               widget.cartProductList![ind].productMo!.productName!,
          //       //                               style: Styles.smallGreyText(context),
          //       //                             );
          //       //                           }),
          //       //                     ],
          //       //                   ),
          //       //                 ),
          //       //               ),
          //       //               Expanded(
          //       //                 flex: 1,
          //       //                 child: Container(
          //       //                   decoration: BoxDecoration(
          //       //                       border: Border(
          //       //                           right: BorderSide(
          //       //                               width: 2,
          //       //                               color: Colors.grey.withOpacity(.5)))),
          //       //                   child: Column(
          //       //                     mainAxisAlignment: MainAxisAlignment.center,
          //       //                     crossAxisAlignment: CrossAxisAlignment.center,
          //       //                     children: [
          //       //                       SizedBox(
          //       //                         height: defaultPadding(context) / 2,
          //       //                       ),
          //       //                       // Text(
          //       //                       //   '',
          //       //                       //   style: Styles.heading3(context),
          //       //                       // ),
          //       //
          //       //                       ListView.builder(
          //       //                           physics: NeverScrollableScrollPhysics(),
          //       //                           shrinkWrap: true,
          //       //                           itemCount:  widget.cartProductList!.length,
          //       //                           itemBuilder: (context, ind) {
          //       //                             return Center(
          //       //                               child: Text(
          //       //                                 // getData(mycustomers[index], ['types', 'quantity'])
          //       //                                 //     .toString(),
          //       //                                   widget.cartProductList![ind].productMo!.skuCode!,
          //       //                                 style: Styles.smallGreyText(context),
          //       //                               ),
          //       //                             );
          //       //                           })
          //       //                     ],
          //       //                   ),
          //       //                 ),
          //       //               ),
          //       //               Expanded(
          //       //                 flex: 1,
          //       //                 child: Container(
          //       //                   decoration: BoxDecoration(
          //       //                       border: Border(
          //       //                           right: BorderSide(
          //       //                               width: 2,
          //       //                               color: Colors.grey.withOpacity(.5)))),
          //       //                   child: Column(
          //       //                     mainAxisAlignment: MainAxisAlignment.center,
          //       //                     crossAxisAlignment: CrossAxisAlignment.center,
          //       //                     children: [
          //       //                       SizedBox(
          //       //                         height: defaultPadding(context) / 2,
          //       //                       ),
          //       //                       // Text(
          //       //                       //   '',
          //       //                       //   style: Styles.heading3(context),
          //       //                       // ),
          //       //
          //       //                       ListView.builder(
          //       //                           physics: NeverScrollableScrollPhysics(),
          //       //                           shrinkWrap: true,
          //       //                           itemCount:  widget.cartProductList!.length,
          //       //                           itemBuilder: (context, ind) {
          //       //                             return Center(
          //       //                               child: Text(
          //       //                                 // getData(mycustomers[index], ['types', 'quantity'])
          //       //                                 //     .toString(),
          //       //                                   widget.cartProductList![ind].qty!,
          //       //                                 style: Styles.smallGreyText(context),
          //       //                               ),
          //       //                             );
          //       //                           })
          //       //                     ],
          //       //                   ),
          //       //                 ),
          //       //               ),
          //       //               Expanded(
          //       //                 flex: 1,
          //       //                 child: Column(
          //       //                   mainAxisAlignment: MainAxisAlignment.center,
          //       //                   crossAxisAlignment: CrossAxisAlignment.center,
          //       //                   children: [
          //       //                     SizedBox(
          //       //                       height: defaultPadding(context) / 2,
          //       //                     ),
          //       //                     // Text(
          //       //                     //   '',
          //       //                     //   style: Styles.heading3(context),
          //       //                     // ),
          //       //
          //       //                     ListView.builder(
          //       //                         physics: NeverScrollableScrollPhysics(),
          //       //                         shrinkWrap: true,
          //       //                         itemCount:  widget.cartProductList!.length,
          //       //                         itemBuilder: (context, ind) {
          //       //                           return Center(
          //       //                             child: Text(
          //       //                                 widget.cartProductList![ind].productMo!.price!,
          //       //                               style: Styles.smallGreyText(context),
          //       //                             ),
          //       //                           );
          //       //                         })
          //       //                   ],
          //       //                 ),
          //       //               ),
          //       //             ],
          //       //           );
          //       //         }),
          //       //
          //       //
          //       //   ],
          //       // ),
          //       child: ListView.builder(
          //               physics: NeverScrollableScrollPhysics(),
          //               shrinkWrap: true,
          //               itemCount:  widget.cartProductList!.length,
          //               itemBuilder: (context, ind) {
          //                 return Padding(
          //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //                   child: Row(
          //                     children: [
          //                       Column(
          //                         children: [
          //                           Text(widget.cartProductList![ind].productMo!.productName!,
          //                             style: Styles.heading3(context),
          //                           ),
          //                           Text(
          //                             widget.cartProductList![ind].qty.toString(),
          //                             style: Styles.normalText(context),
          //                           ),
          //
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 );
          //               })
          //     )),
        );
      }
    );
  }

  final List<Map> mycustomers = [
    {
      'productName': 'Drinking Water',
      'types': {
        'data': [
          {'name': 'Dasani', 'quantity': '1L', 'price': 'KSH 110'},
          {'name': 'Quencher', 'quantity': '500ML', 'price': 'Ksh 46'},
          {'name': 'Highlands', 'quantity': '1L', 'price': 'KSH 67'},
          {'name': 'Waba 5L', 'quantity': '5L', 'price': 'KSH 250'},
        ]
      }
    },
    {
      'productName': 'Soda',
      'types': {
        'data': [
          {'name': 'Coca Cola', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Sprite', 'quantity': '1L', 'price': 'Ksh 70'},
          {'name': 'Fanta Orange', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Fanta Passion', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Fanta Blackcurrant', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Fanta Watermelon', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Stoney', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Krest', 'quantity': '500ML', 'price': 'KSH 56'},
        ]
      }
    },
    {
      'productName': 'Energy Drink',
      'types': {
        'data': [
          {'name': 'Monster', 'quantity': '250ML', 'price': 'KSH 240'},
          {'name': 'Redbull', 'quantity': '250ML', 'price': 'Ksh 180'},
          {'name': 'Power', 'quantity': '250ML', 'price': 'KSH 130'},
          {'name': 'Sunlight', 'quantity': '250ML', 'price': 'KSH 123'},
        ]
      }
    },
    {
      'productName': 'Alcohol(Beer)',
      'types': {
        'data': [
          {'name': 'Heineken', 'quantity': '500ML', 'price': 'KSH 180'},
          {'name': 'Whitecap', 'quantity': '500ML', 'price': 'Ksh 185'},
          {'name': 'Guiness', 'quantity': '500ML', 'price': 'KSH 160'},
          {'name': 'Balozi', 'quantity': '500ML', 'price': 'KSH 140'},
        ]

      }
    },
    {
      'productName': 'Juice',
      'types': {
        'data': [
          {'name': 'Heineken', 'quantity': '500ML', 'price': 'KSH 180'},
          {'name': 'Whitecap', 'quantity': '500ML', 'price': 'Ksh 185'},
          {'name': 'Guiness', 'quantity': '500ML', 'price': 'KSH 160'},
          {'name': 'Balozi', 'quantity': '500ML', 'price': 'KSH 140'},
        ]
      }
    },
  ];
}
