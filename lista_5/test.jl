include("blocksys.jl")

using Test

@testset "BlockMatrix" verbose = true begin
    @testset "constructor" begin
        @test_throws ArgumentError BlockMatrix(0, 1)
        @test_throws ArgumentError BlockMatrix(1, 0)
        @test_throws ArgumentError BlockMatrix(5, 2)
        @test BlockMatrix(2, 1).A == zeros(Float64, (2, 4))
        @test BlockMatrix(4, 2).A == zeros(Float64, (4, 8))
    end

    @testset "parse_block_matrix" begin
        A = BlockMatrix(16, 4)
        A[1, 1] = 6.472204153472842
        A[1, 2] = 1.6794441980562251
        A[1, 3] = 0.4518618115124827
        A[1, 4] = -5.940314442095443
        A[2, 1] = -4.47613982262811
        A[2, 2] = 0.679021550863653
        A[2, 3] = -1.8520456270913648
        A[2, 4] = 4.664232022478227
        A[3, 1] = -1.0401829212332483
        A[3, 2] = 0.2755438527619016
        A[3, 3] = 4.351791232339091
        A[3, 4] = -0.4550986699303858
        A[4, 1] = 2.129011850625808
        A[4, 2] = -7.111319883771252
        A[4, 3] = 0.05552676057759293
        A[4, 4] = 5.782335549873531
        A[1, 5] = 0.18108030442212697
        A[2, 6] = 0.19507088380502147
        A[3, 7] = 0.2850387836647197
        A[4, 8] = 0.13381883268555225
        A[5, 5] = -3.7495443563842135
        A[5, 6] = 0.8977348525504317
        A[5, 7] = -5.040360971180651
        A[5, 8] = 6.934467120035241
        A[6, 5] = 2.153113994242057
        A[6, 6] = 4.581601390062811
        A[6, 7] = -0.05262598907344411
        A[6, 8] = -4.213834982994722
        A[7, 5] = 5.239444785849025
        A[7, 6] = -1.9839146107208354
        A[7, 7] = 2.5182703586888504
        A[7, 8] = -3.198500175952431
        A[8, 5] = -3.245923879911958
        A[8, 6] = -2.613838178617665
        A[8, 7] = 6.135762021799448
        A[8, 8] = -0.0994829814327277
        A[5, 9] = 0.031660482059582926
        A[6, 10] = 0.20960513248293544
        A[7, 11] = 0.06186262364724664
        A[8, 12] = 0.24700053889062848
        A[5, 1] = 0.2840237006864792
        A[5, 4] = 0.2929973771957905
        A[5, 2] = 0.02770353141669768
        A[6, 4] = 0.17760920257345583
        A[5, 3] = 0.1112662107735794
        A[7, 4] = 0.20171925600894386
        A[8, 4] = 0.0010828131364946979
        A[9, 9] = 0.39584942094943026
        A[9, 10] = -1.7596504706596237
        A[9, 11] = -0.35749488488060477
        A[9, 12] = 3.576456929837188
        A[10, 9] = -4.961041676527304
        A[10, 10] = 7.799414864231728
        A[10, 11] = -3.8095074498606327
        A[10, 12] = 3.568246499126192
        A[11, 9] = 5.691731343273831
        A[11, 10] = -0.7688830770178716
        A[11, 11] = -3.9884150333596007
        A[11, 12] = -2.2494494120366917
        A[12, 9] = -0.20393868721371192
        A[12, 10] = -2.008080450842255
        A[12, 11] = 6.190013145529669
        A[12, 12] = -3.086179968062573
        A[9, 13] = 0.14552140315166961
        A[10, 14] = 0.02982980169755751
        A[11, 15] = 0.0536149498138325
        A[12, 16] = 0.005599811996532455
        A[9, 5] = 0.04090869658682606
        A[9, 8] = 0.13068381176047877
        A[9, 6] = 0.24725714025069048
        A[10, 8] = 0.06607325698951601
        A[9, 7] = 0.2294407648245009
        A[11, 8] = 0.06801880552244467
        A[12, 8] = 0.050238101435045875
        A[13, 13] = -2.6714208765939707
        A[13, 14] = 4.122855266948949
        A[13, 15] = -0.2360859867259575
        A[13, 16] = 2.3712327819093892
        A[14, 13] = 1.046345349224168
        A[14, 14] = -5.309219015205901
        A[14, 15] = 0.24589176796198314
        A[14, 16] = 3.875019728544292
        A[15, 13] = 0.7152058008415196
        A[15, 14] = -2.8392415572076897
        A[15, 15] = 6.352199419351599
        A[15, 16] = -7.15710587756658
        A[16, 13] = 2.264728434857337
        A[16, 14] = 5.718903129161993
        A[16, 15] = -4.751272942281603
        A[16, 16] = -0.0036046745123671994
        A[13, 9] = 0.24485539119809113
        A[13, 12] = 0.20590827537497078
        A[13, 10] = 0.22151699846783293
        A[14, 12] = 0.26121226126704034
        A[13, 11] = 0.07877302648132634
        A[15, 12] = 0.11149195748131871
        A[16, 12] = 0.2511145088612949
        B = parse_block_matrix("data/Dane16_1_1/A.txt")
        for i in 1:16, j in 1:16
            @test A[i, j] == B[i, j]
        end
    end

    @testset "parse_rhs" begin
        b = parse_rhs("data/Dane16_1_1/b.txt")
        @test b == [2.8442760253682344,
            -0.7898609925725735,
            3.4170922776020776,
            0.9893731099912335,
            -0.21005205284706197,
            2.8554687472930924,
            2.8388822375207994,
            0.42460033386422047,
            2.648972811820556,
            2.6930152956570566,
            -1.1933824238040565,
            0.9476519528427071,
            4.337634877060631,
            0.11925009179158286,
            -2.817450257099832,
            3.4798684560866553]
    end

    @testset "gauss_elimination" begin
        A = parse_block_matrix("data/Dane10000_1_1/A.txt")
        b = parse_rhs("data/Dane10000_1_1/b.txt")

        x = gauss_elimination(A, b)

        for v in x
            @test v ≈ 1.0
        end

        for (i, v) in enumerate(A * x)
            @test v ≈ b[i]
        end
    end

    @testset "gauss_elimination_with_pivoting" begin
        A = parse_block_matrix("data/Dane10000_1_1/A.txt")
        b = parse_rhs("data/Dane10000_1_1/b.txt")

        x = gauss_elimination_with_pivoting(A, b)

        for v in x
            @test v ≈ 1.0
        end

        for (i, v) in enumerate(A * x)
            @test v ≈ b[i]
        end
    end


    @testset "LU" begin
        A = parse_block_matrix("data/Dane10000_1_1/A.txt")
        b = parse_rhs("data/Dane10000_1_1/b.txt")

        generate_lu!(A)

        x = lu_solve(A, b)

        for v in x
            @test v ≈ 1.0
        end
    end

    @testset "LU with pivoting" begin
        A = parse_block_matrix("data/Dane10000_1_1/A.txt")
        b = parse_rhs("data/Dane10000_1_1/b.txt")

        p = generate_lu_with_pivoting!(A)

        x = lu_solve_with_pivoting(A, p, b)

        for v in x
            @test v ≈ 1.0
        end
    end

    @testset "generated x" begin
        A = parse_block_matrix("data/Dane10000_1_1/A.txt")
        b = parse_rhs("data/Dane10000_1_1/b.txt")
        x = [1.0 for i in 1:A.n]

        for (i, v) in enumerate((A * x))
            @test v ≈ b[i]
        end
    end

    @testset "save_vec_to_file" begin
        x = [1.0 for i in 1:16]
        save_vec_to_file("test.txt", x)
        open("test.txt") do f
            for line in eachline(f)
                @test line == "1.0"
            end
        end
        rm("test.txt")
    end

    @testset "save_vec_with_error_to_file" begin
        A = parse_block_matrix("data/Dane16_1_1/A.txt")
        true_x = [1.0 for i in 1:A.n]
        b = A * true_x
        x = gauss_elimination(A, b)

        save_vec_with_error_to_file("test.txt", x)

        error = norm(x - true_x) / norm(true_x)

        open("test.txt") do f
            @test error == parse(Float64, readline(f))
            for v in x
                @test v == parse(Float64, readline(f))
            end
        end
        rm("test.txt")
    end
end