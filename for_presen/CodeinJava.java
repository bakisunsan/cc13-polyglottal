public MyFacotr {
    public BaseClass create() {
        if(true) {
            return new MyClass1();
        }
        return MyClass2.valueOneMyClass();
    }
}

public class BaseClass {
    // Do something
}

public class MyClass1 extends BaseClass {
    // Do something
}

public class MyClass2 extends BaseClass {
    private int age;
    private String name; 
    
    // Conctructor
    MyClass2() {
        // Do Nothing    
    }
    
    MyClass2(int age, String name) {
        this.age = age;
        this.name = name;
    }
    
    // builder
    MyClass2 age(int age) {
        this.age = age;
        return this;
    }
    
    MyClass2 name(String name) {
        this.name = name;
        return this;
    }
    
    // factory methods
    public static MyClass valueOneMyClass() {
        return new MyClass2().age(1).name("one");
    }
    
     public static MyClass valueTwoMyClass() {
        return new MyClass2().age(2).name("two");
    }
    
    // setter
    public void setAge(int value) {
        this.age = age;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    // getter
    public int getAge() {
        return this.age;
    }
    
    public String getName() {
        return this.name;
    }
}

