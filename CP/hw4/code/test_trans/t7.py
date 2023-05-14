
*** Source Program **
m = input()
n = int(m)
i = 1
s = 1
while (i <= n):
    s *= i
    i += 1

print(s)


*** Target Program **
   3 : read .t1
   4 : m = .t1
   5 : .t3 = m
   6 : .t2 = int(.t3)
   7 : n = .t2
   8 : .t4 = 1
   9 : i = .t4
  10 : .t5 = 1
  11 : s = .t5
  12 : SKIP
  14 : .t7 = i
  15 : .t8 = n
  16 : .t6 = .t7 <= .t8
  26 : iffalse .t6 goto 13
  17 : .t10 = s
  18 : .t11 = i
  19 : .t9 = .t10 * .t11
  20 : s = .t9
  21 : .t13 = i
  22 : .t14 = 1
  23 : .t12 = .t13 + .t14
  24 : i = .t12
  25 : goto 12
  13 : SKIP
  27 : .t16 = s
  28 : .t17 = " "
  30 : write .t16
  29 : write .t17
  31 : .t18 = "\n"
  32 : write .t18
  33 : .t15 = None
   2 : HALT

