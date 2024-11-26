import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key, required this.time, required this.menu})
      : super(key: key);

  final num time;
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

    num allKcal = 0;
    num allSugars = 0;
    num allCarbo = 0;
    num allFats = 0;
    num allProteins = 0;
    for(var x in menu)
      {
        allKcal += x.CaloriesSum;
        allProteins += x.ProteinSum;
        allFats += x.FatSum;
        allCarbo += x.CarbohydrateSum;
        allSugars += x.SugarSum;
      }

    DateTime now = DateTime.now();
    String startDate = '${now.year}-${now.month}-${now.day}';
    DateTime end = now.subtract(Duration(days: time.toInt()));
    String endDate = '${end.year}-${end.month}-${end.day}';

    final List<Stats> dane = [
      Stats('Cukry', allSugars),
      Stats('Węglowodany', allCarbo),
      Stats('Tłuszcze', allFats),
      Stats('Białka', allProteins),
    ];

    final List<StatsLinear> daneWykresSlupkowy;
    if(time > 0){
      daneWykresSlupkowy = [
        StatsLinear('Cukry', allSugars, 100 * time),
        StatsLinear('Węglowodany', allCarbo, 340 * time),
        StatsLinear('Tłuszcze', allFats, 70 * time),
        StatsLinear('Białka', allProteins, 60 * time),
        StatsLinear('Kalorie', allKcal, 2500 * time),
      ];
    }else{
      daneWykresSlupkowy = [
        StatsLinear('Cukry', allSugars, 100),
        StatsLinear('Węglowodany', allCarbo, 340),
        StatsLinear('Tłuszcze', allFats, 70),
        StatsLinear('Białka', allProteins, 60),
        StatsLinear('Kalorie', allKcal, 2500),
      ];
    }


    return SingleChildScrollView(
      child: Center(
          child: Column(
            children: [
              Text(
                  "$startDate : $endDate",
                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                  "Łączna ilość kalorii: $allKcal",

              ),
              SfCircularChart(
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
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries<StatsLinear, String>>[
                  ColumnSeries<StatsLinear, String>(
                    name: 'Aktualne',
                    dataSource: daneWykresSlupkowy,
                    xValueMapper: (StatsLinear stats, _) => stats.name,
                    yValueMapper: (StatsLinear stats, _) => stats.actualValue,
                    color: Colors.blue,
                  ),
                  ColumnSeries<StatsLinear, String>(
                    name: 'Zalecane',
                    dataSource: daneWykresSlupkowy,
                    xValueMapper: (StatsLinear stats, _) => stats.name,
                    yValueMapper: (StatsLinear stats, _) => stats.recommendedValue,
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ],
                legend: Legend(isVisible: true),
              ),
            ],
          )
      ),
    );
  }
}

class Stats {
  final String name;
  final num value;

  Stats(this.name, this.value);
}

class StatsLinear {
  final String name;
  final num actualValue;
  final num recommendedValue;

  StatsLinear(this.name, this.actualValue, this.recommendedValue);
}