# Floating point numbers

## Decimal numbers

In mathematics we have different types of numbers: Integers, Rationals, Reals, ...

On a calculator there is one: floating point

On the computer there may be more than one type for each mathematical type: 8, 16, 32, 64, 128 bit integers...

In mathematics we primarily work with *decimal numbers*

$$
12.34 = 1 \cdot 10^2 + 2 \cdot 10^1 + 3\cdot 10^{-1} + 4 \cdot 10^{-2}
$$

### Rounding

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

### Error bound

Let $x$ be the number and $\tilde{x}$ be its rounded value. How big is the difference when $x$ is rounded to $n$ decimal places?

We consider the value of the $n+1$st decimal number.

- If it is in 0,1,2,3,4 then we round down and the error is $i \cdot 10^{-(n+1)}$

- If it is in 5,6,7,8,9 then we round up, and the error is $10-i \cdot 10^{-(n+1)}$.

In either case, it is less --in absolute value -- than $5*10^{-(n+1)} = 1/2 \cdot 10^{-n}$.

> The error in rounding to $n$ decimal points is bounded by: $|x - \tilde{x}| < 1/2 \cdot 10^{-n}$.

Had we chopped (`floor`) or always rounded up (`ceil`) then the error is bounded by $10^{-n}$.

## Scientific notation

We can write a real number in terms of powers of 10. For example:

$$
1.234 = 1.234 \cdot 10^0 =  12.34 \cdot 10^{-1} =  .1234 \cdot 10^1 = \cdots
$$

We can use normalized scientific notation to say that we can express $x$ by three quantities:

$$
x = \pm r \cdot 10^n
$$

* $\pm$ is $+1$ or $-1$ records the sign of $x$
* $r$ is a number in $0.1 \leq r < 1.0$
* $n$ is an integer, possible negative, or zero.

A more useful representation for storing on the computer is to shift things over by $1$ to get

* $r$ is a number in $1 \leq r < 10$

## Binary numbers

Binary numbers are similar, only we use base $2$ -- not $10$, as with decimal.

So

$$
(10.101)_2 = 1 \cdot 2^1 + 0 \cdot 2^0 + 1 \cdot 2^{-1} + 0 \cdot 2^{-2} + 1 \cdot 2^{-3}
$$

```
1*2^1 + 0*2^0 + 1*1/2^1 + 0 * 1/2^2 + 1 * 1/2^3
```

### Scientific notation with base 2

We can use different bases in scientific notation. Any number can be written as

$$
x = \pm q \cdot 2^m
$$

With

* $\pm$ represents $+1$ or $-1$
* $q$ -- the significand -- has $1 \leq q < 2$ (in base 2)
* $m$ -- is an integer (in base 2)

By writing $q = 1.f$ an extra digit can be gained (the 1) if only a finite number of digits are available, as is the case on the computer.

(In general, with a base $\beta$, we can write $x=\pm q \cdot \beta^m$ where $q$ is written in base $\beta$.)

## Floating point numbers

Floating point is a representation of numbers using scientific notation, as above, except there are only finitely many digits that can be used for $q$ and $m$. For example, we might restrict $q$ to hold just $p$ digits ($p$ is the *precision*), and $m$ will have another restriction on the size of its digits.

For example, let's consider numbers of the type $d.dd \cdot 10^m$ -- that is $p=3$ where $m$ is in $\{-1,0,1,2\}$. Then some numbers are: `1.23e3` , `-1.2oe-1`, `1.99e0`, ... In each case, $q$ has 3 digits and is in $[1,10)$.


## Binary floating point

For binary floating point, things are similar. For *simplicity* let's look at 16-bit floating point where

- 1 bit is the sign bit `0` = $+1$, `1` is $-1$
- $q$ is represented with $10$ bits (the *precision* is 10)
- $m$ is represented with $5$ bits.

There is nothing to represent the *sign* of $m$. The trick is offset the value by subtracting and using  $m -15.

With this, can we represent some numbers:

What is $1$? It is $+1 \cdot 1.0 \cdot 10^{15 - 15}$. So we should have

- sign is `0`
- $q$ is `0000000000`
- $m$ is `01111`

Checking we have

```
convert(Float16, 1.0) |> bits
```


Kinda hard to see: Let's wrap this in a function:

```
function seebits(x)
  b = bits(convert(Float16,x))
  b[1], b[2:6], b[7:end]
end
```
  
```
seebits(1)
```

We have $2 = 1.0 \cdot 2^1$. Se we expect $q$ to represent $0$ and $m$ to represent $16$, as $16-15 = 1$:

```
seebits(2)
```

What about the sign bit?

```
seebits(-2)
```

What about other numbers

```
seebits(1 + 1/2 + 1/4 + 1/8 + 0/16 + 1/32)
```

```
seebits(2^4*(1 + 1/2 + 1/4 + 1/8 + 0/16 + 1/32)) ## 19 - (1 + 1*2 + 1*16) = 0
```

Numbers get rounded!

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

And `01011` for $m$ becomes

```
m = 2.0^(1 + 2 + 8 - 15)
```

```
1 * q * 2^m
```

Notice the number $0.1$ is necessarily approximated.

### Float16, Float32, Float64, ...

16-bit floating point is not typical. What is common is:

* 64-bit floating point (in Julia `Float64`)
* 32-bit floating point (older hardward and OSes)

How the bits are arranged in IEEE 754 binary formats for [floating point](http://tinyurl.com/76kpk6s) we have this [table](http://tinyurl.com/76kpk6s). See also this post by John [Cook](http://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/) for the common case.

For example

```
b = bits(2^2 + 2^0 + 1/2 + 1/8) ## 101.101 = 1.01101 * 2^2
b[1], b[2:12], b[13:end]
```

Here $m = 2^10 + 1 - (2^10 - 1)$ and we can see that $q=1.01101$ with the first $1$ implicit.


## 0, Infinity, NaN

Some values in floating point are special:

* $0$: how to write $0$ in $1.f \cdot 2^m$? Can't do it. So it is coded:

```
bits(0.0)
```

* $-0$: By flipping the sign bit, we could code $-0$ naturally. Is it done?


```
bits(-0.0)   ## why??
```

* Infinity. [Why](http://www.cs.berkeley.edu/~wkahan/Infinity.pdf)?

This value is deemed valuable to have supported at the hardware level. It is coded by reserviing the largest value of $m$:

```
bits(Inf)  # see bits(Inf)[2:12]
```

There is room for $-\infty$ and it too is defined:

```
bits(-Inf)
```

* NaN. This is a special value reserved for computations where no value is possible. Examples include `0/0` or `0 * Inf`:

```
0/0, 0 * Inf
```

These are related to limit problems (indeterminate), though not all forms are indeterminate:

```
1/0, 0^0
```

How is `NaN` coded:

```
bits(NaN)
```

This is *very* similar to `Inf`, but the value of $q$ is non-zero!

```
bits(NaN)[13:end], bits(Inf)[13:end]
```

### Range of numbers

What is the range of the numbers that can be represented? Let's check with Float16.

The largest *positive* value would have $m$ coded with `11110` or ($2 + 4 + 8 + 16 - 15 = 15$)

The largest value for $q$ would be `1111111111`, or

```
sum([1/2^i for i in 0:10])
```

Altogether we have:

```
sum([1/2^i for i in 0:10]) * 2^15
```

Is this right?

```
prevfloat(typemax(Float16))
```

For the smallest *positive* number, the smallest exponent is code `00000` or $0 - 15 = -15$. So the value should be:


```
-sum([1/2^i for i in 0:10]) * 1/2^15
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

## Machine numbers

The numbers that can be represented **exactly** in floating point are called *machine number*.

* There aren't very many compared to the **infinite** number of floating point values.

Let's visualize in a *hypothetical* Float8 mode with 1 sign bit, 3 exponent bits and 4 bits for the mantissa.

The possible *positive* values are

```
qs = [1 + i/2 + j/4 + k/8 + l/16 for i in 0:1, j in 0:1, k in 0:1, l in 0:1] |> vec |> sort
```

The values for the exponents are $-3, -2, -1, 0, 1, 2, 3$. So all our values are given by

```
ms = (-3):3
vals = [q * 2.0^m for q in qs, m in ms] |> vec
```


### Plotting the machine numbers

We can plot these points:

```
using Gadfly
plot(x = vals, y = 0*vals, Geom.point)
```


We notice:

* they are definitely finite
* there are definitely gaps
* they are not evenly spaced out
* there is a "hole" near 0

### Machine precision

Of special note is the size of the gap between values around 1:

```
nextfloat(1.0)
```

This is sometimes called *machine precision* and in `Julia` is returned by `eps()`:

```
eps()
```

```
eps(Float16)
```

### Rounding

As not every number is a machine number, numbers are rounded to machine numbers. There are variants of rounding methods. Some are:

* round to nearest: find the closest machine number. If a tie round to the even number.
* round to $0$: round down if positive, up if negative
* round to $\infty$ (or $-\infty$): always round up (or down)

How big can the error be in rounding one number? Let $p$ be the precision and $\beta=2$, for simplicity we take $p=3$. We can write

$$
x=1.a_1 a_2 a_3 a_4 \dots 2^m = 1.a_1 a_2 a_3 2^m + e
$$

where

$$
e=.000a_4 a_5 \dots 2^m = 0.a_4a_5\dots 2^{-p} 2^m.
$$

If we round down, we take $e=0$.

If we round up, we take $e = 1\cdot 2^{-p} 2^m$.

At most the error is $1/2 2^{-p} 2^m$.

The *relative error* is at most

$$
|\frac{x - fl(x)}{x}| = |\frac{e}{x} = \frac{1/2 2^{-p} 2^m}{q 2^m} \leq 1/2 2^{-p}
$$

(With just chopping there would be no $1/2$.)

The book writes $fl(x)$ for the floating point value of $x$. If $\delta$ is the relative error, then we have $fl(x) = x (1 + \delta)$ and $|\delta| \leq 1/2 2^{-p}$.

### next closest number

Suppose $x = 1.a_1a_2 \cdot a_p \cdot 2^m$ is a machine number with precision $p$. What is the relative size of the next largest number? This would be

$$
x' = (1.a_1a_2 \cdot a_p + 2^{-p}) \cdot  2^m
$$

The absolute difference being $2^{m-p}$. So if $m$ is larger, the difference is larger -- bigger gaps. The *relative difference* is basically a constant: $2^{-p}2^m/(q 2^m) \leq 2^{-p}$. 

## Error analysis of arithmetic operations

Rounding can mess with our "inituitive" ideas of how numbers work: Consider the familiar decimal case with $p=3$.

What is $10.1 - 9.93$?

In regular subtraction we align the decimal points

```
Verbatim("""
10.10
09.93
-----
00.17
""")
```

On the computer though values are shifted to align the decimal points. Hence $9.93$ could become $0.99 \cdot 10^{1}$, if chopped. So that subtraction becomes

```
Verbatim("""
10 *  1.01
      0.99
      ----- 
10 *  0.02
""")
```

The difference between $.20$ and $.17$ is 3 units in the off in the last digit of precision. So rounding can have an adverse effect.


### How far off can subtraction with shifting and truncation be?

Suppose we have  precision $p$ and binary ($\beta=2$). Then the *relative* error can be as large as 1 = $\beta-1$!

Consider a small case: $1.00 \cdot 2^0$ and $1.11 \cdot 2^{-1}$. (These are adjacent). Then mathematically the difference is $0.001$, but if $1.11 2^{-1}$ is shifted (and chopped) to $0.11 \cdot 2^0$ to match, then the difference is $0.01$. We have $|(0.001 - 0.01)/(0.001)| =  1$.

To work around this loss, *guard bits* are used in practice.

## Analysis of floating point operations

Consider more generally the basic operations of addition, subtraction, multiplication, and division.

Let's assume (contrary to above) that the operations on floating point are correctly done and *then* rounded to a machine number. (This can be arranged by using more bits for intermediate computations).

If $\odot$ is any of the above operations, what is $fl(x \odot y)$?

We know for $x$ that $fl(x) = x(1 + \delta)$ where $\delta$ is small ($\leq 2^{-p}$) and depends on $x$. So,

$$
fl(x \odot y) = fl(fl(x) \odot fl(y)) = [(x(1+\delta_x) \odot (y(1 + \delta_y))](1 + \delta)
$$

Each $\delta is small.

Well, how much off are we?

```
using SymPy
x,y,d1,d2,d3 = symbols("x,y,d1,d2,d3", real=true)
op = *
( op(x*(1+d1), y*(1+d2)) * (1 + d3) - op(x,y))/op(x,y) |> expand
```

```
op = /
( op(x*(1+d1), y*(1+d2)) * (1 + d3) - op(x,y))/op(x,y) |> expand
```

But...

```
op = -
( op(x*(1+d1), y*(1+d2)) * (1 + d3) - op(x,y))/op(x,y) |> expand
```

## Addition of numbers and cumulative error

How do errors accumulate?

> Theorem 1 (p49) relative error in $\sum_0^n x_i$ is $(1_\epsilon)^n-1 \approx n\epsilon$.


Let $S_{k+1} = x_{k+1} + S_k$ be the partial sum and $S^*_{k+1} = fl(x_{k+1} + S*_k) = (x_{k+1}+S^*_k)(1+\delta_{k+1}$ be the floating point partial sum. What is the relative difference?

$$
\frac{S_{k+1} - S^*_{k+1}}{S_{k+1}} =
\frac{S_{k+1}(1+\delta) - S^*_{k+1}(1+\delta) - S_{k+1}\delta}{S_{k+1}
= (1 + \delta)\frac{S_k - S^*_k}{S_k}\frac{S_k}{S_{k+1}} - \delta
$$

Let $\rho_k$ be the absolute value. Then
$\rho_{k+1} \leq \rho_k(1+\epsilon) + \espilon$ with $\rho_0 = 0$. This can be solved to yield: $\rho_n \leq (1 + \epsilon)^n - $.

### Other bounds

The maximal possible error for accumulating sums grows *linearly* with the number of sums. There are other algorithms to cut this down. In Julia, [pairwise](https://en.wikipedia.org/wiki/Pairwise_summation) summation is used. This has relative error given by $\epsilon \log_2(n)$.


## Loss of significance


Return to


```
op = -
( op(x*(1+d1), y*(1+d2)) * (1 + d3) - op(x,y))/op(x,y) |> expand
```


The presence of the difference in the denominator can be a problem.


In the book, we have Thm 1 of section 2.2

> If $x$ and $y$ are binary floating point numbers with $x > y > 0$ with
$$
2^{-q} \leq 1 - y/x \leq 2^{-p}
$$
Then at most $q$ and *at least* $p$ significant binary bits are lost in the substraction $x-y$.

The lower bound:

Say $x = r \cdot 2^n$ and $y=s\cdot 2^m$ with $m \leq n$ and here $1/2 \leq r, s < 1$. Then to "line up the decimal points" we may write $y = s \cdot 2^(m-n) \cdot 2^n$.

$$
x - y = (r - s\cdot 2^{m-n}) \cdot 2^n
$$

The significand then satisfies:

$$
r - s \cdot 2^{m-n} = r(1 - \frac{s\cdot 2^m}{r \cdot 2^n}) = r(1 - y/x) < 2^{-p}
$$

To put into normalized floating point, the significand must be shifted (there are leading $0$s) and the (at least) $p$ terms added are spurious, so accuracy is lost.

### Example

Consider $\sin(x) \approx x$. So $\sin(x) - x$ will cause issues.

```
x = 1/2^5
X = big(1/2^5)   # more precision
sin(x) - x
```

```
sin(X) - X
```

Only accurate to the 10th digit -- not the 16th. There is a loss of accuracy

Compare this to

```
sin(x) + x
```

and

```
sin(X) - X
```


The moral of the story -- try to avoid these.

## Accuracy of functions

In `Julia` there are many "redundant" functions:

* `sinpi` for computing $\sin(\pi x)$, `cospi`, ...
* `expm` to compute $e^x - 1$ for $x$ near 0
* `log1p` to compute $\log(1+x)$ near 0

The reason for `expm` seems clear. $e^x \approx 1 + x + x^2/2! + \cdot$, so $e^x-1$ for small $x$ is a subtraction of like-sized values.

For `log1p` [Cook](http://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/) if $x$ is really small, say $x=10^{-17}$ (`x < eps()`), then what happens to $1 + x$? In floating point it is 1. But $\log(1+x) \approx x$ by Taylor, so the absolute error is $x$ and the relative error $1$. Quite large. There are more floating point values closer to $0$ than $1$, so smaller values of $x$ can be used in `log1p`. 

What about `sinpi`?

The first step in 

