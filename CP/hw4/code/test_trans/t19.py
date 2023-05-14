
*** Source Program **
def triangledown(n : int) -> str:
    s = ""
    for i in range(1, (n + 1)):
        s = (s + (" " * (i - 1)))
        s = (s + ("*" * (((n - i) * 2) + 1)))
        s = (s + "\n")

    return s

print(triangledown(4))
print(triangledown(9))
print(triangledown(15))


*** Target Program **
  59 : def triangledown(n)
       5 : .t2 = ""
       6 : s = .t2
       7 : .t6 = 0
       8 : __tidx__.t3 = .t6
       9 : .t8 = 1
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
      56 : iffalse .t14 goto 19
      23 : .t18 = __titer__.t4
      24 : .t19 = __tidx__.t3
      25 : .t17 = .t18[.t19]
      26 : i = .t17
      27 : .t21 = __tidx__.t3
      28 : .t22 = 1
      29 : .t20 = .t21 + .t22
      30 : __tidx__.t3 = .t20
      31 : .t24 = s
      32 : .t26 = " "
      33 : .t28 = i
      34 : .t29 = 1
      35 : .t27 = .t28 - .t29
      36 : .t25 = .t26 * .t27
      37 : .t23 = .t24 + .t25
      38 : s = .t23
      39 : .t31 = s
      40 : .t33 = "*"
      41 : .t37 = n
      42 : .t38 = i
      43 : .t36 = .t37 - .t38
      44 : .t39 = 2
      45 : .t35 = .t36 * .t39
      46 : .t40 = 1
      47 : .t34 = .t35 + .t40
      48 : .t32 = .t33 * .t34
      49 : .t30 = .t31 + .t32
      50 : s = .t30
      51 : .t42 = s
      52 : .t43 = "\n"
      53 : .t41 = .t42 + .t43
      54 : s = .t41
      55 : goto 18
      19 : SKIP
      57 : .t44 = s
      58 : return .t44
       3 : .t1 = None
       4 : return .t1

  60 : .t47 = triangledown
  61 : .t48 = 4
  62 : .t46 := call(.t47, (.t48))
  63 : .t49 = " "
  65 : write .t46
  64 : write .t49
  66 : .t50 = "\n"
  67 : write .t50
  68 : .t45 = None
  69 : .t53 = triangledown
  70 : .t54 = 9
  71 : .t52 := call(.t53, (.t54))
  72 : .t55 = " "
  74 : write .t52
  73 : write .t55
  75 : .t56 = "\n"
  76 : write .t56
  77 : .t51 = None
  78 : .t59 = triangledown
  79 : .t60 = 15
  80 : .t58 := call(.t59, (.t60))
  81 : .t61 = " "
  83 : write .t58
  82 : write .t61
  84 : .t62 = "\n"
  85 : write .t62
  86 : .t57 = None
   2 : HALT

*******
 *****
  ***
   *
 
*****************
 ***************
  *************
   ***********
    *********
     *******
      *****
       ***
        *
 
*****************************
 ***************************
  *************************
   ***********************
    *********************
     *******************
      *****************
       ***************
        *************
         ***********
          *********
           *******
            *****
             ***
              *
 
The number of instructions executed : 1156
