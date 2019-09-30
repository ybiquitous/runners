package sample.checkstyle;

import javax.crypto.spec.SecretKeySpec;

public class Main {

    public static void main(String[] args) {
        System.out.println("Hello Checkstyle!!");
    }

    void bad() {
        new SecretKeySpec("my secret here".getBytes(), "AES");
    }
}
