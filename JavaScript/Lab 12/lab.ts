// Part 1)
var rname: string = 'Monty';
var r: any = new Rabbit('Python');
function Rabbit(name: string) {
    this.name = name;
}
console.log(r.name); // ERROR!!!
console.log(rname); // Prints "Python"

//enabled:  node, for, single and this.

// Part 2)
var largest = sortAndGetLargest([99, 2, 43, 8, 0, 21, 12]);
function swap(arr: Array<number>, i: number, j: number) {
    var tmp: number = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
function sortAndGetLargest(arr: Array<number>) {
    var zeroInd: number = 0;
    var tmp: number = arr[zeroInd]; // largest elem
    var i: number = 0;
    var j: number = 0;
    for (i = 0; i < arr.length; i += 1) {
        if (arr[i] > tmp) {
            tmp = arr[i];
        }
        for (j = i + 1; j < arr.length; j += 1) {
            if (arr[i] < arr[j]) {
                swap(arr, i, j);
            }
        }
    }
    return tmp;
}
console.log(largest); // should be 99, but prints 0
//env set to node, allowed: for, single, this, variable