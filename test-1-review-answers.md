# Test 1 Review

## Chapter 1

### Typical questions

<li>Suppose $f(x)$ is continuous on $[a,b]$ and $f(a) = -1$ while $f(b) = 3$. Which is guaranteed true and why?

- There exists a $\xi$ in $[a,b]$ with $f(\xi) = 0$.

ANS: TRUE, IVT

- There exists a $\xi$ in $[a,b]$ with $f'(\xi) = 0$.

ANS: FALSE, smells like mean value theorem, but isn't

- There exists a $\xi$ in $[a,b]$ with $f'(\xi) \cdot (b-a) = f(b) - f(a)$.

ANS: FALSE, though *if* we assumed $f'(x)$ exists, then this is the mean value theorem.

<li>Prove that

$$
\lim_{h \rightarrow 0} \frac{f(x+h) - f(x-h)}{2h} = f'(x).
$$

What are the assumptions on $f$ used in your proof?

ANS: Did this in class  assuming $C^2$,  and using the following to solve for $f'(x)$:

$$
f(x+h) = f(x) + f'(x)h + \mathcal{O}(h^2),
f(x-h) = f(x) - f'(x)h + \mathcal{O}(h^2),
$$


<li>Suppose $f(x)$ is $C^1$ on $[a,b]$. Why do you know that for any $\xi$ in $[a,b]$ you must have $|f(\xi)| \leq M$ for some $M$ that does not depend on $\xi$?

ANS: This is the extreme value theorem which says also that $M=f(\xi)$ for some $\xi$.

<li>The tangent line approximation for a function is just the function $T_1(x)$. Compute the tangent line approximation for the functions:

ANS: This is just $f(c) + f'(c)(x-c)$:

- $\sin(x)$ at $c=0$

ANS: $\sin(c) + \cos(c)(x-c) = x$


- $\log(1+x)$ at $c=0$

ANS: $\log(1) + 1/(1+0) \cdot (x-0) = x$

- $1 / (1 + x)$ at $c=0$

ANS: $1/(1+0) + (-1)/(1+0)^2 x = 1 - x$

- $\arctan(x)$ at $c=0$

ANS: $\arctan(0) + 1/(1+0^2)x = x$



<li>Find $T_3(x)$ for $c=0$ for each of

ANS: did in class using composition. Here we use the computer:

- $\sin(x)$


```
using SymPy
x = symbols("x")
series(sin(x), x, 0, 3)
```



- $e^x$

```
series(exp(x), x, 0, 3)
```

<li>Use the above to find $T_3(x)$ for $e^{\sin(x)}$.

ANS: We compose the last two answers, but could do this directly, as with:

```	
series(exp(sin(x)), x, 0, 3)
```


<li>In class we saw for $f(x) = \log(1+x)$ and $c=$ that to find $k$ such that if $0 \leq \xi \leq 1$ that

$$
\frac{f^{(k+1)}(\xi)}{(k+1)!} (x-0)^{k+1} \leq 2^{-53}
$$

We needed a *very large* value of $k$. What if we tried this over a smaller interval, say $0 \leq \xi \leq 1/2$, instead? How big would $k$ need to be then.

We used $f^{(k)}(x) = \pm 1 / (k (1+x)^k)$.

ANS: We plug in and need to bound:

$$
|\pm 1| \cdot \frac{1}{(k+1)(k+1)!} \cdot \frac{1}{(1+\xi)^{k+1}} \cdot x^{k+1}
$$

Taking $x=1/2$, we can bound this with

$$
\frac{1}{(k+1)(k+1)!} \cdot 1 \cdot (1/2)^{k+1}
$$

Solving with the computer we get 13, as $2^{-53} = 1.11\dots \cdot 10^{-16}$ and:

```
f(k) = 1/(k+1)/factorial(k+1) * (1/2)^(k+1)
xs = 1:15
ys = map(f, xs)
[xs ys]
```

## Chapter 2
### Some sample problems

<li>Suppose our decimal floating point system had numbers of the form $\pm d.dd \cdot 10^m$.

- If $1 = 1.00 \cdot 10^2$. What is $\epsilon$?

ANS: `1.01 - 1.00 = .01 = 10^(-2)`. 

- What is $3.14 \cdot 10^0 - 3.15 \cdot 10^0$?

ANS: `1.00 10^(-2)`. (The 0's come from needing to pad things out.)

- What is $4.00 \cdot 10^0$ times $3.00 \cdot 10^1$?

ANS: `12 * 10^(0+1) = 1.20 * 10^2`


- What is $\delta$ (where $fl(x \cdot y) = (x\cdot y)\cdot (1 \cdot \delta)$) when computing $1.23 \cdot 10^4$ times $4.32 \cdot 10^1$?


ANS: did this in class: `x*y = 531360.0 = 5.31360 * 10^5` And `fl(x*y) = 5.31 * 10^51`. The value of $\delta$ then would satisfy:
$1 + \delta = 5.31 / 5.31360$, or $-0.00068$.

<li>Suppose our binary floating point system has numbers of the form $\pm 1.pp \cdot 2^m$ where $-2 \leq m \leq 1$.

- How many total numbers are representable in this form ($0$ is not)?

ANS: we have $pp$ can be `00`, `01`, `10`, or `11` and `m` is only one of 4 values and $\pm$ one of 2, so the answer is $2\cdot 4\cdot 4$.


- What is $\epsilon$?

ANS =`1+ = 1.01 * 2^0`, so `1+ - 1` is $2^{-2}$.

- what is $1.11 \cdot 2^1 - 1.00 \cdot 2^0$?

ANS: `1.11 * 2^1 - 0.10 * 2^1 = 1.01 * 2`

- Convert the number $-1.01 \cdot 2^{-2}$ to decimal.

ANS:

```
-(1 + 0*(1/2) + 1 *(1/4)) * 1/2^2
```

- Let $x=1.11 \cdot 2^0$ and $y=1.11 \cdot 2^1$. Find $\delta$ in $fl(x \cdot y) = (x \cdot y)(1 + \delta)$.

ANS: `(1.11 * 2^0) * (1.11 * 2^1) = 11.0001 * 2^1 = 1.10001 * 2^2`. In this floating point it is only `1.10 * 2^2`.  So we have:

`1.10001 / 1.10 - 1 = (.0001) / (1.10) = 1.00/1.10 * 2^(-4)`. Which is less than $\epsilon$.


<li> The answer to a famous question is coded in `0101000101000000`. The first bit, `0` is the sign bit, the exponent `10100` and significand `0101000000`). Can you find the number? Remember the exponent is encoded and you'll need to subtract `01111` then convert.

ANS: We have the sign bit is 0, so the number is postive. The significand is $1 + 1/4 + 1/16 = 1.3125$.
The exponent is `10100 - 01111` is just $(16 +4) - (8 + 4 + 2 + 1) = 5$. The significand is $1 + 1/4 + 1/16$. So all told, we get:

```
2^5 * ( 1 + 1/4 + 1/16)
```



<li>Use Horner's method (or synthetic division) to compute $p(x) = x^3 + 2x^2 + 3x^3 + 1$ at $x=2$.

ANS: Horners method is:

```
x = 2
((1*x + 2)*x + 3)*x + 1
```

<li>The direct definition of $\sinh(x) = (e^x - e^{-x})/2$ is not how it is actually computed. In particular, for $0 \leq x \leq 22$, the following is used where `E = expm1(x)` is the more precise version of $e^x - 1$:

$$
(1/2) \cdot E +  E/(E+1)
$$

Can you think of why the direct approach might cause issues for some values of $x$ in that range?

ANS: Near $x=0$ we have subtraction of like-sized quantities. This
is a possible source of error. The new expression doesn't involve
that. It has issues near $x=0$ that are addressed by using `expm`.

<li>Express the following in a different manner mathematically so that the issue of loss of precision is avoided:

- $\log(x) - \log(y)$

ANS: Use $\log(x/y)$ to avoid issues if $x$ and $y$ are close

- $x^{-3} (\sin(x) - x)$

ANS: Using taylor, we see if $xS$ is close to $0$ that this is just $x^{-3}\cdot(-x^3/3!) = 1/6$. 

- $\sin(x) - \tan(x)$.

ANS: The issue is near $0$, we have the difference in tangent line expressions is $x - x^3/3! + \mathcal{O}(x^5)$ and $x - x^3/3 + \mathcal{O}(x^5)$ so near $0$ we could use $-x^3/2$.

<li>The computation $y = \sqrt{x^2 + 1} -1$ is to be computed. For what values of $x$ are you guaranteed that no more than 2 bits of precision will be lost? (Why is solving $\sqrt{x^2+1}/1 = 2^{-2}$ of any interest?)

ANS: We had the theorem in class that said if $2^{-q} \leq 1 - y/x$ than at most $q$ binary bits are lost. So we have to solve for $x$ which makes $2^{-2} = 1 - 1/\sqrt{x^2 + 1}$. Being lazy, we have

```
using SymPy
u  = symbols("u")
solve(1 - 1/sqrt(u^2 + 1) - 1/4, u)
```



<li>The for $\xi$ between $0$ and $x$ we have $x - \sin(x) = x^3/3! - x^5/5! + x^7/7! + \cdot + (-1)^k x^{2k-1}/(2k-1)! + (-1)^{k+1}(\xi)^{2k+1}/(2k+1)!$

What value of $k$ will ensure that the error over $[0, 1/4]$ is no more than $10^{-3}$?

ANS: The error term is the last term:

$$
|(-1)^{k+1}(\xi)^{2k+1}/(2k+1)!| = (\xi)^{2k+1} \cdot \frac{1}{(2k+1)!} \leq (1/4)^{2k+1} \cdot \frac{1}{(2k+1)!}.
$$

What $k$'s make this less that $10^{-3}$? We check with the computer:

```
f(k) = (1/4)^(2k+1) * 1/factorial(2k+1)
f(1), f(2)
```

So $k=2$ works.

<li>If $fl(xy) = xy\cdot(1 + \delta)$, where $\delta$ depends on the value of $x$ and $y$, show that

$$
fl(fl(xy)\cdot z) \neq fl(x \cdot fl(yz))
$$

That is, floating point multiplication is not associative. You can verify by testing `(0.1 * 0.2)*0.3` and `0.1 * (0.2 * 0.3)`.


ANS: Suppose $x$, $y$ and $z$ are floating point numbers. Then $fl(xy) = xy(1+\delta_1)$ and $fl(yz) = yx (1 + \delta_2)$ where both delta's are small but need not be the same. So the left hand side is:

$$
xy(1+\delta_1) \cdot z (1 + \delta_3) = xyz(1 + \delta_1)\cdot(1+\delta3)
$$

Whereas the right hand side is:

$$
x(yz(1+\delta_2))(1+\delta_4) = xyz (1+\delta_2)\cdot (1+\delta_4)
$$

Since the $\delta$'s can't be assumed equal, the answers aren't the same.

<li>Show that $fl(x^3) = x^3(1 + \delta)^2$ where $|\delta| \leq \epsilon$.

ANS: did this in class. Basically, we get $fl(x^3) = x^3(1+\delta_1)(1+\delta_2)$ and we can write this as $x^3(1+\delta)^2$.

<li>True of false? For a fixed $x$, a floating point number. We expect the following to converge to $f'(x)$?

$$
\lim_{n\rightarrow\infty} \frac{fl(f(x+10^{-n})) + fl(f(x))}{10^{-n}}
$$

That is, if you computed the difference quotient, $(f(x+h)-f(x))/h$ in floating would you expect smaller and smaller values of $h$ would converge. Why?

ANS: NO! We get $fl(f(x+h))$ is basically $f(x+h)(1+\delta)$ and $fl(f(x)) = f(x)(1+\delta_2)$. So all told, the difference in the top is

$$
f(x + h) - f(x) + f(x+h) \cdot \delta_1- f(x) \cdot \delta_2 = f(x + h) - f(x) + c\delta,
$$

where $c$ is some constant that we don't make precise, as the point is to point out that there can be an error of size constant time $\delta$. This is small, but is a problem as its size does not depend on $h$. If we let $h$ "go to " zero, the error is $c\delta/h$ which gets large.



<li>True of false. Suppose $p > q > 0$ are floating point numbers with $1/2 \leq p/q \leq 2$. Then $p-q$ is a floating point number also (unless it is too small).

ANS. This is a bit tricky. Let $p=1.dddd...d 2^m = r2^m$ and $q=1.eeee...e 2^n = s2^n$. As $q < p$ we have two cases:

If $n=m$, then we have $r > s$ and we can just subtract to get a number bigger than 0 that is precise. So we can shift the answer and not lose information.

Otherwise $n=m-1$ (because $p/q > 1/2$.) This forces $s > r$, but that isn't quite the answer, as we really need to look at

$$
p -q = r2^m - s2^(m-1) = r2^m - (s/2)2^m = (r - s/2) 2^m.
$$

If $r - s/2$ is less than $1$ then a shift is needed. In this case
this is a good thing, as the only place there can be an issue is the
last bit that needs accounting for when we have to shift $s$ to form
$s/2$.  But, as $r < s$, $r - s/2 \geq r - r/2 = r/2 < 1$, as $r < 2$.

<li>Show with a *rough* proof that the error in $\log(y(x))$ is about the *relative error* of $y(x)$, that is

$$
\log(y(x+h)) - \log(y(x)) \approx \frac{y(x+h) - y(x)}{y(x)}.
$$

ANS: using the derivative, $[\log(y(x))]' = y'(x)/y(x)$ we get from a first order taylor expansion:

$$
\log(y(x+h)) - \log(y(x)) \approx y'(x)/y(x) \cdot h.
$$

But $y'(x) \approx (y(x+h) - y(x))/h$, so the above becomes:

$$
y'(x)/y(x) \cdot h \approx \frac{y(x+h) - y(x)}{h} \cdot \frac{1}{y(x)} \cdot h = \frac{y(x+h) - y(x)}{y(x)}.
$$

## Chapter 3 -- solving f(x) = 0

### Some sample problems

* Let $f(x) = x^2 - 2$. Starting with $a_0, b_0 = 1, 2$, find $a_4, b_4$. We *could* do this by hand. Here we type:


```
a0, b0 = 1//1, 2//1
c0 = (a0 + b0)/2 ## f(c0) >0

a1,b1 = a0, c0
c1 =  (a1 + b1)/2 ## f(c1) < 0

a2, b2 = c1, b1
c2 =  (a2 + b2)/2 ## f(c1) < 0

a3, b3 = c2, b2
c3 =  (a3 + b3)/2 ## f(c1) > 0

a4, b4 = a3, c3
c4 =  (a3 + b3)/2

a4,b4, c4,  abs(sqrt(2) - c4) <= 1/2^5*(b0 - a0)
```

* Let $e_n$ be $c_n - c$. The order of convergence of $c_n$ is  $q$ provided

$$
\lim_n \frac{e_{n+1}}{e_n^q} = A
$$

Using the bound above, what is the obvious guess for the order of convergence?

ANS: If we had $e_n = 2^{n+1}(b_0 - a_0)$ we would have exactly:

$$
\frac{e_{n+1}}{e_n} = \frac{2^{n+2}(b_0 - a_0)}{2^{n+1}(b_0 - a_0)} = \frac{1}{2}.
$$

So it looks like $q=1$ is right, or the convergence is linear.

* Explain why the bisection method is no help in finding the zeros of $f(x) = (x-1)^2 \cdot e^x$.

ANS: the function doesn't cross $0$, so we can't find $a_0$, $b_0$.

* In floating point, the computation of the midpoint via $(a+b)/2$ is discouraged and using $a + (b-a)/2$ is suggested. Why?

ANS: the errors follow $fl(a+b) = (a+b)(1+\delta)$, so if $a$ and $b$ are big, then the error $fl(a+b) - (a+b) = (a+b)(1+\delta)$ is bigger. 

* Mathematically if $a < b$, it always the case that there exists a $c = (a+b)/2$ and $a < c < b$. Is this also *always* the case in floating point? Can you think of an example of when it wouldn't be?

ANS. No. If $a=1^+$ and $b=1$, then we can't fit a value in between.

* To compute $\pi$ as a solution to $\sin(x) = 0$, one might use the bisection method with $a_0, b_0 = 3,4$. Were you to do so, how many steps would it take to find an error of no more than $10^{-16}$?

ANS: We saw that we need to solve for $n$ with


$$
2^{-(n+1)} (b_0 - a_0) \leq 10^{-16}
$$

This gave:

$$
n \geq  16 \cdot \frac{\log(10)}{\log(2)} - 1
$$

Or in this case

```
p = 16
ceil(p * log(10)/log(2) - 1)
```

* A simple zero for a function $f(x)$ is one where $f'(x) \neq 0$. Some algorithms have different convergence properties for functions with only simple zeros as compared to those with non-simple zeros. Would the bisection algorithm have a difference?

ANS: Well, yes and no. The error bound doesn't depend on $f'(x)$ so the answer is no. However, when a zero is not simple, the function may not cross the $x$ axis. That can be an issue.

* If you answered yes above, you could still be right, even though
  you'd be wrong mathematically (Why? look at the bound on the error
  and the assumptions on $f$.). This is because for functions with non
  simple zeros, you can have a lot of numeric issues creep in. The
  book gives an example of the function lie $f(x) = (x-1)^5$. Explain what
  is going on with this graph near $x=1$:

```
using Gadfly
f(x) = x^5 - 5x^4 +10x^3 -10x^2 + 5x -1
plot(f, 0.999, 1.001)
```

ANS: The floating point computation has a lot of error, as we aren't doing it exactly (or efficiently). Roughly we have

$$
fl(f(x)) = f(x) + \mathcal{O}(\epsilon )
$$

Suppose $x<1$ but close to $1$. When $f(x)$ is near $0$, the error term -- which may be positive or negative -- can push the floating point value above  the $x$ axis even though the mathematical part, $f(x)<0$.
