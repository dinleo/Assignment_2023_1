exception NotImplemented;;

type btree =
    | Leaf of int
    | Left of btree
    | Right of btree
    | LeftRight of btree * btree;;

let rec mirror : btree -> btree = function
    | Leaf (i) -> Leaf (i)
    | Left (b) -> Right(mirror b)
    | Right (b) -> Left(mirror b)
    | LeftRight (l, r) -> LeftRight(mirror r, mirror l);;

mirror (Left (LeftRight (Leaf 1, Leaf 2)))
