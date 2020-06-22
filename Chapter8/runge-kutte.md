# Runge Kutta

The [Runge-Kutta](https://github.com/JuliaLang/ODE.jl/blob/master/src/runge_kutta.jl) methods are formalization the Taylor Series method.

Again solving an IVP:

$$~
x'(t) = f(t,x), \quad x(t_0) = x_0.
~$$

We expand $x(t+h) = x(t) + x'(t) h + x''(t) h^2/2 + \cdots$. To do so we need derivatives. Let $\phi(t) = [t,x(t)]$ be a vector-valued function and $\nabla f = [f_t, f_x]$ be the partial derivatives:

$$~
\begin{align}
x'(t) &= f(t, x)\\
x''(t)&= \nabla f(\phi(t)) \cdot \phi'(t) = [f_t(\phi), f_x(\phi)] \cdot [1, x'] = f_t + x' \cdot f_x = f_t(\phi) + f(\phi) \cdot f_x(\phi)\\
x'''(t)&= \nabla (f_t + f \cdot f_x)(\phi)  = \nabla (G(\phi)) = [G_t, G_x] \cdot [1, x'] =
[f_{tt} + f_t f_x + ff_{tx}, f_{tx} + f_x f_x + f f_{xx}](\phi) \cdot [1, x']
= (f_{tt} + f_t f_x + ff_{tx} + f_{tx} f + (f_x)^2 f + f^2 f_{xx})(\phi)\\
x''''(t) &= \dots
\end{align}
~$$

Substitute this into the Taylor expansion for $x(t+h)$ up to order 2

$$~
x(t+h) = x(t) + h f + h^2/2 \cdot(f_t + f_x f) + \mathcal{O}(h^3).
= x(t) + 1/2 h\cdot f + h/2 ( f + h\cdot f_t + h \cdot f_x f).
~$$

The latter rewrites the last term so that we can use the following
fact from the Taylor expansion for a function of two variables:

$$~
f(t+h, x+hf) = f(t, x) + f_t(t,x) h + f_x(t,x)hf + \mathcal{O}(h^2)
$$

The choice of $hf$ is there so that we can substitute in for $f f_x$:

$$~
x(t+h) = x + (1/2) h \cdot f + (1/2) h \cdot f(t+h, x + hf) +  \mathcal{O}(h^2)
~$$

Let $F1 = h \cdot f$ and $F2 = h \cdot f(t + h, x + F1)$ then we get
the approximation

$$~
x(t+h) \approx x(t) + (1/2) F1 + (1/2) F2.
~$$


The book calls this Heun's method (1859-1929).

It is used like Euler's method:


```
f(t, x) = 1.0 - (1/2)* x^2
h = 1/10
t0, x0 = 0, 1
n = 10               ## so t = h*n = 1
F1(t,x) = h*f(t,x)
F2(t,x) = f(t+h, x + F1(t,x))

ts = Float64[t0]
xs = Float64[x0]
for i in 1:10
ti, xi = ts[end], xs[end]

xi1 = xi + 1/2 * F1(ti, xi) + 1/2 * F2(ti, xi)

push!(ts, ti + h)
push!(xs, xi1)
end
```

```
[ts xs]
```

```
using Plots
plot(ts, xs)
```




### General second-order RK method

The general second-order method may have coefficients:

$$~
\begin{align}
x(t+h) &= x + w_1 hf + w_2 hf(t +\alpha h, x + \beta h f) + \mathcal{O}(h^3) \\
       &= x + w_1 hf + w_2 h \left( f + \alpha hf_t + \beta h f
	   f_x\right) + \mathcal{O}(h^3) \quad \text{Using Taylor on
	   f(.,.)}\\
   & = x + h\cdot (w_1+w_2) f + h^2\cdot w_2\alpha f_t + h^2 w_2\beta
   f f_x + \mathcal{O}(h^3)
\end{align}
~$$

Comparing to an earlier equation:

$$~
x(t+j_ = x + h \cdot  f + h^2 \cdot (1/2) f_t + h^2 \cdot (1/2) f
f_x + + \mathcal{O}(h^3),
~$$

the coefficients should satisfy: $w_1 + w_2=1, w_2\alpha = 1/2, w_2\beta = 1/2$.

Setting $w_1 = 0, w_2 = 1, \alpha = \beta = 1/2$ gives:

$$~
\begin{align*}
x(t+h) &= x(t) + F2\\
F_1 &= h f(t,x)\\
F_2 &= h f(t + h/2, x + F_1/2).
\end{align*}
~$$


This is called a modified Euler method. (Euler's method is of the form $x(t+h) = x(t) + F_1$.)


### Example

Apply both Euler and the modifed Euler to the IVP

$$~
x'(t) = \pi e^{-t} \cdot \cos(\pi t) - x, \quad x(0) = 0.
~$$

```
f(t, x) = pi * exp(-t) * cos(pi*t) - x
h = 1/25
F1(t, x) = h * f(t,x)
F2(t, x) = h * f(t + h/2, x + F1(t,x)/2)
ts = [0.0]
es = [0.0]
mes = [0.0]
for i in 1:25
t,ex,mx = ts[end], es[end], mes[end]
push!(ts, t + h)
push!(es, ex + F1(t, ex))
push!(mes, mx + F2(t, mx))
end
```

To visualize, we have:

```
using Plots
plot(ts, es, color=:blue)
plot!(ts, mes, color=:red)
plot!(t -> exp(-t) *sin(pi*t), 0, 1, color=:green)
```

As can be seen the modified Euler has a smaller error.

## Higher order RK methods

This process can be repeated. Here is an answer for the classical RK method of order 4 (error $\approx \mathcal{O}(h^5)$):

$$~
x(t+h) = x(t) + \frac{1}{6}F_1 + \frac{1}{3} F_2 + \frac{1}{3}F_3 + \frac{1}{6}F_4
~$$

where

$$~
\begin{align*}
F1(t,x) &= h f(t,x)\\
F2(t,x) &= hf(t + h/2, x + F_1/2)\\
F3(t,x) &=  hf(t + h/2, x + F_2/2)\\
F4(t,x) &=  hf(t + h, x + F_3).
\end{align*}
~$$

We can    visualize and compare:

```
F3(t,x) = h*f(t + h/2, x + F2(t,x)/2)
F4(t,x) = h*f(t + h, x + F3(t,x))
ts = [0.0]
m4es = [0.0]

for i in 1:25
t,x= ts[end], m4es[end]
push!(ts, t + h)
push!(m4es,  x + F1(t,x)/6 + F2(t,x)/3 + F3(t,x)/3 + F4(t,x)/6 )
end
```

We compare to the exact answer

```
plot(ts, m4es, color=:black)
plot!(t -> exp(-t) *sin(pi*t), 0, 1, color=:green)
```

## General form

This is from [Wikipedia](http://tinyurl.com/pzm7tww)

The general form of an RK method becomes:

$$~
x_{n+1} = x_n + h \sum_{i=1}^s b_i k_i; \qua
k_i = f(t_n + c_i h, x_n + h \sum_{j=1}^s a_{ij} k_j)
~$$

Where, the coefficients $a,b,c$ are from a table (a Butcher Tableu)

$$~
\begin{array}{c|cccc}
c_1 & a_{11} & a_{12} & \cdots & a_{1s}\\
c_2 & a_{21} & a_{22} & \cdots & a_{2s}\\
&&\cdots&&\\
c_s & a_{s1} & a_{s2} & \cdots & a_{ss}\\
\hline
& b_1 & b_2 & \cdots & b_s
\end{array}
~$$


Specializing this to **explicit** equations -- ones where the $k_i$'s
can be computed directly -- the matrix becomes lower triangular:


$$~
\begin{array}{c|cccc}

0 &  &  & & \\
c_2 & a_{21} & &  & \\
&&\cdots&&\\
c_s & a_{s1} & a_{s2} & \cdots & a_{s,s-1}\\
\hline
& b_1 & b_2 & \cdots & b_s
\end{array}
~$$

Consistency -- a criteria for convergence -- imposes the condition
$c_i = \sum_{j=1}^{i-1} a_{ij}$.


With this, the Heun method:

$$~
\begin{align*}
k1 &= f(t, x)\\
k2 &= f(t + h, x + h\cdot k1)
\end{align*}
~$$

Becomes

$$~
\begin{array}{c|ccc}
0 & &     &\\
1 & 1   &\\
\hline
& 1/2 & 1/2
\end{array}
~$$

The modified Euler method becomes


$$~
\begin{array}{c|ccc}
0 & &     &\\
1/2 & 1/2   &\\
\hline
& 1 & 1
\end{array}
~$$




And the 4th-order one

$$~
\begin{array}{c|ccccc}
0 & &  & & & \\
1/2 &  1/2 &&& \\
1/2 &  0 & 1/2 &&\\
1   &  0 & 0 & 1& \\
&  1/6& 1/3 & 1/3 & 1/6 &
\hline
\end{array}
~$$




To see some more examples: [Runge-Kutta](https://github.com/JuliaLang/ODE.jl/blob/master/src/runge_kutta.jl) .


### Examples

These methods -- and much more -- are implemented in Julia's
differential equations packages. (These must be installed to be used on JuliaBox)

For example,

```
using OrdinaryDiffEq
f(u, p, t) = pi * exp(-t) * cos(pi*t) - u
u0 = 0.0
tspan = (0.0, 1.0)
prob = ODEProblem(f,u0,tspan)
sol = solve(prob,DP5(),reltol=1e-8,abstol=1e-8) # solve(prob) for defaults
sol(.5)
```

Here `DP5` specifies the Runge-Kutta method with order 4-5.


Plotting a solution is easy:

```
plot(sol)
```


The `DP5()` bit specifies the RK-4-5 method, the adaptive `Tsit5()`,
the default, is more efficient:

```
sol1 = solve(prob,Tsit5())
plot!(sol1)
```

In MATLAB, the `ode45` function is the typical workhorse. A Julia
implementation is
[here](https://github.com/JuliaDiffEq/ODE.jl/blob/master/src/runge_kutta.jl).

Higher order RK methods are available, but as the order goes up, the
number of function calls does as well, so typical is the 4-5 method.

## Error

The local truncation error for the 4th order RK method is like $C h^5$, as the Taylor series used employs exact terms up to $h^4$.


If we have, as in the book, $x^*$ be the approximate solution and $x$
the exact one (opposite the book, p543), we have:

$$~
x(t_0 + h) - x^*(t_0+h) = \text{local truncation error} = C h^5.
~$$

This is manageable unless $C$ gets very big.

$C$ is a constant dependent on $t$ and $h$, but *suppose* it does not
change as $t$ changes to $t+h$.


Let $v$ be the value by taking one step of length $h$ from $t_0$.

Let $u$ be the value by taking *two* steps of length $h/2$ from $t_0$.

Then with this error, we have:

$$~
\begin{align}
x(t + h) &= v + C h^5, \quad \text{whereas}\\
x(t_h) &= h + 2 \cdot C(h/2)^5.
\end{align}
~$$

The local truncation error, $Ch^5$ then looks like $(u-v)/(1 - 2^{-4})
\approx (u-v).$

The book suggests that this difference can be monitored during the algorithm. If it gets too
large the algorithm has more accumulated error than expected, and if
so, can be repeated with a smaller $h$ in hopes of circumventing this.
