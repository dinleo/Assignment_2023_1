
*** Source Program **
def collect(a):
    if (a == []):
        return []
    else: 
        hd = a[0]
        res = []
        for x in a:
            if (x == hd):
                res.append(x)
            else: 
                break


        return res


print(collect([1,1,1,2]))
print(collect([1,1,2]))
print(collect([1]))
print(collect([2,2,2,3,3]))


*** Target Program **
  62 : def collect(a)
       5 : .t3 = a
       6 : .t4 = []
       7 : .t2 = .t3 == .t4
      61 : if .t2 goto 55
      60 : goto 56
      55 : SKIP
       8 : .t5 = []
       9 : return .t5
      59 : goto 57
      56 : SKIP
      10 : .t7 = a
      11 : .t8 = 0
      12 : .t6 = .t7[.t8]
      13 : hd = .t6
      14 : .t9 = []
      15 : res = .t9
      16 : .t13 = 0
      17 : __tidx__.t10 = .t13
      18 : .t14 = a
      19 : __titer__.t11 = .t14
      20 : .t16 = __titer__.t11
      21 : .t15 = len(.t16)
      22 : __tlen__.t12 = .t15
      23 : SKIP
      25 : .t18 = __tidx__.t10
      26 : .t19 = __tlen__.t12
      27 : .t17 = .t18 < .t19
      52 : iffalse .t17 goto 24
      28 : .t21 = __titer__.t11
      29 : .t22 = __tidx__.t10
      30 : .t20 = .t21[.t22]
      31 : x = .t20
      32 : .t24 = __tidx__.t10
      33 : .t25 = 1
      34 : .t23 = .t24 + .t25
      35 : __tidx__.t10 = .t23
      36 : .t27 = x
      37 : .t28 = hd
      38 : .t26 = .t27 == .t28
      50 : if .t26 goto 44
      49 : goto 45
      44 : SKIP
      39 : .t30 = res
      40 : .t31 = x
      42 : .t29 = None
      41 : .t30 = .t30@[.t31]
      48 : goto 46
      45 : SKIP
      43 : goto 24
      47 : goto 46
      46 : SKIP
      51 : goto 23
      24 : SKIP
      53 : .t32 = res
      54 : return .t32
      58 : goto 57
      57 : SKIP
       3 : .t1 = None
       4 : return .t1

  63 : .t35 = collect
  64 : .t37 = 1
  65 : .t39 = 1
  66 : .t41 = 1
  67 : .t43 = 2
  68 : .t44 = []
  69 : .t44 = .t43::.t44
  70 : .t42 = .t44
  71 : .t42 = .t41::.t42
  72 : .t40 = .t42
  73 : .t40 = .t39::.t40
  74 : .t38 = .t40
  75 : .t38 = .t37::.t38
  76 : .t36 = .t38
  77 : .t34 := call(.t35, (.t36))
  78 : .t45 = " "
  80 : write .t34
  79 : write .t45
  81 : .t46 = "\n"
  82 : write .t46
  83 : .t33 = None
  84 : .t49 = collect
  85 : .t51 = 1
  86 : .t53 = 1
  87 : .t55 = 2
  88 : .t56 = []
  89 : .t56 = .t55::.t56
  90 : .t54 = .t56
  91 : .t54 = .t53::.t54
  92 : .t52 = .t54
  93 : .t52 = .t51::.t52
  94 : .t50 = .t52
  95 : .t48 := call(.t49, (.t50))
  96 : .t57 = " "
  98 : write .t48
  97 : write .t57
  99 : .t58 = "\n"
 100 : write .t58
 101 : .t47 = None
 102 : .t61 = collect
 103 : .t63 = 1
 104 : .t64 = []
 105 : .t64 = .t63::.t64
 106 : .t62 = .t64
 107 : .t60 := call(.t61, (.t62))
 108 : .t65 = " "
 110 : write .t60
 109 : write .t65
 111 : .t66 = "\n"
 112 : write .t66
 113 : .t59 = None
 114 : .t69 = collect
 115 : .t71 = 2
 116 : .t73 = 2
 117 : .t75 = 2
 118 : .t77 = 3
 119 : .t79 = 3
 120 : .t80 = []
 121 : .t80 = .t79::.t80
 122 : .t78 = .t80
 123 : .t78 = .t77::.t78
 124 : .t76 = .t78
 125 : .t76 = .t75::.t76
 126 : .t74 = .t76
 127 : .t74 = .t73::.t74
 128 : .t72 = .t74
 129 : .t72 = .t71::.t72
 130 : .t70 = .t72
 131 : .t68 := call(.t69, (.t70))
 132 : .t81 = " "
 134 : write .t68
 133 : write .t81
 135 : .t82 = "\n"
 136 : write .t82
 137 : .t67 = None
   2 : HALT

[1, 1, 1] 
[1, 1] 
[1] 
[2, 2, 2] 
The number of instructions executed : 455
