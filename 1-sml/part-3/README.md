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

```sml
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

### Maps and filters ( Beyonce of Higher order functions )

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

### Lexical Scope

Lexical scope means that in a nested group of functions the inner functions have access to the variables and other resources of their parent scope. This means that the child functions are lexically bound to the execution context of their parents

> **The body of a function is evaluated in the environment where the function is defined, not the environment where the function is called**

```sml
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

Lexical scope and closures get more interesting when we have higher-order functions

```sml
val x = 1
fun f y =
    let
        val x = y+1
    in
        fn z => x + y + z (* take z and return 2y+1 *)
    end

val x = 3 (* irrelevant *)
val g = f 4 (* fn z => 4 + 5 + z Returns a fun that adds 9 to its arg *)

val y = 5 (* irrelevant *)
val z = g 6 (* get 15 *)
```

Here, f is bound to a closure where the environment part maps x to 1. So when we later evaluate f 4, we
evaluate let val x = y + 1 in fn z => x + y + z end in an environment where x maps to 1 extended
to map y to 4. But then due to the let-binding we shadow x so we evaluate fn z => x + y + z in an
environment where x maps to 5 and y maps to 4. How do we evaluate a function like fn z => x + y + z?
We create a closure with the current environment. So f 4 returns a closure that, when called, will always
add 9 to its argument, no matter what the environment is at any call-site. Hence, in the last line of the
example, z will be bound to 15.

```sml
fun f g =
    let
        val x = 3 (* irrelevant since its not used in expression below *)
    in
        g 2
    end

val x = 4
fun h y = x + y (* Add 4 to its argument *)
val z = f h (* get 6 since f always return 2 to h which adds 4 to the argument *)
```

In this example, f is bound to a closure that takes another function g as an argument and returns the result
of g 2. The closure bound to h always adds 4 to its argument because the argument is y, the body is x+y,
and the function is defined in an environment where x maps to 4. So in the last line, z will be bound to
6. The binding val x = 3 is totally irrelevant: the call g 2 is evaluated by looking up g to get the closure
that was passed in and then using that closure with its environment (in which x maps to 4) with 2 for an
argument


### Why Lexical Scope

But first we can also motivate lexical scope by showing how dynamic scope (where you just have one current
environment and use it to evaluate function bodies) leads to some fundamental problems.

- Function meaning does not depend on variable name used

Here we can change the body of f to use q everywhere instead of x when in lexical scope but in dynamic scope 
it depends on how the result is being used 

```sml
fun f g = let val x = 9 in g() end
(* In Lexical scope since x is not use this would just return g() *)

val x = 7
fun h() = x+1
val y = f h

(* In Lexical scope 7 is Picked up so y = 8 *)
(* In Dynamic scope 7 is replaced by 9 in local scope up so y = 10 *)

```

- We can remove unused variables

```sml
fun f g = let val x = 9 in g() end
(* we can remove x=9 *)
fun f g = g()
```

- Funs can be type checked and reasoned about where defined

```sml
val x = 1
fun f y = let val x=y+1 in fn z => x+y+z end

val x = "hi"
val g = f 7
val z = g 4
(* Here dynamic scoping adds a string and an unbound variable to x *)
```

- **Closures can store data they need**

```sml
fun greaterThanX x = fn y => y > x
(* 
    Filter all non negative numbers
    Here ~1 is passed to the filter function
    and even tho it might have x defined lexical 
    scope makes sure that does not affect the results
*)
fun noNegatives xs = filter (greaterThanX ~1, xs)
(* Filter all non negative numbers *)
fun allGreater (xs, n) = filter(fn x => x > n, xs)
```

Tho Lexical scope is the right default and common across languages, Dynamic scope is occasionally useful
so languages like Racket have special ways to do it but most don't bother

**Exception handling is more like dynamic scope**

When an exception is raised, evaluation has to "look up" which handle expression should be evaluated. This "look up" is done using the **dynamic call stack** with no regard for the lexical structure of the program


### Closures & Recomputation

We can avoid unnecessary recomputation of things when we're using Closures

```sml
fun allShorterThan1(xs, s) =
    filter (fn x => String.size x < String.size s, xs)

(* recomputes String.size s once per element in xs *)

fun allShorterThan2(xs, s) =
    let
        val i = String Size s
    in
        filter(fn x => String.size x < i, xs)
    end

(* Pre-computes String.size s and binds it to a variable i *)
```

Another side-note, we can print in SML by using `print` and `;` to tie it to expressions as when
running `e1;e2` e1 is executed and result and thrown away while e2 is returned

```sml
print "hello"; 1+2;
```

### Fold and More Closure Examples

Beyond map and filter a third incredibly useful higher-order function is fold, which can have several slightly different definitions and is also known by names such as "reduce" and "inject".

```sml
fun fold (f,acc,xs) =
    case xs of
        [] => acc
      | x::xs' => fold (f, f(acc,x), xs')

(* val fold = fn : ('a * 'b -> 'a) * 'a * 'b list -> 'a *)
```

This version "Folds left"; another version "Folds right", Whether the direction matters or not depends on `f`

fold takes an "initial answer" `acc` and uses `f` to "combine" acc and the first element of the list, using this
as the new "initial answer" for "folding" over the rest of the list. We can use fold to take care of iterating
over a list while we provide some function that expresses how to combine elements. For example, to sum the
elements in a list foo, we can do

```sml
fold ((fn (x,y) => x+y), 0, foo)
```

As with map and filter, much of fold's power comes from clients passing closures that can have **private fields (in the form of variable bindings)** for keeping data they want to consult.

```sml
(* Counts how many elements are in some integer range *)

fun numberInRange (xs,lo,hi) =
    fold ((fn (x,y) =>
        x + (if y >= lo andalso y <= hi then 1 else 0)),
    0, xs)
```

This pattern of splitting the recursive traversal (fold / map) from the data-processing done on the elements is fundamental here, This splits the concerns and allows us to 

- Reuse the same traversal for different data processing
- Reuse the same data processing for different data structures


```sml
(* checks if all elements are strings shorter than some other string’s length *)

fun areAllShorter (xs,s) =
    let
        val i = String.size s
    in
        fold((fn (x,y) => x andalso String.size y < i), true, xs)
    end
```

Functions can use private data in its environment and the iterator need not care much about the data or the types

### Function Composition (Combining Funcs)

When we program with lots of functions, it is useful to create new functions that are just combinations of
other functions. You have probably done similar things in mathematics, such as when you compose two
functions. For example, here is a function that does exactly function composition:

```math
fun compose (f,g) = fn x => f (g x)
```

It takes two functions `f` and `g` and returns a function that applies its argument to `g` and makes that the
argument to `f` so the type of compose is inferred to be `('a -> 'b) * ('c -> 'a) -> 'c -> 'b`

As convenient library function, the ML library defines the **infix operator** `o` as **function composition**,
just like in math. So instead of writing:

```sml
fun sqrt_of_abs i = Math.sqrt(Real.fromInt (abs i))
```

you could write

```sml
fun sqrt_of_abs i = (Math.sqrt o Real.fromInt o abs) i
```

we can also bind to a variable with a val-binding

```sml
val sqrt_of_abs = Math.sqrt o Real.fromInt o abs
```

While all three versions are fairly readable, the first one does not immediately indicate to the reader that
sqrt_of_abs is just the composition of other function

As in math function composition is **Right to Left** which mean we take abs value -> convert to real -> take square root but normally devs are used to reading **left to right** for which we have **Pipelines**

```sml
infix |> 
(* tells the parser |> is a function that appears between its two arguments *)
fun x |> f = f x
(* takes an arg x and a function f to run f x *)

fun sqrt_of_abs i = i |> abs |> Real.fromInt |> Math.sqrt
```

This operator, commonly called the pipeline operator, is very popular in F# programming. (F# is a dialect
of ML that runs on .Net and interacts well with libraries written in other .Net languages.)


## Currying

We have already seen that in ML every function takes exactly one argument so previously
we passed a tuple as the one argument so that each part of the tuple is conceptually one of the multiple arguments.

Another more clever and often more convenient way is to **have a function take the first conceptual argument and return another function that takes the second conceptual argument** and so on. Lexical scope is essential
to this technique working correctly

This technique is called currying after a logician named Haskell Curry

Here is an example of a “three argument” function that uses currying:

```sml
val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x
(* val sorted3 = fn : int -> int -> int -> bool *)

fun sorted3_curried x y z = z >= y andalso y >= x; (* Same Type *)
(* val sorted3_curried = fn : int -> int -> int -> bool *)
```

So `((sorted3 4) 5) 6` computes exactly what we want and feels pretty close to calling sorted3 with 3 arguments. Even better, the parentheses are optional, so we can write exactly the same thing as `sorted3 4 5 6`
which is actually fewer characters than our old tuple approach where we would have done

```sml
fun sorted3_tupled (x,y,z) = z >= y andalso y >= x
val someClient = sorted3_tupled(4,5,6)
```

In general, the syntax e1 e2 e3 e4 is implicitly the nested function calls (((e1 e2) e3) e4) and this
choice was made because it makes using a curried function so pleasant.

```sml
fun f a b c = a+b+c
(* val f = fn : int -> int -> int -> int *)

f 1 2 3; (* 6 *)
```


### Partial Application

Like Currying but we pass in too few arguments cause iss more cleaner sometimes

As a silly example, `sorted3 0 0`
returns a function that returns true if its argument is nonnegative.

```sml
val non_neg = sorted3 0 0;

non_neg 10;
(* val it = true : bool *)
non_neg ~10;
(* val it = false : bool *)
```

let us start by taking in a simple `sum` function

```sml
fun sum xs = fold (fn(x,y)=>x+y) 0 xs
```

We can make this better

```sml
val sum = fold (fn(x,y)=>x+y) 0
```

This is similar to how instead of writing `f x = g x` we write `val f = g`


Let us look at another example of `Range` that returns a list of numbers in a range

```sml
fun range i j= if i > j then [] else i::range (i+1) j
- range 3 5; (* val it = [3,4,5] *)

(*using this we can write a countup function *)
val countup_from_one = range 1
- countup_from_one 4 (* val it = [1,2,3,4] *)

fun countup_bad_example x = range 1 x
(* This works but is bad style, we should rather use partial applications *)
```

We can also use the in-built Map and Filter to define partial applications

```sml
(* Add 1 to every element of a list *)
val incrementAll = List.map (fn x => x+1)

(* Remove the non zero elements in a list *)
val removeZeros = List.filter (fn x => x<>0)
```

Using partial functions to create a Polymorphic function may not work due to **Value Restriction**
we might get an warning `type vars not generalized`

```sml
val pairwithOne = List.map (fn x => (x,1))

stdIn:1.6-1.44 Warning: type vars not generalized because of
   value restriction are instantiated to dummy types (X1,X2,...)
val pairwithOne = fn : ?.X1 list -> (?.X1 * int) list


(* Workarounds *)

(* Fallback to functions *)
fun pairwithOne xs = List.map (fn x => (x,1)) xs (* val pairwithOne = fn : 'a list -> ('a * int) list *)
(* Explicit Typing *)
val pairwithOne: string list -> (string* int) list = List.map (fn x => (x,1))
```

This only happens when the resulting function from a partial application is Polymorphic

### Mutable References

Mutation is okay in sometime and A key approach in functional programming is to use it only when **"updating the state of something so all users of that state can see a change has occurred"** is the natural way to model your computation. Moreover, we want to keep features for mutation separate so that we know when mutation is not being used.

In SMl the mutation construct is called **References**

```
val x = ref 42 (* int ref *)
val y = ref 42
val z = x
(* both z and x now point to the same block like a reference/pointer *)

val _ = x := 43

!y + !z (* 43+42 = 85 *)
```

we cannot perform arithmetic operations on `ref` ie `x+1` type, we can just do a reference/assign with `:=` or a dereference/read with `!`

### Closure Idiom: Callbacks

A callback is a library that detects when "events" occur and informs clients that have previously "registered" their interest in hearing about events. Clients can register their interest by providing a "callback" a function that gets called when the event occurs.

Our example uses the idea that callbacks should be called when a key on the keyboard is pressed. We will
pass the callbacks an int that encodes which key it was. Our interface just needs a way to register callbacks.

```sml
val onKeyEvent : (int -> unit) -> unit
```

Clients will pass a function of type `int -> unit` when called later with an `int` will do whatever they
want. To implement this function we just use a reference that holds a list of the callbacks. Then when an
event actually occurs, we assume the function `onEvent` is called and it calls each callback in the list

```sml
val cbs : (int -> unit) list ref = ref []
fun onKeyEvent f = cbs := f::(!cbs) (* The only "public" binding *)

fun onEvent i =
    let fun loop fs =
        case fs of
            [] => ()
         | f::fs’ => (f i; loop fs’)
    in loop (!cbs) end
```

Most importantly, the type of onKeyEvent places no restriction on what extra data a callback can access
when it is called. Here are different clients (calls to onKeyEvent) that use different bindings of different types
in their environment

```sml
val timesPressed = ref 0
val _ = onKeyEvent (fn _ => timesPressed := (!timesPressed) + 1)

fun printIfPressed i =
    onKeyEvent (fn j => if i=j
                        then print ("you pressed " ^ Int.toString i ^ "\n")
                        else ())

val _ = printIfPressed 4
val _ = printIfPressed 11
val _ = printIfPressed 23

- onEvent 11; (* val it = (): unit *)
- !timesPressed (* 1: int *)
```


### Standard Library

Every language has a stdlib for operations users can implement i.e opening a file & for
operations that are more common when using the Data Structures in the language i.e list List.Map

https://smlfamily.github.io/Basis/manpages.html

We have structures like STRING, Char, List & ListPair. Standard bindings are listed as StructureName.functionName i.e List.map, String.isSubstring


### Abstract Data Types (Another Closure Idiom)

The key to an abstract data type (ADT) is requiring clients to use it via a collection of functions rather
than directly accessing its private implementation. Thanks to this abstraction, we can later change how the
data type is implemented without changing how it behaves for clients.

In an object-oriented language we might implement an ADT by defining a class with all private fields (inaccessible to clients) and some public methods (the interface with clients). We can do the same thing in ML with a record of closures; the variables that the closures use from the environment correspond to the private fields.

As an example, consider an implementation of a set of integers that supports creating a new bigger set and
seeing if an integer is in a set. Our sets are mutation-free in the sense that adding an integer to a set produces
a new, different set. (We could just as easily define a mutable version using ML’s references.) In ML, we
could define a type that describes our interface:

```sml
datatype set = S of { 
                insert : int -> set,
                member : int -> bool,
                size : unit -> int 
            }
```

Let us start with an `empty_set` & before implementing this interface, let’s see how a client might use it

```sml
fun use_sets () =
    let val S s1 = empty_set
        val S s2 = (#insert s1) 34 (* In other langs: s1.insert(34) *)
        val S s3 = (#insert s2) 34
        val S s4 = #insert s3 19
    in
        if (#member s4) 42
        then 99
        else if (#member s4) 19
        then 17 + (#size s3) ()
        else 0
    end
```


There are many ways we could define `empty_set`; they will all use the technique of using a closure to
"remember" what elements a set has. Here is one way:

```sml
val empty_set =
    let
        fun make_set xs = (* xs is a "private field" in result *)
        let (* contains a "private method" in result *)
            fun contains i = List.exists (fn j => i=j) xs
        in
            S {
                insert = fn i => if contains i
                                 then make_set xs
                                 else make_set (i::xs),
                member = contains,
                size = fn () => length xs
            }
        end
    in
        make_set []
    end
```

All the fanciness is in `make_set`, and `empty_set` is just the record returned by make_set []. What make_set
returns is a value of type set. It is essentially a record with three closures. The closures can use xs, the
helper function `contains`, and `make_set`. Like all function bodies, they are not executed until they are
called.

### Closure in Other Languages

To conclude our study of function closures, we digress from ML to show similar programming patterns in
Java (using generics and interfaces) and C (using function pointers taking explicit environment arguments).

For both Java and C, we will "port" this ML code which defines our own polymorphic linked-list type
constructor and three polymorphic functions (two higher-order) over that type. We will investigate a couple
ways we could write similar code in Java or C, which will can help us better understand similarities between
closures and objects (for Java) and how environments can be made explicit (for C).

```sml
datatype ’a mylist = Cons of ’a * (’a mylist) | Empty

fun map f xs =
    case xs of
        Empty => Empty
        | Cons(x,xs) => Cons(f x, map f xs)

fun filter f xs =
    case xs of
        Empty => Empty
        | Cons(x,xs) => if f x 
                        then Cons(x,filter f xs)
                        else filter f xs

fun length xs =
    case xs of
        Empty => 0
        | Cons(_,xs) => 1 + length xs
```

Using this library, here are two client functions. (The latter is not particularly efficient, but shows a simple
use of length and filter.)

```sml
(* Double all numbers in a list *)
val doubleAll = map (fn x => x * 2)

(* Count Ns in a list *)
fun countNs (xs, n : int) = length (filter (fn x => x=n) xs)
```


### In Java

Java8 has closure constructs like map & filter but lets ignore that for now, In java while we do not have first-class functions, currying, or type inference, we do have **generics** (Java did not used to) and we can define interfaces with one method, which we can use like function types.

```java
interface Func<B,A> {
    B m(A x);
}

interface Pred<A> {
    boolean m(A x);
}
```

We are gonna have `null` as our empty list and implement Map and Filter as Static Methods, The Map method
takes in type A and B and returns B, it taken in a Function that acts on A and returns B and applies it over a List of type A, Similarly filter is the same recursive operation like how it is in ML, length is a while loop with Mutability 😱

```java
class List<T> {
    T head;
    List<T> tail;
    List(T x, List<T> xs) {
        head = x;
        tail = xs;
    }
    static <A,B> List<B> map(Func<B,A> f, List<A> xs) {
        if(xs==null)
            return null;
        return new List<B>(f.m(xs.head), map(f,xs.tail));
    }
    static <A> List<A> filter(Pred<A> f, List<A> xs) {
        if(xs==null)
            return null;
        if(f.m(xs.head))
            return new List<A>(xs.head, filter(f,xs.tail));
        return filter(f,xs.tail);
    }
    static <A> int length(List<A> xs) {
        int ans = 0;
        while(xs != null) {
            ++ans;
            xs = xs.tail;
        }
        return ans;
    }
}
```

Here is how clients might use this

```java
class ExampleClients {
    static List<Integer> doubleAll(List<Integer> xs) {
        return List.map((new Func<Integer,Integer>() {
            public Integer m(Integer x) { return x * 2; }
            }),
            xs);
    }

    static int countNs(List<Integer> xs, final int n) {
        return List.length(List.filter((new Pred<Integer>() {
            public boolean m(Integer x) { return x==n; }
            }),
            xs));
        }
}
```

This works but we need to add extra cases in all clients for `null` as we cannot call a method on `null`, The old `NullPointerException` comes up, An more OO approach would be to use a subclass of List for empty lists rather than null
