import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';

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
          Cell('6'),
        ],
      ),
      Row(
        cells: [
          Cell('ß'),
          Cell('ä'),
          Cell('ê'),
          Cell(';;'),
          Cell('Ф'),
          Cell('𝐇')
        ],
      ),
    ]));

    expect(
        table.render(),
        '''
          1234 56 
          ßäê;;Ф𝐇'''
            .trimEveryLine());
  });
}
