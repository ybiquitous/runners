package sample.checkstyle;

public class Main {

    public static void main(String[] args) {
        System.out.println("Hello Checkstyle!!");
    }

    void bad() {
        new SecretKeySpec("my secret here".getBytes(), "AES");
    }
}
