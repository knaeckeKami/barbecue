


extension TableRawStringUtils on String {
  String trimEveryLine() => split('\n').map((line) => line.trim()).join('\n');


}
