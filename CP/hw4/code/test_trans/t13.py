
*** Source Program **
def sum(n):
    sum = 0
    for num in range((n + 1)):
        sum += num

    return sum

print("calcsum(4) = ", sum(4))
print("calcsum(8) = ", sum(8))


*** Target Program **
  39 : def sum(n)
       5 : .t2 = 0
       6 : sum = .t2
       7 : .t6 = 0
       8 : __tidx__.t3 = .t6
       9 : .t8 = 0
      10 : .t10 = n
      11 : .t11 = 1
      12 : .t9 = .t10 + .t11
      13 : .t7 =  range(.t8, .t9)
      14 : __titer__.t4 = .t7
      15 : .t13 = __titer__.t4
      16 : .t12 = len(.t13)
      17 : __tlen__.t5 = .t12
      18 : SKIP
      20 : .t15 = __tidx__.t3
      21 : .t16 = __tlen__.t5
      22 : .t14 = .t15 < .t16
      36 : iffalse .t14 goto 19
      23 : .t18 = __titer__.t4
      24 : .t19 = __tidx__.t3
      25 : .t17 = .t18[.t19]
      26 : num = .t17
      27 : .t21 = __tidx__.t3
      28 : .t22 = 1
      29 : .t20 = .t21 + .t22
      30 : __tidx__.t3 = .t20
      31 : .t24 = sum
      32 : .t25 = num
      33 : .t23 = .t24 + .t25
      34 : sum = .t23
      35 : goto 18
      19 : SKIP
      37 : .t26 = sum
      38 : return .t26
       3 : .t1 = None
       4 : return .t1

  40 : .t28 = "calcsum(4) = "
  41 : .t29 = " "
  43 : write .t28
  42 : write .t29
  44 : .t31 = sum
  45 : .t32 = 4
  46 : .t30 := call(.t31, (.t32))
  47 : .t33 = " "
  49 : write .t30
  48 : write .t33
  50 : .t34 = "\n"
  51 : write .t34
  52 : .t27 = None
  53 : .t36 = "calcsum(8) = "
  54 : .t37 = " "
  56 : write .t36
  55 : write .t37
  57 : .t39 = sum
  58 : .t40 = 8
  59 : .t38 := call(.t39, (.t40))
  60 : .t41 = " "
  62 : write .t38
  61 : write .t41
  63 : .t42 = "\n"
  64 : write .t42
  65 : .t35 = None
   2 : HALT

calcsum(4) =  10 
calcsum(8) =  36 
The number of instructions executed : 322
