exception NotImplemented;;

let rec binarize : int -> int list = function
    | 0 -> [0]
    | 1 -> [1]
    | x -> (if x mod 2 = 0
        then binarize (x/2) @ [0]
        else binarize ((x-1)/2) @ [1]
    )
;;

binarize 17