import 'package:characters/characters.dart';

class TextBorder {
  final Characters characters;

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
