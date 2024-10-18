var rname: string = "Monty";
var r = new Rabbit("Python");

function Rabbit(name: string) {
 this.name = name;
}

console.log(r.name); // ERROR!!!
console.log(rname);  // Prints "Python"

//Env set to node

function swap(arr: number[], i: number, j: number) {
  let tmp: number = arr[i];
  arr[i] = arr[j];
  arr[j] = tmp;
}
function sortAndGetLargest(arr: number[]) {
 let zeroInd: number = 0
 let tmp: number = arr[zeroInd]; // largest elem
 let i: number = 0;
 for (i = 0; i < arr.length; i += 1) {
 if (arr[i] > tmp) {
 tmp = arr[i];
 }
 let j: number = 0;
 for (j = i + 1; j < arr.length; j += 1) {
 if (arr[i] < arr[j]) {
 swap(arr, i, j);
 }
}
 }
 return tmp;
}
let largest: number = sortAndGetLargest([99, 2, 43, 8, 0, 21, 12]);
console.log(largest); // should be 99, but prints 0

//env set to node, for loops were allowed