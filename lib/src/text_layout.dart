import 'dart:math';
import 'package:barbecue/src/model.dart';
import 'package:barbecue/src/text_surface.dart';
import 'package:barbecue/src/text.dart';
import 'package:characters/characters.dart';
import 'package:meta/meta.dart';
import 'package:string_validator/string_validator.dart';

abstract class TextLayout {
  int measureWidth();

  int measureHeight();

  void draw(TextCanvas canvas);
}

class SimpleLayout implements TextLayout {
  final PositionedCell cell;

  SimpleLayout(this.cell);

  int get leftPadding => cell.canonicalStyle?.paddingLeft ?? 0;

  int get topPadding => cell.canonicalStyle?.paddingTop ?? 0;

  @override
  int measureWidth() {
    return leftPadding +
        (cell.canonicalStyle?.paddingRight ?? 0) +
        cell.cell.content.split('\n').fold<int>(
              0,
              (previousValue, element) =>
                  max(previousValue, element.visualCodePointCount),
            );
  }

  @override
  int measureHeight() {
    return 1 +
        topPadding +
        (cell.canonicalStyle?.paddingBottom ?? 0) +
        '\n'.allMatches(cell.cell.content).length;
  }

  @override
  void draw(TextCanvas canvas) {
    final height = measureHeight();

    final alignment = cell.canonicalStyle?.alignment ?? TextAlignment.TopLeft;

    final top = () {
      switch (alignment) {
        case TextAlignment.TopLeft:
        case TextAlignment.TopCenter:
        case TextAlignment.TopRight:
          return topPadding;
        case TextAlignment.MiddleLeft:
        case TextAlignment.MiddleCenter:
        case TextAlignment.MiddleRight:
          return ((canvas.height - height) ~/ 2) + topPadding;
        case TextAlignment.BottomLeft:
        case TextAlignment.BottomCenter:
        case TextAlignment.BottomRight:
          return canvas.height - height + topPadding;
      }
    }();

    var index = 0;

    for (final line in cell.cell.content.split('\n')) {
      final lineWidth = leftPadding +
          (cell.canonicalStyle?.paddingRight ?? 0) +
          line.visualCodePointCount;
      final left = () {
        switch (alignment) {
          case TextAlignment.TopLeft:
          case TextAlignment.MiddleLeft:
          case TextAlignment.BottomLeft:
            return leftPadding;
          case TextAlignment.TopCenter:
          case TextAlignment.MiddleCenter:
          case TextAlignment.BottomCenter:
            return ((canvas.width - lineWidth) ~/ 2) + leftPadding;
          case TextAlignment.TopRight:
          case TextAlignment.MiddleRight:
          case TextAlignment.BottomRight:
            return canvas.width - lineWidth + leftPadding;
        }
      }();

      canvas.write(top + index, left, line);
      index++;
    }
  }
}

@experimental
class EmojiAwareLayout extends SimpleLayout {
  EmojiAwareLayout(PositionedCell cell) : super(cell);

  static const zeroWidthJoiner = '\u200D';

  @override
  int measureWidth() {
    return leftPadding +
        (cell.canonicalStyle?.paddingRight ?? 0) +
        cell.cell.content.split('\n').fold<int>(
              0,
              (previousValue, element) => max(previousValue,
                  element.visualCodePointCount + element.emojiCount),
            );
  }

  @override
  void draw(TextCanvas canvas) {
    final height = measureHeight();

    final alignment = cell.canonicalStyle?.alignment ?? TextAlignment.TopLeft;

    final top = () {
      switch (alignment) {
        case TextAlignment.TopLeft:
        case TextAlignment.TopCenter:
        case TextAlignment.TopRight:
          return topPadding;
        case TextAlignment.MiddleLeft:
        case TextAlignment.MiddleCenter:
        case TextAlignment.MiddleRight:
          return ((canvas.height - height) ~/ 2) + topPadding;
        case TextAlignment.BottomLeft:
        case TextAlignment.BottomCenter:
        case TextAlignment.BottomRight:
          return canvas.height - height + topPadding;
      }
    }();

    var index = 0;

    for (final line in cell.cell.content.split('\n')) {
      final lineWidth = leftPadding +
          (cell.canonicalStyle?.paddingRight ?? 0) +
          line.visualCodePointCount;
      final left = () {
        switch (alignment) {
          case TextAlignment.TopLeft:
          case TextAlignment.MiddleLeft:
          case TextAlignment.BottomLeft:
            return leftPadding;
          case TextAlignment.TopCenter:
          case TextAlignment.MiddleCenter:
          case TextAlignment.BottomCenter:
            return ((canvas.width - lineWidth) ~/ 2) + leftPadding;
          case TextAlignment.TopRight:
          case TextAlignment.MiddleRight:
          case TextAlignment.BottomRight:
            return canvas.width - lineWidth + leftPadding;
        }
      }();

      final emojiCount = line.emojiCount;

      final correctedLine = line + [for (var i = 0; i < emojiCount; i++) zeroWidthJoiner].join();

      canvas.write(top + index, left, correctedLine);
      index++;
    }
  }
}

extension EmojiCount on String {
  int get emojiCount =>
      Characters(this).where((char) => isFullWidth(char)).length;
}
