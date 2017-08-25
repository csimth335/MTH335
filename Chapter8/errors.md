# Local and Global Errors, Stability

We again consider multistep models:



$$~
a_k x_n + a_{k-1}x_{n-1} + \cdots + a_0 x_{n-k} =
h( b_k f_n + f_{k-1} f_{n-1} + \cdots + b_0 f_{n-k}),
~$$

where $f_i = f(t_i, x_i)$.

When $b_k =0$ the value of $x_n$ can be found explicitly knowing the other values of $t$ and $x_i$.

However, when $b_k \neq 0$, the value of $x_n$ enters on the right-hand side in a possibly non-linear manner. These equations are called *implicit*.

As mentioned, we can use a "predictor-corrector" model to iterate to a value.

The coefficients lead to the defintion of two polynomials:

$$~
\begin{align}
p(z) &= a_k z^k + \cdots a_1 z + a_0\\
q(z) &= b_k z^k + \cdots b_1 z + b_0.
\end{align}
~$$


## Key definitions

Let $x(h,t)$ be the value of the approximate sequence formed with step size $h$ at a value $t$. The sequence $t_0, t_1, \dots$ containers $t$ between $t_i$ and $t_{i+1}$, say, and the value of $x$ is the interpolated value between $x_i$ and $x_{i+1}$.


> **Convergent** The multistep method is convergent if for any *fixed* $t$, the limit as $h$ goes to zero has $x(h,t)$ going to $x(t)$ provided only the convergence happens at the initial point:

$$~
\lim_{h \rightarrow 0} x(h,  t_0, nh) = x_0.
~$$


*And* the function $f$ satisfies the lipshitz condition to ensure a unique solution.

(That is, if you graph the approximate solution for a values of $h$, for any fixed value $t$, the approximate solution converges to the real solution at $t$.)

> **Consistent** If $p(1) = 0$ and $p'(1) = q(1)$.  More clearly, if the local truncation error  is $\mathcal{o}(h)$.


> **Stable** If all roots of $p$ line in the disk $|z| \leq 1$ and each root of modulus 1 is simple. More clearly, it is stable if the "total variation" of the numerical solution at a fixed time remains bounded as the step size goes to zero. Stability ensures osciallations don't add up.

## Theorem

> A multistep method is convergent if and only if it is stable and consistent.

So you can check based on the polynomials, convergence.

The book only proves half of this (convergence implies ...)

PF: Suppose the algorithm is convergent. Show it must be stable and consistent.

First, assume we have a convergent algorithm that is *not* stable. That means, we have a root $\lambda$ to $p(z)$ which is either bigger than 1 in modulus or has modulus and is not simple. We do the easier one, and assume $|\lambda| > 1$.

Consider the new IVP:

$x'(t) = 0, x(0) = 0$. This has a solution of $x(t) = 0$.

Now consider this algorithm, which is assumed convergent, to solve it:

$$~
a_k x_n + \cdots + a_1 x_{n-k+1} + a_0 x_{n-k} = 0
~$$

The values $x_n = h \lambda^n$ form a solution. (Factor out powers to get $h\lambda^j p(\lambda)$.)

If the algorithm is convergent then we must have *if* there are no issues at the starting point, then at a fixed $t$ it will converge. So, checking the starting point, we need $\lim_{h \rightarrow -} x(h, t_0,nh) = x_0 = 0$. But for a *fixed n <= k*:

$$~
x(h, t_0 + nh) = h |\lambda^n| \leq h |\lamda^k| -> 0
~$$

That is for fixed n this goes to $0$, as needed.

But at fixed $t = nh$, we have the following:

$$~
x(h, t)  = x(h, nh) = h|\lambda^n| = (t/n) |\lambda^n| -> \infty
~$$

when we assume $|\lambda| > 1$. So if not stable, not convergent; or convergent not stable.


As for consistency, consider the IVP:

$$~
x'(t) = 0, \quad x(0)  = 1
~$$

This has solution $x(t) = 1$. Again, the convergent algorithm is:


$$~
a_k x_n + \cdots + a_1 x_{n-k+1} + a_0 x_{n-k} = 0.
~$$

Starting from $x_0 = x_1 = \cdots = x_k = 1$ the convergent algorithm will have $x_n \rightarrow 1$, as the solution is the constant $1$. This means that if we take a limit the equation above becomes $p(1) = 0$, so the first part of consistency is established.

Now for the derivative.

Here, take the initial value problem $x'(t) = 1, x(0) = 0$. This has solution $x(t) = t$. Our convergent algorithm becomes:

$$~
a_k x_n + \cdots + a_1 x_{n-k+1} + a_0 x_{n-k} =h[b_k \cdot 1 + \cdots + b_1 \cdot 1 + b_0] \quad (\text{as $f=1$}).
~$$

Since this method is assumed convergent, it is now known to be stable, hence if $p(1)=0$ it must be a simple root, so $p'(1) \neq 0$. We need to show it is $q(1) = b_k + \cdots + b_1 + b_0$.

The book shows wne solution is $x_n = (n+k)h\gamma$ with $\gamma = q(1)/p'(1)$ but directly plugging in. But,
if the convergence around $t_0$ is given, then convergence implies $x_n \rightarrow t$, where $t=nh$.

That is,

$\lim_n (n+k)h q(1)/p'(1) = t$. So $q(1)/p'(1) = 1$ and this is done.


### Example. Is Euler's method stable:

Euler's method is

$$~
x_{n+1} -x_n = f(t_n, x_n) = 0 \cdot f_{n+1} + 1 \cdot fn
~$$

So $p(x) = x - 1$ and $q(x) = 1$. So, the method is stable, as the lone root is 1, a simple root in the unit disk. The method is consistent as $p(1) = 1-1=0$ and $p'(1) = 1 = q(1)$.




## global truncation error


Suppose we have done $n$ steps of a multistep algorigthm. The global error is

$$~
x(t_n) - x_n
~$$

That is the error that has accumulated between the algorithm and the solution.


The *local truncation error* is the error given in 1 step. Suppose $x_{n-1}, x_{n-2}, \dots$ are correct, then the multistep algorithm is used to produce $x_n$. The local trunctation error is then the error $x(t_n) - x_n$. (It isn't the case that our approximate sequence satisifies this assumption.)

The global truncation error accounts for the local errors, but also any "interest" they may accumulate for putting the solution in the wrong place. The solution curves may deviate and once an error drives you to one curve, the answer could move far away.

Suppose we have the IVP

$$~
x'(t) = f(t, x), x(t_0) = x_0
~$$

We can consider the function of two variables $x(t,s)$ where we fold in the starting point, $x_0$ as $s$.

Then defining $u(t) = \partial x(t,s) / \partial s$ we have this equation:

$$~
u'(t) = f_x(t,x) u, \quad u(0) = 1
~$$

This is called the **variational** equation.

> Thm: If $f_x \leq \lambda$ then the solution satisfies

$$~
|u(t)| \leq e^{\lambda t}
~$$

PF: This comes from solving the variational equation:

$$~
\frac{u'}{u} = f_x
~$$

So integrating, we have:

$$~
\log(|u|) = \int f_x dt \leq \lambda t
~$$

Or $|u| \leq e^{\lambda t}$.


> If the IVP is solved with initial values $s$ and againi with $s+\delta$, then the solution curves differ at $t$ by at most $|\delta|e^{\lambda t }$.

PF: This will use the mean value thereom in the $s$ variable:

$$~
|x(t,s) - x(t, s+\delta)| = |\frac{\partial}{\partial s} x(t, s + \xi)| |\delta| = |u(t)| |\delta| \leq |d| e^{\lambda t}.
~$$


> Thm: If the *local* truncation errors at $t_1, t_2, \dots, t_n$ do not exceed $\delta$ then the global truncation error does not exceed

$$~
\delta \frac{e^{n \lambda h} - 1}{e^{\lambda h} - 1}.
~$$

PF: Here is how we measure the amount of error introduced when leaving the actual solution curve. Let $\delta_1, \dots, \delta_n$ be the *local* truncation errors. (These assume the prior values are correct.)

In finding $x_1$ there was an error $\delta_1$. How does this effect $x_2$? The difference will be at most $|\delta_1| e^{\lambda h}$.
But there is a new error from the algorithm $\delta_2$. So the error at time $t_2$ will be at most

$$~
|\delta_1| e^{\lambda h}  + |\delta_2|
~$$

At $t_3$, this will possible grow to:

$$~
(|\delta_1| e^{\lambda h}  + |\delta_2|)e^{\lamba h} + |\delta_3| = |\delta_1|e^{2\lambda h} + |\delta_2|e^{2\lambda h} + |\delta_3|e^{0\lambda h}
~$$

The global error is then given by a sum:

$$~
\text{global error} \leq \sum_k^n |\delta_k| e^{(n-k)\lambda h} \leq \delta \sum_k e^{k\lambda h} =
\delta \frac{e^{n\lambda h} - 1}{e^{\lambda h} - 1}.
~$$


> Thm: If the local truncation error is $\mathcal{O}(h^{m+1})$ then the global one is $\mathcal{O}(h^{m})$.

