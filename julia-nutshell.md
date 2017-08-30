# Overview of Julia commands

A quick overview of some `Julia` commands and constructs.

## Getting Started

You can download and install `Julia` on your computer -- it is freely
available. However, you can also use it through the web at
`juliabox.com`. This is easy and gives the convenient `Jupyter`
interface, we we will assume.

To use `juliabox.com`:

* have handy a gmail account
* proceed to `juliabox.com` and log in with your gmail credentials
* Under the "new" dropdown on the right side, open a new "Julia 0.6.0"
notebook. (As of writing, this is the latest release)
* We will enter two commands to install some additional software. Copy
and paste the following into a cell, then press the "play" button:

```
Pkg.clone("https://github.com/mth229/MTH229.jl")
using MTH229
```

Wait... while waiting, learn that the first line downloads a bunch of external
packages that can be convenient. To access these packages during a
session, the second line must be executed.

Now that that is done, you can type commands in a cell and hit the
play button of "shift+enter" to execute them. Their output fills in
below the cell.


## Commands

Commands are typed at the REPL prompt or in a `IJulia` cell. New commands are separated by a new line or a semicolon.

## Numbers, variable types

Unlike a calculator `Julia` has different "types" for different kinds of numbers. For example

- Integers: `2`

- Rational numbers: `1//2`

- Floating point numbers: `0.5`

- Complex numbers `2 + 0im`

As much as possible, operations involving  certain types of numbers will produce output of a given type. For example, both of these divisions produce a floating point answer, even though  mathematically, they need not:

```
2/1, 1/2
```

Some operations won't work with integer types, but will with floating point types, as the type of output can't be assured. Powers are the main example where `2^(1/2)` is not defined, but `2.0^(1/2)` is.

An expression like `(-3.0)^(1/3)` is not defined, as it can't be in general for the two types. However, `Julia` provides the special-case function `cbrt`.

Integer operations may silently overflow, producing odd answers:

```
2^3^4    # is 2^(3^4) = 2^81 which is too big for 64 bit integers
```

When different types of numbers are mixed, `Julia` will usually promote the values to a common type before the operation:

```
(2 + 1//2) + 0.5
```

`Julia` will first add `2` and `1//2` converting the integer `2` to rational before doing so. Then `Julia` will add the result, `5//2`, to `0.5`, promoting `5//2` to the floating point number `2.5` before proceeding.

The standard mathematical operations are implemented by `+`, `-`, `*`, `/`, `^`. Parentheses are used for grouping.

## Vectors

Arithmetic sequences can be defined by either

- `linspace(a,b,n)` which produces `n` values between `a` and `b`;

- `a:h:b` or `a:b` which produces values starting at `a` separated by `h` (`h` is `1` in the last form) until they reach `b`.

- general vectors can be constructed with square brackets:

```
[1,1,2,3,5,8]
```

## Variables

Values can be assigned variable names, with `=`. There are some variants

```
x = 2
a_really_long_name = 3
a, b = 1, 2
a1 = a2 = 0
```

The names can be short, as above, or more verbose. They can't start with a number, but can include numbers. It can also be a fancy unicode or even an emoji.

Names may be repurposed, even with values of different types (a dynamic language), save for function names, which have some special rules.

## Functions

Functions in `Julia` are just regular objects. There are many built-in functions and it is easy to define new functions.

We call a function by passing arguments to it, grouped by parentheses:

```
sin(pi)
```

Functions can have one or more arguments, this `log` function has two with the first indicating the base:

```
log(5, 100)   # log base 5 of 100
```

Many functions can share the same generic name. For example, for base $e$ logarithms, the `log` function is used directly:

```
log(10)     # same as log(e, 10)
```

Julia uses the number of arguments and types of the arguments to disambiguate which method to call. 

Without parentheses, the name refers to generic name and the output lists the number of available implementations.

```
log
```

### Built-in functions

`Julia` has numerous built-in [mathematical](http://julia.readthedocs.org/en/latest/manual/mathematical-operations/#powers-logs-and-roots) functions.

#### Powers logs and roots

Besides `^`, there are `sqrt` and `cbrt` for powers. In addition basic function for exponential and  logarithmic functions:

```
Verbatim("""
sqrt(x), cbrt(x)
exp(x)
log(x) # base e
log10(x), log2(x), log(b, x)
""")
```

#### Trigonometric functions

The $6$ standard trig functions are implemented; their implementation for degree arguments; their inverse functions; and their hyperbolic analogs.

```
Verbatim("""
sin, cos, tan, csc, sec, cot
sind, cosd, tand, cscd, secd, cotd
asin, acos, atan, acsc, asec, acot
sinh, cosh, tanh, csch, sech, coth
asinh, acosh, atanh, acsch, asech, acoth
""")
```

#### Useful functions

Other useful and familiar functions are defined:

- `abs(x)` absolute value

- `sign(x)` is $\lvert x \rvert/x$ except at $x=0$, where it is $0$.

- `floor(x)`, `ceil(x)` greatest integer less or least integer greater

- `max(a,b)` and `min(a,b)` larger (or smaller) of `a` or `b`

- `maximum(xs)` and `minimum(xs)` largest or smallest of the collection referred to by `xs`



### User-defined functions

Simple mathematical functions can be defined using standard mathematical notation:

```
f(x) = -16x^2 + 100x + 2
```

The argument `x` is passed into the body of function.

User defined functions can have 1 or more arguments:

```
area(w, h) = w*h
```

Julia makes different *methods* for *generic* function names, so functions whose argument specification are different are different functions, even if the name is the same. This is *polymorphism* and means users need only remember a much smaller set of function names.

Longer functions can be defined using the `function` keyword, the last command executed is returned:

```
function f(x)
  y = x^2
  z = y - 3
  z
end
```

Functions without names, *anonymous functions* are made with the `->` operator as in:

```
x -> cos(x)^2 - cos(2x)
```

These are useful when passing a function to another function.

## Conditional statements

`Julia` provides the traditional `if-else-end` statements, but more conveniently has a `ternary` operator for the simplest case:

```
our_abs(x) = (x < 0) ? -x : x
```

## Looping

Iterating over a collection can be done with the traditional `for` loop. However, there are list comprehensions to mimic the definition of a set:

```
[x^2 for x in 1:10]
```

And `map` to apply a function over a collection:

```
map(sin, 1:4)
```

## Plotting

Plotting is *not* built-in to `Julia`, rather added through add-on
packages. We use, `Julia`'s `Plots` package, an interface to several
different backends. For this package, there are three basic calling styles:

Plotting a function by passing the function object by name. 

```
using Plots      # needed just once per session
plot(sin, 0, 2pi)
```

Plotting an *anonymous* function

```
plot( x -> exp(-x/pi) * sin(x), 0, 2pi)
```

Plotting more than one function over $[a,b]$ using `plot!`:

```
plot(sin, 0, 2pi)
plot!(cos)
plot!(zero)
```

## Matrices

Matrices are created by horizontally or vertically concatenating values:

```
vcat(1,2,3)  # a vector Array{Int64,1}
```

```
hcat(1,2,3) # a 1x3 matrix Array{Int64, 2}
```

Combining these can be useful:

```
hcat(vcat(1,2,3), vcat(4,5,6))
```

The above is a bit cumbersome. The `[]` function does both:

- `vcat` is done when values are separated by commas or semicolons

- `hcat` done when values are separated by spaces (whitespace is important!)

(Not all permutations are possible)

```
[1 2 3; 4 5 6]  # vertically concatenate two horizontal matrices
```

```
v = [1,2,3]; w = [4,5,6] # vertical vectors
[v w]           # horizontally concatenate
```

Blocks can be manipulated

```
B = [1 1; 1 1]; v= [2,2]; C=[3 3 3]
[B v; C]
```

Matrices can also be formed by comprehensions with two variables:

```
[1//(i+j+1) for i in 1:5, j in 1:5]
```

## Floating point

There are various functions to work with floating point values.

- `nextfloat` and `prevfloat` to give the floating point value to the right or left

- `typemax` and `typemin` to give the larges and smallest value representable by a type

- `bits` to show the bits used in storage

- `Float16`, `Float32`, `Float64`, `BigFloat` for floats of different sizes.


For example, this is the largest non-infinite floating point value for 16-bit floating point values:

```
prevfloat(typemax(Float16))
```

The bits used for floating point numbers are detailed [here](http://en.wikipedia.org/wiki/Floating_point#Internal_representation)

For 64-bit floating point values the first bit is the sign bit, bits `2:12` code the exponent and bits `13:64` code the significand.

For 16-bit floating point values again the first bit is the sign bit, bits `2:6` code the exponent and bits `7:16` code the significand.

Here we can see the special codings of 0, `Inf` and `NaN`:

```
xs =  [0, -Inf, Inf, NaN]
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```


This shows powers of `2` and how they are coded (15 = "01111")

```
xs = [2.0^i for i in -2:2]
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```


This shows the significand changing


```
xs = 1:8
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```

We see how the binary representation is comprised:

```
xs = [1 + 1//2 + 0//4 + 1//8 + 0//16 + 1//32]
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```

Multiplying by 2 just adds 1 to the exponent

```
xs = [3, 6, 12, 24]
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```

Dividing by 2 subtracts 1 from the exponent


```
xs = [3, 3//2, 3//4, 3//8]
[rpad(i, 10) * "$(bits(x)[1]) $(bits(x)[2:6])  $(bits(x)[7:16])" for (i,x) in zip(xs, [convert(Float16, x) for  x in xs])]
```

For even faster math, some programs will work by manipulating bits.

## Psuedocode

Translating pseudo code into an algorithm with `Julia` is usually pretty straightforward. Consider this code for the bisection method:

$$
\begin{align}
&\textbf{input } a, b, M, \delta, \epsilon\\
&u \leftarrow f(a)\\
&v \leftarrow f(b)\\
&e \leftarrow b - a\\
&\textbf{if } sign(u) = sign(v) \textbf{ then stop}\\
&\textbf{for } k=1 \textbf{ to } M \textbf{ do}\\
&\quad e \leftarrow e/2     \\
&\quad c \leftarrow a + e     \\
&\quad w \leftarrow f(c)     \\
&\quad \textbf{if } \lvert e\rvert < \delta \textbf{ or } \lvert w \rvert < \epsilon \textbf{ then stop}\\
&\quad \textbf{if } sign(w) \neq sign(u) \textbf{ then}     \\
&\quad \quad b \leftarrow c     \\
&\quad \quad v \leftarrow w     \\
&\quad \textbf{else}     \\
&\quad \quad a \leftarrow c     \\
&\quad \quad u \leftarrow w     \\
&\quad \textbf{end if}     \\
&\textbf{end do}     \\
\end{align}
$$

The bold text are commands. Here is a `julia` translation:

```
function bisection(f, a, b; M=64, delta=1e-12, epsilon=1e-12)
u,v = f(a),f(b)
e = b-a
c = Inf

if sign(u) == sign(v) error("a,b not a bracket") end
for k in 1:M
  e = e/2
  c = a + e
  w = f(c)
  if (abs(e) < delta) | (abs(w) < epsilon)
    break
  end

  if sign(w) != sign(u)
    b,v = c, w
  else
    a,u = c, w
  end
end

return c
end
```

Does it work? Let's find $\pi$:

```
bisection(sin, 3, 4)
```

`Julia` uses a fairly similar set of commands with a few differences:

- **input** is replaced by the `function` keyword to begin a multi-line function

- the pseudocode $\leftarrow$ is just `=`, the assignment operator.

- the equality test $=$ is replaced by `==` (as `=` is assignment, not a test for equality)

- **if-then-stop** is replaced with an `if-then-end` and **stop** is handled by `error` in one case and `break` in another, as that is what the logic dictates.

- **or** becomes `|` (and **and** becomes `&`). (There are also shortcut versions `&&` and `||`. These are often used used for control flow in `julia`, as with `sign(u) == sign(v) && error("...")`.)

- **for-to-do ... end do** becomes a `for` loop with the syntax `for var in collection ... end`

- **if-else-end if** becomes `if-else-end`.


A more subtle point is the value of `c` in the pseudo code is assigned
within a `for` loop. Our "mental" compiler has no trouble recognizing
this assignment in producing the answer. However, in real `Julia` code
this assignment will not be visible outside the block, as a
block-local variable is created unless there already is a global binding assigned.
In the `julia` code this is done by initializing `c` to
`Inf`. As well, we explicitly return `c` from our function as that is
the approximate answer.
