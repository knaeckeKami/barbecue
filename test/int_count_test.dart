import 'package:barbecue/src/int_count.dart';
import 'package:test/test.dart';

void main() {
  test('IntCount can increase size', () {
    final counts = IntCounts();
    counts.set(2048, 50);

    expect(counts.data[2048], 50);
  });
}
