import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/views/customers/components/checkout_form/checkout_form_screen.dart';
import 'package:soko_flow/widgets/inputs/default_text_field.dart';
import 'package:soko_flow/widgets/inputs/form_drop_down_widget.dart';

class PricingSection extends ConsumerStatefulWidget {
  const PricingSection({Key? key}) : super(key: key);

  @override
  ConsumerState<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends ConsumerState<PricingSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormDropDownField(
              title: "Is cluent interested in making a new order(Yes/No)",
              onChanged: (value) {
                ref.watch(checkoutFormDataProvider).interestedInNewOrder = value;
              },
              value: "Yes",
              itemsLists: const ["Yes", "No", "Not Sure"]),

          SizedBox(height: 10,),
          FormDropDownField(
              title: "Is the product pricing accurate: ( Yes/ No)",
              onChanged: (value) {
                ref.watch(checkoutFormDataProvider).pricingAccuracy = value;
              },
              value: "Yes",
              itemsLists: const ["Yes", "No"]),
          SizedBox(height: 10,),
          ref.watch(checkoutFormDataProvider).pricingAccuracy== "Yes"?SizedBox():Text(
            "If no, Type the product name and current price.",
            style: Styles.heading3(context).copyWith(color: Colors.black54),
          ),
          SizedBox(height: 10,),
          ref.watch(checkoutFormDataProvider).pricingAccuracy! == "Yes"?SizedBox():Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // You can customize the border color here
                width: 1.0, // You can customize the border width here
              ),
              borderRadius: BorderRadius.circular(8.0), // You can customize the border radius here
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                maxLines: null, // This allows the text field to expand to multiple lines
                minLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value){
                  if(value!.isEmpty){
                    return "Field Required";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove the default border of the TextField
                  hintText: 'If no; Type the product name and current price.', // Placeholder text
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          FormDropDownField(
              title: "Progress status of product offers",
              onChanged: (value) {
                ref.watch(checkoutFormDataProvider).progressStatus = value;
              },
              value: "Very poor",
              itemsLists: const ["Very poor", "Average", "Good",]),
        ],
      ),
    );
  }
}
