import 'package:barbecue/src/int_count.dart';
import 'package:barbecue/src/model.dart';
import 'package:meta/meta.dart';

class Table {
  final TableSection header;
  final TableSection body;
  final TableSection footer;
  final CellStyle cellStyle;
  final TableStyle tableStyle;

  final int rowCount;

  int columnCount;
  List<PositionedCell> positionedCells;

  List<List<PositionedCell>> _cellTable;

  Table({
    this.header,
    @required this.body,
    this.footer,
    this.cellStyle = const CellStyle(),
    this.tableStyle,
  })  : assert(body != null, "the body of the table must not be null"),
        rowCount = (header?.rows?.length ?? 0) +
            body.rows.length +
            (footer?.rows?.length ?? 0) {
    final rowSpanCarries = IntCounts();

    final positionedCells = <PositionedCell>[];
    final _cellTable = <List<PositionedCell>>[];
    var rowIndex = 0;

    for (final section
        in [header, body, footer].where((element) => element != null)) {
      final sectionStyle = cellStyle + section.cellStyle;
      for (final row in section.rows) {
        final rowStyle = sectionStyle + row.cellStyle;
        final cellRow = <PositionedCell>[];
        _cellTable.add(cellRow);
        var columnIndex = 0;
        var rawColumnIndex = 0;
        for (final cell in row.cells) {
          // Check for any previous rows' cells whose >1 rowSpan carries them into this row.
          // When found, add them to the current row, pushing remaining cells to the right.
          while (columnIndex < rowSpanCarries.size &&
              rowSpanCarries[columnIndex] > 0) {
            cellRow.add(_cellTable[rowIndex - 1][columnIndex]);
            rowSpanCarries.set(columnIndex, rowSpanCarries[columnIndex] - 1);
            columnIndex++;
          }
          final canonicalStyle = rowStyle + cell.style;
          final positionedCell = PositionedCell(
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              cell: cell,
              canonicalStyle: canonicalStyle);
          positionedCells.add(positionedCell);

          final rowSpan = cell.rowSpan;
          assert(rowIndex + rowSpan <= rowCount,
              'Cell $rawColumnIndex in row $rowIndex has rowSpan=$rowSpan but table rowCount=$rowCount');

          final rowSpanCarry = rowSpan - 1;
          var count = cell.columnSpan;
          while (count-- > 0) {
            cellRow.add(positionedCell);
            rowSpanCarries.set(columnIndex, rowSpanCarry);

            columnIndex++;
          }
          rawColumnIndex++;
        }
        // Check for any previous rows' cells whose >1 rowSpan carries them into this row.
        // When found, add them to the current row, filling any gaps with null.
        while (columnIndex < rowSpanCarries.size) {
          if (rowSpanCarries[columnIndex] > 0) {
            cellRow.add(_cellTable[rowIndex - 1][columnIndex]);
            rowSpanCarries.set(columnIndex, rowSpanCarries[columnIndex] - 1);
          } else {
            cellRow.add(null);
          }
          columnIndex++;
        }
        rowIndex++;
      }
    }
    columnCount = rowSpanCarries.size;
    this.positionedCells = positionedCells;
    this._cellTable = _cellTable;
  }

  PositionedCell getOrNull(int row, int column) {
    if (row < 0 || column < 0 || row >= _cellTable.length) {
      return null;
    }
    final cols = _cellTable[row];
    if (column >= cols.length) {
      return null;
    }
    return cols[column];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Table &&
          runtimeType == other.runtimeType &&
          header == other.header &&
          body == other.body &&
          footer == other.footer &&
          cellStyle == other.cellStyle &&
          tableStyle == other.tableStyle &&
          rowCount == other.rowCount &&
          columnCount == other.columnCount;

  @override
  int get hashCode =>
      header.hashCode ^
      body.hashCode ^
      footer.hashCode ^
      cellStyle.hashCode ^
      tableStyle.hashCode ^
      rowCount.hashCode ^
      columnCount.hashCode;

  @override
  String toString() {
    return 'Table{header: $header, body: $body, footer: $footer, cellStyle: $cellStyle, tableStyle: $tableStyle, rowCount: $rowCount, columnCount: $columnCount}';
  }
}
