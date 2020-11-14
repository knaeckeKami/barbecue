import 'package:characters/characters.dart';

class TextBorder {
  final String characters;

  TextBorder(String characters)
      : assert(Characters(characters).length == 16,
            'Border string must contain exactly 16 characters'),
        characters = characters,
        empty = characters[0],
        down = characters[1],
        up = characters[2],
        vertical = characters[3],
        right = characters[4],
        downAndRight = characters[5],
        upAndRight = characters[6],
        verticalAndRight = characters[7],
        left = characters[8],
        downAndLeft = characters[9],
        upAndLeft = characters[10],
        verticalAndLeft = characters[11],
        horizontal = characters[12],
        downAndHorizontal = characters[13],
        upAndHorizontal = characters[14],
        verticalAndHorizontal = characters[15];

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
    return characters[
        (down ? 1 : 0) | (up ? 2 : 0) | (right ? 4 : 0) | (left ? 8 : 0)];
  }

  static final DEFAULT = TextBorder(' ╷╵│╶┌└├╴┐┘┤─┬┴┼');
  static final ROUNDED = TextBorder(' ╷╵│╶╭╰├╴╮╯┤─┬┴┼');
  static final ASCII = TextBorder('   | +++ +++-+++');
}
