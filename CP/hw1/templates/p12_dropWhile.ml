exception NotImplemented;;

let rec dropWhile : ('a -> bool) -> 'a list -> 'a list = function
    | f -> (function
        | [] -> []
        | hd::tl -> (if f hd = true
            then dropWhile f tl
            else hd::tl
        )
    )
;;

dropWhile (fun x -> x mod 2 = 0) [2;4;7;9];;
dropWhile (fun x-> x > 5) [1;3;7];;