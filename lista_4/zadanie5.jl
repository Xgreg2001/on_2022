include("intepolation.jl")

using .interpolation

f(x) = exp(x)
g(x) = x^2 * sin(x)

for n in 5:5:15
    rysujNnfx(f, 0.0, 1.0, n, title="f(x) = e^x")
    rysujNnfx(g, -1.0, 1.0, n, title="f(x) = x^2 * sin(x)")
end
