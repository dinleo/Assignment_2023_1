exception NotImplemented;;

let rec range : int -> int -> int list = function
    | x -> (function
        | y -> (if y < x
            then []
            else x :: range (x+1) y
        )
    )
;;

range 3 7