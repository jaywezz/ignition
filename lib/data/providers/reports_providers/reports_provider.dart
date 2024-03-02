import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_titles_provider.dart';
import 'package:soko_flow/data/repository/reports_repository.dart';
import 'package:soko_flow/models/reports_model.dart';

final salesProvider = FutureProvider.autoDispose<Reports>((ref) async {
  // Box box = await Hive.openBox<Deposits>(HiveBoxConstants.boxDeposits);
  // final deposits = ref.watch(localStorageRepoProvider).getListData(box) as List<Deposits>;
  final salesReports = await ref.watch(salesRepositoryProvider).getSalesReports();

  return salesReports;
});


final todaySalesReportProvider = StateProvider.autoDispose<List<ReportsData>>((ref){
  final salesReportProvider = ref.watch(salesProvider);
  List<ReportsData> todayReports = [];
  salesReportProvider.whenData((value) {
    todayReports.addAll(value.ordersToday!);
  });
  return todayReports;
});

final weeklyReportsProvider = StateProvider.autoDispose<List<ReportsData>>((ref)  {
  final salesReportProvider = ref.watch(salesProvider);
  List<ReportsData> weekReports = [];
  salesReportProvider.whenData((value) {
    weekReports.addAll(value.ordersWeekly!);
  });
  return weekReports;
});

final monthlyReportsProvider = StateProvider.autoDispose<List<ReportsData>>((ref)  {
  final salesReportProvider = ref.watch(salesProvider);
  List<ReportsData> monthlyReports = [];
  salesReportProvider.whenData((value) {
    monthlyReports.addAll(value.ordersMonthly!);
  });
  return monthlyReports;
});

final salesCountReportsProvider = StateProvider.autoDispose<String>((ref)  {
  final salesReportProvider = ref.watch(salesProvider);
  final salesFilter = ref.watch(salesFilterProvider);
  String sales;
  print("selected filter ${salesFilter}");
  if(salesFilter.name == GraphFilters.month.name){

    salesReportProvider.whenData((value) {
      sales = value.totalSalesMonthly.toString();
      print("the monthly sales $sales");
      return sales;

    });

  }
  else if(salesFilter == GraphFilters.week){
    salesReportProvider.whenData((value) {
      sales = value.totalSalesWeekly.toString();
      return sales;
    });
  }
  else{
    salesReportProvider.whenData((value) {
      sales = value.totalSalesToday.toString();
      return sales;
    });

  }
  return "0";

});



