---
title: Ruby Fibonacci Sequence Generator
date: 2015-10-30 21:14 MDT
tags: ruby
---

Just a simple function to generate a Fibonacci sequence to a defined number of places.

READMORE

```rb
def fibonacci_sequence(number_of_places)
  base_number = 0
  added_number = 1

  (1..number_of_places).map do |num|
    base_number_tmp = base_number
    base_number = added_number
    added_number = base_number_tmp + added_number
  end
end

def reverse_fibonacci_sequence(number_of_places)
  fibonacci_sequence(number_of_places).reverse
end
```
