# barbecue


[![pub package](https://img.shields.io/pub/v/barbecue.svg?label=barbecue)](https://pub.dartlang.org/packages/barbecue)
[![Build Status](https://github.com/knaeckeKami/barbecue/workflows/Build/badge.svg)](https://github.com/knaeckeKami/barbecue/actions)
[![codecov](https://codecov.io/gh/knaeckeKami/barbecue/branch/master/graph/badge.svg)](https://codecov.io/gh/knaeckeKami/barbecue)

Render text tables for CLI-based dart applications.

Ported from Kotlin to Dart from Jake Wharton's [picnic](https://github.com/JakeWharton/picnic).

Features:

 - Borders (with custom styling)
 - Padding
 - Styling on table- row- or cell-level
 - Text alignment (bottom/middle/top - left/middle/right)
 - Row and column spans
 - ANSI Colors and backgrounds! (see example)
 - LIMITED support for emojis and other wide characters
 
## Examples

Simple example:

```dart

print(Table(
      tableStyle: TableStyle(border: true),
      header: TableSection(rows: [
        Row(
          cells: [
            Cell("ID"),
            Cell("Name"),
            Cell("Role"),
          ],
          cellStyle: CellStyle(borderBottom: true),
        ),
      ]),
      body: TableSection(
        cellStyle: CellStyle(paddingRight: 2),
        rows: [
          Row(cells: [
            Cell("42", style: CellStyle(alignment: TextAlignment.TopRight)),
            Cell("John Doe"),
            Cell("Secret Agent")
          ]),
          Row(cells: [
            Cell("4711"),
            Cell("Leanna E. Distefano"),
            Cell("Customer Support")
          ]),
          Row(cells: [Cell("1337"), Cell("Patrice Miller"), Cell("Accountant")])
        ],
      )).render());
```

Prints:

```
┌─────────────────────────────────────────────┐
│ID    Name                 Role              │
├─────────────────────────────────────────────┤
│  42  John Doe             Secret Agent      │
│4711  Leanna E. Distefano  Customer Support  │
│1337  Patrice Miller       Accountant        │
└─────────────────────────────────────────────┘
```

### Text Align + Spans + ASCII style border

```dart

Table(
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
  ).render(border: TextBorder.ASCII)

```

returns

```
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
+-----------------+-------+

```

### ANSI colors


```dart
  final strings = ["look", "at", "all", "these", "colors"];
  var i = 0;
  print(Table(
    tableStyle: TableStyle(border: true),
    body: TableSection(
        cellStyle: CellStyle(
          borderRight: true,
        ),
        rows: [
          Row(
            cells: [
              for (final pen in [
                AnsiPen()
                  ..red(bold: true),
                AnsiPen()
                  ..green(bold: true),
                AnsiPen()..blue(),
                AnsiPen()
                  ..black()
                  ..white(bg: true),
                AnsiPen()..xterm(190)
              ])
                Cell(pen(strings[i++]))
            ],
          ),
        ]),
  ).render());


```
prints 

![image](https://i.imgur.com/1HYQdbV.png)


# Emojis and other wide characters

By default, the layout algorithm assumes a real monospaced font, where every character is the exact same
width as other characters. Most modern "Mono" fonts don't work like that.

See for example this "monospaced" block:

```
😊😊😊
123
```

In a fully monospaced font, the first line with the emojis would be exactly as wide as the second line.
Chances are, that you see this block rendered like this (this depends on the font used):

![emoji_render][logo]

Text based table layouts don't work if some characters are wider than others.
Luckily, most fonts used in terminals just render most emojis twice as wide as other characters:
Something like:

```
😊😊😊|
123456|
```

Will likely render like that in your terminal:

![emoji_render][logo]


With the assumption that emojis are rendered twice as wide, we can build a valid text-table again.
Unfortunately, this is not going to work with all fonts, and not with all characters.

Some characters are rendered with a fractional width of a default character.

See for example bold unicode characters:

```
𝗛𝗲𝗮𝗱𝗲𝗿|
123456|
```

For emojis and other wide characters, you can use the experimental EmojiAwareLayout.

Example:

```dart
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
  final tableString = table.render(layoutFactory: (cell) => EmojiAwareLayout(cell));
```

Your milage may wary. It is recommended not to use any unicode full-width or half-width characters
with barbecue, as there are many platform, font or even terminal specific differences in how
their glyphs are rendered, and this breaks the monospace-assumption of this package.

There is no way of drawing text tables if the glyphs are rendered with fractional widths of 1.5x.