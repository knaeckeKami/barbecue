import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';
import 'package:barbecue/src/text.dart';

void main() {
  test('can handle non-ascii chars', () {
    final table = Table(
        body: TableSection(rows: [
      Row(
        cells: [
          Cell('1'),
          Cell('2'),
          Cell('3'),
          Cell('4'),
          Cell('5'),
        ],
      ),
      Row(
        cells: [
          Cell('ß'),
          Cell('ä'),
          Cell('ê'),
          Cell(';;'),
          Cell('Ф'),
        ],
      ),
    ]));

    expect(
        table.render(),
        '''
          1234 5 
          ßäê;;Ф'''
            .trimEveryLine());
  });

  test("can handle bold chars", () {
    expect("Ｈｅａｄｅｒ".visualLength(withWideChars: false), 6);
    expect("Ｈｅａｄｅｒ".visualLength(withWideChars: true), 12);
  });
}
