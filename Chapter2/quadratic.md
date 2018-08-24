# The quadratic equation

In a paper of [Kahan](https://people.eecs.berkeley.edu/~wkahan/Qdrtcs.pdf)
the issue of computing the quadratic equation arises.

Kahan writes the equation as $ax^2 + 2bx + c$ so the critical computation is the
discriminant $b^2 - a \cdot c$. The issue comes from large enough values that the subtraction masks the low bits influence.

Here is an example in the paper, which should be 1.0 -- not 2.0

```
a,b,c = 94906266.375, 94906267.375, 94906268.375
b^2 - a * c
```

Dekker shows a way to split numbers into a high and low part:

```
function dekker_break(x)
    bigx = x * 134217729.0  # 2^27-1
    y = x - bigx
    xh = y + bigx
    xl = x - xh
    xh, xl
end
```

We have

```
dekker_break(a)
```

Then we can compute `b^2` with:

```
bh, bl = dekker_break(b)
p = b*b
dp = ((bh * bh - p) + 2bh * bl) + bl * bl
p, dp
```

And `a*c` is similar:

```
ah,al = dekker_break(a)
ch,cl = dekker_break(c)
q = a*c; dq = ((ah*ch - q) + (ah*cl + al*ch)) + al*cl
q, dq
```

Here `p-q` gives the simple answer, the correction `dp-dq` carries the bits that were lost:

```
p-q, dp - dq
```

And then

```
(p-q) + (dp - dq)
```

Note, we can check using BigFloats which have more precision:

```
big(b)^2 - big(a) * big(c)
```

With this, the quadratic equation can be solved with:

```
function discr(a, b, c)
    ah, al = dekker_break(a)  
    bh, bl = dekker_break(b)  
    ch, cl = dekker_break(c)  
    p = b*b
    dp = ((bh * bh - p) + 2bh * bl) + bl * bl
    q = a*c
	dq = ((ah*ch - q) + (ah*cl + al*ch)) + al*cl
    (p-q) + (dp - dq)
end

## Solve ax^2 + bx + c;  complex values not covered below
function qdrt(a, b, c)
#  b = -b
  d = discr(a,b,c)
  r = sqrt(d) * (sign(b) + iszero(b)) + b
  r/a, c/r
end
```

Trying it out we have:

```
a, b, c = 1, -1, 1 # x^2 - 2x + 1 -> (x-1)^2
qdrt(a, b, c)
```



And

```
a,b,c = 94906266.375, 94906267.375, 94906268.375
qdrt(a, b, c)
```

Which is correct, but other methods (this one using a linear algebra
techique, not the straightforward discriminant calculution) can be wrong:

```
using Polynomials
x = variable()
r1, r2 = roots(a*x^2 - 2b*x + c)
r1, r2
```
