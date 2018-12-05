# Some example ODEs

## Newton

* The famous equation $F=ma$ can be written as a differential equation via $F=m dv/dt$ or $F = m d^2x /dt^2$.

This equation is solved to give the basic equations of motion.

```
using SymPy
v = SymFunction("v")
@vars t F m t0 v0
eqn = dsolve(v'(t) - F/m, t, (v, t0, v0))
```

```
x = SymFunction("x")
@vars x0
eqn = dsolve(x'(t) - rhs(eqn), t, (x, t0, x0))
```

```
using Plots
fn = lambdify(real(rhs(eqn(t0=>0, x0=>0, v0=>10,F => -9.8, m => 1))))
plot(fn, color=:red, 0, 2)
```


* The Newton law of cooling


$dT/dt = -r(T - T_a)$.


```
T = SymFunction("T")
@vars Ta T0 r
eqn = dsolve(T'(t) + r * (T(t) - Ta), t, (T, t0, T0))
```

```
fn = rhs(eqn(t0 => 0, T0=>10, r=>2, Ta=>5))
plot(lambdify(fn), 0, 5)
```

* Hooke's law

Hooke's law is a law of physics that states that the force (F) needed to extend or compress a spring by some distance x scales linearly with respect to that distance. That is: $F_{s}=-kx$.

Using $F=ma = m d^2x/dt^2$ we have $x''(t) = -kx(t)$.

It can be seen that $\cos(\sqrt{k}t)$ and $\sin(\sqrt{t}t)$ will be solutions.


## The tractrix

The trajectory determined by the middle of the back axle of a car pulled by a rope at a constant speed and with a constant direction (initially perpendicular to the vehicle).

$$~
dx/dt = - \sqrt{a^2 - x^2}/x.
~$$


One solution is

```
a = 2
y(t) = a*log((a + sqrt(a^2 + t^2))/t - sqrt(a^2 - t^2))
plot(y, 0, 1.9)
```
