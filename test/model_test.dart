import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';

void main() {
  test("table correctly implements equals", () {
    final table = Table(
      cellStyle: CellStyle(
          borderBottom: true,
          borderRight: true,
          borderTop: true,
          borderLeft: true,
          alignment: TextAlignment.BottomLeft,
          paddingBottom: 1,
          paddingLeft: 2,
          paddingRight: 3,
          paddingTop: 4),
      body: TableSection(rows: [
        Row(cells: [Cell("content")])
      ]),
    );
    expect(table, equals(table));
    expect(table.hashCode, equals(table.hashCode));

    final equalTable = Table(
      cellStyle: CellStyle(
          borderBottom: true,
          borderRight: true,
          borderTop: true,
          borderLeft: true,
          alignment: TextAlignment.BottomLeft,
          paddingBottom: 1,
          paddingLeft: 2,
          paddingRight: 3,
          paddingTop: 4),
      body: TableSection(rows: [
        Row(cells: [Cell("content")])
      ]),
    );
    expect(table, equals(equalTable));
    expect(table.hashCode, equals(equalTable.hashCode));
    expect(table.toString(), equals(equalTable.toString()));

    final unequalTable = Table(
      cellStyle: CellStyle(
          borderBottom: true,
          borderRight: true,
          borderTop: true,
          borderLeft: true,
          alignment: TextAlignment.BottomLeft,
          paddingBottom: 1,
          paddingLeft: 2,
          paddingRight: 3,
          paddingTop: 4),
      body: TableSection(rows: [
        Row(cells: [Cell("content 2")])
      ]),
    );

    expect(table, isNot(equals(unequalTable)));
    expect(table.hashCode, isNot(equals(unequalTable.hashCode)));
    expect(table.toString(), isNot(equals(unequalTable.toString())));
  });
}
