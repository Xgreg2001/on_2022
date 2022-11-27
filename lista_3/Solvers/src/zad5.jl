using Solvers

f(x) = exp(x) - 3x

# metoda bisekcji
a1 = 0.0
b1 = 1.0
a2 = 1.0
b2 = 2.0
δ = 1e-4
ε = 1e-4

(x1, y1, k, err) = Solvers.mbisekcji(f, a1, b1, δ, ε)
(x2, y2, k, err) = Solvers.mbisekcji(f, a2, b2, δ, ε)

println("metoda bisekcji")
println("x1 ≈ ", x1)
println("x2 ≈ ", x2)

println("wolfram alpha")
println("x1 ≈ 0.619061")
println("x2 ≈ 1.51213")