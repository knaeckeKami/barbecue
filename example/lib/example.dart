import 'package:barbecue/barbecue.dart';
import 'package:ansicolor/ansicolor.dart';

void main(List<String> arguments) {
  final redPen = AnsiPen()
    ..red(bold: true)
    ..gray(bg: true, level: 0.1);
  print(Table(
      tableStyle: TableStyle(border: true),
      header: TableSection(rows: [
        Row(
          cells: [
            Cell("ID"),
            Cell("Name"),
            Cell("Role"),
          ],
          cellStyle: CellStyle(borderBottom: true),
        ),
      ]),
      body: TableSection(
        cellStyle: CellStyle(paddingRight: 2),
        rows: [
          Row(cells: [
            Cell("42", style: CellStyle(alignment: TextAlignment.TopRight)),
            Cell("John Doe"),
            Cell(redPen.write("Secret Agent"))
          ]),
          Row(cells: [
            Cell("4711"),
            Cell("Leanna E. Distefano"),
            Cell("Customer Support")
          ]),
          Row(cells: [Cell("1337"), Cell("Patrice Miller"), Cell("Accountant")])
        ],
      )).render());
}
