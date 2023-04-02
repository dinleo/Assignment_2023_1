exception NotImplemented;;

type btree = Empty | Node of int * btree * btree

let rec mem : int -> btree -> bool = function
    | x -> function
        | Empty -> false
        | Node(i, n1, n2) -> (x = i) || (mem x n1) || (mem x n2);;

let t1 = Node (1, Empty, Empty);;
let t2 = Node (1, Node (2, Empty, Empty), Node (3, Empty, Empty));;

mem 4 t2;;
