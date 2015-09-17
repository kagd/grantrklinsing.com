---
title: Javascript's Call Method
date: 2012-08-18 05:36 MDT
tags: javascript
---

I love Javascript. In particular, the `call` method. `.call()` is used to change scope of a particular object's method. Whoa, that is the technical way of saying that you can use one object's function on another object.

How about an example?

READMORE

```js
var foo = {
	name: function(){
		return this.firstName + ' ' + this.lastName;
	},
	firstName: 'Grant',
	lastName: 'Klinsing'
}

var bar = {
	name: function(){
		return this.lastName + ', ' + this.firstName;
	},
	firstName: 'Joe',
	lastName: 'Johnson'
}

console.log(foo.name()); //-> 'Grant Klinsing'
console.log(bar.name()); //-> 'Johnson, Joe'
```

Pretty straight forward, right? Each object has a method of `name` and returns each objects first and last name is a different order. But what if I wanted to display Grant's name in the order last, first like Joe's does? We can write another method on the foo object to do just that, or we can use `.call()`.

`foo.name.call(bar)` will use foo's `name` method, but it will use `bar` as it's parent object. That means that when `name` is invoked, it will have the `firstName` of "Joe" and the `lastName` of "Johnson".

```js
console.log(foo.name.call(bar)); //-> 'Joe Johnson'
```

The same goes for `bar.name.call(foo)`, but vice versa. Since the order is reversed when invoking `name`, "Klinsing, Grant" will be displayed.

```js
console.log(bar.name.call(foo)); //-> 'Klinsing, Grant'
```

### Let's try a slightly different approach

What if we had an object that solely had methods of returning data in different ways and another object that contained the data? We could just change the data object and still be able to display the data in different formats.

```js
var methods = {
	firstLast: function(){
		return this.firstName + ' ' + this.lastName;
	},
	lastFirst: function(){
		return this.lastName + ', ' + this.firstName;
	}
}

var grant = {
	firstName: 'Grant',
	lastName: 'Klinsing'
}

var joe = {
	firstName: 'Joe',
	lastName: 'Johnson'
}

console.log(methods.firstLast.call(grant)); //-> 'Grant Klinsing'
console.log(methods.lastFirst.call(joe)); //-> 'Johnson, Joe'
```

Pretty sweet, huh?
