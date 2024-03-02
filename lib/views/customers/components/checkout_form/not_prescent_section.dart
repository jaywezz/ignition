import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/data/providers/products_provider.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';

class OutofStockSection extends ConsumerStatefulWidget {
  const OutofStockSection({Key? key}) : super(key: key);

  @override
  ConsumerState<OutofStockSection> createState() => _PrescenceSectionState();
}

class _PrescenceSectionState extends ConsumerState<OutofStockSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Products that are currently available.",
          style: Styles.heading3(context).copyWith(color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        ref.watch(filteredProductsProvider).when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (builder, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(data[index].productName.toString(),
                                  style: Styles.normalText(context)),
                            ),
                            Container(
                              width: 50,
                              height: 30,
                              child: TextFormField(
                                // controller: textEditingController,
                                onChanged: (String value) {
                                  print(value);
                                  print(data[index].productName);
                                  if (int.parse(value) > 0) {
                                    var cartData = NewSalesCart(
                                        productMo: data[index],
                                        qty: int.parse(value),
                                        price: data[index].wholesalePrice!);
                                    // ref.read(customerNotifier.notifier)
                                    //     .addOutOfStockProductsCart(cartData);
                                  }
                                },
                                textAlign: TextAlign.center,
                                cursorHeight: 15,
                                cursorColor: Styles.appSecondaryColor,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 1,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Styles.appSecondaryColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Styles.appSecondaryColor),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              );
            },
            error: (error, stackTrace) => Text(
                  error.toString(),
                  style: Styles.heading3(context).copyWith(color: Colors.red),
                ),
            loading: () {
              return Center(
                child: CircularProgressIndicator(),
              );
            })
      ],
    );
  }
}
