import 'package:picnic/picnic.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';

void main() {
  test('can align multiple lines in a single cell individually', () {
    final table = Table(
        body: TableSection(rows: [
      Row(cells: [
        for (final alignment in [
          TextAlignment.TopLeft,
          TextAlignment.TopCenter,
          TextAlignment.TopRight
        ])
          Cell(
            '''
                  X
                  XXX
                  XXXXX
                  XXX
                  X'''
                .trimEveryLine(),
            style: CellStyle(alignment: alignment),
          ),
      ])
    ]));

    expect(
      table.render(),
      '''    
        X      X      X
        XXX   XXX   XXX
        XXXXXXXXXXXXXXX
        XXX   XXX   XXX
        X      X      X'''
          .trimEveryLine(),
    );
  });
}
