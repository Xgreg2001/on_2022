using Solvers

f(x) = sin(x) - (0.5 * x)^2
pf(x) = cos(x) - x

# metoda bisekcji
a = 1.5
b = 2.0
δ = 0.5 * 10^(-5)
ε = 0.5 * 10^(-5)

(x, y, k, err) = Solvers.mbisekcji(f, a, b, δ, ε)

println("metoda bisekcji")
println("x ≈ $x, y ≈ $y, k = $k, err = $err")

# metoda Newtona
x0 = 1.5
δ = 0.5 * 10^(-5)
ε = 0.5 * 10^(-5)
maxit = 100

(x, y, k, err) = Solvers.mstycznych(f, pf, x0, δ, ε, maxit)

println("metoda Newtona")
println("x ≈ $x, y ≈ $y, k = $k, err = $err")

# metoda siecznych
x0 = 1.0
x1 = 2.0
δ = 0.5 * 10^(-5)
ε = 0.5 * 10^(-5)

(x, y, k, err) = Solvers.msiecznych(f, x0, x1, δ, ε, maxit)

println("metoda siecznych")
println("x ≈ $x, y ≈ $y, k = $k, err = $err")

println("wolfram alpha")
println("x ≈ 1.9337537628270212533")