exception NotImplemented;;

let lst2int : int list -> int = function
| [] -> 0
| l -> List.fold_left (fun acc x -> acc*10 + x) 0 l;;

lst2int [2;3;4;5]