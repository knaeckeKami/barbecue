import 'dart:math';

/// todo use typed_data
class IntCounts {
  var data = List<int>.filled(10, 0);

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
      final newData = List<int>.filled(data.length * 2, 0);
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
