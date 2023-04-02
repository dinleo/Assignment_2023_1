exception NotImplemented;;

let rec pascal : int * int -> int = function
    | (0, _) | (1, _) | (_, 0) -> 1
    | (x, y) -> (if x=y
        then 1
        else pascal (x-1, y-1) + pascal (x-1, y)
    )
;;

pascal (3, 1)