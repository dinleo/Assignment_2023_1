
*** Source Program **
lst = [0,1,2]
i = 3
while (i < 10):
    lst.append(i)
    i += 1

print(lst)
i = 0
while (i < 10):
    print(lst[i])
    i += 1

i = 0
while (i < 100):
    lst[i] *= 2
    i += 1
    if (i < 10):
        continue

    if (i >= 10):
        break


print(lst)
i = 0
j = 0
while (i < 100):
    while (j < 200):
        j += 1
        if ((i + j) > 100):
            continue

        if (j > 88):
            break


    i += 1

print(i)
print(j)


*** Target Program **
   3 : .t2 = 0
   4 : .t4 = 1
   5 : .t6 = 2
   6 : .t7 = []
   7 : .t7 = .t6::.t7
   8 : .t5 = .t7
   9 : .t5 = .t4::.t5
  10 : .t3 = .t5
  11 : .t3 = .t2::.t3
  12 : .t1 = .t3
  13 : lst = .t1
  14 : .t8 = 3
  15 : i = .t8
  16 : SKIP
  18 : .t10 = i
  19 : .t11 = 10
  20 : .t9 = .t10 < .t11
  30 : iffalse .t9 goto 17
  21 : .t13 = lst
  22 : .t14 = i
  24 : .t12 = None
  23 : .t13 = .t13@[.t14]
  25 : .t16 = i
  26 : .t17 = 1
  27 : .t15 = .t16 + .t17
  28 : i = .t15
  29 : goto 16
  17 : SKIP
  31 : .t19 = lst
  32 : .t20 = " "
  34 : write .t19
  33 : write .t20
  35 : .t21 = "\n"
  36 : write .t21
  37 : .t18 = None
  38 : .t22 = 0
  39 : i = .t22
  40 : SKIP
  42 : .t24 = i
  43 : .t25 = 10
  44 : .t23 = .t24 < .t25
  59 : iffalse .t23 goto 41
  45 : .t28 = lst
  46 : .t29 = i
  47 : .t27 = .t28[.t29]
  48 : .t30 = " "
  50 : write .t27
  49 : write .t30
  51 : .t31 = "\n"
  52 : write .t31
  53 : .t26 = None
  54 : .t33 = i
  55 : .t34 = 1
  56 : .t32 = .t33 + .t34
  57 : i = .t32
  58 : goto 40
  41 : SKIP
  60 : .t35 = 0
  61 : i = .t35
  62 : SKIP
  64 : .t37 = i
  65 : .t38 = 100
  66 : .t36 = .t37 < .t38
 102 : iffalse .t36 goto 63
  67 : .t41 = lst
  68 : .t42 = i
  69 : .t40 = .t41[.t42]
  70 : .t43 = 2
  71 : .t39 = .t40 * .t43
  72 : .t44 = lst
  73 : .t45 = i
  74 : .t44[.t45] = .t39
  75 : .t47 = i
  76 : .t48 = 1
  77 : .t46 = .t47 + .t48
  78 : i = .t46
  79 : .t50 = i
  80 : .t51 = 10
  81 : .t49 = .t50 < .t51
  89 : if .t49 goto 83
  88 : goto 84
  83 : SKIP
  82 : goto 62
  87 : goto 85
  84 : SKIP
  86 : goto 85
  85 : SKIP
  90 : .t53 = i
  91 : .t54 = 10
  92 : .t52 = .t53 >= .t54
 100 : if .t52 goto 94
  99 : goto 95
  94 : SKIP
  93 : goto 63
  98 : goto 96
  95 : SKIP
  97 : goto 96
  96 : SKIP
 101 : goto 62
  63 : SKIP
 103 : .t56 = lst
 104 : .t57 = " "
 106 : write .t56
 105 : write .t57
 107 : .t58 = "\n"
 108 : write .t58
 109 : .t55 = None
 110 : .t59 = 0
 111 : i = .t59
 112 : .t60 = 0
 113 : j = .t60
 114 : SKIP
 116 : .t62 = i
 117 : .t63 = 100
 118 : .t61 = .t62 < .t63
 159 : iffalse .t61 goto 115
 119 : SKIP
 121 : .t65 = j
 122 : .t66 = 200
 123 : .t64 = .t65 < .t66
 153 : iffalse .t64 goto 120
 124 : .t68 = j
 125 : .t69 = 1
 126 : .t67 = .t68 + .t69
 127 : j = .t67
 128 : .t72 = i
 129 : .t73 = j
 130 : .t71 = .t72 + .t73
 131 : .t74 = 100
 132 : .t70 = .t71 > .t74
 140 : if .t70 goto 134
 139 : goto 135
 134 : SKIP
 133 : goto 119
 138 : goto 136
 135 : SKIP
 137 : goto 136
 136 : SKIP
 141 : .t76 = j
 142 : .t77 = 88
 143 : .t75 = .t76 > .t77
 151 : if .t75 goto 145
 150 : goto 146
 145 : SKIP
 144 : goto 120
 149 : goto 147
 146 : SKIP
 148 : goto 147
 147 : SKIP
 152 : goto 119
 120 : SKIP
 154 : .t79 = i
 155 : .t80 = 1
 156 : .t78 = .t79 + .t80
 157 : i = .t78
 158 : goto 114
 115 : SKIP
 160 : .t82 = i
 161 : .t83 = " "
 163 : write .t82
 162 : write .t83
 164 : .t84 = "\n"
 165 : write .t84
 166 : .t81 = None
 167 : .t86 = j
 168 : .t87 = " "
 170 : write .t86
 169 : write .t87
 171 : .t88 = "\n"
 172 : write .t88
 173 : .t85 = None
   2 : HALT

[0, 1, 2, 3, 4, 5, 6, 7, 8, 9] 
0 
1 
2 
3 
4 
5 
6 
7 
8 
9 
[0, 2, 4, 6, 8, 10, 12, 14, 16, 18] 
100 
200 
The number of instructions executed : 6581
