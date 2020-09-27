import 'package:characters/characters.dart';

extension Visual on String {
  static final ansiColorEscape = RegExp('\u001B' + r'\[\d+(;\d+)*m');

  int visualIndex(int index) {
    var currentIndex = 0;
    var remaining = index;
    while (true) {
      final match = ansiColorEscape.firstMatch(substring(currentIndex));

      if (match == null) {
        break;
      }

      final jump =
          codePointCount(startIndex: currentIndex, endIndex: match.start +currentIndex);
      if (jump > remaining) break;

      remaining -= jump;
      currentIndex = match.end  +currentIndex;
    }
    final runes = Runes(this);
    while (remaining > 0) {
      final codePoint = runes.elementAt(currentIndex);
      currentIndex += codePoint >= 65536 ? 2 : 1;
      remaining--;
    }

    return currentIndex;
  }

  int get visualCodePointCount {
    /*
    // Fast path: no escapes.
    final firstEscape = indexOf('\u001B');
    if (firstEscape == -1) {
      return codePointCount();
    }

    var currentIndex = firstEscape;
    var count = codePointCount(endIndex : firstEscape);
    while (true) {
      final match = ansiColorEscape.matchAsPrefix(this,  currentIndex);
      if(match == null){
        break;
      }
      count += codePointCount(startIndex :currentIndex, endIndex : match.start);
    currentIndex = match.end + 1;
    }
    count += codePointCount(startIndex : currentIndex);
    return count;
    */

    return Characters(this).length;
  }

  int codePointCount({int startIndex = 0, int endIndex}) {
    endIndex ??= this.length ;

    return Runes(substring(startIndex, endIndex)).length;
  }
}
