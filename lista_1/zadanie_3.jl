function check(first::Float64, last::Float64, step::Float64)
    x = nextfloat(first)
    while (x < last)
        if (nextfloat(x) != x + step)
            return false
        end
        x = nextfloat(x)
    end
    true
end

println(check(1.0, 2.0, 2.0^(-52)))