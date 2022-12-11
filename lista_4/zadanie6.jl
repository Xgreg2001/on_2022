include("intepolation.jl")

using .interpolation

f(x) = abs(x)
g(x) = 1 / (1 + x^2)

for n in 5:5:15
    rysujNnfx(f, -1.0, 1.0, n, title="f(x) = |x|")
    rysujNnfx(g, -5.0, 5.0, n, title="f(x) = frac{1}{(1 + x^2)}")
end
