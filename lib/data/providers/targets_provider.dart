import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/repository/targets_repo.dart';
import 'package:soko_flow/models/targets/targets_model.dart';

final timeFilterProvier = StateProvider((ref) => TargetsTimeFilter.Daily);

final targetsProvider = FutureProvider.autoDispose<Target>((ref) async{
  final targets = await ref.watch(targetsRepositoryProvider).getTargets();
  print("init prov ${targets.targetSales!}");

  return targets;
});

final filteredTargetsProvider = FutureProvider.autoDispose<Target>((ref) {
  final targets =ref.watch(targetsProvider);
  Target _target = Target(
      targetSales: "1",
      targetLeads: "1",
      targetsVisit: "1",
      targetsOrder: "1",
      achievedLeadsTarget: "0",
      achievedSalesTarget: "0",
      achievedOrderTarget: "0",
      achievedVisitTarget: "0"
  );
  try{

    targets.whenData((value) {
      _target = value;
      print("the _target: $value");
      print("achieved sales: ${_target.achievedSalesTarget}");
      print("target sales: ${_target.targetSales}");
      print("achieved leads: ${_target.achievedLeadsTarget}");
      print("target sales: ${_target.targetLeads}");
      print("achieved orders: ${_target.achievedOrderTarget}");
      print("target orders: ${_target.targetsOrder}");
      print("achieved visits: ${_target.achievedVisitTarget}");
      print("visits target: ${_target.targetsVisit}");
    });
    if(ref.watch(timeFilterProvier) == TargetsTimeFilter.Week){
      print("at provier week selected: ${_target.achievedSalesTarget}");
      _target = Target(
        targetSales: _target.targetSales=="0"?"1":(int.parse(_target.targetSales!) / 4).toString(),
        targetLeads: _target.targetLeads=="0"?"1":(int.parse(_target.targetLeads!) / 4).toString(),
        targetsVisit: _target.targetsVisit=="0"?"1":(int.parse(_target.targetsVisit!) / 4).toString(),
        targetsOrder: _target.targetsOrder=="0"?"1":(int.parse(_target.targetsOrder!) / 4).toString(),
        achievedLeadsTarget: (int.parse(_target.achievedLeadsWeeklyTarget ?? "0")).toString(),
        achievedSalesTarget: (int.parse(_target.achievedWeeklySalesTarget ?? "0")).toString(),
        achievedOrderTarget: (int.parse(_target.achievedWeeklyOrderTarget ?? "0")).toString(),
        achievedVisitTarget: (int.parse(_target.achievedWeeklyVisitTarget ?? "0")).toString(),
      );
      print("at daily: ${_target.targetSales}");
      return _target;
    }
    else if(ref.watch(timeFilterProvier) == TargetsTimeFilter.Daily){
      print("error: ${_target.targetsOrder!}");
      _target = Target(
        targetSales: _target.targetSales=="0"?"1":(int.parse(_target.targetSales!) / 24).toString(),
        targetLeads: _target.targetLeads=="0"?"1":(int.parse(_target.targetLeads!) / 24).toString(),
        targetsVisit: _target.targetsVisit=="0"?"1":(int.parse(_target.targetsVisit!) / 24).toString(),
        targetsOrder: _target.targetsOrder=="0"?"1":(int.parse(_target.targetsOrder!) / 24).toString(),
        achievedLeadsTarget: (int.parse(_target.achievedLeadsDailyTarget ?? "0")).toString(),
        achievedSalesTarget: (int.parse(_target.achievedDailySalesTarget ?? "0")).toString(),
        achievedOrderTarget: (int.parse(_target.achievedDailyOrderTarget ?? "0")).toString(),
        achievedVisitTarget: (int.parse(_target.achievedDailyVisitTarget ?? "0")).toString(),
      );
      print("at daily: ${_target.targetSales}");
      return _target;
    }else{
      _target = Target(
        targetSales: _target.targetSales=="0"?"1":(int.parse(_target.targetSales!)).toString(),
        targetLeads: _target.targetLeads=="0"?"1":(int.parse(_target.targetLeads!)).toString(),
        targetsVisit: _target.targetsVisit=="0"?"1":(int.parse(_target.targetsVisit!)).toString(),
        targetsOrder: _target.targetsOrder=="0"?"1":(int.parse(_target.targetsOrder!)).toString(),
        achievedLeadsTarget: (int.parse(_target.achievedLeadsMonthlyTarget ?? "0")).toString(),
        achievedSalesTarget: (int.parse(_target.achievedMonthlySalesTarget ?? "0")).toString(),
        achievedOrderTarget: (int.parse(_target.achievedMonthlyOrderTarget ?? "0")).toString(),
        achievedVisitTarget: (int.parse(_target.achievedMonthlyVisitTarget ?? "0")).toString(),
      );
      return _target;
    }


    return _target;
  }catch(e,s){
    print("error: $s");
    throw e;
  }
});


enum TargetsTimeFilter {Month, Week, Daily}