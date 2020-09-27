import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';

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

  test('column spans across border does not expand', () {
    final table = Table(
        body: TableSection(rows: [
      Row(
        cells: [
          Cell("11", style: CellStyle(borderRight: true)),
          Cell("22"),
        ],
      ),
      Row(cells: [Cell("33333", columnSpan: 2)])
    ]));

    expect(
      table.render(),
      '''
        11│22
        33333'''
          .trimEveryLine(),
    );
  });
}
