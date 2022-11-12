using LinearAlgebra

function alg1(x, y)
    S = 0
    n = length(x)
    for i in 1:n
        S += x[i] * y[i]
    end
    return S
end

function alg2(x, y)
    S = 0
    n = length(x)
    for i in n:-1:1
        S += x[i] * y[i]
    end
    return S
end

function alg3(x, y)
    partialproducts = x .* y
    sort!(partialproducts, rev=true)

    s1 = 0
    for xy in partialproducts
        if xy >= 0
            s1 += xy
        end
    end

    s2 = 0
    reverse!(partialproducts)

    for xy in partialproducts
        if xy < 0
            s2 += xy
        end
    end

    return s1 + s2
end

function alg4(x, y)
    partialproducts = x .* y
    sort!(partialproducts)

    s1 = 0
    for xy in partialproducts
        if xy >= 0
            s1 += xy
        end
    end


    s2 = 0
    reverse!(partialproducts)

    for xy in partialproducts
        if xy < 0
            s2 += xy
        end
    end

    return s1 + s2
end

function main()
    println("Float64 --------------------------------------------------")

    x::Vector{Float64} = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
    y::Vector{Float64} = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

    println(alg1(x, y))
    println(alg2(x, y))
    println(alg3(x, y))
    println(alg4(x, y))

    println(x ⋅ y)


    println("Float32 --------------------------------------------------")

    x32::Vector{Float32} = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
    y32::Vector{Float32} = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

    println(alg1(x32, y32))
    println(alg2(x32, y32))
    println(alg3(x32, y32))
    println(alg4(x32, y32))

    println(x32 ⋅ y32)

    println("Float16 --------------------------------------------------")

    x16::Vector{Float16} = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
    y16::Vector{Float16} = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

    println(alg1(x16, y16))
    println(alg2(x16, y16))
    println(alg3(x16, y16))
    println(alg4(x16, y16))

    println(x16 ⋅ y16)
end

main()