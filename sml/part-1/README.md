## Standard ML of New Jersey	

Was able to install it with `sudo apt-get install smlnj`


Unit 1 Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit1notes.pdf

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






