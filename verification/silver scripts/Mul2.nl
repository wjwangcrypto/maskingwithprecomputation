in 0 0_2 # x[2]
in 1 0_1 # x[1]
in 2 0_0 # x[0]
in 3 1_2 # y[2]
in 4 1_1 # y[1]
in 5 1_0 # y[0]
ref 6 # r[1]
ref 7 # r[0]
buf 7 # u1_BUF
not 3 # u1_NOT
xor 2 5 # u1_XOR
buf 6 # u2_BUF
not 3 # u2_NOT
xor 1 4 # u2_XOR
not 0 # u3_NOT
not 0 # u4_NOT
and 0 3 # u9_AND
xor 7 10 # u3_XOR
xor 6 13 # u4_XOR
and 9 17 # u2_AND
and 12 18 # u4_AND
xor 2 17 # u5_XOR
xor 1 18 # u7_XOR
and 21 3 # u1_AND
and 22 3 # u3_AND
xor 23 19 # u6_XOR
xor 24 20 # u8_XOR
xor 4 26 # u11_XOR
and 14 25 # u6_AND
and 15 26 # u8_AND
xor 5 25 # u9_XOR
and 30 0 # u5_AND
and 27 0 # u7_AND
xor 31 28 # u10_XOR
xor 32 29 # u12_XOR
xor 16 33 # u13_XOR
xor 35 34 # u14_XOR
out 36 0_2 # z[2]
out 11 0_1 # z[1]
out 8 0_0 # z[0]
