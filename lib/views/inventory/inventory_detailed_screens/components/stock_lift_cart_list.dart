import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/allocation_history_model/allocations_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

class StockLiftCartList extends ConsumerStatefulWidget {
  final List<NewSalesCart>? cartProductList;

  const StockLiftCartList({Key? key,this.cartProductList}) : super(key: key);



  @override
  ConsumerState<StockLiftCartList> createState() => _StockLiftCartListState();
}

class _StockLiftCartListState extends ConsumerState<StockLiftCartList> {

  // TextEditingController qtyController = TextEditingController();
  List<TextEditingController>? _qtycontrollers = [];

  @override
  Widget build(BuildContext context) {
    print(widget.cartProductList);
    return SingleChildScrollView(
      child:  ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount:  widget.cartProductList!.length,
          itemBuilder: (context, ind) {
            _qtycontrollers!.add(TextEditingController());
            _qtycontrollers![ind].text = widget.cartProductList![ind].qty.toString();
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
                              Container(
                                width: MediaQuery.of(context).size.width *.45,
                                child: Text(
                                  widget.cartProductList![ind].productMo!.productName!,
                                  style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                "Unit: ${widget.cartProductList![ind].productMo!.skuCode!}",
                                style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                              ),

                              Text(
                                "WholeSale Price: Ksh. ${widget.cartProductList![ind].productMo!.wholesalePrice!}",
                                style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                              Text(
                                "Retail Price: Ksh. ${widget.cartProductList![ind].productMo!.retailPrice!}",
                                style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                              Text(
                                "Total: Ksh. ${(int.parse(widget.cartProductList![ind].productMo!.retailPrice!)) * (widget.cartProductList![ind].qty!)}",
                                style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Styles.appPrimaryColor),
                              ),

                            ],
                          ),

                          Row(
                            children: <Widget>[
                              widget.cartProductList![ind].qty !=0?  IconButton(icon: Icon(Icons.remove),onPressed: (){
                                if(widget.cartProductList![ind].qty! - 1 < 0){

                                }else{
                                  var data = NewSalesCart(
                                      productMo: widget.cartProductList![ind].productMo,
                                      qty: widget.cartProductList![ind].qty! - 1,
                                      price: widget.cartProductList![ind].productMo!.wholesalePrice!
                                  );
                                  _qtycontrollers![ind].text = (widget.cartProductList![ind].qty! - 1).toString();
                                  ref.watch(addStockLiftNotifier.notifier).addStockLiftCart(data);
                                }
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
                                      if( widget.cartProductList![ind].productMo!.stock! >= int.parse(value)){
                                        var data = NewSalesCart(
                                            productMo: widget.cartProductList![ind].productMo,
                                            qty: int.parse(value),
                                            price: widget.cartProductList![ind].productMo!.wholesalePrice!
                                        );
                                        ref.watch(addStockLiftNotifier.notifier).addStockLiftCart(data);
                                      }else{
                                        _qtycontrollers![ind].text =   widget.cartProductList![ind].productMo!.stock!.toString();
                                        showCustomSnackBar("Selected quantity not available",bgColor: Colors.blue, isError: true);
                                      }
                                      print("value");
                                    }
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
                                if(widget.cartProductList![ind].qty! + 1 <= widget.cartProductList![ind].productMo!.stock!){
                                  var data = NewSalesCart(
                                      productMo: widget.cartProductList![ind].productMo,
                                      qty: widget.cartProductList![ind].qty! + 1,
                                      price: widget.cartProductList![ind].productMo!.wholesalePrice!

                                  );
                                  _qtycontrollers![ind].text = (widget.cartProductList![ind].qty! + 1).toString();
                                  ref.watch(addStockLiftNotifier.notifier).addStockLiftCart(data);
                                }else{
                                  showCustomSnackBar("Selected quantity not available",bgColor: Colors.blue, isError: true);
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
