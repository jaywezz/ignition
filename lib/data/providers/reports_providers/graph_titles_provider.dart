
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


final graphFilterProvider = StateProvider<GraphFilters>((ref)=> GraphFilters.week);
final salesFilterProvider = StateProvider<GraphFilters>((ref)=> GraphFilters.week);
// final graphFilterProvider = StateProvider<GraphFilters>((ref)=> GraphFilters.week);

final graphTitlesProvider =
StateNotifierProvider.autoDispose< GraphTitlesNotifier, AsyncValue>((ref) {
  return GraphTitlesNotifier(ref: ref);
});
class GraphTitlesNotifier extends StateNotifier<AsyncValue> {
  GraphTitlesNotifier({required this.ref}) : super(const AsyncValue.data(null));
  Ref ref;

  Widget bottomTitles(double value, TitleMeta meta) {
    final filters = ref.watch(graphFilterProvider);
    print("the current: time filter: $filters");
    var style = TextStyle(
        fontFamily: 'Sans',
        color: Colors.black38, fontSize: 12.sp, fontWeight: FontWeight.w600
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = filters == GraphFilters.week?'Mon':filters == GraphFilters.today? "8am - 10am": DateFormat.LLLL().format(DateTime.now());
        break;
      case 1:
        text = filters == GraphFilters.week?'Tue':filters == GraphFilters.today? "10am - 12pm":"";
        break;
      case 2:
        text = filters == GraphFilters.week?'Wed':filters == GraphFilters.today? "12pm - 2pm":"";
        break;
      case 3:
        text = filters == GraphFilters.week?'Thurs':filters == GraphFilters.today? "2pm - 4pm":"";
        break;
      case 4:
        text = filters == GraphFilters.week?'Fri':filters == GraphFilters.today? "4pm - 6pm":"";
        break;
      case 5:
        text = filters == GraphFilters.week?'Sat':filters == GraphFilters.today? "OverTime":"";
        break;
      default:
        text = "";
        break;
    }
    print("selected text $text");
    return SideTitleWidget(
      angle: filters == GraphFilters.today?120: 0.0,
      space: 10.sp,
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
}


enum GraphFilters {week, month, today}
