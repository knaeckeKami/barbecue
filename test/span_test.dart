import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';

void main() {
  test('handle column spans', () {
    final table = Table(
        body: TableSection(rows: [
      for (var i = 8; i > 0; i = i ~/ 2)
        Row(cells: [
          for (var j = 0; j < 8; j += i)
            Cell(List.filled(i, '$i').join(''), columnSpan: i),
        ])
    ]));

    expect(table.render(), '''
88888888
44444444
22222222
11111111''');
  });
}
