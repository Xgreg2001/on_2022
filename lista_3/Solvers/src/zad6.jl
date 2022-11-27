using Solvers

f1(x) = exp(1 - x) - 1 # x = 1
fp1(x) = -exp(1 - x)
f2(x) = x * exp(-x)  # x = 0
fp2(x) = exp(-x) - x * exp(-x)
δ = 1e-5
ε = 1e-5
maxiter = 1000

# metoda bisekcji
a1 = 0.0
b1 = 3.0
a2 = -1.0
b2 = 2.0

(x1, y1, k1, err) = Solvers.mbisekcji(f1, a1, b1, δ, ε)
(x2, y2, k2, err) = Solvers.mbisekcji(f2, a2, b2, δ, ε)

println("metoda bisekcji")
println("x1 ≈ $x1, y1 ≈ $y1, k1 = $k1, err = $err")
println("x2 ≈ $x2, y2 ≈ $y2, k2 = $k2, err = $err")


# metoda Newtona
x0 = 0.5

(x1, y1, k1, err) = Solvers.mstycznych(f1, fp1, x0, δ, ε, maxiter)

x0 = 0.5

(x2, y2, k2, err) = Solvers.mstycznych(f2, fp2, x0, δ, ε, maxiter)

println("metoda Newtona")
println("x1 ≈ $x1, y1 ≈ $y1, k1 = $k1, err = $err")
println("x2 ≈ $x2, y2 ≈ $y2, k2 = $k2, err = $err")

# metoda siecznych
a1 = 0.5
b1 = 1.5
a2 = -1.5
b2 = 0.5

(x1, y1, k1, err) = Solvers.msiecznych(f1, a1, b1, δ, ε, maxiter)
(x2, y2, k2, err) = Solvers.msiecznych(f2, a2, b2, δ, ε, maxiter)

println("metoda siecznych")
println("x1 ≈ $x1, y1 ≈ $y1, k1 = $k1, err = $err")
println("x2 ≈ $x2, y2 ≈ $y2, k2 = $k2, err = $err")

println("wolfram alpha")
println("x1 = 1")
println("x2 = 0")

# dodatkowe testy metody Newtona

x0 = 100.0
(x1, y1, k1, err1) = Solvers.mstycznych(f1, fp1, x0, δ, ε, maxiter)

x0 = 100.0
(x2, y2, k2, err2) = Solvers.mstycznych(f2, fp2, x0, δ, ε, maxiter)

x0 = 1.0
(x3, y3, k3, err3) = Solvers.mstycznych(f2, fp2, x0, δ, ε, maxiter)

println("dodatkowe testy")
println("x1 ≈ $x1, y1 = $y1, k1 = $k1, err = $err1")
println("x2 ≈ $x2, y2 = $y2, k2 = $k2, err = $err2")
println("x3 ≈ $x3, y3 = $y3, k3 = $k3, err = $err3")