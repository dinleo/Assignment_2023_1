
*** Source Program **
s = "COSE312"
for i in range(len(s)):
    print(s[i])

print()
for c in s:
    print(c)



*** Target Program **
   3 : .t1 = "COSE312"
   4 : s = .t1
   5 : .t5 = 0
   6 : __tidx__.t2 = .t5
   7 : .t7 = 0
   8 : .t9 = s
   9 : .t8 = len(.t9)
  10 : .t6 =  range(.t7, .t8)
  11 : __titer__.t3 = .t6
  12 : .t11 = __titer__.t3
  13 : .t10 = len(.t11)
  14 : __tlen__.t4 = .t10
  15 : SKIP
  17 : .t13 = __tidx__.t2
  18 : .t14 = __tlen__.t4
  19 : .t12 = .t13 < .t14
  38 : iffalse .t12 goto 16
  20 : .t16 = __titer__.t3
  21 : .t17 = __tidx__.t2
  22 : .t15 = .t16[.t17]
  23 : i = .t15
  24 : .t19 = __tidx__.t2
  25 : .t20 = 1
  26 : .t18 = .t19 + .t20
  27 : __tidx__.t2 = .t18
  28 : .t23 = s
  29 : .t24 = i
  30 : .t22 = .t23[.t24]
  31 : .t25 = " "
  33 : write .t22
  32 : write .t25
  34 : .t26 = "\n"
  35 : write .t26
  36 : .t21 = None
  37 : goto 15
  16 : SKIP
  39 : .t28 = "\n"
  40 : write .t28
  41 : .t27 = None
  42 : .t32 = 0
  43 : __tidx__.t29 = .t32
  44 : .t33 = s
  45 : __titer__.t30 = .t33
  46 : .t35 = __titer__.t30
  47 : .t34 = len(.t35)
  48 : __tlen__.t31 = .t34
  49 : SKIP
  51 : .t37 = __tidx__.t29
  52 : .t38 = __tlen__.t31
  53 : .t36 = .t37 < .t38
  70 : iffalse .t36 goto 50
  54 : .t40 = __titer__.t30
  55 : .t41 = __tidx__.t29
  56 : .t39 = .t40[.t41]
  57 : c = .t39
  58 : .t43 = __tidx__.t29
  59 : .t44 = 1
  60 : .t42 = .t43 + .t44
  61 : __tidx__.t29 = .t42
  62 : .t46 = c
  63 : .t47 = " "
  65 : write .t46
  64 : write .t47
  66 : .t48 = "\n"
  67 : write .t48
  68 : .t45 = None
  69 : goto 49
  50 : SKIP
   2 : HALT

C 
O 
S 
E 
3 
1 
2 

C 
O 
S 
E 
3 
1 
2 
The number of instructions executed : 343
