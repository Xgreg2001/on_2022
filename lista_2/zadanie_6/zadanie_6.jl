using Plots
using Memoize

@memoize function x(n::Int, x0::Float64, c::Float64)::Float64
    if n == 0
        return x0
    end
    tmp = x(n - 1, x0, c)
    return tmp * tmp + c
end

cases = [(-2.0, 1.0), (-2.0, 2.0), (-2.0, 1.99999999999999), (-1.0, 1.0), (-1.0, -1.0), (-1.0, 0.75), (-1.0, 0.25)]

for (c, x0) in cases
    plt = scatter([x(n, x0, c) for n in 1:40], label="c= $c, x0= $x0")
    savefig(plt, "$(c)_$x0.pdf")
end