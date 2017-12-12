# Multistep methods

Consider the IVP

$$~
x'(t) = f(t,x), \quad x(t_0) = x_0
~$$

Then to find $x(t+h)$ knowing $x(h)$ we could write

$$~
x(t + h) - x(t) = \int_t^{t+h} x'(t) dt = \int_t^{t+h} f(t, x(t)) dt.
~$$

If we can compute the integral, then we are done. This can happen when $f(t,x)$ depends on only on $t$. In general, we can't compute the integral, but we could approximate it. A scheme may be to consider points between the $t$ and $t+h$, uses these to find an interpolating polynomial and then integrate that.


## Multistep models

If we have time steps $t_0, t_1, \dots$, then we can consider our
solutions to depend on one or more previous steps. Euler's method uses
one, with $f(t,x(t)) \approx f(t_n, x_n)$ (a constant) then

$$~
x(t+h) - x(t) = \int_t^{t+h} f(t, x(t)) dt \approx \int_t^{t+h} f(t_n,x(t_n)) dt = h \cdot f(t_n, x_n).
~$$

So we write:

$$~
x_{n+1} = x_n + h\cdot f(t_n, x_n).
~$$

The general multistep model allows for more than one. A general form might look like this (from p557)

$$~
a_k x_n + a_{k-1}x_{n-1} + \cdots + a_0 x_{n-k} =
h( b_k f_n + b_{k-1} f_{n-1} + \cdots + b_0 f_{n-k}).
~$$

With this indexing, Euler's method, $1\cdot x_n - 1\cdot x_{n-1} = h \cdot 1 \cdot \cdot f_n$, has

$$~
a_1=1, a_0=-1, b_1=0, b_0=1.
~$$

## Adams Bashworth

A means to generate multistep models is to return to the formula $x(t+h) - x(t)=\int_t^{t+h} x'(t) dt.$

For a concrete example, take the time points $t_n, t_{n+1}, t_{n+2}$. We will use the values $t_n$ and $t_{n+1}$ to interpolate the polynomial and use this polynomial to approximate

$$~
x_{n+2} - x_{n+1} = \int_{t_{n+1}}^{t_{n+2}} x'(t) dt\approx \int_{t_{n+1}}^{t_{n+2}} p(t) dt
~$$

Where for this set of points, with a labeling $u_0 = t_n$ and $u_1=t_{n+1}$ we have

$$~
p(t) = \sum f(u_i) \prod_{j=0, j\neq i}^k \frac{t - u_j}{u_i - u_j} = f(u_0) \frac{t-u_1}{u_0 - u_1} + f(u_1)\frac{t-u_0}{u_1-u_0}
~$$

We can integrate $p$ to get $f(u_0) l_0 + f(u_1) l_1$ where, for example, $l_0$ is given by:

```
using SymPy
u, t, h = symbols("u,t, h")
u0, u1, u2 = t, t+h, t+2h
integrate((u-u1)/(u0 - u1), (u, u1,u2)) |> simplify
```

And $l_1$ by:

```
integrate((u-u0)/(u1 - u0), (u, u1,u2))  |> simplify
```

Putting these together gives a formula:

$$~
x_{n+2} - x_{n+1} \approx h (\frac{3}{2} f_{n+1} - \frac{1}{2} f_n).
~$$

This is an Adams Bashworth formula. It is a multstep model with $a_2=1, a_1=-1, a_0=0$ and $b_2=0, b_1=3/2, b_0=-1/2$.

The local error will be basically $h\cdot \mathcal{O}(h^2)$, as the linear polynomial approximation has the $h^2$ error.


### Method of undetermind coefficients

Another way to derive this is to *assume* the approximation $a
f_{n+1} + b f_n$ is exact for *polynomials* of degree 1 or less, and
integrate. Using $p(t) = 1$ and then $p(t) = t$ and *assuming*
(without loss of generality that $t_{n+1}=0$, $t_{n+2} = 1$ that

$$~
\int_{t_n}^{t_{n+1}} 1 dt = 1 = h = h \cdot (a \cdot 1 + b \cdot 1),
\quad \text{or}\quad 1 = a + b,
~$$

and

$$~
\int_{t_n}^{t_{n+1}} t dt = 1/2 = (a \cdot 0 + b \cdot (-1)),
\quad\text{or}\quad 1/2 = -b.
~$$

Piecing togther, we get $x_{n+2} - x_{n+1} = 3/2 x_{n+1} - 1/2 x_n$.


## Adams Moulton

What if we had used all three points, $t_n, t_{n+1},$ **and** $t_{n+2}$ to approximate $f$? The error would be like $h^3$ then. The right hand side would become:

$$~
b_2 f(t_n+2) + b_1f(t_{n+1}) + b_0 f(t_n)
~$$

Where we get $b_2$ from:

```
integrate( (u - u0) * (u-u1) / (u2-u0) / (u2 - u1), (u, u1, u2))  |> simplify
```

And $b_1$ from:


```
integrate( (u - u0) * (u-u2) / (u1-u0) / (u1 - u2), (u, u1, u2))  |> simplify
```

And finally, $b_0$ from:


```
integrate( (u - u1) * (u-u2) / (u0-u1) / (u0 - u2), (u, u1, u2))  |> simplify
```


Putting these together gives the formula:

$$~
x_{n+2} - x_{n+1} \approx h (\frac{5}{12} f_{n+2} - \frac{2}{3}
f_{n+1} - \frac{1}{12} f_n).
~$$


This of course could be
[generalized](https://en.wikipedia.org/wiki/Linear_multistep_method)
by taking more points. The book shows a higher order value.


> Note: we can't explicitly solve for $x_{n+2}$ as it appears on
> *both* sides of the equation -- the right-hand side has $f_{n+2}=f(t_{n+2},x_{n+2})$.


## Example

No. 3 on p556: Compute the solution to the IVP $x' = -2tx^2$, $x_0 = 1$ using the *fourth-order* Adams-Bashworth-Moulton method together with a fourth order Runge Kutta method.

Find the solution at $x=1$ with $h=0.25$.

So, we have

```
ts = [0, 0.25, 0.5, 0.75, 1.0] # t0, t1, t2,t3,t4
```

We have

```
x0 = 1
```

The fourth order ABM method use AB to help with AM (p555 p5):

$$~
x_{n+1} = x_n + h/24 (9f_{n+1} + 19f_n - 5f_{n-1} + f_{n-2})
~$$

We shift things forward by $2$ to get:

$$~
x_{n+3} = x_{n+2} + h/24 \cdot (9f_{n+3} +19f_{n+2} - 5f_{n+1} + f_n)
~$$

When $n=1$ this gives $x_4$ 

*But* we have in $f_{n+3} = f(t_{n+3}, x_{n+3})$, so we have $x_{n+3}$ on both sides. To work around that we use the *explicit* method (8.4p4):

$$~
x_{n+4} = x_{n+3} + h/24 [55 f_{n+3} - 59f_{n+2} + 37f_{n+1} - 9f_n]
~$$

At $n=0$ this gives $x_4$ in terms of previoius values $x_3, x_2, x_1$ and the given value of $x_0$.

To get estimates for those, we will use a fourth order Runge Kutta (p541)

```
function rk4(f, t, x, h)
F1 = h*f(t, x)
F2 = h * f(t + h/2 , x + F1/2)
F3 = h*f(t + h/2, x + F2/2)
F4 = h*f(t+h, x + F3)
xn1 = x + 1/6 *(F1 + F2 + 2F3 + F4)
t+h, xn1
end

f(t, x) = -2 * t * x^2
h = 1/4
t0, x0 = 0, 1
t1, x1 = rk4(f, t0, x0, h)
t2, x2 = rk4(f, t1, x1, h)
t3, x3 = rk4(f, t2, x2, h)
```

Now we use one step of the explicit method to estimate $x_4$:

```
f0, f1, f2, f3 = f(t0,x0), f(t1,x1), f(t2,x2), f(t3, x3)

ax4 = x3 + h/24 * (55*f3 - 59*f2 + 37*f1 - 9f0)
```

Now use this with the Adams Moulton formula:

```
t4 = t3 + h
f4 = f(t4, ax4)
x4 = x3 + h/24 * (8*f4 + 19*f3 - 5*f2 + f1)
```


Okay, how did we do? The book says the exact solution is $1/(1+x^2)$, so at 1 should be $1/2$:

```
x4 - 1/(1+1^2)
```


So with $h=2.5\cdot 10^{-1}$ we have $h^4 \approx$ `4e-3` and this error is about `4e-2` or 10 times what we might hope for is best.



So, with this in mind. Let's suppose our error is going to be $10h^4$.  How small should $h$ be so that our error is less than $10^{-5}$? Well, $h^4 = 10^{-4}$ or $h=1/10$. 

## Stiff equations

Some equations are problematic unless the step size is small. These are called **stiff** equations.

An example comes from [wikipedia](https://en.wikipedia.org/wiki/Stiff_equation):

$$~
x'(t) = -15x, \quad x(0) = 1
~$$

We can easily solve this for $t \geq 0$ to be $e^{-15t}$ -- a rapidly decaying function.

So the value at $t=1$ is $e^{-15}$ or basically 0.

What happens if we try Euler's method here with a large step size, say $h=1/4$?

```
f(t, x) = -15x
h = 1/4
ts=[0.0]
xs = [1.0]

for k=1:4
t,x = ts[end], xs[end]
xnew = x + h * f(t,x)
push!(xs, xnew)
push!(ts, t + h)
end
```

We get the estimate at $1$ of:

```
xs[end]
```

Wow, way off. What happened?

```
using Plots
plot(ts, xs)
plot!(t -> exp(-15t), 0, 1, color=:red)
```

The solution seems to be escaping and oscillating.

The reason being, when $x > 0$, the term $f(t,x) = -15x$ means there is a large negative contribution driving the equation back towards 0, and when $x < 0$ the term $f(t,x) - 15$ means there is a large positive contribution driving the equation back to 0.


### What to do?

We could take $h$ much smaller:

```
f(t, x) = -15x
h = 1e-3
ts=[0.0]
xs = [1.0]

for k=1:1e3
t,x = ts[end], xs[end]
xnew = x + h * f(t,x)
push!(xs, xnew)
push!(ts, t + h)
end

plot(ts, xs)
plot!(t -> exp(-15t), 0, 1, color=:red) 
```

But that seems wasteful.

Altenatively we could use an implicit method.

### Implict Euler method.

The implicit Euler method is a multistep method of this form:

$$~
x_{n+1} = x_n + hf(t_{n+1}, x_{n+1})
~$$

We have $x_{n+1}$ on both sides of the equation. What to do? We could a) do a predictor-corrector thing b) solve the non-linear equation. We will try the latter.


$$~
F(u; t_{n+1}, x_n) =  (x_n + hf(t_{n+1}, u)).
~$$

The solution to $F(s)=s$ is $x_{n+1}$. We have many ways to solve this: iteration, Newton, ... We use the `fzero` function in the `Roots` package for convenience.

```
using Roots
```

Then our backwards Euler becomes:

```
f(t,x) = -15x
h = 1/4
F(u, t, x) = x + h*f(t, u)
ts = [0.0]
xs = [1.0]
for k in 1:4
t,x = ts[end], xs[end]
xnew = fzero(u -> F(u, t, x) - u, x)
push!(ts, t+h)
push!(xs, xnew)
end
```

We get:

```
xs[end]
```

And this graph

```
plot(ts, xs)
```


Much better!
