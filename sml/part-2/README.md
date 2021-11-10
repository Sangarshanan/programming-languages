## Standard ML Part 2

- Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit2notes.pdf
- Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw2.pdf

This week on DragonBallZ We will be defining our own **compound types** which are powerful combinations of the pairs, lists and options already provided by ML. We will also use **pattern matching** to access the pieces of values built out of compound types.

We will introduce the idea of **syntactic sugar** and see that ML is using pattern matching in every function binding and let expression even when it does not seem like it. We will briefly look at ML's exceptions,which also use pattern matching.

Finally, we will study **tail recursion** which is the primary concept one needs to reason about the efficiency of ML programs, and in general any functional programs using recursion.


### Compound Types

In any programming language we can build 3 types of complex datatypes

- `Each of` A value t contains each of t1,t2,...tn eg: Tuple(Int*bool) contain and Int and Bool
- `One of` A value t contains one of t1,t2,...tn eg: Int Option contains int or is Null
- `Self Reference` A t can reference other t values. Can be useful for recursive types like trees eg: Tree is made of Node() which is in itself a compound type 

### Records

They are a new type of Each of types where instead of numbers to references indexes like in tuples we use field names, The expressions defined are evaluated as in tuple and also alphabetical to be canonical

```sml
(* Defining a Record *)
val x ={foo=1+2, bar=(true,9)};

(* Accessing a field in a Record *)
#foo x;
```

At an implementation level Tuples are actually kind of Records with a index (1,2..n) as field names.

```sml
- val x = {2=2, 1=3};
(* val it = (3,2) : int * int *)

- val x = (3,2);
(* val x = (3, 2) : int * int *)
```

Tuples are just **Syntactic Sugar** for Records

### Datatype Bindings

A Strange yet awesome way for us to create `OneOf` types in SML

```sml
datatype mytype = TwoInts of int*int
                | Str of string
                | Pizza
```
- Adds a new type `mytype` to the environment
- Adds **constructors** to the environment. TwoInts, Str & Pizza

Constructor is a function (amongst other things) that makes values of the new type

- TwoInts : int*int -> mytype
- Str : string -> mytype
- Pizza : mytype

```sml
- val a = Str "hi";
(* val a = Str "hi" : mytype *)

- val b = Pizza;
(* val b = Pizza : mytype *)

- val c = TwoInts (1+2, 3+4);
(* val c = TwoInts (3,7) : mytype *)
```

Now we know how to build datatype values but we still need to know how to access them. We would want to extract what constructor made the type & also extract the data.

### Case Expressions

```sml
fun f (x: mytype) =
    case x of
        Pizza => 3
      | Str s => String.size s
      | TwoInts(i1,i2) => i1 + i2
```

we can now pass the constructors to the function to Get values of mytype depending on the case

```sml
- f Pizza;
(* val it = 3 : int *)

- f (Str "hello");
(* val it = 5 : int *)

- f (TwoInts(1,2));
(* val it = 3 : int *)
```

Case-expression we have Each branch has the form `p => e` where p is a pattern and e is an expression, and we separate the branches with the `|` character. This is like a more powerful if-then-else expression that returns the first branch it matches.

We can also define types that would be synonymous to Enums

```sml
datatype suit = Club | Diamond | Heart | Spade
datatype rank = Jack | Queen | King | Ace | Num of int
```

### Expression Trees

This is a datatype for arithmetic expressions containing constants, negations, additions and multiplications.

```sml
datatype exp = Constant of int
               | Negate of exp
               | Add of exp * exp
               | Multiply of exp * exp
```

Thanks to the self-reference, what this data definition really describes is trees where the leaves are integers
and the internal nodes are either negations with one child, additions with two children or multiplications
with two children. We can write a function that takes an exp and evaluates it

```sml
Add (Constant (10 + 9), Negate (Constant 4))
```
Picturing the resultant type
```
Add |---> Constant ---> 19
    |---> Negate ---> Constant ---> 4 
```

Now we can define a function using Case to evaluate our datatype based on the expression and the constructor name given to the operator. With recursive function calls :)

```sml
fun eval e =
    case e of
    Constant i => i
        | Negate e2 => ~ (eval e2)
        | Add(e1,e2) => (eval e1) + (eval e2)
        | Multiply(e1,e2) => (eval e1) * (eval e2)
```

Suppose we have a complex Expression and we want to find the number of Add operations happening inside it, We can do something like this

```sml
fun number_of_adds e =
    case e of
    Constant i => 0
        | Negate e2 => number_of_adds e2
        | Add(e1,e2) => 1 + number_of_adds e1 + number_of_adds e2
        | Multiply(e1,e2) => number_of_adds e1 + number_of_adds e2
```

### Type Synonyms

As a synonym should be this just creates another name for a type that already exists

```sml
type aname = t
(* or a real example *)
type date = int * int * int
```
Here the type `t` and name `aname` are interchangeable in every way

### Lists and Options are Datatypes

Because datatype definitions can be recursive we can use them to create our own types for lists. For example,
this binding works well for a **Linked List Of Integers**

```sml
datatype my_int_list = Empty
                        | Cons of int * my_int_list

val one_two_three = Cons(1,Cons(2,Cons(3,Empty)))

fun append_mylist (xs,ys) =
    case xs of
        Empty => ys
        | Cons(x,xs’) => Cons(x, append_mylist(xs’,ys))
```

Also as it turns out the "built in" lists and options are just datatypes. As a matter of style, it is better to use the built-in widely-known feature than to reinvent the wheel.

It is better style to use **pattern-matching for accessing list and option values** not the
functions `null`, `hd`, `tl`, `isSome`, and `valOf` we saw previously

```sml
fun append (xs,ys) =
    case xs of
        [] => ys
      | x::xs => x :: append(xs,ys)

append([1], [2]);
(*  val it = [1,2] : int list *)
```

### Polymorphic Datatypes

We can define datatypes that can be made up of values of any type, as we have seen with `int list`, `int list list`, `(bool * int) list` etc. This can be very useful for building "generic" data structures

This is how Options are defined in SML

```sml
datatype 'a option = NONE | SOME of 'a

- NONE;
(* val it = NONE : 'a option *)
- SOME 10;
(* val it = SOME 10 : int option *)

```

Such a binding does not introduce a type option. Rather, it makes it so that if t is a type, then t option
is type.


### Pattern-Matching Each-Of Types

So far we have used pattern-matching for one-of types but we can use it for each-of types also

- Tuples can be matched with pattern (x1, ... ,xn)
- Records can be matched with the pattern {f1=x1, ... ,fn=xn}

```sml
fun sum_triple (triple : int * int * int) =
    case triple of
        (x,y,z) => z + y + x

- sum_triple(1,2,3);
(* val it = 6 : int *)

fun full_name (r : {first:string,middle:string,last:string}) =
    case r of
        {first=x,middle=y,last=z} => x ^ " " ^ y ^ " " ^z

- full_name {first="albert", last="camus", middle="french"};
(* val it = "albert french camus" : string *)
```

**A case-expression with one branch is poor style** We will improve our functions using let expressions and the simple fact that you can use patterns in val-bindings too!


```sml
fun full_name r =
    let val {first=x,middle=y,last=z} = r
    in
        x ^ " " ^ y ^ " " ^z
    end

fun sum_triple triple =
    let val (x,y,z) = triple
    in
        x + y + z
    end
```

Actually we can do even better: Just like a pattern can be used in a val-binding to bind variables (e.g., x, y,
and z) to the various pieces of the expression (e.g., triple), we can use a pattern when defining a function
binding and the pattern will be used to introduce bindings by matching against the value passed when the
function is called

```sml
fun full_name {first=x,middle=y,last=z} =
    x ^ " " ^ y ^ " " ^z

fun sum_triple (x,y,z) =
    x + y + z
```

Here `sum_triple` looks like it takes 3 arguments but rather it just One triple tuple argument how does SML know the difference between both these cases.

**Every function in ML takes exactly one argument!** Every time we write a multi-argument function,
we are really writing a one-argument function that takes a tuple as an argument and uses pattern-matching
to extract the pieces. Tis ML not Java

There are no Zero arg functions either. The binding fun f () = e is using the `unit-pattern ()` to match against calls that pass the unit value () which is the only value of type unit. The type unit is just a datatype with only one constructor which takes no arguments and uses the unusual syntax `()`. Basically, `datatype unit = ()` comes pre-defined.

