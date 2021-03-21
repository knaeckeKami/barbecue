import 'package:barbecue/barbecue.dart';
import 'package:test/test.dart';

void main() {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  const ansiEscape = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  const ansiDefault = '${ansiEscape}0m';

  const greenXterm = '2';

  String green(String orig) =>
      '${ansiEscape}38;5;${greenXterm}m$orig$ansiDefault';

  test('handles ansi codes with padding', () {
    final table = Table(
      tableStyle: TableStyle(border: true),
      cellStyle: CellStyle(paddingLeft: 2, paddingRight: 2),
      body: TableSection(
        rows: [
          Row(
            cells: [
              Cell(
                green('test'),
              ),
            ],
          )
        ],
      ),
    );

    final tableString = table.render();

    expect(tableString, '''
┌────────┐
│  \x1B[38;5;2mtest\x1B[0m  │
└────────┘''');
  });

  test('handles ansi codes with columnspan and middle alignment', () {
    final table = Table(
      body: TableSection(
        rows: [
          Row(
            cells: [
              Cell(green('test'),
                  columnSpan: 3,
                  style: CellStyle(alignment: TextAlignment.MiddleCenter)),
            ],
          ),
          Row(cells: [
            Cell(
              '1111',
            ),
            Cell(
              '2222',
            ),
            Cell(
              '3333',
            )
          ])
        ],
      ),
    );

    final tableString = table.render();

    expect(tableString, '''
    \x1B[38;5;2mtest\x1B[0m    
111122223333''');
  });

  test('handles ansi codes with columnspan and left alignment', () {
    final table = Table(
      body: TableSection(
        rows: [
          Row(
            cells: [
              Cell(green('test'),
                  columnSpan: 3,
                  style: CellStyle(alignment: TextAlignment.MiddleLeft)),
            ],
          ),
          Row(cells: [
            Cell(
              '1111',
            ),
            Cell(
              '2222',
            ),
            Cell(
              '3333',
            )
          ])
        ],
      ),
    );

    final tableString = table.render();

    expect(tableString, '''
\x1B[38;5;2mtest\x1B[0m        
111122223333''');
  });

  test('handles ansi codes with columnspan and right alignment', () {
    final table = Table(
      body: TableSection(
        rows: [
          Row(
            cells: [
              Cell(green('test'),
                  columnSpan: 3,
                  style: CellStyle(alignment: TextAlignment.MiddleRight)),
            ],
          ),
          Row(cells: [
            Cell(
              '1111',
            ),
            Cell(
              '2222',
            ),
            Cell(
              '3333',
            )
          ])
        ],
      ),
    );

    final tableString = table.render();

    expect(tableString, '''
        \x1B[38;5;2mtest\x1B[0m
111122223333''');

    /*expect(tableString, '''
┌────────┐
│  \x1B[38;5;2mtest\x1B[0m  │
└────────┘''');*/
  });
}
