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


## TODO

☐ Support custom borders with arbitrary unicode characters (not just characters that can be stored in a single utf 16 codepoint) 
☐ Support emoji and other wide characters (they currently mess up the layout - a fully monospaced font is assumed, however most fonts render emojis as 2 characters wide) 
