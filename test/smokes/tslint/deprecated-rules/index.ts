export function testDestructuring() {
    var [a, b] = [1, 2];
    var [c] = [3];

    var {d, e} = { d: 1, e: 2 };
    var {f} = { f: 3 };

    return c * f;
}
