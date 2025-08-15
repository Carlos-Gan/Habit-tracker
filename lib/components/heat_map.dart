import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/appcolors.dart';
import 'package:provider/provider.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDateNow;
  final Map<DateTime, int> datasets;

  const MyHeatMap({
    super.key,
    required this.startDateNow,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      size: 30,
      scrollable: false,
      startDate: startDateNow,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.tertiary,
      showColorTip: false,
      showText: true,
      textColor: context.watch<ThemeProvider>().showHeatMapText ? Theme.of(context).colorScheme.inversePrimary : Colors.transparent,
      colorsets: {
        1: HeatMapColors.firstColor,
        2: HeatMapColors.secondColor,
        3: HeatMapColors.thirdColor,
        4: HeatMapColors.fourthColor,
        5: HeatMapColors.fifthColor,
        6: HeatMapColors.sixthColor,
        7: HeatMapColors.seventhColor,
        8: HeatMapColors.eighthColor,
        9: HeatMapColors.ninthColor,
      },
    );
  }
}
