# Floating point numbers


## Decimal numbers

In mathematics we have different types of numbers: Integers, Rationals, Reals, Complex, ...

For a minute, lets focus on integers.

There are infinitely many integers mathematically, but only finitely many representable on the computer.


On the computer there may be more than one storage type for each
mathematical type, For example, `Julia` has
[12](http://julia.readthedocs.org/en/latest/manual/integers-and-floating-point-numbers/)
built in types for integers (signed and unsigned and different storage
sizes.)

###

`Int64` is typical. `Int8` has only $256=2^8$ possible values. It uses $-2^7$ to $2^7-1$.

Internally, the values are kept in binary:

```
convert(Int8, 5) |> bits
```

The leading $0$ indicates the sign. 

### Binary numbers

Binary numbers use powers of $2$, not $10$. So -- as you likely know -- $1101$ in binary is just $1\cdot 2^0 + 0\cdot 2^1 + 1 \cdot 2^2 + 1\cdot 2^3 = 13$.

The largest value in `Int8` would then be $1 + 2 + 4 + 8 + 16 + 32 + 64 = 127$.

### Converting binary to decimal

It is easy to convert binary to decimal: we just mentally use powers of 2 instead of 10.

Here is some code:

```
x = "1101101100"
out = [ parse(Int, x[length(x) - i])* 2^i for i in 0:(length(x) - 1)]
```

and we just add

```
sum(out)
```

### Converting decimal in integer to binary

Start with an integer $n$. we generate the value of `x` from left to right. Suppose $n\geq 2$.

First find $p$ with $2^p \leq n < 2^{p+1}$. The number will have $p+1$ digits, and the left most one will be $1$.

Then consider $n = n - 2^p$. Apply the same to this. Repeat.


```
n = 27
log2(n) # 4. So x = 1XXXX
```

```
n = n - 2^4
log2(n) # 3. So x = 11XXX
```

```
n = n - 2^3
log2(n) # 1 So x = 1101X
```

```
n = n - 2^1 ## smaller than 2, so clearly x = 11011
```

and check:

```
x = "11011"
sum( parse(Int, x[length(x) - i])* 2^i for i in 0:(length(x) - 1) )
```


### Math with binary numbers

Adding two binary numbers follows the usual algorithm with carrying:

```
Verbatim("""
  1101
+ 1011
------
 11000  
""")
```

$(1 + 4 + 8 + 1 +2 + 8 = 16 + 8)$

### Multiplication

In decimal multiplying or dividing  by 10 is easy -- add a $0$ or shift the decimal point. Similarly with binary:

```
Verbatim("""
   10101
*     10
--------
   00000
  10101
--------
  101010
""")
```

### Negative numbers

How are negative numbers stored?

```
bits(convert(Int8, 5)),  bits(convert(Int8, -5))
```

They are quite different!

### two's complement

The storage uses [two's](http://tinyurl.com/855yrz2) complements. Basically $-x$ is stored as $2^n-x$.

We have $n$ bits ($n=8$ in our example, $64$ is typical, though $32$ may be for older machines). Positive numbers use the first $n-1$ which is why there the largest number is $2^{n-1} + 2^{n-2} + \cdots 2 + 1 = 2^n-1$.

It could be that the last bit could just be a sign bit, but instead of
that, the values for negative numbers are stored in a different
format. $-x$ ($x>0$) is stored as $2^n-x$.

### Carry


```
bits(convert(Int8, 5)),  bits(convert(Int8, -5))  
```


```
Verbatim("""
11111111    (Carry)
 00000101   (5=1*1 + 0*2 + 1*4)
 11111011   (2^8-5 = 251 = 1 + 2 + 8 + 16+32 + 64 +128
---------
100000000
""")
```

### Why

This makes addition easy, as illustrated above. Or here with 15 + (-5)

```
Verbatim("""
11111111    (Carry)
 00001111   (15=1*1 + 1*2 + 1*4+1*8)
 11111011   (2^8-5 = 251 = 1 + 2 +...+ 64 +128
---------
100001010
""")
```

And `00001010` $ = 2 + 8 = 10$.

### multiplying and shifting

Let's see what happens with powers of 2:

```
bits(2)
```

```
bits(2 * 2)
```

```
bits(2 * 2^2)
```

and ...

```
bits(2^62)
```

and we go over the edge...

```
bits(2 * 2^62)
```


The largest value is

```
bits(typemax(Int64))
```

Which is $2^{63} - 1$.


Integers are stored exactly -- as possible. But that has
limitations. With 64 bit numbers, the largest integer is $2^{63}-1 =
1 + 2 + \cdots + 2^{62}$:

```
sum(2^i for i in 0:62) |> bits
```

but not `2^63`:

```
2^63
```

Though this works:

```
bits(2^63-1)
```

What happens:

```
bits(2)
```

```
bits(2*2)
```

shifts things left

```
bits(2^62)
```

```
bits(2^62 + 2^61)
```

```
bits(2^62 * 2)
```

But still this is correct:

```
bits(2^63 - 1)
```


## Decimal numbers

On a calculator there is one basic number type: floating point. This is primarily the case with computers as well.

In mathematics we primarily work with *decimal numbers*

$$~
12.34 = 1 \cdot 10^2 + 2 \cdot 10^1 + 3\cdot 10^{-1} + 4 \cdot 10^{-2}
~$$

### Scientific notation

We can write a real number in terms of powers of 10. For example:

$$~
1.234 = 1.234 \cdot 10^0 =  12.34 \cdot 10^{-1} =  .1234 \cdot 10^1 = \cdots
~$$

We can use normalized scientific notation to say that we can express $x$ by three quantities:

$$~
x = \pm r \cdot 10^n
~$$

* The $\pm$ is $+1$ or $-1$ and records the sign of $x$
* the $r$ is a number in $0.1 \leq r < 1.0$
* the $n$ is an integer, possibly negative, or zero.




## scientific notation with different bases

We can use different bases in scientific notation. A number would be represented with

$$~
x = \pm q \cdot \beta^m
~$$

We can normalize the number by insisting $q=0.ddddd...$ where the
leading term is non-zero.

A special case would be $\beta =2$ or base 2, which forces the leading
term to be 1. In that case, a special case could be $q=1.dddddd...$.

### Converting decimal to binary

We can convert decimal numbers to binary. The same simple
algorithm for integers works with some modification. Start with $x$. We want to produce digits $ddd.ddd...$
where $d$ are either $0$ or $1$.

First, take the log base 2:

```
x = 12.1
log2(x) |> floor
```

This says $2^3 \leq x < 2^4$. Remember $3$, then subtract $2^3$ and repeat:

```
ds = [3]
x = x - 2.0^ds[end]
n = log2(x) |> floor
```

Remember 2 and then subtract $2^2$ and repeat:

```
push!(ds, n)
x = x - 2.0^ds[end]
n = log2(x) |> floor
```

Remember $-4$ and repeat

```
push!(ds, n)
x = x - 2.0^ds[end]
n = log2(x) |> floor
```

etc.


The `ds` will tell us there is a 1 in position 3,2,-4, -5, 8,9... So `1100.000110011...`

One thing to note: what numbers terminate in decimal are generally different than what numbers will terminate in binary.

## Floating point numbers

Floating point is a representation of numbers using scientific notation. Only there are constraints on the sizes:

* The value $q$, the significand, has $p$ digits. (The precision)

* The values of $m$ is between two values, say $e_{min}$ and $e_{max}$.

### A simple case

For example consider base $\beta=10$, $p=3$ and $e_{min}=-1$ and $e_{max}=2$. Then the possible values are limited to
$-9.99 \cdot 10^{-1}$ to $9.99 \cdot 10^2$. How many are there?

$$~
2 \cdot ((\beta-1)\cdot\beta^{p-1}) \cdot (e_{max} - e_{min})
~$$

## Binary floating point

For binary floating point, things are similar. For *simplicity* let's look at 16-bit floating point where

* 1 bit is the sign bit `0` = $+1$, `1` is $-1$
* the $q$ is represented with $10$ bits (the *precision* is 10)
* the $m$ is represented with $5$ bits.

There is nothing to represent the *sign* of $m$. The trick is offset
the value by subtracting and using  $m -15$. (Here $15 = 2^{5-1}-1$.)

With this, can we represent some numbers:

What is $1$? It is $+1 \cdot 1.0 \cdot 10^{15 - 15}$. So we should have

* the sign is `0`
* the $q$ is `0000000000`
* the $m$ is `01111`

Checking we have

```
convert(Float16, 1.0) |> bits
```

###

Kinda hard to see: Let's wrap this in a function:

```
function seebits(x)
  b = bits(convert(Float16,x))
  b[1:1], b[2:6], b[7:end]
end
```
  
```
seebits(1)
```

###

We have $2 = 1.0 \cdot 2^1$. Se we expect $q$ to represent $0$ and $m$ to represent $16$, as $16-15 = 1$:

```
seebits(2)
```

What about the sign bit?

```
seebits(-2)
```

###

What about other numbers

```
seebits(1 + 1/2 + 1/4 + 1/8 + 0/16 + 1/32)
```

```
seebits(2^4*(1 + 1/2 + 1/4 + 1/8 + 0/16 + 1/32)) ## 19 - (1 + 1*2 + 1*16) = 0
```

## Zero and other "special" numbers


Wait a minute -- if we insist on the significand being $1.dddd...$ we can't represent $0$!

Some values in floating point are special:

* What is $0$? how to write $0$ in $1.dddd \cdot 2^m$? Can't do it. So it is coded:

```
bits(zero(Float16))
```

(The code uses the *smallest* possible exponent, and $0$ for the significand)

* What is $-0$? By flipping the sign bit, we could code $-0$ naturally. Is it done?


```
bits(-zero(Float16))   ## why??
```

### "Infinity": Inf

Infinity. [Why](http://www.cs.berkeley.edu/~wkahan/Infinity.pdf)?

This value is deemed valuable to have supported at the hardware level. It is coded by reserving the *largest* possible value of $m$ and $0$ for the significand.

```
bits(Inf16)  
```

There is room for $-\infty$ and it too is defined:

```
bits(-Inf16)
```

### Not a number: NaN

NaN. This is a special value reserved for computations where no value is possible. Examples include `0/0` or `0 * Inf`:

```
0/0, 0 * Inf
```

These are related to limit problems (indeterminate), though not all forms are indeterminate:

```
1/0, 0^0
```

How is `NaN` coded:

```
bits(NaN16)
```

This is *very* similar to `Inf`, but the value of $q$ is non-zero!

```
seebits(NaN16), seebits(Inf16)
```

`NaN` semantics are a bit [controversial](https://github.com/JuliaLang/julia/issues/7866).

### Poison

The values of `Inf` and `NaN` will "poison" subsequent operations, for example

```
NaN + 1, Inf - 1
```

These special values are generated instead of errors being thrown for some common cases:

* overflow (a number bigger than the largest finite floating point number)
* divide by $0$ (either `Inf`, or if `0/0`, `NaN`)
* invalid number (such as `0 * Inf`)

(Whether something like `sqrt(-1.0)` is an error or `NaN` is not specified.)

### Range of numbers

What is the range of the numbers that can be represented? Let's check with Float16.

The largest *positive* value would have $m$ coded with `11110` or ($2 + 4 + 8 + 16 - 15 = 15$) (The value `11111` is saved for `Inf` and `NaN`.)

The largest value for $q$ would be `1111111111`, or
 
```
sum([1/2^i for i in 0:10])
```

Altogether we have:

```
sum([1//2^i for i in 0:10]) * 2^15
```

Is this right?

```
prevfloat(typemax(Float16))
```

For the smallest *positive* number, the smallest exponent is code `00000` or $0 - 15 = -15$. So the value should be:


```
1/2^15
```

But this isn't actually the case:

```
nextfloat(convert(Float16, 0))
```

(As there are tricks to get smaller numbers called subnormal numbers)


For double precision numbers (Float64) the values are given by:

```
prevfloat(Inf), nextfloat(0.0)
```

## Rounding

We are familiar with the task of rounding: a passing grade is 59.5 not a 60!

We have three types of rounding: round up, round down, mixing based on a rule.

Rounding to the nearest integer shows this fairly clearly:

```
x = 3.14
ceil(x), floor(x), round(x)
```

The same would be true of $3.1$, as that is all that is looked at here.

What becomes of $1.5$? The default is to round up.

```
x = 1.5
ceil(x), floor(x), round(x)
```

Rounding can be done for real numbers too to some specified number of digits:

```
x = 1.23456
round(x,1), round(x,2), round(x,4)
```


### Rounding in floating point

When converting from decimal to floating point, even simple decimal numbers get rounded!

```
convert(Float16, 0.1)
```

```
seebits(0.1)
```

"1001100110" becomes:

```
q = (1 + 1/2 + 1/16 + 1/32 + 1/256 + 1/512 )
```

###

And `01011` for $m$ becomes

```
m = 1 + 2 + 8 - 15
```

```
1 * q * 2.0^m
```

Notice the number $0.1$ is necessarily approximated.

### Error bound

Let $x$ be the number and $\tilde{x}$ be its rounded value. How big is the difference when $x$ is rounded to $n$ decimal places?

We consider the value of the $n+1$st decimal number.

- If it is in 0,1,2,3,4 then we round down and the error is $i \cdot 10^{-(n+1)}$

- If it is in 5,6,7,8,9 then we round up, and the error is $10-i \cdot 10^{-(n+1)}$.

In either case, it is less --in absolute value -- than $(10/2) \cdot 10^{-(n+1)} = 1/2 \cdot 10^{-n}$.

> The error in rounding to $n$ decimal points is bounded by: $|x - \tilde{x}| < 1/2 \cdot 10^{-n}$.

Had we chopped (`floor`) or always rounded up (`ceil`) then the error is bounded by $10^{-n}$.

### Ulp

There is an alternate name for the error. When rounding to a certain
number of digits, there is a unit of last precision, and `ulp`. In the
above, the unit of last precision was $10^{-n}$, so the error is less
than $1/2$ `ulp`.

`ulp`s are easy enough to understand. If we round $3.1415$ to $3.14$
then the error is $0.15$ `ulp`.

### How much off can rounding be?

In binary floating point, the unit of last precision is $2^{-p}$, so
the error in rounding is at most $(1/2) \cdot 2^{-p}$, or half an `ulp`.

### Float16, Float32, Float64, ...

16-bit floating point is not typical. What is common is:

* 64-bit floating point (in Julia `Float64`)
* 32-bit floating point (older hardward and OSes)

How the bits are arranged in IEEE 754 binary formats for [floating point](http://tinyurl.com/76kpk6s) we have this [table](http://tinyurl.com/76kpk6s). See also this post by John [Cook](http://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/) for the common case.

For example

```
b = bits(2^2 + 2^0 + 1/2 + 1/8) ## 101.101 = 1.01101 * 2^2
b[1:1], b[2:12], b[13:end]
```

Here $m = 2^{10} + 1 - (2^{10} - 1)$ and we can see that $q=1.01101$ with the first $1$ implicit.

## Machine numbers

The numbers that can be represented **exactly** in floating point are called *machine numbers*.

| There aren't very many compared to the **infinite** number of floating point values.

Let's visualize in a *hypothetical* Float8 mode with 1 sign bit, 3 exponent bits and 4 bits for the mantissa.

The possible *positive* values are

```
qs = [1 + i/2 + j/4 + k/8 + l/16 for i in 0:1, j in 0:1, k in 0:1, l in 0:1] |> vec |> sort
```

The values for the exponents are $-2, -1, 0, 1, 2, 3$. So all our values are given by

```
ms = (-2):3
vals = [q * 2.0^m for q in qs, m in ms] |> vec
```

### Plotting the machine numbers

We can plot these points:

```
using Plots
scatter(vals, 0*vals)
```

We notice:

* they are definitely finite
* there are definitely gaps
* they are not evenly spaced out
* there is a "hole" near 0

### Machine precision

Of special note is the size of the gap between values around 1:

```
nextfloat(1.0), nextfloat(1.0) - 1.0
```

This is sometimes called *machine precision* and in `Julia` is returned by `eps()`:

```
eps()
```

```
eps(Float16)
```


In floating point, `1.0 = 1.000...000 * 2^0` where there are `k` zeros
in the mantissa. The next floating point value is `1.000...001 * 2^0$
so the differcne is the $2^{-k}$. 

[FloatingPoint](https://en.wikipedia.org/wiki/Floating-point_arithmetic)
has $k=10$ for 16-bit, $k=23$ for 32 bit and $k=52$ for 64 bit.
