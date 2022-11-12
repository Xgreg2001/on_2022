function p(n, r, p0)
    if n == 0
        return p0
    end
    tmp = p(n - 1, r, p0)
    return tmp + r * tmp * (1 - tmp)
end

println("40 iterations Float32: ", p(40, Float32(3), Float32(0.01)))
println("40 iterations Float64: ", p(40, Float64(3), Float64(0.01)))

res = p(10, Float32(3), Float32(0.01))
println("10 iterations Float32 afther trunc: ", Float32(trunc(res * 1000) / 1000))
res = p(30, Float32(3), Float32(trunc(res * 1000) / 1000))

println("40 iterations Float32 with truncation: ", res)