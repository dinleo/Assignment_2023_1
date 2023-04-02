exception NotImplemented;;

let rec modi = function
    | (_, 1) -> true
    | (x, y) -> (if x mod y = 0
        then false
        else modi(x, y-1)
    )
;;

let prime : int -> bool = function
    | 0 -> false
    | 1 -> true
    | x -> modi (x, x-1)
;;

prime 17