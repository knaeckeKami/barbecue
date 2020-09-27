import 'package:characters/characters.dart';
import 'package:picnic/src/text.dart';

abstract class TextCanvas {
  final int width;
  final int height;



  TextCanvas(this.width,
      this.height,);

  void write(int row, int column, String string);

  void set(int row, int column, String char) {
    final unicodeChar = Characters(char);
    assert(unicodeChar.length <= 1);
    setCharacter(row, column, unicodeChar);
  }

  void setCodePoint(int row, int column, int codePoint) {
    setCharacter(row, column, Characters(String.fromCharCode(codePoint)));
  }

  TextCanvas clip(int left, int right, int top, int bottom) {
    return ClippedTextCanvas(
        canvas: this,
        left: left,
        right: right,
        top: top,
        bottom: bottom);
  }

  void setCharacter(int row, int column, Characters unicodeChar);
}


class TextSurface extends TextCanvas {
  final List<String> rowBuilders;

  TextSurface(int width, int height)
      :  rowBuilders =
  List.filled(height, [for (int i = 0; i < width; i++) ' '].join('')),
        super(width, height);

  @override
  void setCharacter(int row, int column, Characters unicodeChar) {

    final writeIndex = rowBuilders[row].visualIndex(column);

    rowBuilders[row] = rowBuilders[row].replaceRange(writeIndex, writeIndex+1, unicodeChar.string);
  }

  void write(int row, int column, String string) {
    int lineIndex = 0;
    for (final line in string.split('\n')) {
      final rowBuilder = rowBuilders[row + lineIndex];
      final writeStartIndex = rowBuilder.visualIndex(column);
      final writeEndIndex =
      rowBuilder.visualIndex(column + line.visualCodePointCount);

      final newRow =
      rowBuilder.replaceRange(writeStartIndex, writeEndIndex, line);
      rowBuilders[row + lineIndex] = newRow;
      lineIndex++;
    }
  }

  @override
  String toString() {

    final buffer = StringBuffer();
    var index =0;
    for(final rowBuilder in rowBuilders) {
      if (index > 0) {
        buffer.writeln();
      }
      buffer.write(rowBuilder);
      index++;
    }
    return buffer.toString();
  }
}

class ClippedTextCanvas extends TextCanvas {
  final TextCanvas canvas;
  final int left;
  final int right;
  final int top;
  final int bottom;

  ClippedTextCanvas({
    this.canvas,
    this.left,
    this.right,
    this.top,
    this.bottom,
  }) : super(right - left, bottom - top);

  @override
  int get width => right - left;

  @override
  int get height => bottom - top;


  @override
  void setCharacter(int row, int column, Characters unicodeChar) {
    canvas.setCharacter(top + row, left + column, unicodeChar);
  }

  @override
  void write(int row, int column, String string) {
    canvas.write(top + row, left + column, string);
  }
}
