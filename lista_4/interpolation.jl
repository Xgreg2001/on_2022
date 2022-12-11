module interpolation
export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx
using Plots

function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})::Vector{Float64}
    n = length(x)
    fx = zeros(n)
    for i in 1:n
        fx[i] = f[i]
    end
    for j in 2:n
        for i in n:-1:j
            fx[i] = (fx[i] - fx[i-1]) / (x[i] - x[i-j+1])
        end
    end
    fx
end

function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)::Float64
    n = length(x)
    if n != length(fx)
        error("Vectors x and fx must have the same length")
    end
    nt = fx[n]
    for i in (n-1):-1:1
        nt = fx[i] + (t - x[i]) * nt
    end
    return nt
end

function naturalna(x::Vector{Float64}, fx::Vector{Float64})::Vector{Float64}
    n = length(x)
    a = zeros(n)
    a[n] = fx[n]
    for i in (n-1):-1:1
        a[i] = fx[i] - x[i] * a[i+1]
        for j in (i+1):(n-1)
            a[j] += -x[i] * a[j+1]
        end
    end
    return a
end

function rysujNnfx(f, a::Float64, b::Float64, n::Int; points::Int=50, title::String="")
    x = zeros(n + 1)
    y = zeros(n + 1)
    h = (b - a) / n
    for k in 0:n
        x[k+1] = a + k * h
        y[k+1] = f(x[k+1])
    end
    c = ilorazyRoznicowe(x, y)

    points = points * (n + 1)
    dx = (b - a) / (points - 1)
    xs = zeros(points)
    poly = zeros(points)
    func = zeros(points)
    xs[1] = a
    poly[1] = func[1] = y[1]
    for i in 2:points
        xs[i] = xs[i-1] + dx
        poly[i] = warNewton(x, c, xs[i])
        func[i] = f(xs[i])
    end
    if title != "" && title[end] != ' '
        title *= " "
    end
    title *= "{[$a, $b], n = $n}"
    p = plot(xs, [poly func], label=["wielomian" "funkcja"], title=title, xlabel="x", ylabel="f")
    savefig(p, joinpath("plots", title * ".pdf"))
end

end