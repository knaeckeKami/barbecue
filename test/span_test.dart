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

    expect(
      table.render(),
      '''
       88888888
       44444444
       22222222
       11111111'''
          .trimEveryLine(),
    );
  });

  test('column spans across border does not expand', () {
    final table = Table(
        body: TableSection(rows: [
      Row(
        cells: [
          Cell('11', style: CellStyle(borderRight: true)),
          Cell('22'),
        ],
      ),
      Row(cells: [Cell('33333', columnSpan: 2)])
    ]));

    expect(
      table.render(),
      '''
        11│22
        33333'''
          .trimEveryLine(),
    );
  });

  test('handle row spans', () {
    final table = Table(
        body: TableSection(rows: [
      Row(cells: [
        Cell('8\n8\n8\n8\n8\n8\n8\n8', rowSpan: 8),
        Cell('4\n4\n4\n4', rowSpan: 4),
        Cell('2\n2', rowSpan: 2),
        Cell('1')
      ]),
      Row(
        cells: [Cell('1')],
      ),
      Row(
        cells: [
          Cell('2\n2', rowSpan: 2),
          Cell('1'),
        ],
      ),
      Row(
        cells: [Cell('1')],
      ),
      Row(cells: [
        Cell('4\n4\n4\n4', rowSpan: 4),
        Cell('2\n2', rowSpan: 2),
        Cell('1')
      ]),
      Row(
        cells: [Cell('1')],
      ),
      Row(
        cells: [
          Cell('2\n2', rowSpan: 2),
          Cell('1'),
        ],
      ),
      Row(
        cells: [
          Cell('1'),
        ],
      ),
      Row(
        cells: [
          Cell('1'),
          Cell('1'),
          Cell('1'),
          Cell('1'),
        ],
      ),
    ]));

    expect(
        table.render(),
        '''
       8421
       8421
       8421
       8421
       8421
       8421
       8421
       8421
       1111'''
            .trimEveryLine());
  });

  test('invalid rowspan throws exception', () {
    expect(
        () => Table(
              body: TableSection(
                rows: [
                  Row(
                    cells: [
                      Cell('2', rowSpan: 2),
                    ],
                  ),
                ],
              ),
            ),
        throwsA(isA<AssertionError>()));
  });

  test('row spans can leave hole', () {
    final table = Table(
        body: TableSection(rows: [
      Row(cells: [
        Cell('1'),
        Cell('2\n2', rowSpan: 2),
        Cell('1'),
        Cell('2\n2', rowSpan: 2),
      ]),
      Row(cells: [Cell('1')]),
      Row(cells: [Cell('1'), Cell('1'), Cell('1'), Cell('1')])
    ]));

    expect(
        table.render(),
        '''
         1212
         12 2
         1111'''
            .trimEveryLine());

    expect(table.getOrNull(1, 2), isNull);
    expect(table.getOrNull(1, 3), isNotNull);
  });

  test('more complex row span', () {
    final table = Table(
      cellStyle: CellStyle(
          borderBottom: true,
          borderRight: true,
          borderLeft: true,
          borderTop: true,
          alignment: TextAlignment.TopLeft),
      body: TableSection(
        rows: [
          Row(
            cells: [
              Cell("Real Planets",
                  rowSpan: 8,
                  style: CellStyle(alignment: TextAlignment.MiddleCenter)),
              Cell("Mercury")
            ],
          ),
          Row(
            cells: [Cell("Venus")],
          ),
          Row(
            cells: [Cell("Earth")],
          ),
          Row(
            cells: [Cell("Mars")],
          ),
          Row(
            cells: [Cell("Jupiter")],
          ),
          Row(
            cells: [Cell("Saturn")],
          ),
          Row(
            cells: [Cell("Uranus")],
          ),
          Row(
            cells: [Cell("Neptune")],
          ),
          Row(
            cells: [Cell("Very Fake Planets", rowSpan: 1), Cell("Pluto")],
          ),
        ],
      ),
    ).render(border: TextBorder.ASCII);

    expect(table, '''
+-----------------+-------+
|                 |Mercury|
|                 +-------+
|                 |Venus  |
|                 +-------+
|                 |Earth  |
|                 +-------+
|                 |Mars   |
|  Real Planets   +-------+
|                 |Jupiter|
|                 +-------+
|                 |Saturn |
|                 +-------+
|                 |Uranus |
|                 +-------+
|                 |Neptune|
+-----------------+-------+
|Very Fake Planets|Pluto  |
+-----------------+-------+''');
  });
}
