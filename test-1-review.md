# Test 1 Review

## Chapter 1

Chapter 1 covered mathematical theorems from calculus and some definitions:

<li> The fundamental notions of a *limit*, *continuity*, and *differentiability*.

<li>A new hierarchy of functions was discussed, these being $C^k$, where this stands for functions which have $k$ continuous derivatives.

A an example of a $C^1$ function is $F(x) = \int_a^x f(u) du$ when $f$ is continuous. This example can be re-integrated to get examples of $C^k$ functions.

<li>The basic theorems of continuous and differentiable functions:

- The intermediate value theorem

- the extreme value theorem

- the mean value theorem. (We formulated this in an extended sense due to Cauchy.)

<li>The all important theorem of Taylor, written here in a slightly less powerful means:

> Let $f$ be a $C^{k+1}$ function on $[a,b]$. Let $a < c < b$ and $x$ be in $(a,b)$. Then there exists an $\xi$ between $c$ and $x$ satisfying:

$$
f(x) = T_k(x) + \frac{f^{(k+1)}(\xi)}{(k+1)!} (x - c)^{k+1},
$$

where $T_k(x) = f(c) + f'(c)(x-c) + \cdots + f^{(k)}(c)/k! \cdot (x-c)^k$.

$T_k$ is the Taylor polynomial of degree $k$ for $f$ about $c$.

There are other ways to write the remainder term, and somewhat relaxed assumptions on $f$ that are possible, but this is the easiest to remember.

A less precise, but still true, form of the above is:

$$
f(x) = T_k(x) + \mathcal{O}((x-c)^{k+1}).
$$

### Typical questions

<li>Suppose $f(x)$ is continuous on $[a,b]$ and $f(a) = -1$ while $f(b) = 3$. Which is guaranteed true and why?

- There exists a $\xi$ in $[a,b]$ with $f(\xi) = 0$.

- There exists a $\xi$ in $[a,b]$ with $f'(\xi) = 0$.

- There exists a $\xi$ in $[a,b]$ with $f'(\xi) \cdot (b-a) = f(b) - f(c)$.

<li>Prove that

$$
\lim_{h \rightarrow 0} \frac{f(x+h) - f(x-h)}{2h} = f'(x).
$$

What are the assumptions on $f$ used in your proof?

<li>Suppose $f(x)$ is $C^1$ on $[a,b]$. Why do you know that for any $\xi$ in $[a,b]$ you must have $|f(\xi)| \leq M$ for some $M$ that does not depend on $\xi$?

<li>The tangent line approximation for a function is just the function $T_1(x)$. Compute the tangent line approximation for the functions:

- $\sin(x)$ at $c=0$

- $\log(1+x)$ at $c=0$

- $1 / (1 + x)$ at $c=0$

- $\arctan(x)$ at $c=0$

<li>Find $T_5(x)$ for $c=0$ for each of

- $\sin(x)$

- $e^x$

<li>Use the above to find $T_5(x)$ for $e^{\sin(x)}$.

<li>In class we saw for $f(x) = \log(1+x)$ and $c=$ that to find $k$ such that if $0 \leq \xi \leq 1$ that

$$
\frac{f^{(k+1)}(\xi)}{(k+1)!} (x-0)^{k+1} \leq 2^{-53}
$$

We needed a *very large* value of $k$. What if we tried this over a smaller interval, say $0 \leq \xi \leq 1/2$, instead? How big would $k$ need to be then.

We used $f^{(k)}(x) = \pm 1 / (k (1+x)^k)$.

## Chapter 2

Chapter 2 deals with floating point representation of real numbers. Some basic things we saw along the way:

<li>integers can be exactly represented in binary.

- We saw how the non-negative integers $0, \dots, 2^n-1$ can fit in $n$ bits in a simple manner.

- We saw how the integers $-2^{n-1}, \dots, 0, \dots, 2^{n-1}-1$ can fit in $n$ bits using two's complements for the negative numbers. The advantage with this storage is fast addition and subtraction.

<li>We mentioned that in Julia, rational numbers can also be exactly represented, as integers can be.

<li>For real numbers, we mentioned that they are stored in floating point. The exact format depends on the amount of size dedicated to storage, with 64 bits being the typical  size now, though 32 was when the book was written.

The basic storage uses

- a sign bit

- $p$ bits to store the significand which is *normalized* to be $1.ddd\cdots d$.

- some bits to store the exponent, $e_{min} \leq m \leq e_{max}$.

and all this is put together to create the floating point numbers of the form

$$
\pm 1.ddddd\cdots d \cdot 2^m.
$$


<li>The floating point numbers are discrete. They are more spaced out as they get bigger, and more concentrated near $0$.

<li>There are some conventions:

- the sign bit comes first and uses `1` for minus, and `0` for plus.

- the exponent is stored as an unsigned integer ($0, \cdots 2^k - 1$) and there is an implicit bias to be subtracted. The value $000\cdots 0$ is special and used for $0.0$ (or $-0.0$) and subnormal numbers. The value $111\cdots 1$ is used for `Inf`, `-Inf` and various types of `NaN`.

- the significand has an implicit $1$ in front, except for the special numbers `0`, `Inf`, and `NaN`.

<li>We use $fl(x)$ to be the floating point number that $x$ rounds to. A key formula is

$$
fl(x) = x(1 + \delta)
$$

What is $\delta$? Some number between $-\epsilon$ and $\epsilon$. What is $\epsilon$? Good question.

<li>we define $\epsilon$ or `eps` through $\epsilon = 1^+ - 1$, where $1^+$ is the next largest floating than $1$. We saw $\epsilon = 2^{-p}$.

<li>The basic math operations with floating point numbers satisfy: $fl(x \odot y) = (x \odot y)(1 + \delta)$.

<li>The basic math operations do *not* satisfy some common properties: associativity and commutativity.

<li>*However*, relative errors can be a problem when rounding is involved.

- We saw that if $x$ and $y$ are real numbers, that the relative error of the floating point result of $x-y$ can be large if $x$ is close to $y$

- We saw a theorem that says even if there is no rounding error, the subtraction of $y$ from $x$ can introduce a loss of precision. Basically, if $x$ and $y$ agree to $p$ binary digits, then a shift is necessary of $p$ units. More concretely: if $x > y > 0$ and $1 - y/x \leq 2^{-p}$ then at least $p$ significant binary bits are lost in forming $x-y$.

- We saw that if possible we should avoid big numbers, as the errors are then possibly  bigger. (Why the book suggests finding $(a+b)/2$ as $a + (b-a)/2$.)

- We saw that when possible we should cut down on the operations used. (One reason why Horner's method for polynomial evaluations is preferred.)

- We saw that errors can accumulate. In particular we discussed this theorem:

> If $x_i$ are positive, the relative error in a nieve summation of $\sum x_i$ is $\mathcal{O}(n\epsilon)$.

<li>We saw that there are times where trivial functions mathematically speaking are necessary.

<li>We saw that errors can propagate quickly. The book has the example of $x_{n+1} = 13/3 x_n - 4/3 x_{n-1}$ which numerically diverges from the true quickly with 32 bit usage.

<li>We saw that some problems lend themselves to a condition number. There were two examples

- evaluation of function when the input is uncertain. That is we evaluate $f(x+h)$ when we want to find $f(x)$. (It could be $x + h = x(1+\delta)$, say. For this we have

$$
\frac{f(x+h) - f(x)}{f(x)} \approx \frac{x f'(x)}{f(x)} \cdot \frac{h}{x},
$$

Or the relative error in the image is the relative error in the domain times a factor $xf'(x)/f(x)$.

- evaluation of a perturbed function (which can happen with polynomials that have rounded coefficients). For this, we have $F(x) = f(x) + \epsilon g(x)$. The example we had is if $r$ is a root of $f$ and $r+h$ is a root of $F$. What can we say about $h$? We can see that

$$
h \approx -\epsilon g(r)/f'(r)
$$

Which can be big. The example in the book uses the Wilkinson polynomial and $r=20$. (The Wilkinson polynomial actually is exactly this case, as there is necessary rounding to get its coefficients into floating point.

### Some sample problems

<li>Suppose our decimal floating point system had numbers of the form $\pm d.dd \cdot 10^m$.

- If $1 = 1.00 \cdot 10^2$. What is $\epsilon$?

- What is $3.14 \cdot 10^0 - 3.15 \cdot 10^0$?

- What is $4.00 \cdot 10^0$ times $3.00 \cdot 10^1$?

- What is $\delta$ (where $fl(x \cdot y) = (x\cdot y)\cdot (1 \cdot \delta)$) when computing $1.23 \cdot 10^4$ times $4.32 \cdot 10^1$?

<li>Suppose our binary floating point system has numbers of the form $\pm 1.pp \cdot 2^m$ where $-2 \leq m \leq 1$.

- How many total numbers are representable in this form ($0$ is not)?

- What is $\epsilon$?

- what is $1.11 \cdot 2^1 - 1.00 \cdot 2^0$?

- Convert the number $-1.01 \cdot 2^{-2}$ to decimal.

- Let $x=1.11 \cdot 2^0$ and $y=1.11 \cdot 2^1$. Find $\delta$ in $fl(x \cdot y) = (x \cdot y)(1 + \delta)$.

<li> The answer to a famous question is coded in `0101000101000000`. The first bit, `0` is the sign bit, the exponent `10100` and significant `0101000000`). Can you find the number? Remember the exponent is encoded and you'll need to subtract `01111` then convert.



<li>Use Horner's method (or synthetic division) to compute $p(x) = x^3 + 2x^2 + 3x^3 + 1$ at $x=2$.

<li>The direct definition of $\sinh(x) = (e^x - e^{-x})/2$ is not how it is actually computed. In particular, for $0 \leq x \leq 22$, the following is used where `E = expm1(x)` is the more precise version of $e^x - 1$:

$$
(1/2) \cdot E +  E/(E+1)
$$

Can you think of why the direct approach might cause issues for some values of $x$ in that range?

<li>Express the following in a different manner mathematically so that the issue of loss of precision is avoided:

- $\log(x) - \log(y)$

- $x^{-3} (\sin(x) - x)$

- $\sin(x) - \tan(x)$.

<li>The computation $y = \sqrt{x^2 + 1} -1$ is to be computed. For what values of $x$ are you guaranteed that no more than 2 bits of precision will be lost? (Why is solving $\sqrt{x^2+1}/1 = 2^{-2}$ of any interest?)

<li>The for $\xi$ between $0$ and $x$ we have $x - \sin(x) = x^3/3! - x^5/5! + x^7/7! + \cdot + (-1)^k x^{2k-1}/(2k-1)! + (-1)^{k+1}(\xi)^{2k+1}/(2k+1)!$

What value of $k$ will ensure that the error over $[0, 1/4]$ is no more than $10^{-3}$?

<li>If $fl(xy) = xy\cdot(1 + \delta)$, where $\delta$ depends on the value of $x$ and $y$, show that

$$
fl(fl(xy)\cdot z) \neq fl(x \cdot fl(yz))
$$

That is, floating point multiplication is not associative. You can verify by testing `(0.1 * 0.2)*0.3` and `0.1 * (0.2 * 0.3)`.

<li>Show that $fl(x^3) = x^3(1 + \delta)^2$ where $|\delta| \leq \epsilon$.

<li>True of false? For a fixed $x$, a floating point number. We expect the following to converge to $f'(x)$?

$$
\lim_{n\rightarrow\infty} \frac{fl(f(x+10^{-n})) + fl(f(x))}{10^{-n}}
$$

That is, if you computed the difference quotient, $(f(x+h)-f(x))/h$ in floating would you expect smaller and smaller values of $h$ would converge. Why?

<li>True of false. Suppose $p > q > 0$ are floating point numbers with $1/2 \leq p/q \leq 2$. Then $p-q$ is a floating point number also (unless it is too small).

<li>Show with a *rough* proof that the error in $\log(y(x))$ is about the *relative error* of $y(x)$, that is

$$
\log(y(x+h)) - \log(y(x)) \approx \frac{y(x+h) - y(x)}{y(x)}.
$$

## Chapter 3 -- solving f(x) = 0

TBA
