function derivative(f)
    return h -> (f(1.0 + h) - f(1.0)) / h
end

function main()
    f(x) = sin(x) + cos(3x)
    df(h) = derivative(f)(h)
    diff(h) = abs(df(h) - (cos(1.0) - 3sin(3.0)))

    println("real value = ", cos(1.0) - 3sin(3.0))

    for h in [2.0^(-n) for n in 0:54]
        println("h = $h, derivative = $(df(h)), diff = $(diff(h))")
    end
end

main()