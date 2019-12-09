package sample;

import javax.crypto.spec.SecretKeySpec;

public class Hello {

    public static void main(String[] args) {
        System.out.println("Hello Checkstyle!!");
    }

    void bad() {
        new SecretKeySpec("my secret here".getBytes(), "AES");
    }

    String foo() {
        finalize();
        return "" + 123;
    }

    synchronized void no() {}

    class Foo extends java.lang.Error {
        static final long serialVersionUID = 1L;
    }
}
