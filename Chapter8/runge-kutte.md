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

Now, we use the taylor expansion for a function of two variables:

$$~
f(t+h, x+hf) = f(t, x) + f_t(t,x) h + f_x(t,x)hf + \mathcal{O}(h^2)
$$

The choice of $hf$ is there so that we can substitute in for $f f_x$:

$$~
x(t+h) = x + f (h/2) + f(t+h, x + hf) h/2 +  \mathcal{O}(h^2)
~$$

This gives the formula to move a step:

$$~
x(t+h) = x(t) + \frac{1}{2} F_1+ \frac{1}{2} F_2,
~$$

With

$$~
F_1 = hf, \quad F_2 = hf(t+h, x + F_1)
~$$

The book calls this Heun's method (1859-1929).

It is used like Euler's method:



### General RK method

The general second-order method may have coefficients:

$$~
x(t+h) = x + w_1 hf + w_2 hf(t +\alpha h, x + \beta h f) + \mathcal{O}(h^3)
= x + w_1 hf + w_2 h \left( f + \alpha hf_t + \beta h f f_x\right) + \mathcal{O}(h^3)
~$$

The coefficients satisfy: $w1 + w2=1, w_2\alpha = 1/2, w_2\beta = 1/2$.

Setting $w_1 = 0, w_2 = 1, \alpha = \beta = 1/2$ gives:

$$~
\begin{align}
x(t+h) &= x(t) + F2\\
F_1 &= h f(t,x)\\
F_2 &= h f(t + h/2, x + F1/2).
\end{align}
~$$


This is called a modified Euler method, which is of the form $x(t+h) = x(t) + F1$


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
backend(:gadfly)
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
\begin{align}
F1(t,x) &= h f(t,x)\\
F2(t,x) &= hf(t + h/2, x + F_1/2)\\
F3(t,x) &=  hf(t + h/2, x + F_2/2)\\
F4(t,x) &=  hf(t + h, x + F_3).
\end{align}
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
x_{n+1} = x_n + h \sum_{i=1}^s b_i k_i
k_i = f(t_n + c_i h, x_n + h \sum_{j=1}^s a_{ij} k_j
~$$

Where, the coefficients $a,b,c$ are from a table:

$$~
\begin{array}{c|cccc}
c_1 & a_{11} & a_{12} & \cdots & a_{1s}\\
c_2 & a_{21} & a_{22} & \cdots & a_{2s}\\
&&\cdots&&\\
c_s & a_{s1} & a_{s2} & \cdots & a_{ss}\\
\hline
& b_1 & b_2 & \cdots & b_n
\end{array}
~$$

To see some examples: [Runge-Kutta](https://github.com/JuliaLang/ODE.jl/blob/master/src/runge_kutta.jl) .

## Error

The local truncation error for the 4th order RK method is like $C h^5$, as the Taylor series used employs exact terms up to $h^4$.


If we have, as in the book, $x$ be the approximate solution and $x^*$ the exact one, we have:

$$~
x^*(t_0 + h) - x(t_0+h) = \text{local truncation error} = C h^5.
~$$

How to monitor the growth of this error? The book suggests looking at $u$ -- the approximate value with one step of size $h$ and $v$ -- the approximate error of two steps of size $h/2$.

Then we have $x^*(t+h) = u + Ch^5$ and if $C$ is constant:

$$~
\begin{align}
x(t + h/2) &= v + C(h/2)^5\\
x(t + h) &= x(t + h/2 + h/2) = x(t+h/2) + C(h/2)^5 = v + C(h/2)^5 + C(h/2)^5 = v + 2C (h/2)^5
\end{align}
~$$

So, we have local error $= Ch^5 = (u-v)/(1 = 2^{-4}$ so is basically estimated by $u-v$. This can be monitored during the evaluation to see if there is growth. If so, $h$ can be adjusted.
