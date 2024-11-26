import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key, required this.title, required this.menu})
      : super(key: key);

  final String title;
  final List<Menu> menu;

  @override
  Widget build(BuildContext context) {

    if (menu.isEmpty) {
      return const Center(
        child: Text(
          'Nothing to see here',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    final List<Stats> dane = [
      Stats('Cukry', menu.first.SugarSum),
      Stats('Węglowodany', menu.first.CarbohydrateSum),
      Stats('Tłuszcze', menu.first.FatSum),
      Stats('Białka', menu.first.ProteinSum),
    ];

    return Center(
      child: SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries>[
          PieSeries<Stats, String>(
            dataSource: dane,
            xValueMapper: (Stats dane, _) => dane.name,
            yValueMapper: (Stats dane, _) => dane.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            explode: true,
            explodeIndex: 0,
          ),
        ],
      ),
    );
  }
}

class Stats {
  final String name;
  final num value;

  Stats(this.name, this.value);
}