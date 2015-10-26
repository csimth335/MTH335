# Review for test 2

This is some of the material that will be up for testing on test 2.

## Chapter 3

In Chapter 3 we discussed various means to solve the equation $f(x)=0$ where $f: R \rightarrow R$. (That is a $f$ is a scalar-valued function of a real variable). This formulation applies to finding answers for each of these equations:

$$~
\begin{align}
\sin(x) -x + 1/2 &= 0\\
\tan(x) + x &= 1\\
a\cos(x) &= x
\end{align}
~$$

Here is a summary of the methods we discussed:

### Bisection method:

* assumes $f(x)$ is $C$ (continuous).

* $c_i = mid(a_i, b_i)$; and $[a_{i+1}, b_{i+1}]$ chosen from $[a_i, c_i]$ or $[c_i, b_i]$.

* The error, $e_n = c_n -r$  is bounded by $2^{-(n+1)}(b_0 - a_0)$.

* guaranteed (mathematically) to converge ($c_n \rightarrow r$) if $a_0, b_0$ brackets a root. (Intermediate value theorem.)

* linear convergence

* in floating point can be guaranteed to produce a floating point number $r$ where it may not be $f(r)=0$, but if not, the `f(prevfloat(r)) * f(nextfloat(r)) < 0$.


### Newton's method

* assumes $f(x)$ is $C^2$ and $r$ is a *simple* zero

* a process $x_{n+1} = x_n - f(x_n) / f'(x_n)$

* the error satisfies $e_{n+1} = f''(\xi)/(2f'(x_n)) e_n^2 \approx f''(r)/(2f'(r)) e_n^2$.

* Let $C(\delta) = max(f''(y))/(2min(f'(y)))$ for $x,y$ within $\delta$ of $r$. If $\delta C(\delta) < 1$, then any starting value within $\delta$ of $r$ will converge to $r$ quadratically fast.

* If $f'>0$ and $f''>0$ then any initial value will converge

* numerically one needs to clarify when we stop iterating using different tolerances.

* If $r$ is not a simple zero, convergence is linear.

### Secant method

* Assume $f$ is $C^2$ and $r$ is a simple zero.

* if $f[a,b] = (f(b) - f(a))/(b-a) \approx f'(a)$, then the method is $x_{n+1} = x_n - f(x_n) / f[x_n, x_{n-1}]$.

* $e_{n+1} \approx f''(r) / (2f'(r)) e_n e_{n-1}$.

* convergence is faster than linear, slower than quadratic: $\alpha = (1 + \sqrt{5})/2$

### Fixed point

* Assume $F$ is $C^q$ and $r$ is a simple zero

* method is $x_{n+1} = F(x_n)$.

* If $F$ is a **contractive mapping**, then the method converges to a (uinque) fixed point $s$.

* If $x_{n+1} = F(x_n)$ converges to $s$ and If $q$ is the first integer where $F^{(q)})(r) \neq 0$, then

- $e_{n+1} = F^{(q)}(\xi)/q! e_n^q$

- $q$ is the order of convergence.

### some sample problems

* Will the bisection method find the zero of $(x-1)^2$?

* Will Newton's method find the zero of $(x-1)^2$?

* In what ways does the function $f(x) = x^{20} - 1$ challenge the convergence of Newton's method?

* Why do you know that using Newton's method on the function $f(x) = e^x + x$ will be guaranteed to converge?

* Let $f(x) = \sin(x)$. Starting with the $x_0, x_1 = 3, 4$, perform 2 steps of the secant method (find $x_2, x_3$). How accurate is your value ($f(x_3) - \pi$)?

* The *efficiency index* is defined by $\mu^{1/f}$ where $\mu$ is the order of convergence of a method and $f$ is the number of function calls per step. For Newton, these values are $2$ and $2$ and for the secant method $(1 + \sqrt{5})/2$ and $1$. Which method has a bigger efficiency index?

* Let $e_n = x_n -r$, Taylor's theorem gives

$$~
f(x_n) = f(r) + f'(r)e_n + (1/2) f''(r) e_n^2 + \mathcal{O}(e_n^3)
~$$

Divide this by $e_n$, then use for both the case $n$ and $n-1$. Use these pieces to identify the limit as $n$ goes to $\infty$ of

$$~
\frac{f(x_n)/e_n - f(x_{n-1})/e_{n-1}}{x_n - x_{n-1}}.
~$$

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. Show that $F(x)$ is a contractive map.

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. What is the order of convergence of the iterative mapping: $x_{n+1} = F(x_n)$?

* Let $p>0$. What is the value of this expression:

$$~
\sqrt{p + \sqrt{p + \sqrt{p + \cdots}}}
~$$

(As the book says, this is $x_{n+1} = \sqrt{p + x_n}$.)







## Chapter 4

TBA

## Chapter 5

TBA
