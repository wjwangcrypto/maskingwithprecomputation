in 0 0_3 # x[3]
in 1 0_2 # x[2]
in 2 0_1 # x[1]
in 3 0_0 # x[0]
in 4 1_3 # y[3]
in 5 1_2 # y[2]
in 6 1_1 # y[1]
in 7 1_0 # y[0]
ref 8 # r[2]
ref 9 # r[1]
ref 10 # r[0]
and 0 4 # u13_AND
buf 10 # u1_BUF
not 4 # u1_NOT
xor 3 7 # u1_XOR
xor 1 5 # u21_XOR
buf 9 # u2_BUF
not 4 # u2_NOT
xor 2 6 # u2_XOR
buf 8 # u3_BUF
not 4 # u3_NOT
not 0 # u4_NOT
not 0 # u5_NOT
not 0 # u6_NOT
xor 10 14 # u3_XOR
xor 9 18 # u4_XOR
xor 8 15 # u5_XOR
xor 1 26 # u10_XOR
and 13 24 # u2_AND
and 17 25 # u4_AND
and 20 26 # u6_AND
xor 3 24 # u6_XOR
xor 2 25 # u8_XOR
and 31 4 # u1_AND
and 32 4 # u3_AND
and 27 4 # u5_AND
xor 35 30 # u11_XOR
xor 33 28 # u7_XOR
xor 34 29 # u9_XOR
and 22 38 # u10_AND
and 23 36 # u12_AND
xor 7 37 # u12_XOR
xor 6 38 # u14_XOR
xor 5 36 # u16_XOR
and 21 37 # u8_AND
and 43 0 # u11_AND
and 41 0 # u7_AND
and 42 0 # u9_AND
xor 46 44 # u13_XOR
xor 47 39 # u15_XOR
xor 45 40 # u17_XOR
xor 11 48 # u18_XOR
xor 51 49 # u19_XOR
xor 52 50 # u20_XOR
out 53 0_3 # z[3]
out 19 0_2 # z[2]
out 16 0_1 # z[1]
out 12 0_0 # z[0]
