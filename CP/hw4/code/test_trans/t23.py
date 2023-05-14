
*** Source Program **
def string_of_stars(n):
    res = ""
    for i in range(1, (n + 1)):
        for j in range(1, (n + 1)):
            if ((i == 1) or (i == n) or (j == 1) or (j == n) or (i == j) or (j == ((n - i) + 1))):
                res += "*"
            else: 
                res += " "


        res += "\n"

    return res

print(string_of_stars(5))
print(string_of_stars(6))
print(string_of_stars(9))
print(string_of_stars(20))


*** Target Program **
 109 : def string_of_stars(n)
       5 : .t2 = ""
       6 : res = .t2
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
     106 : iffalse .t14 goto 19
      23 : .t18 = __titer__.t4
      24 : .t19 = __tidx__.t3
      25 : .t17 = .t18[.t19]
      26 : i = .t17
      27 : .t21 = __tidx__.t3
      28 : .t22 = 1
      29 : .t20 = .t21 + .t22
      30 : __tidx__.t3 = .t20
      31 : .t26 = 0
      32 : __tidx__.t23 = .t26
      33 : .t28 = 1
      34 : .t30 = n
      35 : .t31 = 1
      36 : .t29 = .t30 + .t31
      37 : .t27 =  range(.t28, .t29)
      38 : __titer__.t24 = .t27
      39 : .t33 = __titer__.t24
      40 : .t32 = len(.t33)
      41 : __tlen__.t25 = .t32
      42 : SKIP
      44 : .t35 = __tidx__.t23
      45 : .t36 = __tlen__.t25
      46 : .t34 = .t35 < .t36
     100 : iffalse .t34 goto 43
      47 : .t38 = __titer__.t24
      48 : .t39 = __tidx__.t23
      49 : .t37 = .t38[.t39]
      50 : j = .t37
      51 : .t41 = __tidx__.t23
      52 : .t42 = 1
      53 : .t40 = .t41 + .t42
      54 : __tidx__.t23 = .t40
      55 : .t45 = i
      56 : .t46 = 1
      57 : .t44 = .t45 == .t46
      58 : .t49 = i
      59 : .t50 = n
      60 : .t48 = .t49 == .t50
      61 : .t53 = j
      62 : .t54 = 1
      63 : .t52 = .t53 == .t54
      64 : .t57 = j
      65 : .t58 = n
      66 : .t56 = .t57 == .t58
      67 : .t61 = i
      68 : .t62 = j
      69 : .t60 = .t61 == .t62
      70 : .t65 = j
      71 : .t68 = n
      72 : .t69 = i
      73 : .t67 = .t68 - .t69
      74 : .t70 = 1
      75 : .t66 = .t67 + .t70
      76 : .t64 = .t65 == .t66
      77 : .t71 = 0
      78 : .t63 = .t64 || .t71
      79 : .t59 = .t60 || .t63
      80 : .t55 = .t56 || .t59
      81 : .t51 = .t52 || .t55
      82 : .t47 = .t48 || .t51
      83 : .t43 = .t44 || .t47
      98 : if .t43 goto 92
      97 : goto 93
      92 : SKIP
      84 : .t73 = res
      85 : .t74 = "*"
      86 : .t72 = .t73 + .t74
      87 : res = .t72
      96 : goto 94
      93 : SKIP
      88 : .t76 = res
      89 : .t77 = " "
      90 : .t75 = .t76 + .t77
      91 : res = .t75
      95 : goto 94
      94 : SKIP
      99 : goto 42
      43 : SKIP
     101 : .t79 = res
     102 : .t80 = "\n"
     103 : .t78 = .t79 + .t80
     104 : res = .t78
     105 : goto 18
      19 : SKIP
     107 : .t81 = res
     108 : return .t81
       3 : .t1 = None
       4 : return .t1

 110 : .t84 = string_of_stars
 111 : .t85 = 5
 112 : .t83 := call(.t84, (.t85))
 113 : .t86 = " "
 115 : write .t83
 114 : write .t86
 116 : .t87 = "\n"
 117 : write .t87
 118 : .t82 = None
 119 : .t90 = string_of_stars
 120 : .t91 = 6
 121 : .t89 := call(.t90, (.t91))
 122 : .t92 = " "
 124 : write .t89
 123 : write .t92
 125 : .t93 = "\n"
 126 : write .t93
 127 : .t88 = None
 128 : .t96 = string_of_stars
 129 : .t97 = 9
 130 : .t95 := call(.t96, (.t97))
 131 : .t98 = " "
 133 : write .t95
 132 : write .t98
 134 : .t99 = "\n"
 135 : write .t99
 136 : .t94 = None
 137 : .t102 = string_of_stars
 138 : .t103 = 20
 139 : .t101 := call(.t102, (.t103))
 140 : .t104 = " "
 142 : write .t101
 141 : write .t104
 143 : .t105 = "\n"
 144 : write .t105
 145 : .t100 = None
   2 : HALT

*****
** **
* * *
** **
*****
 
******
**  **
* ** *
* ** *
**  **
******
 
*********
**     **
* *   * *
*  * *  *
*   *   *
*  * *  *
* *   * *
**     **
*********
 
********************
**                **
* *              * *
*  *            *  *
*   *          *   *
*    *        *    *
*     *      *     *
*      *    *      *
*       *  *       *
*        **        *
*        **        *
*       *  *       *
*      *    *      *
*     *      *     *
*    *        *    *
*   *          *   *
*  *            *  *
* *              * *
**                **
********************
 
The number of instructions executed : 29500
