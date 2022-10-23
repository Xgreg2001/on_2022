
function macheps(type)
    eps = one(type)
    prev_eps = eps
    while one(type) + eps != one(type)
        prev_eps = eps
        eps /= 2
    end
    return prev_eps
end

function eta(type)
    eta = one(type)
    prev_eta = eta
    while eta != zero(type)
        prev_eta = eta
        eta /= 2
    end
    return prev_eta
end

function MAX(type)
    MAX = one(type)
    prev_MAX = MAX
    while !isinf(MAX)
        prev_MAX = MAX
        MAX *= 2
    end
    return prev_MAX
end

function main()
    println("calculated eps Float16: $(macheps(Float16)), real: $(eps(Float16))")
    println("calculated eps Float32: $(macheps(Float32)), real: $(eps(Float32))")
    println("calculated eps Float64: $(macheps(Float64)), real: $(eps(Float64))")

    @assert macheps(Float16) == eps(Float16)
    @assert macheps(Float32) == eps(Float32)
    @assert macheps(Float64) == eps(Float64)

    println("calculated eta Float16: $(eta(Float16)), real: $(nextfloat(zero(Float16)))")
    println("calculated eta Float32: $(eta(Float32)), real: $(nextfloat(zero(Float32)))")
    println("calculated eta Float64: $(eta(Float64)), real: $(nextfloat(zero(Float64)))")

    @assert eta(Float16) == nextfloat(zero(Float16))
    @assert eta(Float32) == nextfloat(zero(Float32))
    @assert eta(Float64) == nextfloat(zero(Float64))

    println("float min Float32: $(floatmin(Float32))")
    println("float min Float64: $(floatmin(Float64))")

    println("calculated MAX Float16: $(MAX(Float16)), real: $(floatmax(Float16))")
    println("calculated MAX Float32: $(MAX(Float32)), real: $(floatmax(Float32))")
    println("calculated MAX Float64: $(MAX(Float64)), real: $(floatmax(Float64))")
end

main()