import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_titles_provider.dart';
import 'package:soko_flow/data/providers/targets_provider.dart';

final graphTargetsProvider = StateProvider.autoDispose<String>((ref) {
  String _salesTarget = "";
  final targets = ref.watch(targetsProvider).whenData((value) {
    print(value.targetSales);
    if(value.targetSales!.isEmpty){
      _salesTarget = "0";
    }else{
      if(ref.watch(graphFilterProvider) == GraphFilters.week){
        _salesTarget = (int.parse(value.targetSales!) / 4).toString();
      }
      if(ref.watch(graphFilterProvider) == GraphFilters.today){
        _salesTarget = (int.parse(value.targetSales!) / 24*5).toString();
      }
      if(ref.watch(graphFilterProvider) == GraphFilters.month){
        _salesTarget = (int.parse(value.targetSales!)).toString();
      }
    }
  });
  print("graph target: $_salesTarget");
  return _salesTarget;
});
