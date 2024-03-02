
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_targets_provider.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_titles_provider.dart';
import 'package:soko_flow/data/providers/reports_providers/reports_provider.dart';
import 'package:soko_flow/models/reports_model.dart';

final maxYprovider = StateProvider.autoDispose<double>(((ref) {
  double value = 0.0;
  ref.watch(graphDataProvider).forEach((k,v){
    if(v[0] + v[1]>value) {
      value = v[0] + v[1];
    }
  });
  return value;
}));
final graphDataProvider = StateProvider.autoDispose<Map<int, List<double>>>((ref){
  Map<int, List<double>> mainItems ={};
  String target = ref.watch(graphTargetsProvider);
  GraphFilters filter = ref.watch(graphFilterProvider);

  print("the target: $target");
  mainItems = <int, List<double>>{
    0: [0, double.parse(target)],
    1: [0, double.parse(target)],
    2: [0, double.parse(target)],
    3: [0, double.parse(target)],
    4: [0, double.parse(target)],
    5: [0, double.parse(target)],
  };

  print("the selected filter is : ${filter.name}");
  if (filter.name == GraphFilters.today.name) {
    print("the target for day is: $target");
    print("in the sale: ${ref.watch(todaySalesReportProvider)}");
    for (var sale in ref.watch(todaySalesReportProvider)) {
      print("executing today");

      if(sale.createdAt!.hour >=8 && sale.createdAt!.hour<=10){
        print("1st hour");
        mainItems[0] = [mainItems[0]![0] + double.parse(sale.priceTotal!), double.parse(target) -double.parse(sale.priceTotal!)];
      }
      else if(sale.createdAt!.hour >=10 && sale.createdAt!.hour<=12){
        print("2st hour");
        mainItems[1] = [mainItems[1]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
      }
      else if(sale.createdAt!.hour >=12 && sale.createdAt!.hour<=14){
        print("3st hour");
        mainItems[2] = [mainItems[2]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
      }
      else if(sale.createdAt!.hour >=14 && sale.createdAt!.hour<=16){
        print("4st hour");
        mainItems[3] = [mainItems[3]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
      }
      else if(sale.createdAt!.hour >=16 && sale.createdAt!.hour<=18){
        print("5st hour");
        mainItems[4] = [mainItems[4]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
      }else{
        mainItems[5] = [mainItems[5]![0] + double.parse(sale.priceTotal!),0];
      }

    }

  }else if (filter.name == GraphFilters.week.name) {
    print("executing for week");
    for (var sale in ref.watch(weeklyReportsProvider)) {
      print("executing week");
      switch(sale.createdAt!.weekday) {
        case 1:
          print("weekday 1");
          mainItems[0] = [mainItems[0]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          break;
        case 2:
          mainItems[1] = [mainItems[1]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          // code block
          break;
        case 3:
          mainItems[2] = [mainItems[2]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          // code block
          break;
        case 4:
          mainItems[3] = [mainItems[3]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          // code block
          break;
        case 5:
          mainItems[4] = [mainItems[4]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          // code block
          break;
        case 6:
          mainItems[5] = [mainItems[4]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
          // code block
          break;
        default:
        // code block
      }
    }

  }else if(filter == GraphFilters.month){
    mainItems = <int, List<double>>{
      0: [0, double.parse(target)],
    };
    for (var sale in ref.watch(monthlyReportsProvider)) {
      mainItems[0] = [mainItems[0]![0] + double.parse(sale.priceTotal!), double.parse(target)-double.parse(sale.priceTotal!)];
    }
    print("the main items: $mainItems");
  }
  return mainItems;
});


