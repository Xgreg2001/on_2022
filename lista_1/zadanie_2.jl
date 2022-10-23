function kahan(type)
    return type(3) * (type(4) / type(3) - type(1)) - type(1)
end

function main()
    println("calculated kahan Float16: $(kahan(Float16)), real: $(eps(Float16))")
    println("calculated kahan Float32: $(kahan(Float32)), real: $(eps(Float32))")
    println("calculated kahan Float64: $(kahan(Float64)), real: $(eps(Float64))")
end

main()