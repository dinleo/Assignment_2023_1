
*** Source Program **
def even(n):
    return ((n % 2) == 0)

def odd(n):
    return ((n % 2) == 1)

def smaller(x, y):
    if (x < y):
        return x
    else: 
        return y


def smallest(x, y, z):
    return smaller(smaller(x, y), z)

def smaller_even(x, y):
    if (even(x) and even(y)):
        return smaller(x, y)
    else: 
        if (even(x) and odd(y)):
            return x
        else: 
            if (odd(x) and even(y)):
                return y
            else: 
                return None




def smallest_even(x, y, z):
    if (smaller_even(x, y) == None):
        if even(z):
            return z
        else: 
            return None

    else: 
        return smaller_even(smaller_even(x, y), z)


print(smallest_even(2, 4, 6))
print(smallest_even(1, 4, 6))
print(smallest_even(2, (- 4), (- 5)))
print(smallest_even(10, (- 3), (- 1)))
print(smallest_even(1, (- 3), (- 1)))


*** Target Program **
  11 : def even(n)
       5 : .t4 = n
       6 : .t5 = 2
       7 : .t3 = .t4 % .t5
       8 : .t6 = 0
       9 : .t2 = .t3 == .t6
      10 : return .t2
       3 : .t1 = None
       4 : return .t1

  20 : def odd(n)
      14 : .t10 = n
      15 : .t11 = 2
      16 : .t9 = .t10 % .t11
      17 : .t12 = 1
      18 : .t8 = .t9 == .t12
      19 : return .t8
      12 : .t7 = None
      13 : return .t7

  37 : def smaller(x, y)
      23 : .t15 = x
      24 : .t16 = y
      25 : .t14 = .t15 < .t16
      36 : if .t14 goto 30
      35 : goto 31
      30 : SKIP
      26 : .t17 = x
      27 : return .t17
      34 : goto 32
      31 : SKIP
      28 : .t18 = y
      29 : return .t18
      33 : goto 32
      32 : SKIP
      21 : .t13 = None
      22 : return .t13

  48 : def smallest(x, y, z)
      40 : .t21 = smaller
      41 : .t23 = smaller
      42 : .t24 = x
      43 : .t25 = y
      44 : .t22 := call(.t23, (.t24,.t25))
      45 : .t26 = z
      46 : .t20 := call(.t21, (.t22,.t26))
      47 : return .t20
      38 : .t19 = None
      39 : return .t19

 110 : def smaller_even(x, y)
      51 : .t30 = even
      52 : .t31 = x
      53 : .t29 := call(.t30, (.t31))
      54 : .t34 = even
      55 : .t35 = y
      56 : .t33 := call(.t34, (.t35))
      57 : .t36 = 1
      58 : .t32 = .t33 && .t36
      59 : .t28 = .t29 && .t32
     109 : if .t28 goto 103
     108 : goto 104
     103 : SKIP
      60 : .t38 = smaller
      61 : .t39 = x
      62 : .t40 = y
      63 : .t37 := call(.t38, (.t39,.t40))
      64 : return .t37
     107 : goto 105
     104 : SKIP
      65 : .t43 = even
      66 : .t44 = x
      67 : .t42 := call(.t43, (.t44))
      68 : .t47 = odd
      69 : .t48 = y
      70 : .t46 := call(.t47, (.t48))
      71 : .t49 = 1
      72 : .t45 = .t46 && .t49
      73 : .t41 = .t42 && .t45
     102 : if .t41 goto 96
     101 : goto 97
      96 : SKIP
      74 : .t50 = x
      75 : return .t50
     100 : goto 98
      97 : SKIP
      76 : .t53 = odd
      77 : .t54 = x
      78 : .t52 := call(.t53, (.t54))
      79 : .t57 = even
      80 : .t58 = y
      81 : .t56 := call(.t57, (.t58))
      82 : .t59 = 1
      83 : .t55 = .t56 && .t59
      84 : .t51 = .t52 && .t55
      95 : if .t51 goto 89
      94 : goto 90
      89 : SKIP
      85 : .t60 = y
      86 : return .t60
      93 : goto 91
      90 : SKIP
      87 : .t61 = None
      88 : return .t61
      92 : goto 91
      91 : SKIP
      99 : goto 98
      98 : SKIP
     106 : goto 105
     105 : SKIP
      49 : .t27 = None
      50 : return .t27

 148 : def smallest_even(x, y, z)
     113 : .t65 = smaller_even
     114 : .t66 = x
     115 : .t67 = y
     116 : .t64 := call(.t65, (.t66,.t67))
     117 : .t68 = None
     118 : .t63 = .t64 == .t68
     147 : if .t63 goto 141
     146 : goto 142
     141 : SKIP
     119 : .t70 = even
     120 : .t71 = z
     121 : .t69 := call(.t70, (.t71))
     132 : if .t69 goto 126
     131 : goto 127
     126 : SKIP
     122 : .t72 = z
     123 : return .t72
     130 : goto 128
     127 : SKIP
     124 : .t73 = None
     125 : return .t73
     129 : goto 128
     128 : SKIP
     145 : goto 143
     142 : SKIP
     133 : .t75 = smaller_even
     134 : .t77 = smaller_even
     135 : .t78 = x
     136 : .t79 = y
     137 : .t76 := call(.t77, (.t78,.t79))
     138 : .t80 = z
     139 : .t74 := call(.t75, (.t76,.t80))
     140 : return .t74
     144 : goto 143
     143 : SKIP
     111 : .t62 = None
     112 : return .t62

 149 : .t83 = smallest_even
 150 : .t84 = 2
 151 : .t85 = 4
 152 : .t86 = 6
 153 : .t82 := call(.t83, (.t84,.t85,.t86))
 154 : .t87 = " "
 156 : write .t82
 155 : write .t87
 157 : .t88 = "\n"
 158 : write .t88
 159 : .t81 = None
 160 : .t91 = smallest_even
 161 : .t92 = 1
 162 : .t93 = 4
 163 : .t94 = 6
 164 : .t90 := call(.t91, (.t92,.t93,.t94))
 165 : .t95 = " "
 167 : write .t90
 166 : write .t95
 168 : .t96 = "\n"
 169 : write .t96
 170 : .t89 = None
 171 : .t99 = smallest_even
 172 : .t100 = 2
 173 : .t102 = 4
 174 : .t101 = -.t102
 175 : .t104 = 5
 176 : .t103 = -.t104
 177 : .t98 := call(.t99, (.t100,.t101,.t103))
 178 : .t105 = " "
 180 : write .t98
 179 : write .t105
 181 : .t106 = "\n"
 182 : write .t106
 183 : .t97 = None
 184 : .t109 = smallest_even
 185 : .t110 = 10
 186 : .t112 = 3
 187 : .t111 = -.t112
 188 : .t114 = 1
 189 : .t113 = -.t114
 190 : .t108 := call(.t109, (.t110,.t111,.t113))
 191 : .t115 = " "
 193 : write .t108
 192 : write .t115
 194 : .t116 = "\n"
 195 : write .t116
 196 : .t107 = None
 197 : .t119 = smallest_even
 198 : .t120 = 1
 199 : .t122 = 3
 200 : .t121 = -.t122
 201 : .t124 = 1
 202 : .t123 = -.t124
 203 : .t118 := call(.t119, (.t120,.t121,.t123))
 204 : .t125 = " "
 206 : write .t118
 205 : write .t125
 207 : .t126 = "\n"
 208 : write .t126
 209 : .t117 = None
   2 : HALT

2 
4 
-4 
10 
None 
The number of instructions executed : 786
