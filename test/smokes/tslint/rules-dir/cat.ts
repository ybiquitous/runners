class Cat {
    name: string;
    constructor(name: string) {
        this.name = name;
    }
    meow() {
        console.log(`Meow! I'm ${this.name}`);
    }
}

function findCat (cats: Cat[], name: string): Cat {
    for (let i = 0; i < cats.length; i++) {
        if (cats[i].name == name) { return cats[i] }
    }
    return null;
}

// @see http://www.anicom-sompo.co.jp/name_cat/cat_2017.html
const cats = [
    new Cat('sora'),
    new Cat('reo'),
    new Cat('momo'),
];

const cat = findCat(cats, 'reo');
if (cat != null) {
    cat.meow();
}
