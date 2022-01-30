## Standard ML Part 4

Type Inference, Module System, Mutual Recursion & Equivalence

- Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit4notes.pdf

### Type Inference

- Static (type checking can reject program before it runs) & Dynamic Typing (done at runtime) have their own pros and cons
- Even tho ML is static typed, its implicit typing so we rarely need to write down types & bad type code won't compile

Type Inference problem: Give every binding/expression a type such that type-checking succeeds and fail if no solution exists, This is often implemented with the type system of the language and the complexity of type inference entirely depends on the said type system.

How does SML do it ?

```sml
val x = 4 (* val x : int *)

fun f (y, z, w) =
    if y (* y must be a bool *)
    then z + x (* z must be an int *)
    else 0 (* both branches have same type *)
(*
 - f must return an int
 - f must take a bool,int,anything
 so val f : bool * int * 'a -> int
*)
```

- Determine types in Order (Except for mutual recursion)
- For each val or fun binding
    - Analyse the definition for all facts (constraints) if see x > 0 then x must be an int
    - Type Error if no way for all facts to hold (over-constrained)
- Use type var (eg: 'a) for unconstrained types, An unused argument can have any type

```sml
(*
    sum : T1 -> T2
    xs : T1

    x : T3
    xs' : T3 list [pattern match a T1]

    T1 = T3 list [ since we pass xs' to sum recursively ]
    T2 = int [ 0 might be returned ]
    T3 = int [ cause x:T3 and we add x to something ]

    From T1 = T3 list and T3 = int, we know that T1 = int list
    From T2 = int, we know f : int list -> int
*)

fun sum xs = 
    case xs of
        [] => 0
    |   x::xs' => x + sum xs'
```

Another feature of ML is that it can infer types with type variables/ **Polymorphic types**

The process here is very similar except that fact that we have too few constraints to narrow the type to one

```sml
(*
    length : T1 -> T2
    xs: T1

    x: T3
    xs': T3 list

    T1 = T3 list
    T2 = int

    Based on these constraints we end up with
    T3 list -> int
    The list does not need to have a particular type
    'a list -> int
*)
fun length xs =
    case xs of
        [] => 0
    |   x:xs' => 1 + (length xs')
```

**Let us look at compose**

```sml
(*
    compose: T1 * T2 -> T3
    f: T1
    g: T2

    Looking at the body of the function
    x: T4
    and result would be T4 -> T5

    from g being passed to x, T2 = T4 -> T6 for some T6
    from f being passed to result of g, T1 = T6 -> T7 for some T7
    since call to f is the result of fun we can say that T7 = T5 

    put it all: T1=T6->T5, T2=T4->T6, T3=T4*T5
    (T6->T5)*(T4->T6) -> (T4->T5)
    
    ('a -> 'b) * ('c -> 'a) -> 'c -> 'b
*)

fun compose (f,g) = fn x => f (g x)
```

ML type inference is way too lenient that we have value restriction limits where polymorphic types occur, i.e things like allowing putting a value of type t1 (eg:int) where we expect a value of type t2 (eg:string)

A combination of **Polymorphism + Mutation** is the problemo

```sml
val r = ref NONE (* val r = 'a option ref *)

val _ = r := SOME "hi" (* infix has type 'a ref * 'a -> unit *)

val i + valof (Ir) (* deref has type 'a ref * 'a so we can instantiate with int *)
```

To restore soundness it seems like we need to have stricter type for references but we **cannot have these special rules for reference types** cause the type checker cannot know the definition of all type synonyms 

Solution: A variable binding can have a polymorphic type only if the expression is a variable or a value, function calls like `ref NONE` are neither so ML hits you with a warning

```sml
- val r = ref NONE;
stdIn:3.5-3.17 Warning: type vars not generalized because of
   value restriction are instantiated to dummy types (X1,X2,...)
val r = ref NONE : ?.X1 option ref
```

Here are some examples of value restrictions

```sml
(* This fails with value restrictions*)
val pairWithone = List.map (fn x => (x, 1))

(* workaround by function wrapping *)
fun pairWithone xs = List.map (fn x => (x,1)) xs
```

Despite value restrictions ML types inference is quite elegant and fairly easy to understand, We have a beautiful statically typed language where we don't need to specify the types at all.

### Mutual Recursion

Two functions are called mutually recursive if the first function makes a recursive call to the second function and the second function, in turn, calls the first one. Allow f to call g and g to call f.

It is a useful idiom to implement state machines

```sml
(* and Keyword *)

fun f1 p1 = e1
and f2 p2 = e2
and f3 p3 = e3
```

We can have similar mutually recursive datatype bindings

```sml
datatype t1 = ...
and t2 = ...
and t3 = ...
```

**State machine** Each "state of a computation" is a function and "state transition" is "call another function" with "rest of input" and this generalizes to any finite state machine example

```sml
(*
    Deciding if a list of ints alternate 
    between 1 and 2 & not ending with 1
*)
fun match xs = (* [1,2,1,2] *)
    let fun s_need_one xs =
        case xs of
        [] => true
        | 1::xs’ => s_need_two xs’
        | _ => false
    and s_need_two xs =
        case xs of
        [] => false
        | 2::xs’ => s_need_one xs’
        | _ => false
    in
        s_need_one xs
    end
```

Here is a second example that also uses two mutually recursive datatype bindings. The definition of
types t1 and t2 refer to each other which is allowed by using and in place of datatype for the second one.
This defines two new datatypes t1 and t2.

```sml
datatype t1 = Foo of int | Bar of t2
and t2 = Baz of string | Quux of t1

fun no_zeros_or_empty_strings_t1 x =
    case x of
    Foo i => i <> 0
    | Bar y => no_zeros_or_empty_strings_t2 y
and no_zeros_or_empty_strings_t2 x =
    case x of
    Baz s => size s > 0
    | Quux y => no_zeros_or_empty_strings_t1 y
```

Now suppose we wanted to implement the “no zeros or empty strings” functionality of the code above but
for some reason we did not want to place the functions next to each other or we were in a language with no
support for mutually recursive functions.

**We can write almost the same code by having the “later” function pass itself to a version of the “earlier” function that takes a function as an argument**

```sml
fun no_zeros_or_empty_strings_t1(f,x) =
    case x of
    Foo i => i <> 0
    | Bar y => f y

(* Because all function calls are tail calls,
the code runs in a small amount of space,
just as one would expect for an implementation
of a finite state machine *)

fun no_zeros_or_empty_string_t2 x =
    case x of
    Baz s => size s > 0
    | Quux y => no_zeros_or_empty_strings_t1(no_zeros_or_empty_string_t2,y)
```
This is yet-another powerful idiom allowed by functions taking functions.


### Module system

When we have a large program using just one top level sequence of bindings is poor style especially cause a binding can use all earlier (non shadowed) bindings, so ML let's you define modules.
For eg: `List.map` has `map` as a function in the `List` module.

```sml
structure MyMathLib =
struct

fun fact x =
    if x=0
    then 1
    else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y
end

val pi = MyMathLib.half_pi + MyMathLib.half_pi
val twenty_eight = MyMathLib.doubler 14
```

### Signatures and Hiding things

A signature is a type for a module, what bindings it has & what are its types. They let us
provide strict interfaces that code outside the module must obey

```sml
signature MATHLIB =
sig
val fact : int -> int
val half_pi : real
val doubler : int -> int
end

structure MyMathLib :> MATHLIB =
struct
fun fact x =
    if x=0
    then 1
    else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y
end
```

Because of the `:> MATHLIB` the structure MyMathLib will type-check only if it actually provides everything the
signature MATHLIB claims it does and with the right types. Signatures can also contain datatype, exception, and type bindings.

Signatures help a lot in hiding implementations and ofc separating the interface from the implementation is probably the most important strategy for building correct, robust & reusable programs

If a function is not part of a signature then it cannot be called outside the Module i.e it becomes unbounded, This is kinda synonymous to having private functions

```sml
signature MATHLIB =
sig
val fact : int -> int
val half_pi : real
end
```

For this signature, the client code cannot call `MyMathLib.doubler`. The binding simply is not in scope, so no use of it will type-check. In general, the idea is that we can implement the module however we like and only bindings
that are explicitly listed in the signature can be called directly by clients.
