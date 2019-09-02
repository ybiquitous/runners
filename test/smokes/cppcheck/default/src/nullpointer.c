void f(int *q) {
    *q = 3;
}

int main() {
    int *a = 0;
    f(a);
}
