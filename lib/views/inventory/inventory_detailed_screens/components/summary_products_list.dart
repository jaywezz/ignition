import 'package:flutter/material.dart';
import 'package:soko_flow/widgets/buttons/item_quantity_count_button.dart';

class SummaryProductsList extends StatefulWidget {
  const SummaryProductsList({Key? key}) : super(key: key);

  @override
  State<SummaryProductsList> createState() => _SummaryProductsListState();
}

class _SummaryProductsListState extends State<SummaryProductsList> {
  int _value = 1;
  void _QuantityIncreament() {
    setState(() {
      _value++;
    });
  }

  void _QuantityDecreament() {
    setState(() {
      _value--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      itemBuilder: (BuildContextcontext, index) {
        return Container(
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      left: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/monster_test_img.jpeg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Monster Blue Ice 250ML",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ItemQuantityButtonCount(
                                  onPress: () {
                                    _QuantityDecreament();
                                  },
                                  icon: Icons.remove,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  _value.toString(),
                                  style: TextStyle(),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                ItemQuantityButtonCount(
                                  onPress: () {
                                    _QuantityIncreament();
                                  },
                                  icon: Icons.add,
                                ),
                                SizedBox(width: 13),
                                Text(
                                  "x",
                                  style: TextStyle(),
                                ),
                                SizedBox(width: 8),
                                Text("200",
                                    style: TextStyle(
                                        // fontSize: 16,
                                        ))
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  print("youTapped");
                                },
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 15, right: 15, top: 12),
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }
}
