class Dog {
    name: string;
    constructor(name: string) {
        this.name = name;
    }
    bow() {
        console.log(`Bow! I'm ${this.name}`);
    }
}

function findDog (dogs: Dog[], name: string): Dog {
    for (let i = 0; i < dogs.length; i++) {
        if (dogs[i].name == name) { return dogs[i] }
    }
    return null;
}

// @see https://www.anicom-sompo.co.jp/special/name_dog/dog_2018/
const dogs = [
    new Dog('coco'),
    new Dog('momo'),
    new Dog('marron'),
];

const dog = findDog(dogs, 'coco');
if (dog != null) {
    dog.bow();
}
