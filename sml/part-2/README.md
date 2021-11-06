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

At an implementation level Tuples are actually kind of Records with a index (1,2..n) as field names. **Tuples are syntactic sugar for Records**

```sml
- val x = {2=2, 1=3};
val it = (3,2) : int * int

- val x = (3,2);
val x = (3, 2) : int * int
```
