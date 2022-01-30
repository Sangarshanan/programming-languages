## Racket Part 1

Part 1 Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit5notes.pdf

Homework: https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

Racket and ML share many similarities: They are both mostly functional languages (i.e., mutation exists but is discouraged) with closures, anonymous functions, convenient support for lists, no return statements, etc. Seeing these features in a second language should help re-enforce the underlying ideas. One moderate difference is that we will not use pattern matching in Racket.

- Racket does not use a static type system. So it accepts more programs and programmers do not need to define new types all the time, but most errors do not occur until run time.
- Racket has a very minimalist and uniform syntax.

Racket has many advanced language features including **macros**, a module system quite different from ML,
quoting/eval, first-class continuations, contracts, and much more


### Getting Started

