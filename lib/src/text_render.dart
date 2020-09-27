import 'package:barbecue/src/model.dart';
import 'package:barbecue/src/table.dart';
import 'package:barbecue/src/text_border.dart';
import 'package:barbecue/src/text_layout.dart';
import 'package:barbecue/src/text_surface.dart';



TextLayout _simpleLayoutFactory(PositionedCell cell) => SimpleLayout(cell);

extension Render on Table {
  String render(
      {TextLayout Function(PositionedCell) layoutFactory = _simpleLayoutFactory,
      TextBorder border}) {
    border ??= TextBorder.DEFAULT;

    final layouts = {for (var a in positionedCells) (a).cell: layoutFactory(a)};

    final columnWidths = List<int>.filled(columnCount, 1);
    final columnBorderWidths = List<int>.filled(columnCount + 1, 0);
    final rowHeights = List<int>.filled(rowCount, 1);
    final rowBorderHeights = List<int>.filled(rowCount + 1, 0);

    for (final positionedCell in positionedCells) {
      final rowIndex = positionedCell.rowIndex;
      final columnIndex = positionedCell.columnIndex;
      final cell = positionedCell.cell;
      final canonicalStyle = positionedCell.canonicalStyle;

      final layout = layouts[cell];

      final columnSpan = cell.columnSpan;
      if (columnSpan == 1) {
        final currentWidth = columnWidths[columnIndex];
        final contentWidth = layout.measureWidth();
        if (contentWidth > currentWidth) {
          columnWidths[columnIndex] = contentWidth;
        }
      }

      final rowSpan = cell.rowSpan;
      if (rowSpan == 1) {
        final currentHeight = rowHeights[rowIndex];
        final contentHeight = layout.measureHeight();
        if (contentHeight > currentHeight) {
          rowHeights[rowIndex] = contentHeight;
        }
      }

      if ((columnIndex == 0 && tableStyle?.border == true ||
              canonicalStyle?.borderLeft == true) &&
          (columnIndex > 0 || tableStyle?.borderStyle != BorderStyle.Hidden)) {
        final oldValue =
            (columnBorderWidths[columnIndex] == 0) ? '0 ->' : 'already';

        columnBorderWidths[columnIndex] = 1;
      }
      if ((columnIndex + columnSpan == columnCount &&
                  tableStyle?.border == true ||
              canonicalStyle?.borderRight == true) &&
          (columnIndex + columnSpan < columnCount ||
              tableStyle?.borderStyle != BorderStyle.Hidden)) {
        final oldValue = (columnBorderWidths[columnIndex + columnSpan] == 0)
            ? '0 ->'
            : 'already';

        columnBorderWidths[columnIndex + columnSpan] = 1;
      }
      if ((rowIndex == 0 && tableStyle?.border == true ||
              canonicalStyle?.borderTop == true) &&
          (rowIndex > 0 || tableStyle?.borderStyle != BorderStyle.Hidden)) {
        final oldValue = (rowBorderHeights[rowIndex] == 0) ? '0 ->' : 'already';

        rowBorderHeights[rowIndex] = 1;
      }
      if ((rowIndex + rowSpan == rowCount && tableStyle?.border == true ||
              canonicalStyle?.borderBottom == true) &&
          (rowIndex + rowSpan < rowCount ||
              tableStyle?.borderStyle != BorderStyle.Hidden)) {
        final oldValue =
            (rowBorderHeights[rowIndex + rowSpan] == 0) ? '0 ->' : 'already';

        rowBorderHeights[rowIndex + rowSpan] = 1;
      }
    }

    final sortedColumnSpanCells = positionedCells
        .where((it) => it.cell.columnSpan > 1)
        .toList()
          ..sort((a, b) =>
              Comparable.compare(a.cell.columnSpan, b.cell.columnSpan));

    for (final positionedCell in sortedColumnSpanCells) {
      final rowIndex = positionedCell.rowIndex;
      final columnIndex = positionedCell.columnIndex;
      final cell = positionedCell.cell;

      final layout = layouts[cell];
      final columnSpan = cell.columnSpan;
      final contentWidth = layout.measureWidth();
      final columnSpanIndices = [
        for (var i = columnIndex; i < columnIndex + columnSpan; i++) i
      ];
      final currentSpanColumnWidth =
          columnSpanIndices.map((e) => columnWidths[e]).fold(0, _plus);
      final currentSpanBorderWidth = [
        for (var i = columnIndex; i < columnIndex + columnSpan; i++) i
      ].map((e) => columnBorderWidths[e]).fold(0, _plus);
      final currentSpanWidth = currentSpanColumnWidth + currentSpanBorderWidth;
      final remainingSize = contentWidth - currentSpanWidth;

      if (remainingSize > 0) {
        // TODO change to distribute remaining size proportionally to the existing widths?
        final commonSize = remainingSize ~/ columnSpan;

        final extraSize = remainingSize - (commonSize * columnSpan);

        for (var spanIndex = 0;
            spanIndex < columnSpanIndices.length;
            spanIndex++) {
          final targetColumnIndex = columnSpanIndices[spanIndex];

          final additionalSize =
              (spanIndex < extraSize) ? commonSize + 1 : commonSize;
          final currentWidth = columnWidths[targetColumnIndex];
          final newWidth = currentWidth + additionalSize;
          columnWidths[targetColumnIndex] = newWidth;
        }
      }
    }

    final sortedRowSpanCells = positionedCells
        .where((it) => it.cell.rowSpan > 1)
        .toList()
          ..sort((a, b) => Comparable.compare(a.cell.rowSpan, b.cell.rowSpan));

    for (final positionedCell in sortedRowSpanCells) {
      final rowIndex = positionedCell.rowIndex;
      final columnIndex = positionedCell.columnIndex;
      final cell = positionedCell.cell;

      final layout = layouts[cell];
      final rowSpan = cell.rowSpan;
      final contentHeight = layout.measureHeight();

      final rowSpanIndices = [
        for (var i = rowIndex; i < rowIndex + rowSpan; i++) i
      ];
      final currentSpanRowHeight =
          rowSpanIndices.map((it) => rowHeights[it]).fold(0, _plus);
      final currentSpanBorderHeight = [
        for (var i = rowIndex + 1; i < rowIndex + rowSpan; i++) i
      ].map((it) => rowBorderHeights[it]).fold(0, _plus);
      final currentSpanHeight = currentSpanRowHeight + currentSpanBorderHeight;
      final remainingSize = contentHeight - currentSpanHeight;
      if (remainingSize > 0) {
        // TODO change to distribute remaining size proportionally to the existing widths?
        final commonSize = remainingSize ~/ rowSpan;
        final extraSize = remainingSize - (commonSize * rowSpan);
        var spanIndex = 0;
        rowSpanIndices.forEach((targetRowIndex) {
          final additionalSize =
              (spanIndex < extraSize) ? commonSize + 1 : commonSize;
          final currentHeight = rowHeights[targetRowIndex];
          final newHeight = currentHeight + additionalSize;
          rowHeights[targetRowIndex] = newHeight;
          spanIndex++;
        });
      }
    }

    final tableLefts = List<int>(columnWidths.length + 1);
    int tableWidth;

    var left = 0;
    for (final i in Iterable<int>.generate(columnWidths.length)) {
      tableLefts[i] = left;
      left += columnWidths[i] + columnBorderWidths[i];
    }
    tableLefts[columnWidths.length] = left;
    tableWidth = left + columnBorderWidths[columnWidths.length];

    final tableTops = List<int>(rowHeights.length + 1);
    int tableHeight;

    var top = 0;
    for (final i in Iterable<int>.generate(rowHeights.length)) {
      tableTops[i] = top;
      top += rowHeights[i] + rowBorderHeights[i];
    }
    tableTops[rowHeights.length] = top;
    tableHeight = top + rowBorderHeights[rowHeights.length];

    final surface = TextSurface(tableWidth, tableHeight);

    print(rowCount);

    for (final rowIndex in Iterable<int>.generate(rowCount + 1)) {
      final rowDrawStartIndex = tableTops[rowIndex];

      for (final columnIndex in Iterable<int>.generate(columnCount + 1)) {
        final positionedCell = getOrNull(rowIndex, columnIndex);
        final cell = positionedCell?.cell;

        final cellCanonicalStyle = positionedCell?.canonicalStyle;

        final previousRowPositionedCell = getOrNull(rowIndex, columnIndex - 1);
        final previousRowCell = previousRowPositionedCell?.cell;
        final previousRowCellCanonicalStyle =
            previousRowPositionedCell?.canonicalStyle;

        final previousColumnPositionedCell =
            getOrNull(rowIndex - 1, columnIndex);
        final previousColumnCell = previousColumnPositionedCell?.cell;
        final previousColumnCellCanonicalStyle =
            previousColumnPositionedCell?.canonicalStyle;

        final columnDrawStartIndex = tableLefts[columnIndex];
        final rowBorderHeight = rowBorderHeights[rowIndex];
        final hasRowBorder = rowBorderHeight != 0;
        final columnBorderWidth = columnBorderWidths[columnIndex];
        final hasColumnBorder = columnBorderWidth != 0;
        if (hasRowBorder && hasColumnBorder) {
          final previousRowColumnPositionedCell =
              getOrNull(rowIndex - 1, columnIndex - 1);
          final previousRowColumnCell = previousRowColumnPositionedCell?.cell;
          final previousRowColumnCellCanonicalStyle =
              previousRowColumnPositionedCell?.canonicalStyle;

          final cornerTopBorder =
              !identical(previousRowColumnCell, previousColumnCell) &&
                  (previousRowColumnCellCanonicalStyle?.borderRight == true ||
                      previousColumnCellCanonicalStyle?.borderLeft == true ||
                      rowIndex > 0 &&
                          (columnIndex == 0 || columnIndex == columnCount) &&
                          tableStyle?.border == true);
          final cornerLeftBorder =
              !identical(previousRowColumnCell, previousRowCell) &&
                  (previousRowColumnCellCanonicalStyle?.borderBottom == true ||
                      previousRowCellCanonicalStyle?.borderTop == true ||
                      columnIndex > 0 &&
                          (rowIndex == 0 || rowIndex == rowCount) &&
                          tableStyle?.border == true);
          final cornerBottomBorder = !identical(previousRowCell, cell) &&
              (previousRowCellCanonicalStyle?.borderRight == true ||
                  cellCanonicalStyle?.borderLeft == true ||
                  rowIndex < rowCount &&
                      (columnIndex == 0 || columnIndex == columnCount) &&
                      tableStyle?.border == true);
          final cornerRightBorder = !identical(previousColumnCell, cell) &&
              (previousColumnCellCanonicalStyle?.borderBottom == true ||
                  cellCanonicalStyle?.borderTop == true ||
                  columnIndex < columnCount &&
                      (rowIndex == 0 || rowIndex == rowCount) &&
                      tableStyle?.border == true);
          if (cornerTopBorder ||
              cornerLeftBorder ||
              cornerBottomBorder ||
              cornerRightBorder) {
            final borderChar = border.get(
              down: cornerBottomBorder,
              up: cornerTopBorder,
              left: cornerLeftBorder,
              right: cornerRightBorder,
            );
            surface.set(rowDrawStartIndex, columnDrawStartIndex, borderChar);
          }
        }

        if (hasColumnBorder &&
            !identical(previousRowCell, cell) &&
            (previousRowCellCanonicalStyle?.borderRight == true ||
                cellCanonicalStyle?.borderLeft == true ||
                (columnIndex == 0 || columnIndex == columnCount) &&
                    tableStyle?.border == true)) {
          final rowDrawEndIndex =
              tableTops[rowIndex + 1]; // Safe given cell != null.
          final borderChar = border.vertical;
          for (final rowDrawIndex in [
            for (int i = rowDrawStartIndex + rowBorderHeight;
                i < rowDrawEndIndex;
                i++)
              i
          ]) {
            surface.set(rowDrawIndex, columnDrawStartIndex, borderChar);
          }
        }

        if (hasRowBorder &&
            !identical(previousColumnCell, cell) &&
            (previousColumnCellCanonicalStyle?.borderBottom == true ||
                cellCanonicalStyle?.borderTop == true ||
                (rowIndex == 0 || rowIndex == rowCount) &&
                    tableStyle?.border == true)) {
          final columnDrawEndIndex =
              tableLefts[columnIndex + 1]; // Safe given cell != null
          final borderChar = border.horizontal;
          for (final columnDrawIndex in [
            for (int i = columnDrawStartIndex + columnBorderWidth;
                i < columnDrawEndIndex;
                i++)
              i
          ]) {
            surface.set(rowDrawStartIndex, columnDrawIndex, borderChar);
          }
        }
      }
    }

    positionedCells.forEach((positionedCell) {
      final rowIndex = positionedCell.rowIndex;
      final columnIndex = positionedCell.columnIndex;
      final cell = positionedCell.cell;

      final cellLeft =
          tableLefts[columnIndex] + columnBorderWidths[columnIndex];
      final cellRight = tableLefts[columnIndex + cell.columnSpan];
      final cellTop = tableTops[rowIndex] + rowBorderHeights[rowIndex];
      final cellBottom = tableTops[rowIndex + cell.rowSpan];

      final canvas = surface.clip(cellLeft, cellRight, cellTop, cellBottom);
      final layout = layouts[cell];
      layout.draw(canvas);
    });

    return surface.toString();
  }

  void debug(String s) => print(s);
}

int _plus(int a, int b) => a + b;
