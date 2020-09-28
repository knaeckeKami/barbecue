import 'package:barbecue/barbecue.dart';
import 'package:ansicolor/ansicolor.dart';

void main(List<String> arguments) {
  print(Table(
    cellStyle: CellStyle(
        borderBottom: true,
        borderRight: true,
        borderLeft: true,
        borderTop: true,
        alignment: TextAlignment.TopLeft),
    body: TableSection(
      rows: [
        Row(
          cells: [
            Cell("Real Planets",
                rowSpan: 8,
                style: CellStyle(alignment: TextAlignment.MiddleCenter)),
            Cell("Mercury")
          ],
        ),
        Row(
          cells: [Cell("Venus")],
        ),
        Row(
          cells: [Cell("Earth")],
        ),
        Row(
          cells: [Cell("Mars")],
        ),
        Row(
          cells: [Cell("Jupiter")],
        ),
        Row(
          cells: [Cell("Saturn")],
        ),
        Row(
          cells: [Cell("Uranus")],
        ),
        Row(
          cells: [Cell("Neptune")],
        ),
        Row(
          cells: [Cell("Very Fake Planets", rowSpan: 1), Cell("Pluto")],
        ),
      ],
    ),
  ).render(border: TextBorder.ASCII));
}
