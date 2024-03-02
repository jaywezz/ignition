import 'package:flutter/material.dart';

class ShipmentsPage extends StatefulWidget {
  const ShipmentsPage({Key? key}) : super(key: key);

  @override
  State<ShipmentsPage> createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Shipments"),
      ),
    );
  }
}
