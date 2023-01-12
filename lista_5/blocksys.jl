using Profile
using LinearAlgebra

mutable struct BlockMatrix
    A::Matrix{Float64}
    n::Int64
    l::Int64
    v::Int64
end

function BlockMatrix(n::Int64, l::Int64)::BlockMatrix
    if n <= 0 || l <= 0
        throw(ArgumentError("n and l must be positive"))
    end
    if n % l != 0
        throw(ArgumentError("n must be a multiple of l"))
    end
    return BlockMatrix(zeros(Float64, (n, 4 * l)), n, l, n / l)
end

function Base.getindex(B::BlockMatrix, i::Int64, j::Int64)
    if (j + B.l < i || j + 1 > 3 * B.l + i)
        return 0.0
    end
    return B.A[i, j-i+B.l+1]
end

function Base.setindex!(B::BlockMatrix, v::Float64, i::Int64, j::Int64)
    if (j + B.l < i || j + 1 > 3 * B.l + i)
        throw(error("Index out of bounds"))
    end
    B.A[i, j-i+B.l+1] = v
    return B
end

function Base.size(B::BlockMatrix)
    return (B.n, B.n)
end

function Base.show(io::IO, B::BlockMatrix)
    println(io, "BlockMatrix of size $(B.n) with block size $(B.l)")
    println(io, B.A)
end

@inline function get_first_column(B::BlockMatrix, row_idx::Int64)::Int64
    return max(1, row_idx - B.l)
end

@inline function get_last_column(B::BlockMatrix, row_idx::Int64)::Int64
    return min(B.n, row_idx + B.l)
end

@inline function get_first_row(B::BlockMatrix, column_idx::Int64)::Int64
    return max(1, column_idx - B.l)
end

@inline function get_last_row(B::BlockMatrix, column_idx::Int64)::Int64
    return min(B.n, column_idx + B.l)
end

function parse_block_matrix(input::IOStream)::BlockMatrix
    header = readline(input)
    n, l = map(x -> parse(Int64, x), split(header))
    B = BlockMatrix(n, l)
    for line in eachline(input)
        line = split(line)
        B[parse(Int64, line[1]), parse(Int64, line[2])] = parse(Float64, line[3])
    end

    return B
end

function parse_block_matrix(filename::String)::BlockMatrix
    open(filename) do input
        return parse_block_matrix(input)
    end
end

function parse_rhs(input::IOStream)::Vector{Float64}
    header = readline(input)
    n = parse(Int64, header)
    rhs = Vector{Float64}()
    for line in eachline(input)
        push!(rhs, parse(Float64, line))
    end
    return rhs
end

function parse_rhs(filename::String)::Vector{Float64}
    open(filename) do input
        return parse_rhs(input)
    end
end

function Base.:*(B::BlockMatrix, x::Vector{Float64})::Vector{Float64}
    if length(x) != B.n
        throw(DimensionMismatch("x must be of length $(B.n)"))
    end
    R = zeros(Float64, B.n)
    for i in 1:B.n
        for j in max(1, i - B.l):min(B.n, i + 3 * B.l - 1)
            R[i] += x[j] * B[i, j]
        end
    end
    return R
end

function gauss_elimination(A::BlockMatrix, b::Vector{Float64})
    n = A.n

    # faza eliminacji
    for k in 1:n-1
        for i in k+1:get_last_row(A, k)
            if A[k, k] == 0.0
                error("Zero value on the diagonal of A at index ($k, $k)")
            end

            m = A[i, k] / A[k, k]
            A[i, k] = 0.0

            for j in k+1:get_last_column(A, k)
                A[i, j] -= m * A[k, j]
            end

            b[i] -= m * b[k]
        end
    end

    # wyznaczanie wektora x
    x = zeros(n)
    x[n] = b[n] / A[n, n]
    for i in n-1:-1:1
        x[i] = b[i]
        for j in i+1:get_last_column(A, i)
            x[i] -= A[i, j] * x[j]
        end
        x[i] /= A[i, i]
    end
    return x
end

function gauss_elimination_with_pivoting(A::BlockMatrix, b::Vector{Float64})
    n = A.n
    p = [1:n;]

    for k in 1:n-1
        bound = get_last_row(A, k)
        j = reduce((x, y) -> abs(A[p[x], k]) >= abs(A[p[y], k]) ? x : y, k:bound)
        p[k], p[j] = p[j], p[k]
        for i in k+1:bound
            z = A[p[i], k] / A[p[k], k]
            A[p[i], k] = 0.0
            # p[k] to najwyżej k + block_size, ponieważ poniżej są już zera
            # można by ograniczyć to bardziej, na przykład pamiętając maksymalny dotychczas użyty indeks wiersza (łącznie z p[k])
            for j in k+1:get_last_column(A, get_last_row(A, k))
                A[p[i], j] -= z * A[p[k], j]
            end
            b[p[i]] -= z * b[p[k]]
        end
    end

    # wyznaczanie wektora x
    x = zeros(n)
    x[n] = b[p[n]] / A[p[n], n]
    for i in n-1:-1:1
        x[i] = b[p[i]]
        # analiza jak wyżej
        for j in i+1:get_last_column(A, get_last_row(A, i))
            x[i] -= A[p[i], j] * x[j]
        end
        x[i] /= A[p[i], i]
    end
    return x

end

function generate_lu!(A::BlockMatrix)
    n = A.n

    for k in 1:n-1
        for i in k+1:get_last_row(A, k)
            if (A[k, k] == 0.0)
                error("Zero value on the diagonal of A at index ($k, $k)")
            end

            m = A[i, k] / A[k, k]
            A[i, k] = m

            for j in k+1:get_last_column(A, k)
                A[i, j] -= m * A[k, j]
            end

        end
    end
end

function lu_solve(LU::BlockMatrix, b::Vector{Float64})
    n = LU.n

    # Lz = b
    # z przechowamy w miejsce b, bo
    # na diagonali L są w domyśle jedynki
    for k in 1:n-1
        for i in k+1:get_last_row(LU, k)
            b[i] -= LU[i, k] * b[k]
        end
    end

    # Ux = z
    x = zeros(Float64, n)
    for i in n:-1:1
        x[i] = b[i]
        for j in i+1:get_last_column(LU, i)
            x[i] -= LU[i, j] * x[j]
        end
        x[i] /= LU[i, i]
    end
    return x
end

function generate_lu_with_pivoting!(A::BlockMatrix)
    n = A.n
    p = [1:n;]
    for k in 1:n-1
        bound = get_last_row(A, k)
        j = reduce((x, y) -> abs(A[p[x], k]) >= abs(A[p[y], k]) ? x : y, k:bound)
        p[k], p[j] = p[j], p[k]
        for i in k+1:bound
            z = A[p[i], k] / A[p[k], k]
            A[p[i], k] = z
            for j in k+1:get_last_column(A, get_last_row(A, k))
                A[p[i], j] -= z * A[p[k], j]
            end
        end
    end
    return p
end

function lu_solve_with_pivoting(LU::BlockMatrix, P::Vector{Int}, b::Vector{Float64})
    n = LU.n

    # Lz = Pb
    for i in 2:n
        # P[i] to maksymalnie i + block_size, więc tu maksymalnie 2 * block_size iteracji
        for j in get_first_column(LU, P[i]):i-1
            b[P[i]] -= LU[P[i], j] * b[P[j]]
        end
    end

    # Ux = z
    x = zeros(Float64, n)
    x[n] = b[P[n]] / LU[P[n], n]
    for i in n-1:-1:1
        x[i] = b[P[i]]
        for j in i+1:get_last_column(LU, get_last_row(LU, i))
            x[i] -= LU[P[i], j] * x[j]
        end
        x[i] /= LU[P[i], i]
    end
    return x
end


function save_vec_to_file(file_path::String, x::Vector)
    open(file_path, "w") do file
        for v in x
            println(file, v)
        end
    end
end

function save_vec_with_error_to_file(file_path::String, x::Vector)
    target_x = [1.0 for _ in x]
    error = norm(x - target_x) / norm(target_x)
    open(file_path, "w") do file
        println(file, error)
        for v in x
            println(file, v)
        end
    end
end


function Base.:*(A::BlockMatrix, B::BlockMatrix)
    C = BlockMatrix(A.n, A.l)

    for i in 1:A.n
        for j in get_first_column(A, i):get_last_column(A, i)
            sum = 0.0
            for k in get_first_row(B, i):get_last_row(B, i)
                sum += A[i, k] * B[k, j]
            end
            C[i, j] = sum
        end
    end
    return C
end

function get_L(LU::BlockMatrix)
    L = BlockMatrix(LU.n, LU.l)
    for i in 1:LU.n
        for j in get_first_column(LU, i):get_last_column(LU, i)
            if i == j
                L[i, j] = 1.0
            elseif i > j
                L[i, j] = LU[i, j]
            end
        end
    end
    return L
end

function get_U(LU::BlockMatrix)
    U = BlockMatrix(LU.n, LU.l)
    for i in 1:LU.n
        for j in get_first_column(LU, i):get_last_column(LU, i)
            if i <= j
                U[i, j] = LU[i, j]
            end
        end
    end
    return U
end

function Base.isapprox(A::BlockMatrix, B::BlockMatrix)
    result = true
    for i in 1:A.n
        for j in get_first_column(A, i):get_last_column(A, i)
            result &= isapprox(A[i, j], B[i, j])
        end
    end
    return result
end