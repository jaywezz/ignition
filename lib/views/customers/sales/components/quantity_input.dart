import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';

class QuantitySmallInput extends StatefulWidget {
  final String price;
  const QuantitySmallInput({Key? key,this.allocations, this.isReconcile, required this.price}) : super(key: key);

  final LatestAllocationModel? allocations;
  final bool? isReconcile;

  @override
  State<QuantitySmallInput> createState() => _QuantitySmallInputState();
}

class _QuantitySmallInputState extends State<QuantitySmallInput> {
  TextEditingController? controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isReconcile!){
      controller!.text = widget.allocations!.allocatedQty!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (String value){
        // print("controller text: ${textEditingController.text}");

        print(value);
        // print(stockHistoryController.lstLatestAllocations[index].productName);

        if(int.parse(value) > 0){
          if(int.parse(value) > int.parse(widget.allocations!.allocatedQty!.toString())){
            print("greater");
            Fluttertoast.showToast(
                msg: "Quantity cannot be more than ${widget.allocations!.allocatedQty}",
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
                webPosition: 'top',
                gravity: ToastGravity.TOP,
                backgroundColor:Colors.redAccent
            );


            controller!.text = widget.allocations!.allocatedQty!.toString();
          }else{
            var data = VanSalesCart(
                latestAllocationModel: widget.allocations,
                qty: int.parse(value),
                price: int.parse(widget.price)
            );
            print("the data is ${data.latestAllocationModel}, ${data.qty}");
            Get.find<AddToCartController>().addVanSalesCart(data);
            print("value");
          }

        }
        // _debouncer.run(() {
        //   print(value);
        // });
      },
      textAlign: TextAlign.center,
      cursorHeight: 15,
      cursorColor:
      Styles.appSecondaryColor,
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderSide: BorderSide(
              color: Styles
                  .appSecondaryColor),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
