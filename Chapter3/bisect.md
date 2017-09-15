
	
```
midpoint(a,b, f) = (a+b)/2
```

```
function alldone(a, b, c, fc, n, delta, epsilon, MAXITER)
    n > MAXITER && throw(DomainError())
    norm(b - a) <= b * delta && return true
    norm(fc) <= epsilon * c && return true
    false
end
```

```
function bisect(f, a, b; delta=eps(), epsilon=eps(), MAXITER=100, verbose=false)


    
    fa, fb = f(a), f(b)
    sign(fa)*sign(fb) >= 0 && throw(DomainError())
    
    fncalls = 2
    nsteps = 0

    
    c = midpoint(a, b, f)
    fc = f(c)
    
    while !alldone(a, b, c, fc, nsteps, delta, epsilon, MAXITER)

        iszero(fc) && return (c, nsteps, fncalls)
        if sign(fc) * sign(fa) < 0.0
            b, fb = c, fc
        else
            a, fa = c, fc
        end

        c = midpoint(a, b, f)
        fc = f(c)
        fncalls += 1
        nsteps += 1
        verbose && println(c)
    end

    (c, nsteps, fncalls)
end
```

```
bisect(sin, 3, 4)[1] ≈ pi
```

```
bisect(log, 1/10, 10^6)[1] ≈ 1
```

```
bisect(log, .1, 10^20, delta=1e-16, epsilon=0) # error
```


better
```
midpoint(a, b, f) = a + (b-a)/2
```        

```
bisect(log, .1, 10^20)[1] ≈ 1
```

```
bisect(sin, 3, 4)
```

We might try a stopping rule that assumes floating point numbers are
being used--as they are. This one would stop when the interval `[a,b]`
can't be subdivided (an impossibility mathematically, but should be
the case over the machine numbers):

```
function alldone(a, b, c, fc, n, delta, epsilon, MAXITER)
   a < c < b && return false
   true
end
```

```
x, n, fncalls = bisect(sin, 3, 4)
```

```
x, n, fncalls = bisect(x -> x^20 - 1, 0, pi)
```


Regula falsi can be much faster

Here the "midpoint" comes from the intersection point of the secant line
between `(a, f(a))` and `(b,f(b))`.


```
function midpoint(a, b, f)
    # c = a - f(a) / (f(b)-f(a)/(b-a))
    c = (a * f(b) - f(a) * b)/(f(b) - f(a))  # simplified
    c
end
```

```
x, n, fncalls = bisect(sin, 3, 4)
```


But this method can have issues not *always* here:

```
f(x) = x^20 - 1 # f(1) = 0
x, n, fncalls = bisect(f, 0, 2)  # moves too slow, note number of steps
```

