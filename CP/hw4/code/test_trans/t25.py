
*** Source Program **
def drop(f, a):
    skip = True
    result = []
    for x in a:
        if (not f(x)):
            skip = False

        if skip:
            pass
        else: 
            result.append(x)


    return result

print(drop((lambda x: (x < 7)), [1,2,3,4,5,6,7,8,9,10]))
print(drop((lambda x: ((x % 5) == 0)), [1,2,3,4,5,6,7,8,9,10]))


*** Target Program **
  59 : def drop(f, a)
       5 : .t2 = 1
       6 : skip = .t2
       7 : .t3 = []
       8 : result = .t3
       9 : .t7 = 0
      10 : __tidx__.t4 = .t7
      11 : .t8 = a
      12 : __titer__.t5 = .t8
      13 : .t10 = __titer__.t5
      14 : .t9 = len(.t10)
      15 : __tlen__.t6 = .t9
      16 : SKIP
      18 : .t12 = __tidx__.t4
      19 : .t13 = __tlen__.t6
      20 : .t11 = .t12 < .t13
      56 : iffalse .t11 goto 17
      21 : .t15 = __titer__.t5
      22 : .t16 = __tidx__.t4
      23 : .t14 = .t15[.t16]
      24 : x = .t14
      25 : .t18 = __tidx__.t4
      26 : .t19 = 1
      27 : .t17 = .t18 + .t19
      28 : __tidx__.t4 = .t17
      29 : .t22 = f
      30 : .t23 = x
      31 : .t21 := call(.t22, (.t23))
      32 : .t20 = !.t21
      41 : if .t20 goto 35
      40 : goto 36
      35 : SKIP
      33 : .t24 = 0
      34 : skip = .t24
      39 : goto 37
      36 : SKIP
      38 : goto 37
      37 : SKIP
      42 : .t25 = skip
      54 : if .t25 goto 48
      53 : goto 49
      48 : SKIP
      43 : SKIP
      52 : goto 50
      49 : SKIP
      44 : .t27 = result
      45 : .t28 = x
      47 : .t26 = None
      46 : .t27 = .t27@[.t28]
      51 : goto 50
      50 : SKIP
      55 : goto 16
      17 : SKIP
      57 : .t29 = result
      58 : return .t29
       3 : .t1 = None
       4 : return .t1

  60 : .t32 = drop
  67 : def _lambda_.t34(x)
      63 : .t37 = x
      64 : .t38 = 7
      65 : .t36 = .t37 < .t38
      66 : return .t36
      61 : .t35 = None
      62 : return .t35

  68 : .t39 = _lambda_.t34
  69 : .t33 = .t39
  70 : .t41 = 1
  71 : .t43 = 2
  72 : .t45 = 3
  73 : .t47 = 4
  74 : .t49 = 5
  75 : .t51 = 6
  76 : .t53 = 7
  77 : .t55 = 8
  78 : .t57 = 9
  79 : .t59 = 10
  80 : .t60 = []
  81 : .t60 = .t59::.t60
  82 : .t58 = .t60
  83 : .t58 = .t57::.t58
  84 : .t56 = .t58
  85 : .t56 = .t55::.t56
  86 : .t54 = .t56
  87 : .t54 = .t53::.t54
  88 : .t52 = .t54
  89 : .t52 = .t51::.t52
  90 : .t50 = .t52
  91 : .t50 = .t49::.t50
  92 : .t48 = .t50
  93 : .t48 = .t47::.t48
  94 : .t46 = .t48
  95 : .t46 = .t45::.t46
  96 : .t44 = .t46
  97 : .t44 = .t43::.t44
  98 : .t42 = .t44
  99 : .t42 = .t41::.t42
 100 : .t40 = .t42
 101 : .t31 := call(.t32, (.t33,.t40))
 102 : .t61 = " "
 104 : write .t31
 103 : write .t61
 105 : .t62 = "\n"
 106 : write .t62
 107 : .t30 = None
 108 : .t65 = drop
 117 : def _lambda_.t67(x)
     111 : .t71 = x
     112 : .t72 = 5
     113 : .t70 = .t71 % .t72
     114 : .t73 = 0
     115 : .t69 = .t70 == .t73
     116 : return .t69
     109 : .t68 = None
     110 : return .t68

 118 : .t74 = _lambda_.t67
 119 : .t66 = .t74
 120 : .t76 = 1
 121 : .t78 = 2
 122 : .t80 = 3
 123 : .t82 = 4
 124 : .t84 = 5
 125 : .t86 = 6
 126 : .t88 = 7
 127 : .t90 = 8
 128 : .t92 = 9
 129 : .t94 = 10
 130 : .t95 = []
 131 : .t95 = .t94::.t95
 132 : .t93 = .t95
 133 : .t93 = .t92::.t93
 134 : .t91 = .t93
 135 : .t91 = .t90::.t91
 136 : .t89 = .t91
 137 : .t89 = .t88::.t89
 138 : .t87 = .t89
 139 : .t87 = .t86::.t87
 140 : .t85 = .t87
 141 : .t85 = .t84::.t85
 142 : .t83 = .t85
 143 : .t83 = .t82::.t83
 144 : .t81 = .t83
 145 : .t81 = .t80::.t81
 146 : .t79 = .t81
 147 : .t79 = .t78::.t79
 148 : .t77 = .t79
 149 : .t77 = .t76::.t77
 150 : .t75 = .t77
 151 : .t64 := call(.t65, (.t66,.t75))
 152 : .t96 = " "
 154 : write .t64
 153 : write .t96
 155 : .t97 = "\n"
 156 : write .t97
 157 : .t63 = None
   2 : HALT

[7, 8, 9, 10] 
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10] 
The number of instructions executed : 872
