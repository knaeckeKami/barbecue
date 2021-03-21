import 'package:barbecue/barbecue.dart';
import 'package:string_validator/string_validator.dart';
import 'package:test/test.dart';
import 'package:characters/characters.dart';

void main() {
  test('can match emojis', () {
    expect(isFullWidth('🤡'), isTrue);
  });

  test('simpleLayout does not handle emojis well', () {
    final table = Table(
        tableStyle: TableStyle(border: true),
        cellStyle: CellStyle(borderLeft: true, borderRight: true),
        body: TableSection(rows: [
          Row(cells: [
            Cell('1'),
            Cell('🤡'),
            Cell('1'),
          ])
        ]));

    final tableString =
        (table.render(layoutFactory: (cell) => SimpleLayout(cell)));

    expect(tableString, '''
┌─┬─┬─┐
│1│🤡│1│
└─┴─┴─┘''');
  });

  test('emojiAwareLayout can handle emojis ', () {
    final table = Table(
        tableStyle: TableStyle(border: true),
        cellStyle: CellStyle(borderLeft: true, borderRight: true),
        body: TableSection(rows: [
          Row(cells: [
            Cell('1'),
            Cell('🤡'),
            Cell('1'),
          ])
        ]));

    final tableString =
        (table.render(layoutFactory: (cell) => EmojiAwareLayout(cell)));

    expect(tableString, '''
┌─┬──┬─┐
│1│🤡${EmojiAwareLayout.zeroWidthJoiner}│1│
└─┴──┴─┘''');
  });

  test('emojiAwareLayout can handle emojis with padding and centering', () {
    final table = Table(
        body: TableSection(rows: [
      Row(cells: [
        Cell('🤡',
            columnSpan: 4,
            style: CellStyle(alignment: TextAlignment.MiddleCenter)),
      ]),
      Row(cells: [
        Cell(
          '1',
        ),
        Cell(
          '2',
        ),
        Cell(
          '3',
        ),
        Cell(
          '4',
        ),
      ])
    ]));

    final tableString =
        (table.render(layoutFactory: (cell) => EmojiAwareLayout(cell)));

    print(tableString);

    expect(tableString, '''
 🤡‍ 
1234''');
  });

  test('emojiAwareLayout can handle emojis with padding and centering 2', () {
    final table = Table(
        body: TableSection(rows: [
      Row(cells: [
        Cell('🤡',
            columnSpan: 4,
            style: CellStyle(alignment: TextAlignment.MiddleCenter)),
      ]),
      Row(cells: [
        Cell(
          '1',
        ),
        Cell(
          '2',
        ),
        Cell(
          '3',
        ),
        Cell(
          '4',
        ),
      ])
    ]));

    final tableString =
        (table.render(layoutFactory: (cell) => EmojiAwareLayout(cell)));

    expect(tableString, '''
 🤡‍ 
1234''');
  });

  test('bold characters', () {
    final table = Table(
        body: TableSection(cellStyle: CellStyle(borderRight: true), rows: [
      Row(cells: [Cell('Ｈｅａｄｅｒ')]),
      Row(cells: [
        Cell(
          '123456789abc',
        ),
      ])
    ]));

    final tableString =
        (table.render(layoutFactory: (cell) => EmojiAwareLayout(cell)));


    const expected = '''
Ｈｅａｄｅｒ|
123456789abc|''';


    expect(tableString, expected);
  }, skip: true);
}
