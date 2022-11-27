import Solvers
using Test

# Test bisection method
@testset "Bisection tests" begin
    f(x) = x^2 - 2
    a = 1.0
    b = 2.0
    delta = 1e-6
    epsilon = 1e-6
    (x, y, k, err) = Solvers.mbisekcji(f, a, b, delta, epsilon)
    @test isapprox(x, 1.41421356237310, atol=delta)
    @test err == 0
end

# Test Newton's method
@testset "Newton's method tests" begin
    f(x) = x^2 - 2
    pf(x) = 2x
    x0 = 1.0
    delta = 1e-6
    epsilon = 1e-6
    maxit = 100
    (x, y, k, err) = Solvers.mstycznych(f, pf, x0, delta, epsilon, maxit)
    @test isapprox(x, 1.41421356237310, atol=delta)
    @test err == 0
end

# Test secant method
@testset "Secant method tests" begin
    f(x) = x^2 - 2
    x0 = 1.0
    x1 = 2.0
    delta = 1e-6
    epsilon = 1e-6
    maxit = 100
    (x, y, k, err) = Solvers.msiecznych(f, x0, x1, delta, epsilon, maxit)
    @test isapprox(x, 1.41421356237310, atol=delta)
    @test err == 0
end
