import 'package:barbecue/src/text.dart';
import 'package:test/test.dart';

void main() {
  test('visual index ascii', () {
    expect(0, 'AAAAA'.visualIndex(0));
    expect(1, 'AAAAA'.visualIndex(1));
    expect(2, 'AAAAA'.visualIndex(2));
    expect(3, 'AAAAA'.visualIndex(3));
    expect(4, 'AAAAA'.visualIndex(4));
  });

  test('visual index unicode', () {
    expect(1, '\u0031a'.visualIndex(1));
    // 2 UTF-8 bytes.
    expect(1, '\u00A3a'.visualIndex(1));
    // 3 UTF-8 bytes.
    expect(1, '\u20ACa'.visualIndex(1));
    // 3 UTF-8 bytes, full-width.
    expect(1, '\u5317a'.visualIndex(1));
    // 4 UTF-8 bytes (2 * UTF-16), full-width.
    expect(2, '😃a'.visualIndex(1));
  });

  test('visual index of ANSI jump escapes', () {
    final singleAnsiEscape = 'AAA\u001B[31;1;4mAA';
    expect(0, singleAnsiEscape.visualIndex(0));
    expect(1, singleAnsiEscape.visualIndex(1));
    expect(2, singleAnsiEscape.visualIndex(2));
    expect(12, singleAnsiEscape.visualIndex(3));
    expect(13, singleAnsiEscape.visualIndex(4));

    final dualAdjacentAnsiEscapes = 'AAA\u001B[31;1;4m\u001B[0mAA';
    expect(0, dualAdjacentAnsiEscapes.visualIndex(0));
    expect(1, dualAdjacentAnsiEscapes.visualIndex(1));
    expect(2, dualAdjacentAnsiEscapes.visualIndex(2));
    expect(16, dualAdjacentAnsiEscapes.visualIndex(3));
    expect(17, dualAdjacentAnsiEscapes.visualIndex(4));

    final dualAnsiEscapes = 'AAA\u001B[31;1;4mAA\u001B[31;1;4mAA';
    expect(0, dualAnsiEscapes.visualIndex(0));
    expect(1, dualAnsiEscapes.visualIndex(1));
    expect(2, dualAnsiEscapes.visualIndex(2));
    expect(12, dualAnsiEscapes.visualIndex(3));
    expect(13, dualAnsiEscapes.visualIndex(4));
  });

  test('visualCodePointCountAscii', () {
    expect(0, ''.visualCodePointCount);
    expect(1, 'A'.visualCodePointCount);
    expect(2, 'AA'.visualCodePointCount);
    expect(3, 'AAA'.visualCodePointCount);
  });

  test('visualCodePointCountAnsiEscapes', () {
    expect(1, '\u001B[31;1;4mA\u001B[0m'.visualCodePointCount);
    expect(3, 'A\u001B[31;1;4mA\u001B[0mA'.visualCodePointCount);

    expect(
        3,
        '\u001B[31;1;4mA\u001B[0m\u001B[31;1;4mA\u001B[0mA'
            .visualCodePointCount);
  });

  test('visualCodePointCountUnicode', () {
    // 1 UTF-8 bytes.
    expect(2, '\u0031a'.visualCodePointCount);
    // 2 UTF-8 bytes.
    expect(2, '\u00A3a'.visualCodePointCount);
    // 3 UTF-8 bytes.
    expect(2, '\u20ACa'.visualCodePointCount);
    // 3 UTF-8 bytes, full-width.
    expect(2, '\u5317a'.visualCodePointCount);
    // 4 UTF-8 bytes (2 * UTF-16), full-width.
    expect(2, ('${String.fromCharCode(0x1F603)}a').visualCodePointCount);
  });
}
