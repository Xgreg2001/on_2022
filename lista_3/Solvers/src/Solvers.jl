module Solvers
MAX_ITER = 1000

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    u = f(a)
    v = f(b)
    e = b - a
    if sign(u) == sign(v)
        return (0, 0, 0, 1)
    end
    for k in 1:MAX_ITER
        e = e / 2
        c = a + e
        w = f(c)
        if abs(e) < delta || abs(w) < epsilon
            return (c, w, k, 0)
        end
        if sign(u) != sign(w)
            b = c
            v = w
        else
            a = c
            u = w
        end
    end
    println("Przekrozono maksymalną liczbę iteracji")
end

function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    if abs(v) < epsilon
        return (x0, v, 0, 0)
    end
    for k in 1:maxit
        if abs(pf(x0)) < epsilon
            return (x0, v, k, 2)
        end
        x1 = x0 - v / pf(x0)
        v = f(x1)
        if abs(x1 - x0) < delta || abs(v) < epsilon
            return (x1, v, k, 0)
        end
        x0 = x1
    end
    return (x0, v, maxit, 1)
end

function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64,
    maxit::Int)
    f0 = f(x0)
    f1 = f(x1)
    for k in 1:maxit
        if abs(f0) > abs(f1)
            x0, f0, x1, f1 = x1, f1, x0, f0
        end
        s = (x1 - x0) / (f1 - f0)
        x1 = x0
        f1 = f0
        x0 = x0 - s * f0
        f0 = f(x0)
        if abs(x1 - x0) < delta || abs(f0) < epsilon
            return (x0, f0, k, 0)
        end
    end
    return (x0, f0, maxit, 1)
end

precompile(mbisekcji, (Function, Float64, Float64, Float64, Float64))
precompile(mstycznych, (Function, Function, Float64, Float64, Float64, Int))
precompile(msiecznych, (Function, Float64, Float64, Float64, Float64, Int))

end