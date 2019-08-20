function validRange (range: any) {
    return range.min <= range.middle && range.middle <= range.max;
}

const range = {
    min: 5,
    middle: 10,    // TSLint will warn about unsorted keys here
    max: 20
};

console.log(validRange(range));
