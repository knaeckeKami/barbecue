import 'package:ansicolor/ansicolor.dart';
import 'package:barbecue/barbecue.dart';

void main(List<String> arguments) {
  final strings = ["look", "at", "all", "these", "colors"];
  var i = 0;
  print(Table(
    tableStyle: TableStyle(border: true),
    body: TableSection(
        cellStyle: CellStyle(
          borderRight: true,
        ),
        rows: [
          Row(
            cells: [
              for (final pen in [
                AnsiPen()..red(bold: true),
                AnsiPen()..green(bold: true),
                AnsiPen()..blue(),
                AnsiPen()
                  ..black()
                  ..white(bg: true),
                AnsiPen()..xterm(190)
              ])
                Cell(pen(strings[i++]))
            ],
          ),
        ]),
  ).render());
}
