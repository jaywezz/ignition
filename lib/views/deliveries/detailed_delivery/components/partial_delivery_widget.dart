import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class PartialDelivertWidget extends ConsumerStatefulWidget {
  const PartialDelivertWidget( {Key? key,}) : super(key: key);

  @override
  ConsumerState<PartialDelivertWidget> createState() => _PartialDelivertWidgetState();
}

class _PartialDelivertWidgetState extends ConsumerState<PartialDelivertWidget> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .678,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ref.watch(deliveryCartProvider).length,
          itemBuilder: (builder, index){
            return DeliveryItemCard(cartItem: ref.watch(deliveryCartProvider)[index],);
          }),
    );
  }
}

class DeliveryItemCard extends ConsumerStatefulWidget {
  final DeliveryCartModel cartItem;
  const DeliveryItemCard({Key? key,  required this.cartItem }) : super(key: key);

  @override
  ConsumerState<DeliveryItemCard> createState() => _DeliveryItemCardState();
}

class _DeliveryItemCardState extends ConsumerState<DeliveryItemCard> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // print("the new qty: ${ref.watch(deliveryCartProvider).where((element) => element.productId == widget.orderItem.productId).first.quantity!  - 1}");
    textEditingController.text = ref.watch(deliveryCartProvider).where((element) => element.productId == widget.cartItem.productId).first.qty!.toString();
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width *.5,
                        child: Text(
                          widget.cartItem.productName!,
                          style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        "Total: Ksh. ${widget.cartItem.sellingPrice}",
                        style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600, color: Styles.appPrimaryColor),
                      ),

                    ],
                  ),

                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.remove),onPressed: (){
                        if((int.parse(textEditingController.text) - 1) == 0){
                          showCustomSnackBar("Quantity cannot be less than 0");
                        }else{
                          print("id: ${widget.cartItem.productId}");
                          int index = ref.watch(deliveryCartProvider).indexWhere((element) => element.productId == widget.cartItem.productId);
                          setState(() {
                            ref.watch(deliveryCartProvider)[index].qty = ref.watch(deliveryCartProvider)[index].qty! - 1;
                            print("qty: ${ref.watch(deliveryCartProvider)[index].qty!}");
                          });
                        }

                      },
                      ),
                      Container(
                        width: 40,
                        height: 30,
                        child: TextFormField(
                          controller: textEditingController,
                          onChanged: (String value){
                            // print("controller text: ${textEditingController.text}");
                            print(value);
                            if(int.parse(value) > 0){
                              if(int.parse(value) > widget.cartItem.allocatedQuantity!){
                                showCustomSnackBar("Quantity cannot be greater than the allocated quantity");
                              }else{
                                print("id: ${widget.cartItem.productId}");
                                int index = ref.watch(deliveryCartProvider).indexWhere((element) => element.productId == widget.cartItem.productId);
                                setState(() {
                                  ref.watch(deliveryCartProvider)[index].qty = int.parse(value);
                                  print("qty: ${ref.watch(deliveryCartProvider)[index].qty!}");
                                });
                              }
                            }else{
                              showCustomSnackBar("Quantity cannot be less or equal to 0");
                            }
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
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Styles.appPrimaryColor),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(icon: Icon(Icons.add),onPressed: (){
                        if((int.parse(textEditingController.text) + 1) > widget.cartItem.allocatedQuantity!){
                          showCustomSnackBar("Quantity cannot be more than the allocated quantity");
                        }else{
                          setState(() {
                            print("id: ${widget.cartItem.productId}");
                            int index = ref.watch(deliveryCartProvider).indexWhere((element) => element.productId == widget.cartItem.productId);
                            setState(() {
                              ref.watch(deliveryCartProvider)[index].qty =ref.watch(deliveryCartProvider)[index].qty! + 1;
                              // print("qty: ${ref.watch(deliveryCartProvider)[index].quantity!}");
                            });
                          });
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
  }
}

