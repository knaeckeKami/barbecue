import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';

void main() {
  test('table correctly implements equals', () {
    final table = Table(
      tableStyle: TableStyle(border: true),
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
        Row(cells: [Cell('content')])
      ]),
    );
    expect(table, equals(table));
    expect(table.hashCode, equals(table.hashCode));

    final equalTable = Table(
      tableStyle: TableStyle(border: true),
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
        Row(cells: [Cell('content')])
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
        Row(cells: [Cell('content 2')])
      ]),
    );

    expect(table, isNot(equals(unequalTable)));
    expect(table.hashCode, isNot(equals(unequalTable.hashCode)));
    expect(table.toString(), isNot(equals(unequalTable.toString())));
  });

  test('PositionedCell equals/hashCode/toString()', () {
    final cell = PositionedCell(
        rowIndex: 0,
        columnIndex: 1,
        canonicalStyle: CellStyle(paddingRight: 1),
        cell: Cell('1'));

    expect(cell, equals(cell));
    expect(cell.hashCode, equals(cell.hashCode));

    final equalCell = PositionedCell(
        rowIndex: 0,
        columnIndex: 1,
        canonicalStyle: CellStyle(paddingRight: 1),
        cell: Cell('1'));

    expect(cell, equals(equalCell));
    expect(cell.hashCode, equals(equalCell.hashCode));

    final unequalCell = PositionedCell(
        rowIndex: 1,
        columnIndex: 1,
        canonicalStyle: CellStyle(paddingRight: 1),
        cell: Cell('1'));

    expect(cell, isNot(equals(unequalCell)));
    expect(cell.hashCode, isNot(equals(unequalCell.hashCode)));
    expect(cell.toString(), isNot(equals(unequalCell.toString())));
  });
}
