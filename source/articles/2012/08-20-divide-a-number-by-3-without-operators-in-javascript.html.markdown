---
title: Divide a Number by 3 Without Operators in Javascript
date: 2012-08-20 05:15 MDT
tags: javascript, code golf
---

**Code Golf**: show off your code-fu by trying to solve coding problems using the least number of keystrokes.

All to often, as developers can become complacent and bored with our work situation. From my own experience, this usually corresponds with doing the same thing over and over again without any challenges. I love challenges and brain teasers to keep me sharp, and I am always trying to do something that keeps me on my toes.

READMORE

The last problem presented to me was that of a popular code golf problem, divide a number by 3, without using any mathematical operators. Meaning, no minus (-), plus (+), multiply(*), and/or divide (/). The original problem was limited to just those operators but I decided to take it a bit further, no bitwise (<<).

I had to think about this problem for quite a while before proceeding with a solution. The only thing that I could think of was, "This has to be accomplished with string manipulation". After pondering it a while further, I realized that string manipulation was only the first part of the solution, arrays was the second.

In order for us to do any kind of mathematics, we need to have something that we can manipulate and count. For each digit in the number, we have to create an array representation for it. Assume that we have the number 132, we need to have 132 entries in the array.

```js
var n = 132;
var total = [];
while(total.length < n){
  total.push("1");
}
end
```

Next, split the total array into thirds. We need to do this to find out how many times it can be divided. To accomplish this, convert the array to a string and use a regular expression to grab 3 characters `/\w{3}/`. When the loop is done, we have an array with each entry having three characters. Example ["111","111","111", etc...]

```js
var triples = [];
var temp = total.join("");
var match = temp.match(/\d{3}/);
while (match) {
  triples.push(match[0]);
  temp = temp.replace(match[0], "");
  match = temp.match(/\w{3}/)
}
```

The last piece is to combine what we have into the end number. First, let's find out how many characters were not caught by our regex. Using String.substr and the `triples` array, we can find out how many characters were not grabbed.

```js
var remaining = count.substr(triples.join("").length);
```

Based on how many digits remain, we can determine what the float will be. When you divide a number by 3, you can only have 3 possible solutions for the float: 0, 3 or 6;

```js
if (remaining.length == 2) float = 6;
else if (remaining.length == 1) float = 3;
```

Lastly, create the float. `triples.length` gets us the whole number and `float` is the 0,3 or 6. It seems weird to use an array to create the number but rememer, we can use a plus (+).

```js
return parseFloat([triples.length, float].join('.'));
```

And, the final solution.

```js
var divideBy3 = function(n) {
  var total = [];
  var float = 0;
  while(total.length < n){
    total.push("1");
  }
  var triples = [];
  var count = temp = total.join("");
  var match = temp.match(/\d{3}/);
  while (match) {
    triples.push(match[0]);
    temp = temp.replace(match[0], "");
    match = temp.match(/\w{3}/)
  }

  var remaining = count.substr(triples.join("").length);
  if (remaining.length == 2) float = 6;
  else if (remaining.length == 1) float = 3;
  return parseFloat([triples.length, float].join('.'));
};
```
