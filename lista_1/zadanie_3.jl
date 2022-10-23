using ProgressBars

function check()
    δ = 2^(-52)
    y = nextfloat(1.0)
    succes = true
    for k in ProgressBar(1:(2^(52)-1))
        if y != 1 + k * δ
            succes = false
            break
        end
        y = nextfloat(y)
    end
    return succes
end

println(check())