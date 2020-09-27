


import 'dart:math';

class IntCounts {
  var data = List<int>(10);

  var size = 0;

  int operator [](int index) {
    if (index >= size) {
      return 0;
    } else {
      return data[index];
    }
  }

  void set(int index, int value) {
    final newSize = index + 1;
    while (newSize >= data.length) {
      final newData = List<int>(data.length * 2);
      newData.setRange(0, data.length, data);
      data = newData;
    }
    data[index] = value;
    size = max(size, newSize);
  }

  @override
  String toString() {
    return 'IntCounts{data: $data, size: $size}';
  }
}
