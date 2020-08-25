import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MyClass {
  String hello() {
    return "hello";
  }
}

// define mock
class MyClassMock extends Mock implements MyClass {}

void main() {
  group("grouping test like describe()", () {
    test('write test like it()', () {
      int a = 10;
      var counter = (num) => num * 2;
      expect(counter(a), 20);
    });
  });

  group("mock testing", () {
    test('return mocked result', () {
      var mock = MyClassMock();
      when(mock.hello()).thenReturn("world");
      expect(mock.hello(), "world");
    });
  });
}
