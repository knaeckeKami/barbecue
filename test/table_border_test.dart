import 'dart:math';

import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';
import '../test/test_table_string_helper.dart';

void main() {
  test('table can draw border and cell border', () {
    final table = Table(
      tableStyle: TableStyle(
        border: true,
      ),
      cellStyle: CellStyle(
          borderBottom: true,
          borderLeft: true,
          borderRight: true,
          borderTop: true),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('9'),
            ],
          ),
        ],
      ),
    );

    expect(
        table.render(),
        '''
           ┌─┬─┬─┐
           │1│2│3│
           ├─┼─┼─┤
           │4│5│6│
           ├─┼─┼─┤
           │7│8│9│
           └─┴─┴─┘'''
            .trimEveryLine());
  });

  test('table can draw border and cell border with different lengths', () {
    final table = Table(
      tableStyle: TableStyle(
        border: true,
      ),
      cellStyle: CellStyle(
          borderBottom: true,
          borderLeft: true,
          borderRight: true,
          borderTop: true),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1A'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('999'),
            ],
          ),
        ],
      ),
    );

    expect(
        table.render(),
        '''
           ┌──┬─┬───┐
           │1A│2│3  │
           ├──┼─┼───┤
           │4 │5│6  │
           ├──┼─┼───┤
           │7 │8│999│
           └──┴─┴───┘'''
            .trimEveryLine());
  });

  test('draw table without border and no cell border', () {
    final table = Table(
      tableStyle: TableStyle(
        border: false,
      ),
      cellStyle: CellStyle(
          borderBottom: false,
          borderLeft: false,
          borderRight: false,
          borderTop: false),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('9'),
            ],
          ),
        ],
      ),
    );

    expect(
        table.render(),
        '''
           123
           456
           789'''
            .trimEveryLine());
  });

  test('draw table with border and no cell border', () {
    final table2 = Table(
      tableStyle: TableStyle(
        border: true,
      ),
      cellStyle: CellStyle(
          borderBottom: false,
          borderLeft: false,
          borderRight: false,
          borderTop: false),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('9'),
            ],
          ),
        ],
      ),
    );

    print(table2.render());

    expect(
        table2.render(),
        '''
          ┌───┐
          │123│
          │456│
          │789│
          └───┘'''
            .trimEveryLine());
  });

  test('table can draw ascii border', () {
    final table = Table(
      tableStyle: TableStyle(
        border: true,
      ),
      cellStyle: CellStyle(
          borderBottom: true,
          borderLeft: true,
          borderRight: true,
          borderTop: true),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('9'),
            ],
          ),
        ],
      ),
    );

    expect(
        table.render(border: TextBorder.ASCII),
        '''
+-+-+-+
|1|2|3|
+-+-+-+
|4|5|6|
+-+-+-+
|7|8|9|
+-+-+-+'''
            .trimEveryLine());
  });

  test('table can draw rounded border', () {
    final table = Table(
      tableStyle: TableStyle(
        border: true,
      ),
      cellStyle: CellStyle(
          borderBottom: true,
          borderLeft: true,
          borderRight: true,
          borderTop: true),
      body: TableSection(
        rows: [
          Row(cells: [
            Cell('1'),
            Cell('2'),
            Cell('3'),
          ]),
          Row(cells: [
            Cell('4'),
            Cell('5'),
            Cell('6'),
          ]),
          Row(
            cells: [
              Cell('7'),
              Cell('8'),
              Cell('9'),
            ],
          ),
        ],
      ),
    );

    expect(
        table.render(border: TextBorder.ROUNDED),
        '''
╭─┬─┬─╮
│1│2│3│
├─┼─┼─┤
│4│5│6│
├─┼─┼─┤
│7│8│9│
╰─┴─┴─╯'''
            .trimEveryLine());
  });

  test('can draw table with header and footer with middle border', () {
    final table = Table(
        tableStyle: TableStyle(
          border: true,
        ),
        header: TableSection(
            cellStyle: CellStyle(
              borderBottom: true,
            ),
            rows: [
              Row(cells: [
                Cell('1', style: CellStyle(borderRight: true)),
                Cell('2'),
                Cell('3'),
              ])
            ]),
        body: TableSection(
          rows: [
            Row(cells: [
              Cell('4', style: CellStyle(borderRight: true)),
              Cell('5'),
              Cell('6'),
            ]),
            Row(
              cells: [
                Cell('7', style: CellStyle(borderRight: true)),
                Cell('8'),
                Cell('9'),
              ],
            ),
          ],
        ),
        footer: TableSection(rows: [
          Row(
            cellStyle: CellStyle(borderTop: true),
            cells: [
              Cell('A', style: CellStyle(borderRight: true)),
              Cell('B'),
              Cell('C'),
            ],
          ),
        ]));

    expect(table.render(), '''
┌─┬──┐
│1│23│
├─┼──┤
│4│56│
│7│89│
├─┼──┤
│A│BC│
└─┴──┘''');
  });
}
