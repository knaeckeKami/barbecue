import 'package:collection/collection.dart';

enum TextAlignment {
  TopLeft,
  TopCenter,
  TopRight,
  MiddleLeft,
  MiddleCenter,
  MiddleRight,
  BottomLeft,
  BottomCenter,
  BottomRight
}

class CellStyle {
  final int? paddingLeft;

  final int? paddingRight;

  final int? paddingTop;

  final int? paddingBottom;

  final bool? borderLeft;

  final bool? borderRight;

  final bool? borderTop;

  final bool? borderBottom;

  final TextAlignment? alignment;

  const CellStyle(
      {this.paddingLeft,
      this.paddingRight,
      this.paddingTop,
      this.paddingBottom,
      this.borderLeft,
      this.borderRight,
      this.borderTop,
      this.borderBottom,
      this.alignment});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellStyle &&
          runtimeType == other.runtimeType &&
          paddingLeft == other.paddingLeft &&
          paddingRight == other.paddingRight &&
          paddingTop == other.paddingTop &&
          paddingBottom == other.paddingBottom &&
          borderLeft == other.borderLeft &&
          borderRight == other.borderRight &&
          borderTop == other.borderTop &&
          borderBottom == other.borderBottom &&
          alignment == other.alignment;

  @override
  int get hashCode =>
      paddingLeft.hashCode ^
      paddingRight.hashCode ^
      paddingTop.hashCode ^
      paddingBottom.hashCode ^
      borderLeft.hashCode ^
      borderRight.hashCode ^
      borderTop.hashCode ^
      borderBottom.hashCode ^
      alignment.hashCode;

  @override
  String toString() {
    return 'CellStyle{paddingLeft: $paddingLeft, paddingRight: $paddingRight, paddingTop: $paddingTop, paddingBottom: $paddingBottom, borderLeft: $borderLeft, borderRight: $borderRight, borderTop: $borderTop, borderBottom: $borderBottom, alignment: $alignment}';
  }

  CellStyle operator +(CellStyle? override) {
    if (this == null) {
      return override!;
    }
    if (override == null) {
      return this;
    }
    return CellStyle(
      paddingLeft: override.paddingLeft ?? paddingLeft,
      paddingRight: override.paddingRight ?? paddingRight,
      paddingTop: override.paddingTop ?? paddingTop,
      paddingBottom: override.paddingBottom ?? paddingBottom,
      borderLeft: override.borderLeft ?? borderLeft,
      borderRight: override.borderRight ?? borderRight,
      borderTop: override.borderTop ?? borderTop,
      borderBottom: override.borderBottom ?? borderBottom,
      alignment: override.alignment ?? alignment,
    );
  }
}

class Cell {
  final String content;
  final int columnSpan;
  final int rowSpan;
  final CellStyle? style;

  const Cell(this.content, {this.columnSpan = 1, this.rowSpan = 1, this.style});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          columnSpan == other.columnSpan &&
          rowSpan == other.rowSpan &&
          style == other.style;

  @override
  int get hashCode =>
      content.hashCode ^
      columnSpan.hashCode ^
      rowSpan.hashCode ^
      style.hashCode;

  @override
  String toString() {
    return 'Cell{content: $content, columnSpan: $columnSpan, rowSpan: $rowSpan, style: $style}';
  }
}

class Row {
  final List<Cell> cells;
  final CellStyle? cellStyle;

  const Row({required this.cells, this.cellStyle}) : assert(cells != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Row &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(cells, other.cells) &&
          cellStyle == other.cellStyle;

  @override
  int get hashCode => DeepCollectionEquality().hash(cells) ^ cellStyle.hashCode;

  @override
  String toString() {
    return 'Row{cells: $cells, cellStyle: $cellStyle}';
  }
}

class TableSection {
  final List<Row> rows;
  final CellStyle? cellStyle;

  const TableSection({required this.rows, this.cellStyle})
      : assert(rows != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableSection &&
          runtimeType == other.runtimeType &&
          DeepCollectionEquality().equals(rows, other.rows) &&
          cellStyle == other.cellStyle;

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(rows) ^ cellStyle.hashCode;

  @override
  String toString() {
    return 'TableSection{rows: $rows, cellStyle: $cellStyle}';
  }
}

enum BorderStyle { Hidden, Solid }

class TableStyle {
  final bool? border;
  final BorderStyle? borderStyle;

  const TableStyle({this.border, this.borderStyle});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableStyle &&
          runtimeType == other.runtimeType &&
          border == other.border &&
          borderStyle == other.borderStyle;

  @override
  int get hashCode => border.hashCode ^ borderStyle.hashCode;

  @override
  String toString() {
    return 'TableStyle{border: $border, borderStyle: $borderStyle}';
  }
}

class PositionedCell {
  final int rowIndex;
  final int columnIndex;
  final Cell cell;
  final CellStyle canonicalStyle;

  const PositionedCell(
      {required this.rowIndex,
      required this.columnIndex,
      required this.cell,
      required this.canonicalStyle});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionedCell &&
          runtimeType == other.runtimeType &&
          rowIndex == other.rowIndex &&
          columnIndex == other.columnIndex &&
          cell == other.cell &&
          canonicalStyle == other.canonicalStyle;

  @override
  int get hashCode =>
      rowIndex.hashCode ^
      columnIndex.hashCode ^
      cell.hashCode ^
      canonicalStyle.hashCode;

  @override
  String toString() {
    return 'PositionedCell{rowIndex: $rowIndex, columnIndex: $columnIndex, cell: $cell, canonicalStyle: $canonicalStyle}';
  }
}
