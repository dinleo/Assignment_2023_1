
*** Source Program **
def change(a, b, c, d, e):
    (a,b,c,d,e) = (c,e,a,b,d)
    return (a,b,c,d,e)

print(change(1, 2, 3, 4, 5))
print(change(5, 4, 3, 2, 1))
print(change(5, 2, 4, 4, 1))


*** Target Program **
  58 : def change(a, b, c, d, e)
       5 : .t3 = c
       6 : .t5 = e
       7 : .t7 = a
       8 : .t9 = b
       9 : .t11 = d
      10 : .t12 = ()
      11 : .t12 = (.t11) + .t12
      12 : .t10 = .t12
      13 : .t10 = (.t9) + .t10
      14 : .t8 = .t10
      15 : .t8 = (.t7) + .t8
      16 : .t6 = .t8
      17 : .t6 = (.t5) + .t6
      18 : .t4 = .t6
      19 : .t4 = (.t3) + .t4
      20 : .t2 = .t4
      21 : .t14 = .t2
      22 : .t15 = 0
      23 : .t13 = .t14[.t15]
      24 : a = .t13
      25 : .t17 = .t2
      26 : .t18 = 1
      27 : .t16 = .t17[.t18]
      28 : b = .t16
      29 : .t20 = .t2
      30 : .t21 = 2
      31 : .t19 = .t20[.t21]
      32 : c = .t19
      33 : .t23 = .t2
      34 : .t24 = 3
      35 : .t22 = .t23[.t24]
      36 : d = .t22
      37 : .t26 = .t2
      38 : .t27 = 4
      39 : .t25 = .t26[.t27]
      40 : e = .t25
      41 : .t29 = a
      42 : .t31 = b
      43 : .t33 = c
      44 : .t35 = d
      45 : .t37 = e
      46 : .t38 = ()
      47 : .t38 = (.t37) + .t38
      48 : .t36 = .t38
      49 : .t36 = (.t35) + .t36
      50 : .t34 = .t36
      51 : .t34 = (.t33) + .t34
      52 : .t32 = .t34
      53 : .t32 = (.t31) + .t32
      54 : .t30 = .t32
      55 : .t30 = (.t29) + .t30
      56 : .t28 = .t30
      57 : return .t28
       3 : .t1 = None
       4 : return .t1

  59 : .t41 = change
  60 : .t42 = 1
  61 : .t43 = 2
  62 : .t44 = 3
  63 : .t45 = 4
  64 : .t46 = 5
  65 : .t40 := call(.t41, (.t42,.t43,.t44,.t45,.t46))
  66 : .t47 = " "
  68 : write .t40
  67 : write .t47
  69 : .t48 = "\n"
  70 : write .t48
  71 : .t39 = None
  72 : .t51 = change
  73 : .t52 = 5
  74 : .t53 = 4
  75 : .t54 = 3
  76 : .t55 = 2
  77 : .t56 = 1
  78 : .t50 := call(.t51, (.t52,.t53,.t54,.t55,.t56))
  79 : .t57 = " "
  81 : write .t50
  80 : write .t57
  82 : .t58 = "\n"
  83 : write .t58
  84 : .t49 = None
  85 : .t61 = change
  86 : .t62 = 5
  87 : .t63 = 2
  88 : .t64 = 4
  89 : .t65 = 4
  90 : .t66 = 1
  91 : .t60 := call(.t61, (.t62,.t63,.t64,.t65,.t66))
  92 : .t67 = " "
  94 : write .t60
  93 : write .t67
  95 : .t68 = "\n"
  96 : write .t68
  97 : .t59 = None
   2 : HALT

(3, 5, 1, 2, 4) 
(3, 1, 5, 4, 2) 
(4, 1, 5, 2, 4) 
The number of instructions executed : 200
