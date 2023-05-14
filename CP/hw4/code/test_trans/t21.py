
*** Source Program **
def collatz(n):
    steps = 0
    while (n != 1):
        if ((n % 2) == 0):
            n = (n // 2)
        else: 
            n = ((3 * n) + 1)

        steps += 1

    return steps

print(collatz(3))
print(collatz(4))
print(collatz(5))
print(collatz(13))
print(collatz(25))
print(collatz(100))
print(collatz(2022))
print(collatz(12345))


*** Target Program **
  42 : def collatz(n)
       5 : .t2 = 0
       6 : steps = .t2
       7 : SKIP
       9 : .t4 = n
      10 : .t5 = 1
      11 : .t3 = .t4 != .t5
      39 : iffalse .t3 goto 8
      12 : .t8 = n
      13 : .t9 = 2
      14 : .t7 = .t8 % .t9
      15 : .t10 = 0
      16 : .t6 = .t7 == .t10
      33 : if .t6 goto 27
      32 : goto 28
      27 : SKIP
      17 : .t12 = n
      18 : .t13 = 2
      19 : .t11 = .t12 / .t13
      20 : n = .t11
      31 : goto 29
      28 : SKIP
      21 : .t16 = 3
      22 : .t17 = n
      23 : .t15 = .t16 * .t17
      24 : .t18 = 1
      25 : .t14 = .t15 + .t18
      26 : n = .t14
      30 : goto 29
      29 : SKIP
      34 : .t20 = steps
      35 : .t21 = 1
      36 : .t19 = .t20 + .t21
      37 : steps = .t19
      38 : goto 7
       8 : SKIP
      40 : .t22 = steps
      41 : return .t22
       3 : .t1 = None
       4 : return .t1

  43 : .t25 = collatz
  44 : .t26 = 3
  45 : .t24 := call(.t25, (.t26))
  46 : .t27 = " "
  48 : write .t24
  47 : write .t27
  49 : .t28 = "\n"
  50 : write .t28
  51 : .t23 = None
  52 : .t31 = collatz
  53 : .t32 = 4
  54 : .t30 := call(.t31, (.t32))
  55 : .t33 = " "
  57 : write .t30
  56 : write .t33
  58 : .t34 = "\n"
  59 : write .t34
  60 : .t29 = None
  61 : .t37 = collatz
  62 : .t38 = 5
  63 : .t36 := call(.t37, (.t38))
  64 : .t39 = " "
  66 : write .t36
  65 : write .t39
  67 : .t40 = "\n"
  68 : write .t40
  69 : .t35 = None
  70 : .t43 = collatz
  71 : .t44 = 13
  72 : .t42 := call(.t43, (.t44))
  73 : .t45 = " "
  75 : write .t42
  74 : write .t45
  76 : .t46 = "\n"
  77 : write .t46
  78 : .t41 = None
  79 : .t49 = collatz
  80 : .t50 = 25
  81 : .t48 := call(.t49, (.t50))
  82 : .t51 = " "
  84 : write .t48
  83 : write .t51
  85 : .t52 = "\n"
  86 : write .t52
  87 : .t47 = None
  88 : .t55 = collatz
  89 : .t56 = 100
  90 : .t54 := call(.t55, (.t56))
  91 : .t57 = " "
  93 : write .t54
  92 : write .t57
  94 : .t58 = "\n"
  95 : write .t58
  96 : .t53 = None
  97 : .t61 = collatz
  98 : .t62 = 2022
  99 : .t60 := call(.t61, (.t62))
 100 : .t63 = " "
 102 : write .t60
 101 : write .t63
 103 : .t64 = "\n"
 104 : write .t64
 105 : .t59 = None
 106 : .t67 = collatz
 107 : .t68 = 12345
 108 : .t66 := call(.t67, (.t68))
 109 : .t69 = " "
 111 : write .t66
 110 : write .t69
 112 : .t70 = "\n"
 113 : write .t70
 114 : .t65 = None
   2 : HALT

7 
2 
5 
9 
23 
25 
63 
50 
The number of instructions executed : 4545
