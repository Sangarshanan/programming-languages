## Standard ML Part 1

Was able to install it with `sudo apt-get install smlnj`

REPL with `rlwrap sml`

Run inside REPL `use "sml/part-1/list_stuff.sml";`

Unit 1 Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit1notes.pdf

Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

https://www.yld.io/blog/the-not-so-scary-guide-to-functional-programming/

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

https://en.wikipedia.org/wiki/Variable_shadowing variable shadowing occurs when a variable declared within a certain scope (decision block, method, or inner class) has the same name as a variable declared in an outer scope

**Bindings are immutable.**

Given `val x = 8+9;` we produce a dynamic environment where x maps to 17. In
this environment, x will always map to 17; there is no **assignment statement** in ML for changing what
x maps to. That is very useful if you are using x.

You can have another binding later, say `val x = 19;` but that just creates a different environment where the later binding for x shadows the earlier one. This distinction will be extremely important when we define functions that use variables

```sml
val a = 10;
(* a -> 10 *)

val b = a *2;
(* a -> 10; b -> 20 *)

val a = 5;
(* a -> 5; b -> 20 *)
val c = b;
(* a -> 5; b -> 20; c -> 20 *)
```

Here `val a = 5` is not a mutable assignment expression but rather an immutable value binding, Redefining a does not replace the existing a but there is a new environment where a is shadowed and given a new value, The variables and functions binding to the old a in the old environment still are tied there

https://stackoverflow.com/questions/54777237/sml-behind-the-scenes-of-immutable-variables


```sml
val a = 5
fun f x = x + a
val a = 10
val b = f 1  (* Returns 6 and not 11 *)
```

This is a lil confusing so it is not recommended to use shadowing in programs, Even tho in SML its actually much easier to reason about this than in languages like Python

```python
a = 5
f = lambda x : x + a
a = 10
f(1) # Returns 11
```


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

#### THERE ARE NO ASSIGNMENTS IN SML

so you literally cannot do something like 

```sml 
val a = 10
a = a + 1
```

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

This technique — **define a local function that uses other variables in scope — is a hugely common and convenient thing to do in functional programming. It is a shame that many non-functional languages have little or no support for doing something like it.**

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

Let allows you to cache variables to avoid making recursive calls repeatedly

```sml
fun good_max (xs : int list) =
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else
        let val tl_ans = good_max(tl xs)
        in
            if hd xs > tl_ans
            then hd xs
            else tl_ans
        end
```

### Options

Options allow you to not return a value and its usage is a bit analogous to a list.

- **Building**: An option can be defined by `NONE` (empty list) or `SOME <expression>` (one element list)
- **Accessing:** `isSome` returns a bool based on NONE. `valOf` returns the evaluates expression of `SOME`

```sml 
fun better_max (xs : int list) =
    if null xs
    then NONE
    else
        let val tl_ans = better_max(tl xs)
        in if isSome tl_ans andalso valOf tl_ans > hd xs
            then tl_ans
            else SOME (hd xs)
    end
```


### Boolean Expressions

- And `e1 andalso e2` Or `e1 orelse e2` Not `not e1`
- Comparison: `=, <>` for not equal, and `>, <, >=, <=`


### Benefits of no mutation

With No mutations we avoid a lot of issues like shared references (one object that two or more items referencing to it) and aliasing (one variable's value is assigned to another variable) Eg:`x=5; y=x` https://stackoverflow.com/questions/32915792/are-alias-and-reference-the-same-thing-in-c
 We cannot never inadvertently alter data we didn't indent to. Even tho ML has aliases its **under the hood** and we never have to worry about them and let compiler do it.

No need to use `df.copy()` before every function to make sure you don't accidentally pollute your original df

```sml
fun sort_pair (pr : int*int) =
    if (#1 pr) < (#2 pr)
    then pr
    else ((#2 pr),(#1 pr))
```
In `sort_pair`, we clearly build and return a new pair in the else-branch, but in the then-branch, do we
return a copy of the pair referred to by pr or do we return an alias, where a caller like:

```sml
val x = (3,4)
val y = sort_pair x
```

Would now have x and y be aliases for the same pair? The answer is you cannot tell — there is no construct in ML that can figure out whether or not x and y are aliases, and no reason to worry that they might be.

If we had mutation, life would be different. Suppose we could say, “change the second part of the pair x is bound to so that it holds 5 instead of 4.” Then we would have to wonder if #2 y would be 4 or 5.

In case you are curious, we would expect that the **code above would create aliasing**: by returning pr, the sort_pair function would return an alias to its argument. That is more efficient than this version, which would create another pair with exactly the same contents

## Java Mutations

Suppose we are maintaining permissions for who is allowed to access something like a file on the disk. It is fine to let everyone see who has permission `public` but clearly only those that do have permission can actually use the resource which is `private`

```java
class ProtectedResource {
    private Resource theResource = ...;

    private String[] allowedUsers = ...;

    public String[] getAllowedUsers() {
        return allowedUsers;
    }

    public String currentUser() { ... }

    public void useTheResource() {
        for(int i=0; i < allowedUsers.length; i++) {
            if(currentUser().equals(allowedUsers[i])) {
                ... // access allowed: use it
                return;
                }
        }
    throw new IllegalAccessException();
    }
}
```
Here `getAllowedUsers` returns an alias to the `allowedUsers` array, so any user can gain access by doing `getAllowedUsers()[0] = currentUser()`. Hackerman !  This would not be possible if we had some sort of array in Java that did not allow its contents to be updated. Instead, in Java we often have to remember to make a copy.

```java
public String[] getAllowedUsers() {
    String[] copy = new String[allowedUsers.length];
    for(int i=0; i < allowedUsers.length; i++)
        copy[i] = allowedUsers[i];
    return copy;
}
```

## Lessons

This will be a little subjective

- I realized I haven't been using recursion as effectively as I could have, its quite powerful. I am still not able to effectively actualize problems with recursion and I am hoping that gets better with practice
- How much Immutability in a language can offer interms of guarantees and understandability. your code naturally becomes  more predictable this way and compiler is a better friend
- I am starting to hate the default sml repl
