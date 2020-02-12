import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

const SETUP_BATAS_UANG_MAKAN_HARIAN = 50000.0;
const APP_LOCALE      = "id_ID";

class GrafikUangMakan extends StatefulWidget {
  GrafikUangMakan({Key key, this.barWidth = 12}) : super(key: key);
  final double barWidth;

  @override
  State<StatefulWidget> createState() => GrafikUangMakanState();
}

class UangMakan {
  UangMakan(this.indeksHari, this.nominal);
  double nominal;
  int indeksHari;
}

class GrafikUangMakanState extends State<GrafikUangMakan> {
  final _barBackgroundColor = Color(0xff72d8bf);

  var _barGroups = <BarChartGroupData>[],
      _maksUangMakanPerHari = SETUP_BATAS_UANG_MAKAN_HARIAN,
      _touchedIndex = -1,
      _uangMakan = <int, UangMakan>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChartData();
    });
  }

  String formatNumber(num nominal) => NumberFormat("###,###.###", APP_LOCALE).format(nominal.toDouble());
  String formatPrice(dynamic nominal, {String symbol = 'Rp '}) => NumberFormat.currency(locale: APP_LOCALE, symbol: symbol).format(nominal);
  String dayName(num index) {
    switch (index) {
      case 0: return 'Senin';
      case 1: return 'Selasa';
      case 2: return 'Rabu';
      case 3: return 'Kamis';
      case 4: return 'Jumat';
      case 5: return 'Sabtu';
      case 6: return 'Minggu';
    }
    return '';
  }
  String dayAbbr(num index) {
    switch (index.toInt()) {
      case 0: return 'Sn';
      case 1: return 'Sl';
      case 2: return 'Rb';
      case 3: return 'Km';
      case 4: return 'Jm';
      case 5: return 'Sb';
      case 6: return 'Mg';
    }
    return '';
  }
  
  _loadChartData() {
    var listNominal = <int, UangMakan>{};
    listNominal[0] = UangMakan(DateTime.parse("2020-02-06").weekday - 1, 13000.00);
    listNominal[1] = UangMakan(DateTime.parse("2020-02-07").weekday - 1, 22000.00);
    listNominal[3] = UangMakan(DateTime.parse("2020-02-09").weekday - 1, 5000.00);
    listNominal[2] = UangMakan(DateTime.parse("2020-02-08").weekday - 1, 10000.00);
    listNominal[4] = UangMakan(DateTime.parse("2020-02-10").weekday - 1, 17000.00);
    listNominal[5] = UangMakan(DateTime.parse("2020-02-11").weekday - 1, 24500.00);
    listNominal[6] = UangMakan(DateTime.parse("2020-02-12").weekday - 1, 1000.00);
    setState(() {
      // TODO BUG: BARS HAVE SAME HEIGHT ALTHOUGH THE VALUES ARE DIFFERENT
      _barGroups = [
        makeGroupData(0, 13, width: widget.barWidth),
        makeGroupData(1, 22, width: widget.barWidth),
        makeGroupData(3, 5, width: widget.barWidth),
        makeGroupData(2, 10, width: widget.barWidth),
        makeGroupData(4, 17, width: widget.barWidth),
        makeGroupData(5, 24.5, width: widget.barWidth),
        makeGroupData(6, 1, width: widget.barWidth),
      ];
      _uangMakan = listNominal;
    });
  }

  @override
  Widget build(BuildContext context) {
    var barChart = BarChart(mainBarData);
    var card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Color(0xff81e5cd),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Mingguan',
                  style: TextStyle(color: Color(0xff0f4a3c), fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2,),
                Text(
                  'Grafik uang makan',
                  style: TextStyle(color: Color(0xff379982), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: barChart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return card;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    double width = 10,
    List<int> showTooltips = const [],
  }) {
    var barHeight = _maksUangMakanPerHari / 1000;
    var isTouched = _touchedIndex == x;
    return BarChartGroupData(x: x, showingTooltipIndicators: showTooltips, barRods: [
      BarChartRodData(
        y: y,
        width: isTouched ? width + 4 : width,
        color: y >= barHeight * 2 ? Colors.red[400] : (y > barHeight ? Colors.amber[300] : Colors.white),
        borderRadius: BorderRadius.circular(50),
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: barHeight,
          color: _barBackgroundColor,
        ),
      ),
    ],);
  }

  BarChartData get mainBarData => BarChartData(
    barTouchData: BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem("${dayName(_uangMakan[groupIndex].indeksHari)}\n${formatPrice(_uangMakan[groupIndex].nominal)}", TextStyle(color: Colors.white));
        }
      ),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
            barTouchResponse.touchInput is! FlPanEnd &&
            barTouchResponse.touchInput is! FlLongPressEnd) {
            _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            _touchedIndex = -1;
          }
        });
      }
    ),
    gridData: FlGridData(
      show: false,
      drawHorizontalLine: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.normal, fontSize: 11),
        getTitles: (val) => _uangMakan[val.toInt()] == null ? val.toString() : dayAbbr(_uangMakan[val.toInt()].indeksHari),
        margin: 4,
      ),
      leftTitles: SideTitles(showTitles: false,),
    ),
    borderData: FlBorderData(show: false,),
    barGroups: _barGroups
  );
}