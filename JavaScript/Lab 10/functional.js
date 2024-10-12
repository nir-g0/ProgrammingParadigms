var foldl = function (f, acc, array) {
  if (array.length === 0) {
    return acc
  }
  var newAccumulator = f(array.pop(), acc)
  return foldl(f, newAccumulator, array)
}

console.log(
  foldl(
    function (x, y) {
      return x + y
    },
    0,
    [1, 2, 3]
  )
)
console.log(
  foldl(
    function (x, acc) {
      return [x].concat(acc)
    },
    [],
    [1, 2, 3]
  )
)

var foldr = function (f, z, array) {
  if (array.length === 0) {
    return z
  }
  var newAccumulator = f(array.shift(), z)
  return foldr(f, newAccumulator, array)
}

console.log(
  foldr(
    function (x, y) {
      return x / y
    },
    1,
    [2, 4, 8]
  )
)
console.log(
  foldr(
    function (x, acc) {
      return [x].concat(acc)
    },
    [],
    [1, 2, 3]
  )
)

var map = function (f, array) {
  if (array.length === 0) {
    return []
  }
  var newIndex = f(array.shift())
  return [newIndex].concat(map(f, array))
}

console.log(
  map(
    function (x) {
      return x + x
    },
    [1, 2, 3, 5, 7, 9, 11, 13]
  )
)

// Object-oriented programming in JavaScript.
// Create a 'Student' constructor, like we did for Cat in class.
// It should have the following fields:
// *firstName
// *lastName
// *studentID
// *display -- A function that prints out the firstName, lastName, and studentID number.
//       To invoke it, you should call `student.display()`.

// Create an array of new students.
// Add a 'graduated' property to just one of your students.

// Now create another student **without** using the constructor.
// (In other words, use the object literal `{}` syntax).
// Set the prototype chain manually using the __proto__ field.
// Make sure the display method still works (without you having to add it to the object explicitly).

function Student (firstName, lastName, studentID) {
  this.firstName = firstName
  this.lastName = lastName
  this.studentID = studentID
}

Student.prototype.display = function () {
  console.log(`${this.firstName} ${this.lastName}, ${this.studentID}`)
}

var student1 = new Student('Nir', 'Guberman', 1)
var student2 = new Student('Nir', 'Guber', 2)
var student3 = new Student('Nir', 'Gub', 3)
var studentList = [student1, student2, student3]
studentList.forEach(s => s.display())
student1.gradutated = false
console.log(student1.gradutated)

var student4 = {
  firstName: 'Nir',
  lastName: 'G',
  studentID: 4,
  __proto__: Student.prototype
}
student4.display()
