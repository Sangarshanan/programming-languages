## Racket Part 1

Part 1 Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit5notes.pdf

Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

Racket and ML share many similarities: They are both mostly functional languages (i.e., mutation exists but is discouraged) with closures, anonymous functions, convenient support for lists, no return statements, etc. Seeing these features in a second language should help re-enforce the underlying ideas. One moderate difference is that we will not use pattern matching in Racket.

- Racket does not use a static type system. So it accepts more programs and programmers do not need to define new types all the time, but most errors do not occur until run time.
- Racket has a very minimalist and uniform syntax.

Racket has many advanced language features including **macros**, a module system quite different from ML,
quoting/eval, first-class continuations, contracts, and much more


### Getting Started

The first line of a Racket file (which is also a Racket module) should be

```racket
#lang racket
```

A definition like
```racket
(define a 3)
a
# 3
(+ a 2 )
# 5
```
extends the top-level environment so that a is bound to 3. Racket has very lenient rules on what characters
can appear in a variable name, and a common convention is hyphens to separate words like `my-favorite-identifier`.

A subsequent definition like
```racket
(define b (+ a 2))
```
would bind b to 5. In general, if we have `(define x e)` where x is a variable and e is an expression, we
evaluate e to a value and change the environment so that x is bound to that value.

```racket
(+ 3 2 )
# 5
```

> **Function application requires prefix notation in Racket, so the + function needs to come first in the parentheses.**

racket heavily makes use of lambda functions

```racket
(define cube1
    (lambda (x) (* x (* x x)))
)

(cube3 3)
# 27
```
In Racket, different functions really take different numbers of arguments and it is a run-time error to call a
function with the wrong number. A three argument function would look like (lambda (x y z) e). However,
many functions can take any number of arguments. The multiplication function * is one of them so we
could have written

```racket
(define cube2
    (lambda (x)
    (* x x x)))
```

There is a very common form of syntactic sugar we should use for defining functions and it does not use the
word lambda explicitly

```racket
(define (cube3 x)
    (* x x x))
```

Also unlike ML you can use recursion with anonymous functions because the definition itself is in scope in the
function body

```racket
(define (pow x y)
    (if (= y 0)
        1
        (* x (pow x (- y 1)))))

(pow 3 2)
# 9
```

We can use currying in Racket cause Racket’s first-class functions are closures like in ML and currying
is just a programming idiom

```racket
(define pow-cur
    (lambda (x)
        (lambda (y)
         (pow x y))))

(define three-to-the (pow-cur 3))
(define eightyone (three-to-the 4))
# why parenthesis matters
(define sixteen ((pow 2 4))
(define sixteen ((pow-cur 2) 4)
```

Because Racket’s multi-argument functions really are multi-argument functions & not sugar for something
else, currying is not as common. There is no syntactic sugar for calling a curried function: we have to write
((pow 2) 4) because (pow 2 4) calls the one-argument function bound to pow with two arguments, which
is a run-time error.

**Lists in Racket**

Racket has built-in lists, much like ML, and Racket programs probably use lists even more often in practice
than ML programs

| Description                                   |  Primitive   |   Example              |
|-----------------------------------------------|--------------|------------------------|
| The empty list                                | null         | null                   |
| Construct a list                              | cons         | (cons 2 (cons 3 null)) |
| Get first element of a list                   | car          | (car some-list)        |
| Get tail of a list                            | cdr          | (cdr some-list)        |
| Return #t for the empty-list and #f otherwise |   null?      | (null? some-value)     |

There is also a built-in function list for building a list from any number of elements, so you can write
`(list 2 3 4)` instead of `(cons 2 (cons 3 (cons 4 null)))`. **Lists also need not hold elements of the same type** so you can create `(list #t "hi" 14)` without error.

```racket
# Sum of numbers in a list
(define (sum xs)
    (if (null? xs)
        0
        (+ (car xs) (sum (cdr xs)))))
```

Unlike ML there is no type checker for the function but it will throw an error if incompatible

```racket
> (sum (list 3 4 5))
12
> (sum (list 3 4 "hi"))
; +: contract violation
;   expected: number?
;   given: "hi"

```

Writing other common list functions

```racket
# append two lists
(define (my-append xs ys)
    (if (null? xs)
    ys
    (cons (car xs) (my-append (cdr xs) ys))))

(my-append (list 10 20) (list 30 40))
# '(10 20 30 40)

# map a function onto a list
(define (my-map f xs)
    (if (null? xs)
        null
        (cons (f (car xs)) (my-map f (cdr xs)))))

(my-map (lambda (x) (+ x 1)) (list 1 2))
# '(2 3)
```

### Syntax and Parentheses

Racket has an amazingly simple syntax and Everything in the language is either

- Some form of atom such as #t, #f, 34, "hi", null, etc. A particularly important form of atom is an
identifier, which can either be a variable (e.g: x or something-like-this!)
- A special form such as define, lambda, if, and so on. Macros will let us define our own special forms
- A sequence of things in parentheses (t1 t2 ... tn), if t1 is a special form then the semantics of sequence is special else its just a function call

The first thing in a sequence affects what the rest of the sequence means. For example, (define ...) means
we have a definition and the next thing can be a variable to be defined or a sequence for the sugared version
of function definitions.

If the first thing in a sequence is not a special form and the sequence is part of an expression, then we have
a function call. Many things in Racket are just functions, such as `+` and `>`.

By "parenthesizing everything" Racket has a syntax that is **unambiguous**. There are never any rules to learn
about whether `1+2*3 is 1+(2*3)` or `(1+2)*3` and whether `f x y` is `(f x) y` or `f (x y)`. 

It makes parsing, converting the program text into a tree representing the program structure, trivial. Notice that XML-based languages like HTML take the same approach. In HTML, an "open parenthesis" looks like `<foo>` and the
matching close-parenthesis looks like `</foo>`.

- Atoms are leaves
- Sequences are nodes with elements as children

```
(define cube
    (lambda (x)
        (* x x x )))
```

![alt ast](https://github.com/sangarshanan/programming-languages/blob/master/2-racket/part-1/static/ast.png "AST")
