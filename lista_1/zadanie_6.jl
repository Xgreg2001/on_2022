f(x) = sqrt(x * x + 1) - 1
g(x) = x * x / (sqrt(x * x + 1) + 1)

function main()
    for x in [8.0^(-i) for i in 1:52]
        println(x, " | ", f(x), " | ", g(x))
    end
end

main()