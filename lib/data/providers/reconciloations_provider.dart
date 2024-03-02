import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/all_reconciliations_repo.dart';
import 'package:soko_flow/models/reconcile/reconciliations_list_model.dart';

final reconciliationsProvider = FutureProvider<List<ReconciliationListModel>>((ref) async {
  final reconciliations = await ref.watch(allReconciliationRepo).getAllReconciliations(false);
  return reconciliations.reversed.toList();
});