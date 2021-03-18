## Standard ML of New Jersey	

Was able to install it with `sudo apt-get install smlnj`

Run with `use "sml/part-1/shadowing.sml";;`

Unit 1 Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit1notes.pdf

Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

### Variable Bindings

An ML program is a sequence of bindings. Each binding gets type-checked and then (assuming it type-checks)
evaluated. What type a binding has depends on a static environment, which is roughly the types
of the preceding bindings in the file. How a binding is evaluated depends on a dynamic environment, which
is roughly the values of the preceding bindings in the file. When we just say environment, we usually mean
dynamic environment. Sometimes context is used as a synonym for static environment.
There are several kinds of bindings, but for now let’s consider only a variable binding, which in ML has this
syntax

```sml
val x = e; 
```

Here, **val is a keyword, x can be any variable, and e can be any expression.** We will learn many ways to
write expressions. The semicolon is optional in a file, but necessary in the read-eval-print loop to let the
interpreter know that you are done typing the binding.

Whenever you learn a new construct in a programming language, you should ask these three questions

1) **What is the syntax?**
2) **What are the type-checking rules?**
3) **What are the evaluation rules?**

An integer like `5` or bool like `True` is type checked to its type and evaluates to itself.

Lets look at Conditional binding 
```sml 
(* Syntax *)
if e1 then e2 else e3;
```
- **Type-checking: using the current static environment**, a conditional type-checks only if 
    (a) e1 has type bool 
    (b) e2 and e3 have the same type. 
    The type of the whole expression is the type of e2 and e3.
- **Evaluation: under the current dynamic environment**, evaluate e1. If the result is true, the result
of evaluating e2 under the current dynamic environment is the overall result. If the result is
false, the result of evaluating e3 under the current dynamic environment is the overall result


### Shadowing

https://en.wikipedia.org/wiki/Variable_shadowing

**Bindings are immutable.**

Given `val x = 8+9;` we produce a dynamic environment where x maps to 17. In
this environment, x will always map to 17; there is no **assignment statement** in ML for changing what
x maps to. That is very useful if you are using x.

You can have another binding later, say `val x = 19;` but that just creates a different environment where the later binding for x shadows the earlier one. This distinction will be extremely important when we define functions that use variables

```sml
val a = 10
val b = 2
val b = a * 2
val a = 5;= = =

val a = <hidden-value> : int
val b = <hidden-value> : int
val b = 20 : int
val a = 5 : int
```

Shadowed variables are just shown as `hidden-value` cause they have a newer reference and the old ref don't matter anymore, even tho they exist we cannot use them anymore

```python
# Issues with Shadowing 
value = 'henlo' # global
def print_value(name):
    print(value) # local
print_value('jar jar')

# instead of raising an exception Python uses the global mapping for name
# because it can’t find one locally, and therefore we might be unaware of our mistake.
# It is for this reason that people suggest avoiding shadowing.
```

No to multiple `use` statements in SML because of shadowing remnants of bindings may linger and cause issues

### Function Bindings 

- Syntax for now is just `fun x0 (x1 : t1, ..., xn : tn) = e`
- Evaluation: a function is just a value. It can be called later.
- Type-checking: x0 gets the type t1 * ... * tn -> t. Type-checker checks the expression e, taking into account x1, ... xn and any environment variables, and then produces (by itself!) a type t. This is done with **Type Checking**.

### Tuples / Pairs

- Tuples have a fixed number of pieces that may have different types.
- Syntax: (e1,e2).
- Evaluation: Evaluate both e1 and e2, the result is (v1,v2).
- Type checking: the product type.

Accessing a pair: #1 pr or #2 pr.

```sml
fun sort_pair(pr : int * int) =
    if (#1 pr) < (#2 pr)
    then pr
    else (#2 pr, #1 pr);
```

### Lists 

- Lists can be arbitrary size but of elements of the same type.
- We can add one value to the beginning of a list using cons i.e the notation `::`

```sml
- val x = [1,2,4];
val x = [1,2,4] : int list
- val y = 5::x;
val y = [5,1,2,4] : int list
- 6::7::8::y;
val it = [6,7,8,5,1,2,4] : int list
- [10] :: [[1,2],[3]];
val it = [[10],[1,2],[3]] : int list list 
```

- `null x` returns `True` is `val x = []`
- `hd [1,2]` returns the head/ first element `1`
- ` tl [1,2,3,4]` returns `[2,3,4]` here the tail of a list is a list containing all the elements of the original list except the list's first element or head so `tl [9]` returns `[]`

```sml
(* Access 3rd element in the list *)
val x = [5,4,6,2]
val third= hd (tl (tl x));
```

Every list has the `Type` followed by `List` so it can be an `int List` for list of integers and `(int * int) list` for a list of integer tuples but when we print an empty list we get 

```
- [];
val it = [] : 'a list
```

THis `'a list` can be pronounced alpha list and can type check to anything, so we can use `cons` to add a bool, an integer, another list, a tuple and so on
```sml
- [1,2]::[];
val it = [[1,2]] : int list list

```

The functions `hd` `tl` and `null` are typechecked with this alpha list as well

```sml 
null: 'a list -> bool
hd: 'a list -> 'a
tl: 'a list -> a list
```

### List functions

List Functions are always **Recursive** cause that is how we iterate through our list

`list_stuff.sml` has some example functions to understand this better


### Let Expressions

- Local variables valid only in a function

- Syntax: `let b1 b2 ... bn in e end.` Each `bi` is any binding, `e` is any expression.
- Evaluation: evaluate each `bi` and use it to evaluate `e`.
- Type-checking: check types of each `bi` and then check type of `e` in the local environment given by bindings `bi`.

```sml
fun hello_let (x : int) =
    let
	val a = if x > 0 then x else ~10
	val b = a + x
    in
	if a > b then a else b
    end;
```

- `let` introduced the concept of scope for us

**They also allow Nested functions**

It can be used to define a function that you can then only use in the scope defined by the let expression.

```sml
fun countup_from1(x : int) =
    let fun count (from : int) =
	    if from = x
	    then x :: []
	    else from :: count(from +1);
    in
	count(1)
    end;
```
Here count is a private helper function that can use parameters of the main function to make things nicer

