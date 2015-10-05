# Floating point numbers


## Rounding, again

As not every number is a machine number, numbers are rounded to machine numbers. There are variants of rounding methods. Some are:

* round to nearest: find the closest machine number. If a tie round to the even number.
* round to $0$: round down if positive, up if negative
* round to $\infty$ (or $-\infty$): always round up (or down)


### For example,...

```
with_rounding(Float32, RoundUp) do 
       .1 + .2 + .3
end
```

```
with_rounding(Float32, RoundDown) do 
       .1 + .2 + .3
end
```	   

```
with_rounding(Float32, RoundDown) do 
    -.1 - .2 - .3
end
```

and

```
with_rounding(Float32, RoundToZero) do 
       -.1 - .2 - .3
end
```

### A more realistic problem

```
xs = rand(10^7) - 0.5
ys = big(xs)
rup = with_rounding(() -> sum(xs), Float64, RoundUp)
rdown = with_rounding(() -> sum(xs), Float64, RoundDown)
ex = convert(Float64, sum(ys))

ex - sum(xs), ex - rup, ex - rdown
```



### How big can the error be in rounding one number?

We've seen this answered: the significand can be off by at most $1/2$`ulp` $=1/2 \cdot 2^{-p}$.

At most the *error* is $1/2 \cdot 2^{-p}\cdot 2^m$.

Write $fl(x)$ to be the machine number that $x$ rounds to. Then

$$
e = |x - fl(x)| \leq 1/2 \cdot 2^{-p}\cdot  2^m
$$

The *relative error* of rounding $x$ is at most

$$
|\frac{x - fl(x)}{x}| = |\frac{e}{x}| = \frac{1/2 \cdot 2^{-p}\cdot 2^m}{q 2^m} \leq 1/2 \cdot 2^{-p}
$$

(With just chopping there would be no $1/2$.)

If $\delta$ is the relative error, then we have $fl(x) = x (1 + \delta)$ and $|\delta| \leq 1/2\cdot 2^{-p}$.

### Next closest number

Suppose $x = 1.a_1a_2 \cdot a_p \cdot 2^m$ is a machine number with precision $p$. What is the relative size of the next largest number? This would be

$$
x' = (1.a_1a_2 \cdot a_p + 2^{-p}) \cdot  2^m
$$

The absolute difference being $2^{m-p}$. So if $m$ is larger, the difference is larger -- bigger gaps. The *relative difference* is basically a constant: $2^{-p}2^m/(q 2^m) \leq 2^{-p}$.

### 1+

What is the next number after 1? This would be

$$
1+ = 1.0000 \cdots 0000 1 \cdot 2^0
$$

The difference $1^+ - 1 = 2^{-52}$ or

```
2.0 ^ (-52)
```

As mentioned, this value is given by:

```
eps()
```

Or `nextfloat(1.0) - 1.0`

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

Consider a *primitive* computer where the digits are shifted to align the decimal points. Hence $9.93$ could become $0.99 \cdot 10^{1}$, if chopped. So that subtraction becomes

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

Consider a small case: $1.00 \cdot 2^0$ and $1.11 \cdot 2^{-1}$. (These are adjacent). Then mathematically the difference is $0.001$, but if $1.11 \cdot 2^{-1}$ is shifted (and chopped) to $0.11 \cdot 2^0$ to match, then the difference is $0.01$. We have $|(0.001 - 0.01)/(0.001)| =  1$.

**Historically** this led to engineering using guard digits (mentioned in
the book). The IEEE 754 standard is different -- the values should be
exactly subtracted then rounded (exact rounding).

## Analysis of floating point operations

Consider more generally the basic operations of addition, subtraction, multiplication, and division.

Let's assume (contrary to above) that the operations on floating point
are correctly done and *then* rounded to a machine number. (This can
be arranged by using more bits for intermediate computations).

If $\odot$ is any of the above operations, what is $fl(x \odot y)$?

We know for $x$ that $fl(x) = x(1 + \delta)$ where $\delta$ is small ($\leq 2^{-p}$) and depends on $x$. So,

$$
fl(x \odot y) = fl(fl(x) \odot fl(y)) = ((x(1+\delta)) \odot (y(1 + \delta)))(1 + \delta)
$$

Each $\delta$ is small and possibly different.

Well, how much off are we? Let's quickly check:

```
ENV["PYTHONHOME"] = "/Users/verzani/anaconda/"
using SymPy
```

###

```
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
op = +
( op(x*(1+d1), y*(1+d2)) * (1 + d3) - op(x,y))/op(x,y) |> expand
```

## A Leaky abstraction

Floating point is a [leaky](http://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/) abstraction for the real numbers. Certain mathematical facts aren't true for floating point operations!

Here are some "gotchas"

<li> subtraction of like sized values can be a problem

<li> there is no guarantee of *associativity* ($a+(b+c) = (a+b) + c$.


### Subtraction

Consider again the case of subtracting two numbers that are close by.

We saw

$$
fl(fl(x) - fl(y)) - (x-y) = \frac{1}{x-y}(x (\delta_1 + \delta_3 + \delta_1 \delta_3) + y((\delta_2 + \delta_3 + \delta_2 \delta_3))).
$$

If $x$ and $y$ are close, then this can be quite large.

In the book, we have Theorem 1 of section 2.2

> If $x$ and $y$ are binary floating point numbers with $x > y > 0$ with
> $$2^{-q} \leq 1 - y/x \leq 2^{-p}$$
> Then at most $q$ and *at least* $p$ significant binary bits are lost in the substraction $x-y$.

### Idea

Suppose we  are in decimal and we have $4$ digits of precision. Consider subtracting $22/7 = 3.142857142857143$ from $\pi = 3.1415926535897...$. We have

$$
fl(\pi) - fl(22/7) = 3.142 - 3.143 = -0.001 = -1.000 \cdot 10^{-3}.
$$

The actual answer is $-0.0012644892...$ rounded to  $-1.264\cdot 10^{-3}$. Where did the extra zeros come from in the answer above? They are just added on as there is no obvious alternative when shifted to normalized scientific notation. So we lost 3 digits of accuracy and we have $10^{-3} \leq 1 - \pi/(22/7) \leq 10^{-4}$. 

### Proof

The lower bound:

Say $x = r \cdot 2^n$ and $y=s\cdot 2^m$ with $m \leq n$ and here $1/2 \leq r, s < 1$. Then to "line up the decimal points" we may write $y = s \cdot 2^{m-n} \cdot 2^n$.

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

Compare this to addition:

```
sin(x) + x
```

and

```
sin(X) + X
```

The moral of the story -- try to avoid subtraction when the values are of the same size.

(Yes, but what about $f(x+h) - f(x)$?)

### floating point is not always associative

```
a,b,c = 10.0^30, -10.0^30, 1
a + (b + c),  (a + b) + c # not associative, even with machine numbers
```

And:

```
(0.1 + 0.2) + 0.3,  0.1 + (0.2 + 0.3)
```

### Floating point is not always "commutative"

```
0.1 + 0.2 + 0.3, 0.3 +  0.2 +  0.1
```

This is not quite correct mathematically. It is the case that $fl(x) + fl(y) = fl(y) + fl(x)$. However, the above shows that we can't arbitrarily move around sums. This is due to the lack of associativity. On the left `0.1 + 0.2` is performed first, on the right `0.3 + 0.2` is.


Moral: need to be careful when trying to say two things are exactly equal: Not only is there rounding, but algebraic reductions done different ways can lead as well to different answers.

### Proof not associative

Let $a$, $b$ and $c$ be machine numbers. Then we have $fl(a+b) = (a+b)(1+\delta)$, where delta may be $0$, is small, but may not be $0$ and depends on $a$ and $b$. So:

$$
\begin{align}
fl((a+b)+c) &= ((a+b)(1+\delta_1)+c)(1+\delta_2) = (a+b)(1+\delta_1)(1+\delta_2) + c(1+\delta_2)\\
fl((a+(b +c) &= (a+ (b+c)(1+\delta_3))(1+\delta_4) =  a(1+\delta_4) + (b+c)(1+\delta_3)(1+\delta_4)
\end{align}
$$

Are these equal? Add smaller first?

### finessing the problem

Consider the problem of the quadratic equation and computing $b^2 - 4ac$.

An example of [Goldberg](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf) of Catastrophic cancellation using rounding to three significant digits illustrates. Suppose $a=1.22$, $b=3.34$ and $c=2.28$.  Then

```
a,b,c = 1.22, 3.34, 2.28
b^2 - 4a*c
```

But if we rounded $b^2$ and $4ac$ to 3 significant digits, we would have

```
round(b^2,1) - round(4a*c, 1)  ## b^2 > 10, so round(_,1) is 3 digits, ...
```

The subtraction isn't the issue here, it is that rounding of floating
point numbers to machine numbers can be a source of loss of accuracy.

### Case study: finding the midpoint of two numbers

In an example in the book (p76) a formula to find the midpoint -- the point halfway between $a$ and $b$ -- is given:

$$
a + \frac{b-a}{2}
$$

And not $(a+b)/2$. Why?

###

Error in $(a+b)$ can be of size $(a+b)\delta$ which can be large. The error in $b-a$ is generally smaller.

Their general strategem is:

> in numerical calculations it is best to compute a quantity by adding
> a small correction term to a previous approximation.


### Case study: Polynomial evaluation

Polynomial evaluation can be sensitive to numeric issues. Problem 3 on
page 62 considers a polynomial evaluated 3 ways:

$$
\begin{align}
h(x) &= (x-1)^8 \\
f(x) &= x^8 - 8x^7 + 28x^6 - 56x^5 + 70x^4 - 56x^3 + 28x^2 - 8x + 1 \\
g(x) &= (((((((x-8)x + 28)x - 56)x + 70)x -56)x + 28) - 8)x + 1
\end{align}
$$

###

They are interested in values near $1$ (101 values between 0.99 and 1.01 in fact). Let's see the differences

```
using Gadfly
h(x) = (x-1.0)^8
f(x) = x^8 - 8x^7 + 28x^6 - 56x^5 + 70x^4 - 56x^3 + 28x^2 - 8x + 1
g(x) = (((((((x-8)*x + 28)*x - 56)*x + 70)*x -56)*x + 28)*x - 8)*x + 1
xs = linspace(0.99, 1.01, 101)
hs = map(h, xs); fs = map(f, xs); gs = map(g, xs)
plot(layer(x=xs, y=hs, Geom.line, Theme(default_color=color("red"))),
layer(x=xs, y=fs, Geom.line, Theme(default_color=color("blue"))),
layer(x=xs, y=gs, Geom.line,Theme(default_color=color("green")))
)
```

###

The red one is the most exact, as we would expect. It is basically 8 operations.

The blue has *more* variability than the green. Why? More operations:

* $g$ has only $7$ multiplications -- $f$ has $9 + 8 + 7 + 6 + 5 + \dots + 2$.
* $f$ has large numbers $x^8$ with small numbers $1$ being added. This can cause loss of precision.

Moral $g$ is "better."

The method for $g$ is called "Horner's" method.

You may have seen it in synthetic division:

### Synthetic division

Evaluate the polynomial $f(x) = x^4 - 4x^3 + 6x^2 - 4x + 3$ at $x=2$. (The answer is $3$):

```
Verbatim("""
2  |  1  -4  6  -4  3
      .   2 -4   4  0 
   ------------------
      1  -2  2   0  3
""")
```

Notice, in the above the numbers are not large in any sense unlike $16 - 32 + 24 -8 + 3$.

###

The algorithm is on page 21: Writing $p(x) = a_nx^n + \cdots a_2 x^2 + a_1 x + a_0$ we have:

```
Verbatim("""
s = an
for i = n-1 to 0
   s = s*x + a_i
end
""")
```

The order is different, but in `Julia` there is a "macro" to do this:

```
@evalpoly(2, 3, -4, 6, -4, 1)
```

### Kahan summation

Kahan
[summation](https://en.wikipedia.org/wiki/Kahan_summation_algorithm)
is a means to compensate for the error when sums are made. Here is the basic algorithm:

```
function ksum(s, a, c)
  y = a - c
  t = s + y
  c = (t-s) - y
  s = t
  s, c
end
```

It *should* be that $t-s$ is $y$ and so $c=0$. But if $s$ is large and $y$ small, then there is a loss of precision. The value of $c$ adjusts for this:

* $(t-s)$ gets the high bits of $y$, subtracting $y$ from this sets $c$ to the *minus* the low bits of $y$. These are then subtracted off in the next step.


### Testing ...

```
xs = rand(10^7);
S = sum(map(big, xs)) |> x -> convert(Float64, x) ## using 256 bits
ss = 0.0; for i in 1:length(xs) ss = ss + xs[i] end
s = sum(xs)
ks, c = 0.0, 0.0
while(length(xs) > 0)
  ks,c = ksum(ks, shift!(xs), c)
end
S - ks, S-s, S - ss
```



## Addition of numbers and cumulative error

Errors accumulate. How big can they get???

> Theorem 1 (p49) relative error in $\sum_0^n x_i$ is $(1 + \epsilon)^n-1 \approx n\epsilon$.

Let $S_{k+1} = x_{k+1} + S_k$ be the partial sum and
$T_{k+1} = fl(x_{k+1} + T_k) = (x_{k+1}+ T_k)(1+\delta)$
be the floating point partial sum. What is the relative difference?

$$
\begin{align}
\frac{S_{k+1} - T_{k+1}}{S_{k+1}} &=
\frac{S_{k+1}(1+\delta) - T_{k+1} - S_{k+1}\delta}{S_{k+1}}\\
&= \frac{(S_k + x_{k+1})(1+\delta) - (T_k + x_{k+1})(1+\delta) - S_{k+1}\delta}{S_{k+1}}\\
&= (1 + \delta)\frac{S_k - T_k}{S_k} \cdot \frac{S_k}{S_{k+1}} - \delta
\end{align}
$$


Let $\rho_k$ be the absolute value. Since $|\delta| \leq \epsilon$, it follows that
with $\rho_0 = 0$:

$$
\rho_{k+1} \leq \rho_k(1+\epsilon) + \epsilon.
$$ 

This can be solved to yield: $\rho_n \leq (1 + \epsilon)^n - 1$.

### Other bounds

The maximal possible error for accumulating positive sums grows *linearly* with the number of sums.

If on average the summands are equally
likely to be negative as positive, then a square root of $n$ is the
growth.

Better algorithms are possible. Kahan summation is $\mathcal{O}(n\epsilon^2)$, so until $n \approx 1/\epsilon$ the errors are not noticeable. Though this method is a bit slow.

In Julia, [pairwise](https://en.wikipedia.org/wiki/Pairwise_summation)
summation is used. This has relative error given by $\epsilon
\log_2(n)$. For $n=10^7$, this is about $23 \epsilon$, so around `5e-15`.

## Accuracy of functions

Numbers may be approximate, so after applying a function the error can propagate. How much? Suppose $x$ is the real value and $\bar{x}$ is a machine approximation. Further, assume our function $f$ is perfectly defined and $C^1$. Then [why?]:

$$
f(x) - f(\bar{x}) = f'(\xi)(x - \bar{x}).
$$

The relative error divides this difference by $f(x)$ to get:

$$
|\frac{f(x) - f(\bar{x})}{f(x)}| = |x|\frac{f'(\xi)}{f(x)} \cdot |\frac{x - \bar{x}}{x}|.
$$

(Written to emphasize a factor times the relative error in the approximation to the number $x$.

### Redundant functions
In `Julia` there are many "redundant" functions:

* `sinpi` for computing $\sin(\pi x)$, `cospi`, ...
* `expm` to compute $e^x - 1$ for $x$ near 0
* `log1p` to compute $\log(1+x)$ near 0

The reason for `expm` seems clear. $e^x \approx 1 + x + x^2/2! + \cdot$, so $e^x-1$ for small $x$ is a subtraction of like-sized values.

###

For `log1p` [Cook](http://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/) if $x$ is really small, say $x=10^{-17}$ (`x < eps()`), then what happens to $1 + x$? In floating point it is 1. But $\log(1+x) \approx x$ by Taylor, so the absolute error is $x$ and the relative error $1$. Quite large. There are more floating point values closer to $0$ than $1$, so smaller values of $x$ can be used in `log1p`. 

In [What Every ...](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf) there is a theorem that this function

$$
\begin{cases}
x & \text{if } 1 \oplus x = 1\\
\frac{x \log(1+x)}{(1+x) - 1}& \text{ otherwise}
\end{cases}
$$

has relative error less than $5\epsilon$ when $0 \leq x \leq 3/4$ and ... (guard digit, $\log$ computed to within 1/2 ulp).

### 

What about `sinpi`? It is needed:

```
n = 10^8
sin(pi*n), sinpi(n)
```

Why? The definition of sine involves a reduction to the range $[0,2\pi]$. Let's just see:

```
divrem(pi * 10, 2pi)
```


```
divrem(pi * 10^8, 2pi)  ## 2e-8 from 2pi
```

Note though

```
divrem(10^8, 2)
```

### Case Study: The Log function

From `openlibm`

```
Verbatim("""

/* __ieee754_log(x)
 * Return the logrithm of x
 *
 * Method :                  
 *   1. Argument Reduction: find k and f such that 
 *			x = 2^k * (1+f), 
 *	   where  sqrt(2)/2 < 1+f < sqrt(2) .
 *
 *   2. Approximation of log(1+f).
 *	Let s = f/(2+f) ; based on log(1+f) = log(1+s) - log(1-s)
 *		 = 2s + 2/3 s**3 + 2/5 s**5 + .....,
 *	     	 = 2s + s*R
 *      We use a special Reme algorithm on [0,0.1716] to generate 
 * 	a polynomial of degree 14 to approximate R The maximum error 
 *	of this polynomial approximation is bounded by 2**-58.45. In
 *	other words,
 *		        2      4      6      8      10      12      14
 *	    R(z) ~ Lg1*s +Lg2*s +Lg3*s +Lg4*s +Lg5*s  +Lg6*s  +Lg7*s
 *  	(the values of Lg1 to Lg7 are listed in the program)
 *	and
 *	    |      2          14          |     -58.45
 *	    | Lg1*s +...+Lg7*s    -  R(z) | <= 2 
 *	    |                             |
 *	Note that 2s = f - s*f = f - hfsq + s*hfsq, where hfsq = f*f/2.
 *	In order to guarantee error in log below 1ulp, we compute log
 *	by
 *		log(1+f) = f - s*(f - R)	(if f is not too large)
 *		log(1+f) = f - (hfsq - s*(hfsq+R)).	(better accuracy)
 *	
 *	3. Finally,  log(x) = k*ln2 + log(1+f).  
 *			    = k*ln2_hi+(f-(hfsq-(s*(hfsq+R)+k*ln2_lo)))
 *	   Here ln2 is split into two floating point number: 
 *			ln2_hi + ln2_lo,
 *	   where n*ln2_hi is always exact for |n| < 2000.
 *
 * Special cases:
 *	log(x) is NaN with signal if x < 0 (including -INF) ; 
 *	log(+INF) is +INF; log(0) is -INF with signal;
 *	log(NaN) is that NaN with no signal.
 *
 * Accuracy:
 *	according to an error analysis, the error is always less than
 *	1 ulp (unit in the last place).
 *
 * Constants:
 * The hexadecimal values are the intended ones for the following 
 * constants. The decimal values may be used, provided that the 
 * compiler will convert from decimal to binary accurately enough 
 * to produce the hexadecimal values shown.
 */

#include "openlibm.h"
#include "math_private.h"

static const double
ln2_hi  =  6.93147180369123816490e-01,	/* 3fe62e42 fee00000 */
ln2_lo  =  1.90821492927058770002e-10,	/* 3dea39ef 35793c76 */
two54   =  1.80143985094819840000e+16,  /* 43500000 00000000 */
Lg1 = 6.666666666666735130e-01,  /* 3FE55555 55555593 */
Lg2 = 3.999999999940941908e-01,  /* 3FD99999 9997FA04 */
Lg3 = 2.857142874366239149e-01,  /* 3FD24924 94229359 */
Lg4 = 2.222219843214978396e-01,  /* 3FCC71C5 1D8E78AF */
Lg5 = 1.818357216161805012e-01,  /* 3FC74664 96CB03DE */
Lg6 = 1.531383769920937332e-01,  /* 3FC39A09 D078C69F */
Lg7 = 1.479819860511658591e-01;  /* 3FC2F112 DF3E5244 */

...
""")
```

## 2.3 Stable and unstable computations

The book gives an example of an iterative sequence:

$$
\begin{cases}
x_0 = 1, x_1=1/3&\\
x_{n+1} = 13/3 x_n - 4/3 x_{n-1} & (n \geq 1)
\end{cases}
$$

What happens as $n$ gets larger:

### Using exact fractions

```
xs = [1//1, 1//3]
for i in 1:15
   xn_1, xn = xs[end-1:end]
   push!(xs, 13//3 * xn - 4//3 * xn_1)
end
xs = map(float, xs)   
```

(Or you could solve $x_2 = 13/9 - 4/3 = 1/9$, $x_3 = 13/27 - 4/9 = 1/27$, ... $x_n=(1/3)^n$.)

### Float32

Using `Float32` like the book:

```
ys = [1.0, 1/3]
ys = [convert(Float32, y) for y in ys]
for i in 1:15
   yn_1, yn = ys[end-1:end]
   push!(ys, 13//3 * yn - 4//3 * yn_1)
end
[xs ys]
```

### Relative errors are way off:

```
[(x-y)/x for (x,y) in zip(xs, ys)]
```

### Float64

Using 64-bit floating point

```
zs = [1.0, 1/3]
for i in 1:15
   zn_1, zn = zs[end-1:end]
   push!(zs, 13//3 * zn - 4//3 * zn_1)
end
[xs ys zs]
```

### What happens?

Any error in $x_n$ is multiplied by $13/3$. So in particular, any error in $x_1$ is propagated to $x_n$ with a possible error of $(13/3)^n \delta$. So even if $\delta$ is small the possible error is big (and relative error even bigger):

```
(13/3)^15 * eps(Float32)
```

The same happens with 64 bits, just slower as the bounds on $\delta$ are smaller.

### What about different starting values?

Had the problem been started differently, say $x_0=1$, $x_1=4$. Then the error in $x_1$ is still propagated, but the relative error stays small, as the sequence grows as $4^n$ and does not decay like $(1/3)^n$:

```
ys = [1, 4+eps()]
ys = [convert(Float32, x) for x in xs]
for i in 1:15
   xn_1, xn = xs[end-1:end]
   yn_1, yn = ys[end-1:end]
   push!(xs, 13//3 * xn - 4//3 * xn_1)
   push!(ys, 13/3 * yn - 4//3 * yn_1)
end
xs = [4^(n-1) for n in 1:length(ys)]   
[(x-y)/x for (x,y) in zip(xs, ys)]
```

Yet the "error" is large.

### Case study: different approaches to the same problem lead to different answers...

Consider the case of computing $I_n = \int_0^1 x^n e^{-x}$. (Attributed to Forsythe, Malcom and Moler 1977). Using integration by parts gives:

$$
I_n = n I_{n-1} - 1/e
$$

Or reversing $I_{n-1} = 1/n (I_n + 1/e)$.

### forward solving

Starting with $I_0 = e - 1$ we can get $I_n$:

```
S = e - 1
for n in 1:50
  S = n * S - 1/e
end
S
```

All good, right?

###

Well, ...

```
using SymPy
n = 50
x = symbols("x")
integrate(x^n *exp(-x), (x, 0, 1)) |> N
```

The limit is ...

### What happens

From the expression $n I_{n-1}$,
any error is multiplied by $n$. So If $I_1$ is off by $\epsilon$, then $I_2$ is off by $2\epsilon$,
so $I_3$ is off by $3\cdot 2 \epsilon$, ... and $I_50$ is off by $50! \epsilon$. which is `3e64`.

Working backwards isn't the same issue as we have $1/n \cdot I_n$ so errors are multiplied by $1/n$ not $n$. So we would just need a starting point:

```
n = 60
S = integrate(x^n *exp(-x), (x, 0, 1)) |> N
for n in 60:-1:51
  S = 1/n * (S + 1/e)
end
S, integrate(x^50 *exp(-x), (x, 0, 1)) |> N
```

## Conditioning

Some algorithms perform well under certain inputs and poorly under others. When can you tell?

> Condition: how sensitive is a solution to small changes in the input?

> ill-conditioned: small changes can produce large changes.

> condition number: for some problems a numeric value can be assigned.

### Function evaluation

Suppose our "algorithm" is just $x \rightarrow f(x)$.

What is $f(x+h)$ for small $h$ *compared* with $f(x)$?

$$
\text{error} = f(x+h) - f(x) = f'(\xi) h, \quad \xi \text{ between $x$ and $x+h$}.
$$

The *relative error* is then

$$
\begin{align}
\text{relative error} &= \frac{f(x+h) - f(x)}{f(x)}\\
&= \frac{f'(\xi)h}{f(x)} \approx \frac{xf'(x)}{f(x)} \frac{h}{x}.
\end{align}
$$

### Example.

What is the condition number when evaluating $\sqrt(x)$ near $1/2$?

$$
\frac{x f'(x)}{f(x)} = \frac{x \cdot 1/\sqrt{x}}{\sqrt{x}} = 1
$$

So small.

### Evaluation of a root with *uncertainty* in the function

Think about a polynomial with floating point coefficients -- there is rounding.

Let $f(x)$ have a root $r$ and suppose $F(x) = f(x) + \epsilon g(x)$. Then suppose $F$ has a root $r+h$ (nearby, but effected by $\epsilon$. What is $h$? Assume both $f$ and $g$ have Taylor series so that:

$$
0 = F(r +h) = f(r) + f'(r)h + \mathcal(O)(h^2) + \epsilon \left( g(r) + g'(r)h + \mathcal(O)(h^2) \right)
$$

Dropping the big $\mathcal{O}$ term and using $f(r)=0$, gives:

$$
0 \approx f'(r)h + \epsilon g(r)  + \epsilon g'(r)g
$$

Or

$$
h \approx -\epsilon \frac{g(r)}{f'(r) + \epsilon g'(r)} \approx -\epsilon \frac{g(r)}{f'(r)}.
$$

### Wilkinson example

The Wilkinson polynomial is $f(x) = (x-1)(x-2) \cdots (x-20)$. Suppose, the coefficients are perturbed by $10^{-4}x^{20}$. ($\epsilon = 10^{-4}$ and $g(x) = x^{20}$. 

We have $g(20) = 20^{20}$. What is $f'(20)$? It is $(20-1)(20-2)
\cdots (20-19) = 19!$. (Why?) And so the condition number is

$$
-\epsilon \frac{20^{20}}{19!}
$$

With $\epsilon=10^{-4}$ this is:

```
1e-4 * 20.0^20 / factorial(19)
```

That is almost $10^5$! So a small perturbation in this problem *could* lead to dramatically different roots.

###

```
using Roots
p(x) = prod([x-i for i in 1:20])
roots(p) 
```




