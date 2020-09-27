import 'package:picnic/picnic.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';

void main() {
  test("can align text", () {
    final table = Table(
        tableStyle: TableStyle(border: false),
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
