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

### We get Type Inference !

By using patterns to access values of tuples and records rather than `#foo` it's no longer
necessary to write types on your function arguments. In fact it is conventional in ML to leave them off
as you can always use the REPL to find out a function's type.

Suppose we write a partial_sum function

```sml
fun partial_sum (x,y,z) =
    x + z
```

We are not using y here but we still expect he Return type for this function to be `int * int * int -> int`
but if we run this we actually get `int * 'a * int` which means `y` can be of any type.

Which means `partial_sum (3,4,5)` is just as valid as `partial_sum (3,false,5)` making this a **Polymorphic Function**


### Nested Patterns

Patterns are recursive: anywhere we have been putting a variable in our patterns we can instead put another pattern
For example, the pattern `a::(b::(c::d))` would match any list with at least 3 elements and it would bind a to the first element, b to the second, c to the third, and d to the list holding all the other elements (if any). The pattern `a::(b::(c::[]))` on the other hand, would match only lists with exactly three elements.

Zipping a list where `([1,2], [3,4], [5,6])` Returns `([1,3,5], [2,4,6])`

```sml
exception LengthMismatch

fun bad_zip (l1, l2, l3) = 
    if null l1 andalso null l2 andalso null l3
    then []
    else if null l1 orelse null l2 orelse null l3
    then raise LengthMismatch
    else (hd l1, hd l2, hd l3) :: bad_zip(tl l1, tl l2, tl l3)
```

In the above case we can easily miss cases and are getting no help from the type checker. This can be done in a more clean & efficient way using nested pattern matching. 


```sml
exception BadTriple

fun zip list_triple =
    case list_triple of
        ([],[],[]) => []
        | (hd1::tl1,hd2::tl2,hd3::tl3) => (hd1,hd2,hd3)::zip3(tl1,tl2,tl3)
        | _ => raise BadTriple
```

Here `_` is a wildcard matches everything without introducing a binding

Unzip is the opposite of Zip and can also be solved with nested patterns

```sml
fun unzip lst =
    case lst of
        [] => ([],[],[])
        | (a,b,c)::tl => let val (l1,l2,l3) = unzip3 tl
                         in
                            (a::l1,b::l2,c::l3)
                         end
```

This is a function that gives you the sign of the result after multiplying two numbers

```sml
(* Positive, Negative, Zero *)
datatype sgn = P | N | Z

fun multsign (x1,x2) =
let fun sign x = if x=0 then Z else if x>0 then P else N
    in
        case (sign x1,sign x2) of
            (Z,_) => Z
            | (_,Z) => Z
            | (P,P) => P
            | (N,N) => P
            | _ => N (* many say bad style; I am okay with it *)
    end
```

When you include a “catch-all” case at the bottom like this, you are giving up any checking that you did not forget any cases: after all, it matches anything the earlier cases did not, so the type-checker will certainly not think you forgot any cases. So you need to be extra careful if using this sort of technique and it is probably less error-prone to enumerate the remaining cases `(in this case (N,P) and (P,N))`). That the type-checker will then still determine that no cases are missing is useful and non-trivial since it has to reason about the use (Z,_) and (_,Z) to figure out that there are no missing possibilities of type sgn * sgn.

- Avoid nested case expressions and replace them with nested patterns to avoid unnecessary branches
- Match against a tuple of datatypes to compare them
- Wildcards are a good idea ! when we don't need the data

We can also have nested function which we can use instead of case expressions

```sml
fun eval (Constant i) = i
    | eval (Negate e2) = ~ (eval e2)
    | eval (Add(e1,e2)) = (eval e1) + (eval e2)
    | eval (Multiply(e1,e2)) = (eval e1) * (eval e2)
```

### Exceptions

ML has a built-in notion of exceptions which you can define with `exception <name>` and raise (also known as throw)

```sml
exception UndesirableCondition

fun mydiv (x, y) =
    if y=0
    then raise UndesirableCondition
    else x div y
```

Exceptions are a lot like constructors of a datatype binding so have types and can be passed to functions

```sml
fun maxlist (xs,ex) =
    case xs of
        [] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x,maxlist(xs',ex))

(* val maxlist = fn : int list * exn -> int *)
(* Here the Function takes exn or Exception as an Argument *)

val x = maxlist([], UndesirableCondition)
        handle UndesirableCondition => 42
(* val x = 42 : int *)

val x = maxlist([1,2,3], UndesirableCondition)
        handle UndesirableCondition => 42
(* val x = 3 : int *)
```

We can also define `exception MyOtherException of int * int` and raise `raise MyOtherException(3,9)`


```sml
fun f n =
    if n=0
    then raise List.Empty
    else if n=1
    then raise (MyException 4)
    else n * n

val x = (f 1 handle List.Empty => 42) handle MyException n => f n
(* 16 *)
```

As with case-expressions, handle-expression can also have multiple branches each with a pattern and expression, syntactically separated by |

### Tail Recursion

Lets break down tail recursion using our Call stack and a simple factorial function

```sml
fun fact n = if n=0 then 1 else n*fact(n-1)
val x = fact 3
```

When this recursion runs our call stack is made up for 4 elements i.e recursive calls that pop out as they execute to return the end result

```math
fact 3: 3*_     fact 3: 3*_     fact 3: 3*_     fact 3: 3*2  
fact 2: 2*_     fact 2: 2*_     fact 2: 2*1
fact 1: 1*_     fact 1: 1*1
fact 0: 1*_
```

Now let's define a new version of factorial that is a bit more complicated and break it down

```sml
fun fact n =
    let fun aux(n,acc) = 
        if n=0 
        then acc 
        else aux(n-1,acc*n)
    in
        aux(n,1)
    end

val x = fact 3
```

We now have a helper functions `aux` that takes in an accumulator along with n to return itself when n = 0 else multiple the accumulator with n and decrement n recursively, This is exactly the same as factorial example above

One key difference is that now the **Return function does not do anything extra** cause in the first function we do `n * fact(n-1)` so the return function fact(n-1) needs to be multiplied with n but in our accumulator example the return function `aux(n-1, acc*n)` does not have any additional operation with it

Let's us take a look at the call stack here

```math
fact 3:_    fact 3:_
aux(3,1)    aux(3,1): _
            aux(2,3): 6
            aux(1,6): 6
            aux(0,6): 6
```

**It is unnecessary to keep around a stack frame just so it can return the callee's result without any evaluation**

ML recognizes these functions as **Tail calls** in the compiler and treats them differently: Pop the caller before the call allowing the callee to reuse the same stack space

```math
No stack space is alloted and recursive functions returned are just replaced

fact 3      aux(3,1)    aux(2,3)    aux(1,6)    aux(0,6)
```

POV: WHITE GIRL SUMMER  https://www.youtube.com/watch?v=-PX0BV9hGZY

Tail Recursive: Recursive calls are tail calls

There is a common methodology that can guide this transformation

- Create a helper function that takes an **accumulator**
- Old base case becomes initial accumulator
- New base case becomes final accumulator

In general converting a non-tail-recursive function to a tail-recursive function usually needs associativity, but many functions are associative.


```sml
fun sum1 xs =
    case xs of
    [] => 0
  | i::xs’ => i + sum1 xs’


fun sum2 xs =
    let fun f (xs,acc) =
        case xs of
            [] => acc
            | i::xs’ => f(xs’,i+acc)
    in
        f(xs,0)
    end
```

A more interesting example is this inefficient function for reversing a list:

```sml
fun rev1 lst =
    case lst of
        [] => []
      | x::xs => (rev1 xs) @ [x]
```

We can recognize immediately that it is not tail-recursive since after the recursive call it remains to append
the result onto the one-element list that holds the head of the list. Although this is the most natural way
to reverse a list recursively, the inefficiency is caused by more than **creating a call-stack of depth equal to the argument's length which we will call n**. The worse problem is that the total amount of work performed
is proportional to n^2 i.e this is a quadratic algorithm. The reason is that appending two lists takes time proportional to the length of the first list

```sml
fun rev2 lst =
    let fun aux(lst,acc) =
        case lst of
            [] => acc
            | x::xs => aux(xs, x::acc)
    in
        aux(lst,[])
    end
```

By using accumulators & tail recursion we do only a constant amount of work for each recursive
call because `::` does not have to traverse either of its arguments

