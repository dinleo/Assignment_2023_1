type aexp =
  | Const of int
  | Var of string
  | Plus of aexp * aexp
  | Mult of aexp * aexp
  | Sub of aexp * aexp

type bexp =
  | True  | False
  | Equal of aexp * aexp
  | Le of aexp * aexp
  | Ge of aexp * aexp
  | Not of bexp
  | And of bexp * bexp

type cmd =
  | Assign of string * aexp
  | Seq of cmd list
  | If of bexp * cmd * cmd
  | While of bexp * cmd


module AbsBool = struct
  type t = Top | Bot | True | False
  let not b = match b with
    | Top -> Top
    | Bot -> Bot
    | True -> False
    | False -> True
  let band b1 b2 = match (b1, b2) with
    | (Top, _) | (_, Top) -> Top
    | (Bot, c) | (c, Bot) -> c
    | (False, _) | (_, False) -> False
    | (True, True) -> True
  let bor b1 b2 = match (b1, b2) with
    | (Top, _) | (_, Top) -> Top
    | (Bot, c) | (c, Bot) -> c
    | (True, _) | (_, True) -> True
    | (False, False) -> False
  let to_string b = match b with
    | Top -> "Top"
    | Bot -> "Bot"
    | True -> "True"
    | False -> "False"
end

module Sign = struct
  type t = Top | Bot | Neg | Zero | Pos
  let order a b = match (a, b) with
    | (Bot, _) | (_, Top) -> true
    | (Top, _) | (_, Bot) -> false
    | (Zero, Zero) | (Neg, Neg) | (Pos, Pos) -> true
    | _ -> false
  let alpha n =
    if n > 0 then Pos
    else if n < 0 then Neg
    else Zero
  let join a b = match (a, b) with
    | (Bot, c) | (c, Bot) -> c
    | (Pos, Pos) -> Pos
    | (Neg, Neg) -> Neg
    | (Zero, Zero) -> Zero
    | _ -> Top
  let add a b = match (a, b) with
    | (Bot, c) | (c, Bot) -> c
    | (Top, _) | (_, Top) -> Top
    | (Zero, c) | (c, Zero) -> c
    | (Pos, Neg) | (Neg, Pos) -> Top
    | (Pos, Pos) -> Pos
    | (Neg, Neg) -> Neg
  let sub a b = match (a, b) with
    | (Bot, c) | (c, Bot) -> c
    | (Top, _) | (_, Top) -> Top
    | (Zero, c) | (c, Zero) -> c
    | (Pos, Neg) -> Pos
    | (Neg, Pos) -> Neg
    | (Pos, Pos) -> Top
    | (Neg, Neg) -> Top
  let mul a b = match (a, b) with
    | (Bot, c) | (c, Bot) -> c
    | (Top, _) | (_, Top) -> Top
    | (Zero, _) | (_, Zero) -> Zero
    | (Pos, Neg) | (Neg, Pos) -> Neg
    | (Pos, Pos) | (Neg, Neg) -> Pos
  let equal a b = match (a, b) with
    | (Bot, Bot) | (Zero, Zero) -> AbsBool.True
    | (Pos, Zero) | (Pos, Neg) | (Zero, Pos) | (Zero, Neg) | (Neg, Pos) | (Neg, Zero) -> AbsBool.False
    | _ -> AbsBool.Top
  let le a b = match (a, b) with
    | (Bot, Bot) | (Pos, Zero) | (Pos, Neg) | (Zero, Neg) -> AbsBool.True
    | (Zero, Pos) | (Zero, Zero) | (Neg, Pos) | (Neg, Zero) -> AbsBool.False
    | _ -> AbsBool.Top
  let ge a b = match (a, b) with
    | (Bot, Bot) | (Zero, Pos) | (Neg, Pos) | (Neg, Zero) -> AbsBool.True
    | (Pos, Zero) | (Pos, Neg) | (Zero, Zero) | (Zero, Neg) -> AbsBool.False
    | _ -> AbsBool.Top
  let to_string = function
    | Top -> "Top"
    | Bot -> "Bot"
    | Neg -> "Neg"
    | Zero -> "Zero"
    | Pos -> "Pos"
end

module AbsMem = struct
  module LocMap = Map.Make(String)
  type t = Sign.t LocMap.t
  let empty = LocMap.empty
  let add = LocMap.add
  let find k m = try LocMap.find k m with _ -> Sign.Bot
  let join m1 m2 =
    LocMap.fold (fun m1_k m1_v m2_acc -> add m1_k (Sign.join m1_v (find m1_k m2_acc)) m2_acc) m1 m2
  let order m1 m2 =
    LocMap.for_all (fun m1_k m1_v -> Sign.order m1_v (find m1_k m2)) m1
  let print m =
    LocMap.iter (fun k v -> print_endline (k ^ " |-> " ^ Sign.to_string v)) m
end

let rec eval_aexp : aexp -> AbsMem.t -> Sign.t
=fun a m ->
  match a with
  | Const n -> Sign.alpha n
  | Var x -> AbsMem.find x m
  | Plus (a1, a2) -> Sign.add (eval_aexp a1 m) (eval_aexp a2 m)
  | Mult (a1, a2) -> Sign.mul (eval_aexp a1 m) (eval_aexp a2 m)
  | Sub (a1, a2) -> Sign.sub (eval_aexp a1 m) (eval_aexp a2 m)

let rec eval_bexp : bexp -> AbsMem.t -> AbsBool.t
=fun b m ->
  match b with
  | True -> AbsBool.True
  | False -> AbsBool.False
  | Equal (a1, a2) -> Sign.equal (eval_aexp a1 m) (eval_aexp a2 m)
  | Le (a1, a2) -> Sign.le (eval_aexp a1 m) (eval_aexp a2 m)
  | Ge (a1, a2) -> Sign.ge (eval_aexp a1 m) (eval_aexp a2 m)
  | Not b -> AbsBool.not (eval_bexp b m)
  | And (b1, b2) -> AbsBool.band (eval_bexp b1 m) (eval_bexp b2 m)

let rec eval_cmd : cmd -> AbsMem.t -> AbsMem.t
=fun c m ->
  match c with
  | Assign (x, a) -> AbsMem.add x (eval_aexp a m) m
  | Seq cs -> List.fold_left (fun m c -> eval_cmd c m) m cs
  | If (b, c1, c2) -> begin
      match eval_bexp b m with
      | AbsBool.Top -> AbsMem.join (eval_cmd c1 m) (eval_cmd c2 m)
      | AbsBool.True -> eval_cmd c1 m
      | AbsBool.False -> eval_cmd c2 m
      | AbsBool.Bot -> AbsMem.empty
    end
  | While (b, c) ->
    let rec iter b c m =
      match eval_bexp b m with
      | AbsBool.True | AbsBool.Top ->
        if AbsMem.order (eval_cmd c m) m
        then m
        else iter b c (AbsMem.join m (eval_cmd c m))
      | _ -> m
    in iter b c m


let analyze : Spy.program -> Spvm.program -> bool 
=fun _ _ -> true (* TODO *)