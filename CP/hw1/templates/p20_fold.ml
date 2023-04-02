exception NotImplemented;;

let rec fold_right : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b
= fun f lst init ->
    match lst with
    | [] -> init
    | hd::tl -> f hd (fold_right f tl init)
;;
let rec fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
= fun f init lst ->
    match lst with
    | [] -> init
    | hd::tl -> fold_left f (f init hd) tl
;;
let length : 'a list -> int = function
    | lst -> fold_left (fun acc _ -> acc + 1) 0 lst
;;
let reverse : 'a list -> 'a list = function
    | lst -> fold_right (fun x acc -> acc@[x]) lst []
;;
let is_all_pos : 'a list -> bool = function
    | lst -> fold_left (fun acc x -> acc&&(0<x)) true lst
;;
let map : ('a -> 'b) -> 'a list -> 'b list = function
    | f -> (function
        | lst -> fold_right (fun x acc -> (f x)::acc) lst []
    )
;;
let filter : ('a -> bool) -> 'a list -> 'a list = function
    | f -> (function
        | lst -> fold_right (fun x acc -> if (f x) then x::acc else acc) lst []
    )
;;
length [1;2;3;4;5;6];;
reverse [1;2;3;4;5;6];;
is_all_pos [1;2;3;4;5;6];;
is_all_pos [1;-2;3;-4;5;6];;
map (fun x-> x+1) [1;2;3;4;5;6];;
filter (fun x-> x<0) [1;-2;3;-4;5;6];;
