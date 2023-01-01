in 0 0_1 # x[1]
in 1 0_0 # x[0]
in 2 1_1 # y[1]
in 3 1_0 # y[0]
ref 4 # r1
not 2 # u1_NOT
buf 4 # u2_BUF
not 0 # u2_NOT
xor 1 3 # u3_XOR
and 0 2 # u5_AND
xor 4 8 # u4_XOR
and 5 10 # u2_AND
xor 1 10 # u5_XOR
and 12 2 # u1_AND
xor 13 11 # u7_XOR
and 7 14 # u4_AND
xor 3 14 # u8_XOR
and 16 0 # u3_AND
xor 17 15 # u10_XOR
xor 9 18 # u11_XOR
out 19 0_1 # z[1]
out 6 0_0 # z[0]
