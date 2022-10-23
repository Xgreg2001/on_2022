function find_number()
    x = nextfloat(1.0)
    while x * (1.0 / x) == 1.0 && x < 2.0
        x = nextfloat(x)
    end
    if x < 2.0
        return x
    else
        return nothing
    end
end

function main()
    println(find_number())
end

main()