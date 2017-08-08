# Review for test 3

Review questions for test 3. Some edits made 12/13. Test 3 will now only cover chapters 6-8

## Ch 6: Polynomial Interpolation

The main goal: if we have points $(x_0, y_0), \dots, (x_n, y_n)$ where $y_i = f(x_i)$, can we approximate the function $f(x)$ with a polynomial $p(x)$?

> Thm: if the $x_i$'s are distinct, then there is a *unique* polynomial of degree $n$ with $p(x_i) = y_i$.

There are two different ways to write this:

* Newton form: $p_n(x) = \sum_{i=0}^n c_i \prod_{j=0}^{i-1} (x - x_j)$. We saw that the constants can be written in terms of divided differences: $c_i = f[x_0, x_1, \dots, x_i]$.

* Lagrange form: $p_n(x) = \sum y_k l_k(x)$. We mentioned that the $l_k$ can be written in a terms of a product:

$$~
l_i(x) = \prod_{j=0, j \neq i}^n \frac{x - x_j}{x_i - x_j}.
~$$

The Newton form represents $p$ in terms of polynomials of degree $i$ whereas the Lagrange form has terms all of degree $n$.


### Error:

$$~
f(x) - p_n(x) = \frac{1}{(n+1)!} f^{(n+1)}(\xi) \prod_{i=0}^n (x - x_i)
~$$

This gives a bound on the error.


### Convergence

Even if it is true that for each $x$, $f(x) - p_n(x) \rightarrow 0$ it need not be the case that $\|f - p_n\|_\infty = max_{a \leq x \leq b}|f(x) - p_n(x)| \rightarrow 0$. As we saw on the computer there can be wild oscillations near the edges in $p_n$. In fact: if the interpolation points are evenly spaced the interpolating polynomials become unbounded.

### HW Problems

6.1: 1, 2, 12


6.2: 4, 12, 13 (n=1 only)


## Ch7: Numeric differentiation and Integration

Again, we have a table of function values $(x_0, y_0), \dots, (x_n, y_n)$ where $y_i = f(x_i)$, What can we say about the derivate of $f$? The integral of $f$?

We had a basic scheme:

* Find $p_n(x)$ an interpolating polynomial
* Find $p_n'(x)$ of $\int_a^b p_n(x)dx$.
* Approximate the desired answer by the computed answer.
* Assess the error

### Differentiation

For differentiation it was mentioned that if we applied the above to points $x$, $x-h$ and $x_h$, we would get the central difference formula:

$$~
f'(x) \approx \frac{f(x+h) - f(x-h)}{2h}.
~$$

The forward difference equation is $(f(x+h) - f(x))/h$.

The error in the approximation -- when done on the computer -- has two sources of error:

* truncation error -- what happens when using an approximate polynomial of degree $n$ and not an infinite series
* floating point error -- resulting from putting the problem on the computer

For the forward difference, the truncation error is *roughly* $\mathcal{O}(h)$, whereas the floating point error is $\mathcal{O}(\delta/h)$. So there needs to be a balance if using: take $h$ small enough so the truncation error isn't large but not *too* small so that the floating point error isn't large.

The central difference has similar floating point error, but truncation error like $\mathcal{O}(h^2)$.  (It is basically $f'''(\xi)/6h^2$.)

We mentioned automatic differentiation, but this won't be on the test.

## Integration

The process of approximating $f$ by $p$ and integrating $p$ leads to 3 familar concepts:

* The Riemann sum is when $n=0$, or using a constant for interpolation
* The trapezoid rule is when $n=1$, or using a linear polynomial for interpolation
* Simpson't rule is when $n=2$, that is a polynomial is used for interpolation

Rather than globally approximate $[a,b]$ with just a few points, what is done if that interval is partitioned and on each subpartition the approximation is used. With this we saw errors, $\int_a^b f(x) dx - \int_a^b p_n(x) dx$, given by

* Riemann $(b-a)^2/n)$
* Trapezoid $-1/12f''(\xi)(b-a)^3/n^2$
* Simpsons $-1/180 f''''(\xi)(b-a)^5/n^4$


### Generalized

The expression $\int_a^b p_n(x)dx$ can be written differently taking LaGrange's form for polynomial interpolation:

$$~
\int_a^b f(x) dx \approx
\int_a^b p_n(x) dx - \int_a^b \sum_{k=0}^n f(x_k) l_k(x) dx
= \sum_{k=0}^n f(x_k) \int_a^b l_k(x)dx = \sum_{k=0}^n f(x_k) A_k.
~$$

The points $x_k$ are called the *nodes* and the terms $A_k$ the *weights*. Both can be precomputed, as they do not depend on $f$.


The main use here are quadrature formulas:

> (p493) Let $w$ be a positive weight function (like $w(x) = 1$) and let $q$ be a non-zero polynomial of degree $n+1$ that is $w$-orthogonal to the space of polynomials of degree $n$ or less. Then If $x_0, x_1, \dots, x_n$ are the zeros of $q$, the quadrature formula derived by using these zeros as the nodes and used in the weight computation will be *exact* for any polynomial of degree $2n+1$ or less.

We saw one family of orthogonal polynomials, those when $w=1$. These were the Legendre polynomials satisfying the recursion:

$$~
P_0(x) = 1, \quad P_1(x) =x, \quad (n+1)P_{n+1}(x) = (2n + 1) x P_n(x)  - n P_{n-1}(x).
~$$


### Error

If we defined

$$~
\int_a^b f(x) w(x) dx = \sum_{i=0}^n A_i f(x_i) + E
~$$

Then for $f$ in $C^{2(n+1)}([a,b])$ the error can be written as:

$$~
E = \frac{1}{(2n)!} f^{(2(n+1))}(\xi) \int_a^b (\prod(x-x_i))^2 w(x) dx
~$$

### Questions

7.1 6 (for $f'(x)$ only),

7.2: 1, 2, 27 (using 26 as given)

7.3: 3, 6

* The Gauss weights and nodes for $n=3$ are given by:

```
nodes = [-sqrt(3 / 5), 0.0, sqrt(3 / 5)]
weights = [5 // 9, 8 // 9, 5 // 9]
```

Use these to estimate $\int_{-1}^1 \sin(x) dx$.

Use the error term and the fact that $|f^{(2n)}(\xi) |<1$ to estimate the error.


## Chapter 8. Differential Equations

The IVP (initial value problem) is a specification about a function $x(t)$ through a relation involving its derivative at time $t$:

$$~
x'(t) = f(t, x), \quad x(t_0) = x_0
~$$

In 8.1, we see that an IVP may not have an answer for all $t$; it may not have an answer at all; and if it does have an answer, it may not be unique.

There are theorems which will vouch for uniqueness and existence:

> Thm 1. Existence theorem

If $f$ is *continuous* on a rectangle centered at $(t_0, x_0)$, say:

$$~
R = \{ (t,x) : |t - t_0| \leq \alpha, |x - x_0| \leq \beta \}.
~$$

Then the inital value problem has a solution $x(t)$ for $|t - t_0| \leq min(\alpha, \beta/M)$ where $M$ maximizes $|f|$ in $R$.


> Thm 2 (p526). If both $f$ and $\partial f/\partial x$ are *continuous* in R, then there is a unique solution for $|t - t_0| \leq min(\alpha, \beta/M)$


> Thm 3 If f is Lipshitz then the intial value problem will have a unique solution in some interval.

Precisely, if $f$ is continuous on the strip $a \leq t\leq b$ and $x \in (-\infty, \infty)$ *and* satisfies the inequality for a fixed $L$:

$$~
| f(t,x_1) - f(t, x_2) | \leq L | x_1 - x_2|
~$$

then the solution exists on the interval $[a,b]$.

----

The last two give conditions on $f$ that guarantee an answer exists and is unique, at least for some values of $t$.

### Euler's method

The granddaddy of all methods to numerically approximate the solution to an IVP is Euler's method:

From a sequence of time steps $t_i = t_0 +  ih$, where $h$ is the small time step, Euler's method defines a sequence of $x_i$ values through

$$~
x_{i+1} = x_{i} + f(t_i, x_i)
~$$

The approximate local truncation error at each step is like $\mathcal{O}(h^2)$, so if things are nice, the global truncation error will be like $\mathcal{O}(h)$, when the number of steps is basically $1/h$.

### Taylor methods

The Euler method can be derived by starting with a Taylor series:

$$~
x(t + h) = x(t) + x'(t)h + x''(t)/2 \cdot h^2 + \cdots + x^{(n)}(t)/n! \cdot h^n + \mathcal{O}(h^{n+1})
~$$

Then truncating at the first order. As the IVP defines $x'(t)$ in terms of $f$, Euler's method is nothing more than the tangent line approximation.

Using more terms can be done by differentiating, though that gets tricky.


### Runge-Kutte methods

The Runge - Kutte methods generalize Euler's method by adding various combinations of the approximations for $f$. The two discussed in class were:

* Heun's method where

$$~
\begin{align}
x_{n+1} &= x_n + \frac{1}{2} F_1 + \frac{1}{2} F_2, \text{ where}\\
F_1(x) &= h\cdot f(t, x)\\
F_2(x) &= h\cdot f(t+h, F_1)
\end{align}
~$$

This has  local truncation errors of $\mathcal{O}(h^3)$


* The fourth order method


$$~
\begin{align}
x_{n+1} &= x_n + \frac{1}{6}( F_1 + 4F_2 + 4F_3 + F_4), \text{ where}\\
F_1 &= h\cdot f(t_n, x_n)\\
F_2 &= h\cdot f(t_n+h, F_1/2)\\
F_3 &= h\cdot f(t_n+h, F_2/2)\\
F_2 &= h\cdot f(t_n+h, F_3)\\
\end{align}
~$$

This has  local truncation errors of $\mathcal{O}(h^5)$.

### Multistep methods


The general multistep model might look like this (from p557)

$$~
a_k x_n + a_{k-1}x_{n-1} + \cdots + a_0 x_{n-k} =
h( b_k f_n + f_{k-1} f_{n-1} + \cdots + b_0 f_{n-k}).
~$$

We discussed:

* if $b_k \neq 0$ the method is *implicit* otherwise it is explicit
* Definining $p(x)$ and $q(x)$ using the coefficients $a$ and $b$ that the method converges only if all the roots of $p$ are in or on the unit disc, and if on, they are simple roots *and* $p(1)=0$ and $p'(1) = q(1)$. (Consistent and stable)
* If $f_x < \lambda$, the if the local truncation error is $\mathcal{O}(h^{m+1})$ then the global error is $\mathcal{O}(h^m)$

Some special cases:

* Euler's method
* Backward Euler
* Adams Bashworth
* Adams Moulton




### Problems

* Let an IVP be given by $x'(t) = atan(x), \quad x(0) = 0$. Is $f(t,x)$

- continuous in the strip $0 \leq t \leq 10$ and $-\infty < x < \infty$?
- does it satisfy
$$~
|f(t,x_1) - f(t,x_2)| \leq L |x_1 - x_2|
~$$


* Use one of the theorems in section 8.1 to show p9 on page 528. You need to show that $\beta/M$ can be as large of the value, where $M$ is the biggest that $f(t,x)$ can be in when $|x| < \beta$.

* Using $h=1/3$ use Euler's method to solve the IVP at $t=1$ with

$$~
x'(t) = 10 - 3x \cdot t\quad
x(0) = 1
~$$

* Using $h=1/3$ use the Heun's method to solve the following IVP at $t=1$. 


$$~
x'(t) = 1 + x^2,\quad x(0)=0
~$$


* problem 2, page 546

* The Runge Kutte method is often called `rk45`, as the global error is order 4 and the local error order 5. Assuming this, what should be the step size $h$ so that the error at time $1$ (starting at $0$ is basically $10^{-5}$?

* The second-order Adams-Bashworth method is

$$~
x_{n+1} = x_n + h[(3/2) f_n - (1/2) f_{n-1}]
~$$

Take $h=1/4$. Using Euler's method to find $x_1$, find $x_4$ when

$$~
x'(t) = t + x,\quad
x'(0) = 1
~$$

* The implicit Euler (backward) is

$$~
x_{n+1} = x_n + h f(t_{n+1}, x_{n+1}).
~$$

For the IVP

$$~
x'(t) = -10x, \quad x(0) =1
~$$

The implicitness can be solved directly, as $f$ is linear. Using $h=1/3$, find $x_3$.

* The multistep method is convergent if it is both stable and consistent. Both these may be checked by accompanying polynomials.

Show the  second-order Adams-Bashworth method 

$$~
x_{n+1} = x_n + h[(3/2) f_n - (1/2) f_{n-1}]
~$$

is convergent.

* The Runge Kutta methods involve a certain number of function evaluations per step. The following table shows the best possible local truncation error for a given number of function evaluations:

```verbatim
Evals  order
2  2
3  3
4  4
5  4
6  5
7  6
8  6
9  7
```

- Why might this suggest using an order 4 method?

- Euler's method has 1 evaluation for order 2. Compare the sum of the 1-step errors in using 4 steps of Euler of size $h/4$ with one step of a fourth order RK method with order 4. What values of $h$ would make one more attractive than the other?



