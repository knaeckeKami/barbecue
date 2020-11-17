import 'package:characters/characters.dart';

/// represents the border of a table
class TextBorder {
  final Characters characters;

  /// create a new textborder from the given string
  /// the string must have a visual length of 16 (as of the characters package)
  /// these 16 characters will be used for constructing the border.
  /// the positions of the character defines its usage.
  /// the positions are in that order: empty, down, up, vertical, right,
  /// downAndRight, upAndRight, verticalAndRight, left, downAndLeft, upAndLeft,
  /// verticalAndLeft, horizontal, downAndHorizontal, upAndHorizontal and
  /// verticalAndHorizontal.
  factory TextBorder(String string) {
    return TextBorder.fromCharacters(Characters(string));
  }

  TextBorder.fromCharacters(Characters characters)
      : assert(characters.length == 16,
            'Border string must contain exactly 16 characters, but got ${characters.length}'),
        characters = characters,
        empty = characters.elementAt(0),
        down = characters.elementAt(1),
        up = characters.elementAt(2),
        vertical = characters.elementAt(3),
        right = characters.elementAt(4),
        downAndRight = characters.elementAt(5),
        upAndRight = characters.elementAt(6),
        verticalAndRight = characters.elementAt(7),
        left = characters.elementAt(8),
        downAndLeft = characters.elementAt(9),
        upAndLeft = characters.elementAt(10),
        verticalAndLeft = characters.elementAt(11),
        horizontal = characters.elementAt(12),
        downAndHorizontal = characters.elementAt(13),
        upAndHorizontal = characters.elementAt(14),
        verticalAndHorizontal = characters.elementAt(15);

  final String empty;
  final String down;
  final String up;

  final String vertical;
  final String right;

  final String downAndRight;
  final String upAndRight;

  final String verticalAndRight;
  final String left;

  final String downAndLeft;
  final String upAndLeft;

  final String verticalAndLeft;

  final String horizontal;

  final String downAndHorizontal;
  final String upAndHorizontal;

  final String verticalAndHorizontal;

  String get({
    bool down = false,
    bool up = false,
    bool right = false,
    bool left = false,
  }) {
    return characters.elementAt(
      (down ? 1 : 0) | (up ? 2 : 0) | (right ? 4 : 0) | (left ? 8 : 0),
    );
  }

  static final DEFAULT = TextBorder(' ╷╵│╶┌└├╴┐┘┤─┬┴┼');

  static final ROUNDED = TextBorder(' ╷╵│╶╭╰├╴╮╯┤─┬┴┼');

  static final ASCII = TextBorder('   | +++ +++-+++');

  static final HEAVY = TextBorder(' ╹╹┃╺┏┗┣╸┓┛┫━┳┻╋');
}
