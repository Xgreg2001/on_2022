include("blocksys.jl")

using Plots

# let julia compile everything
function compile_everything()
    A = parse_block_matrix("data/Dane16_1_1/A.txt")
    b = parse_rhs("data/Dane16_1_1/b.txt")
    x = gauss_elimination(A, b)
    A = parse_block_matrix("data/Dane16_1_1/A.txt")
    b = parse_rhs("data/Dane16_1_1/b.txt")
    x = gauss_elimination_with_pivoting(A, b)
    A = parse_block_matrix("data/Dane16_1_1/A.txt")
    b = parse_rhs("data/Dane16_1_1/b.txt")
    _A = deepcopy(A)
    generate_lu!(_A)
    L = get_L(A)
    U = get_U(A)
    x = lu_solve(A, b)
    A = parse_block_matrix("data/Dane16_1_1/A.txt")
    b = parse_rhs("data/Dane16_1_1/b.txt")
    p = generate_lu_with_pivoting!(A)
    x = lu_solve_with_pivoting(A, p, b)
end

compile_everything()

println("eliminacja gaussa")
println("rozmiar & błąd względny & czas \\\\")

times = [[], [], [], []]
ns = [16, 10000, 50000, 100000, 300000, 500000]

for folder_name in readdir("data")
    true_A = parse_block_matrix("data/$folder_name/A.txt")
    true_b = parse_rhs("data/$folder_name/b.txt")
    true_x = [1.0 for i in 1:true_A.n]

    A = deepcopy(true_A)
    b = deepcopy(true_b)

    time = @elapsed x = gauss_elimination(A, b)
    error = norm(true_x - x) / norm(true_x)
    println("$(true_A.n) & $(error) & $(time) \\\\")
    push!(times[1], time)
end

println("")

println("eliminacja gaussa z wyborem elementu głównego")
println("rozmiar & błąd względny & czas \\\\")

for folder_name in readdir("data")
    true_A = parse_block_matrix("data/$folder_name/A.txt")
    true_b = parse_rhs("data/$folder_name/b.txt")
    true_x = [1.0 for i in 1:true_A.n]

    A = deepcopy(true_A)
    b = deepcopy(true_b)

    time = @elapsed x = gauss_elimination_with_pivoting(A, b)
    error = norm(true_x - x) / norm(true_x)
    println("$(true_A.n) & $(error) & $(time) \\\\")

    push!(times[2], time)
end

println("")

println("rozkład LU")
println("rozmiar & błąd względny & czas \\\\")

for folder_name in readdir("data")
    true_A = parse_block_matrix("data/$folder_name/A.txt")
    true_b = parse_rhs("data/$folder_name/b.txt")
    true_x = [1.0 for i in 1:true_A.n]

    A = deepcopy(true_A)
    b = deepcopy(true_b)

    time = @elapsed generate_lu!(A)
    time += @elapsed x = lu_solve(A, b)
    error = norm(true_x - x) / norm(true_x)
    println("$(true_A.n) & $(error) & $(time) \\\\")

    push!(times[3], time)
end

println("")

println("rozkład LU z wyborem elementu głównego")
println("rozmiar & błąd względny & czas \\\\")


for folder_name in readdir("data")
    true_A = parse_block_matrix("data/$folder_name/A.txt")
    true_b = parse_rhs("data/$folder_name/b.txt")
    true_x = [1.0 for i in 1:true_A.n]

    A = deepcopy(true_A)
    b = deepcopy(true_b)

    time = @elapsed p = generate_lu_with_pivoting!(A)
    time += @elapsed x = lu_solve_with_pivoting(A, p, b)
    error = norm(true_x - x) / norm(true_x)
    println("$(true_A.n) & $(error) & $(time) \\\\")

    push!(times[4], time)
end

println("")

map(sort!, times)

plot(ns, times, label=["gauss" "gauss pivoting" "lu" "lu pivoting"], title="Czasy działania", xlabel="rozmiar macierzy", ylabel="czas [s]", legend=:topleft, marker=:+)

savefig("times.pdf")