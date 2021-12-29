## Standard ML Part 3 

Higher-order functions

- Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit3notes.pdf

- Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw3.pdf

Functional Programming can mean a few different things

- Avoid mutation in most/ all cases
- Using functions as values

Style
-  Encouraging Recursion & Recursive data structures
-  Closer definitions to mathematical functions
-  Programming idioms using laziness

### First Class Functions

Functions can be values: arguments, results, parts of tuples, exceptions, carried by datatype constructors etc

```sml
fun double x = 2 * x
fun incr x = x + 1
val a_tuple = (double, incr, double(incr 7))
val eighteen = (#1 a_tuple) 9
(* Returns 18 *)
```

Most common use is as an **Argument / Result of another function**

- Other function is called higher order function
- They are a powerful way to factor out common computations

### Functions as Arguments

The most common use of first-class functions is passing them as arguments to other functions, can be used to factor
out common code by replacing N similar functions with calls to 1 function where you pass in N different funs as args

```sml
fun n_times (f,n,x) =
    if n=0
    then x
    else f (n_times(f,n-1,x))
```

We can tell the argument f is a function because the last line calls f with an argument. What n_times does
is compute `f(f(...(f(x))))` where the number of calls to f is n. That is a genuinely useful helper function
to have around. For example, here are 3 different uses of it

```sml
fun double x = x+x
val x1 = n_times(double,4,7) (* answer: 112 i.e 14+28+35+35 *)

fun increment x = x+1
val x2 = n_times(increment,4,7) (* answer: 11 i.e 7+(1+1+1+1) *)

val x3 = n_times(tl,2,[4,8,12,16]) (* answer: [12,16] *)
```
Like any helper function, `n_times` lets us abstract the common parts of multiple computations so we can
reuse some code in different ways by passing in different arguments. The main novelty is making one of
those arguments a function, which is a powerful and flexible programming idiom.

```sml
(* Type Definition *)

val n_times : ('a -> 'a) * int * 'a -> 'a
```

### Polymorphic Types and Functions as Arguments

Higher order functions are often "generic" that they have **Polymorphic types** which makes them more useful but

- There can be higher order functions that are not polymorphic

```sml
fun times_until_zero(f,x) = 
    if x=0 then 0 else 1 + times_until_zero(f, f x)

(* val times_until_zero = fn : (int -> int) * int -> int *)
```

Since we have a `1+` the type can only be an int

- There can be non-higher-order (first order) functions that are polymorphic

```sml
fun len xs =
    case xs of
        [] => 0
    |   x::xs' => 1 + len xs'

(* val len = fn : 'a list -> int *)
```

Here since we are using the length of the list so the type does not matter making it polymorphic

Always good to understand the type of a function

### Anonymous Functions

Define functions without using a `fun` binding, It is useful in times when it's overkill to have functions
defined at the top level and it is better style to lower the scope of such functions

In the above examples we could have just defined triple inside the scope of the function like this

```sml
fun triple_n_times (n,x) =
    let fun triple x = 3*x in n_times(triple,n,x) end
```

ML has a much more concise way to define functions right where you use them

```
(* Anonymous fn *)
fun triple_n_times (n,x) = 
    n_times(
        (fn y => 3*y), 
        n, 
        x
    )
```

It is common to use anonymous functions as arguments to other functions. Moreover, you can put an
anonymous function anywhere you can put an expression as it simply is a value, the function itself. The
only thing you cannot do with an anonymous function is recursion, exactly because you have no name to
use for the recursive call. In such cases, you need to use a fun binding as before, and fun bindings must be
in let-expressions or at top-level.

For non-recursive functions, you could use anonymous functions with val bindings instead of a fun binding.
For example, these two bindings are exactly the same thing:

```sml
fun increment x = x + 1
val increment = fn x => x+1
```

They both bind increment to a value that is a function that returns its argument plus 1. So function-bindings are almost syntactic sugar, but they support recursion, which is essential

### Unnecessary Function Wrapping

While anonymous functions are incredibly convenient, there is one poor idiom where they get used for no
good reason. Consider:

```sml
fun nth_tail_poor (n,x) = n_times((fn y => tl y), n, x)
```

What is `fn y => tl y?` It is a function that returns the list-tail of its argument. But there is already a variable bound to a function that does the exact same thing: tl! In general, there is no reason to write fn x => f x when we can just use f. This is analogous to the beginner’s habit of writing `if x then true else false` instead of `x`. Just do this:

```sml
fun nth_tail (n,x) = n_times(tl, n, x)
```

### Maps and filters

Let's consider a very useful higher-order function over lists from the **Hall of Fame**

```sml
fun map (f,xs) =
    case xs of
        [] => []
      | x::xs' => (f x)::(map(f,xs'))
```

The map function takes a list and a function f and **produces a new list by applying f to each element of the list**

```sml
val x1 = map (increment, [4,8,12,16]) (* answer: [5,9,13,17] *)
val x2 = map (hd, [[1,2],[3,4],[5,6,7]]) (* answer: [1,3,5] *)
```

The type of map is illuminating: `(’a -> ’b) * ’a list -> ’b list`

This means you can pass map any kind of list you want but the argument type of f must be the element type of the list(they are both ’a). But the return type of f can be a different type ’b. The resulting list is a ’b list. For x1, both ’a and ’b are instantiated with int. For x2, ’a is int list and ’b is int

The ML standard library provides a very similar function `List.map` but it is defined in a **curried form**, a
topic we will discuss later in this unit

Here is a second very useful higher-order function for lists. It takes a function of type `’a -> bool` and
an `’a list` and returns the `’a list` **containing only the elements of the input list for which the function returns** true

```sml
fun filter (f,xs) =
    case xs of
        [] => []
      | x::xs' => if f x
                    then x::(filter (f,xs'))
                    else filter (f,xs')
```

```sml
val filter = fn : ('a -> bool) * 'a list -> 'a list`
```
Here is an example use that assumes the list elements are pairs with second component of type int; it returns
the list elements where the second component is even

```sml
fun get_all_even xs = filter((fn v => v mod 2 = 0), xs)
(* get_all_even [10, 11, 12, 13, 15, 16] returns [10,12,16] *)
```

There is also another similar `List.filter` which uses currying


### Functions returning Functions

```sml
fun double_or_triple f =
    if f 7
    then fn x => 2*x
    else fn x => 3*x
```

The type of double_or_triple is `(int -> bool) -> (int -> int)` The if-test makes the type of f clear
and as usual the two branches of the if must have the same type in this case `int->int`


Because ML programs tend to use lists a lot, you might forget that higher-order functions are useful for more
than lists. We can use higher order functions for our own data structures

```sml
datatype exp = Constant of int | Negate of exp | Add of exp * exp | Multiply of exp * exp

fun is_even v =
    (v mod 2 = 0)

fun true_of_all_constants(f,e) =
    case e of
        Constant i => f i
      | Negate e1 => true_of_all_constants(f,e1)
      | Add(e1,e2) => true_of_all_constants(f,e1) andalso true_of_all_constants(f,e2)
      | Multiply(e1,e2) => true_of_all_constants(f,e1) andalso true_of_all_constants(f,e2)

fun all_even e = true_of_all_constants(is_even,e)
```

## Lexical Scope

Lexical scope means that in a nested group of functions the inner functions have access to the variables and other resources of their parent scope. This means that the child functions are lexically bound to the execution context of their parents

> **The body of a function is evaluated in the environment where the function is defined, not the environment where the function is called**

```
val x = 1
(* x maps to 1 *)

fun f y = x + y
(* f maps a function that adds 1 to its argument *)

val x = 2
(* x maps to 2 *)

val y = 3
(* y maps to 3 *)

val z = f (x+y)
(* we call function f(5) which is 6, so z maps to 6 *)
```

This semantics is called lexical scope. The alternate, inferior semantics where you use the current environment
(which would produce 7 in the above example) is called dynamic scope.

A Function value has two parts

- The code (obviously)
- The environment that was current when the function was defined

This "pair" is called a **Function Closure** or just closure & this closure carries with it an environment that provides all the necessary bindings so it is "closed" - it has everything it needs to produce a function result given a function argument. A function call just evaluates the code part in the environment part.
