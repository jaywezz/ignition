import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/repository/sales_count.dart';
import 'package:soko_flow/models/leadsModel/new_leads.dart';
import 'package:soko_flow/models/ordersCountModel/orders_count.dart';
import 'package:soko_flow/models/salesCountModel/sales_count.dart';
import 'package:soko_flow/models/visitCountModel/visit_count.dart';

import '../repository/new_leads_repo.dart';
import '../repository/orders_count_repo.dart';
import '../repository/visit_count_repo.dart';

final salesCountProvider = FutureProvider.autoDispose<SalesCount>((ref) {
  final sales = ref.read(salesCountRepositoryProvider).getSalesCount();
  return sales;
});

final ordersCountProvider = FutureProvider.autoDispose<OrdersCount>((ref) {
  final orders = ref.read(ordersCountRepositoryProvider).getOrdersCount();
  return orders;
});

final newLeadsCountProvider = FutureProvider.autoDispose<NewLeads>((ref) {
  final leads = ref.read(newLeadsRepositoryProvider).getNewLeads();
  return leads;
});

final visitsCountCountProvider = FutureProvider.autoDispose<VisitsCount>((ref) {
  final visits = ref.read(visitsCountRepositoryProvider).getVisitsCount();
  return visits;
});
