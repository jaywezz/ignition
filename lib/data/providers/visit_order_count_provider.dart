
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/repository/get_data_count.dart';

final customerVisitsOrderProvider = FutureProvider.autoDispose.family<Response, String>((ref, customer_id) async{
  final targets = await ref.watch(customerVisitsOrderRepo).getVisitOrder(customer_id);
  return targets;
});
