include("interpolation.jl")
using .interpolation
using Test

@testset "$(rpad("test z wielomianem", 25))" begin
    w = x -> 5 * x^2 + 2 * x - 12
    x = [1.0, 2.0, 3.0, 4.0, 5.0]
    y = w.(x)
    c = ilorazyRoznicowe(x, y)
    val = z -> warNewton(x, c, z)
    @test c == [-5.0, 17.0, 5.0, 0.0, 0.0]
    @test naturalna(x, c) == [-12.0, 2.0, 5.0, 0.0, 0.0]
    @test val.(x) == y
end

@testset "$(rpad("zad 5 list 4", 25))" begin
    x = [-1.0, 0.0, 1.0, 2.0]
    y = [2.0, 1.0, 2.0, -7.0]
    c = ilorazyRoznicowe(x, y)
    val = z -> warNewton(x, c, z)
    @test c == [2.0, -1.0, 1.0, -2.0]
    @test naturalna(x, c) == [1.0, 2.0, 1.0, -2.0]
    @test val.(x) == y
end