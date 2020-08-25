class MyFactory {
  BaseClass create() {
    if (true) {
      return MyClass1();
    }
    return (MyClass2Builder()
          ..age = 2
          ..name = "two")
        .build();
  }
}

class BaseClass {}

class MyClass1 extends BaseClass {}

class MyClass2Builder {
  int age;
  String name;

  MyClass2 build() {
    // Do build
  }
}

class MyClass2 extends BaseClass {
  int _age;
  String _name;

  //MyClass2();

  MyClass2(this._age, this._name);

  MyClass2.valueOneMyClass() {
    this._age = 1;
    this._name = "one";
  }

  MyClass2.valueTwoMyClass() {
    this._age = 2;
    this._name = "two";
  }

  int get age => _age;
  String get name => _name;

  set age(int age) => _age = age;
  set name(String name) => _name = name;
}
