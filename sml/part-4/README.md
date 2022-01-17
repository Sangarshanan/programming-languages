## Standard ML Part 4

Type Inference, Module System, Mutual Recursion & Equivalence

- Notes: https://courses.cs.washington.edu/courses/cse341/16sp/unit4notes.pdf

### Type Inference

- Static (type checking can reject program before it runs) & Dynamic Typing (done at runtime) have their own pros and cons
- Even tho ML is static typed, its implicit typing so we rarely need to write down types & bad type code won't compile

Type Inference problem: Give every binding/expression a type such that type-checking succeeds and fail if no solution exists, This is often implemented with the type system of the language and the complexity of type inference entirely depends on the said type system.
