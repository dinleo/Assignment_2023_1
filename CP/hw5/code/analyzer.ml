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
    | (False, _) | (_, False) -> False
    | (Top, _) | (_, Top) -> Top
    | (Bot, Bot) -> Bot
    | (True, True) -> True
  let to_string b = match b with
    | Top -> "Top"
    | Bot -> "Bot"
    | True -> "True"
    | False -> "False"
end

module Sign = struct
  type t = Top | Bot | Neg | Zero | Pos
  let order a b = match (a, b) with
    | (Top, _) | (_, Bot) -> true
    | (Bot, _) | (_, Top) -> false
    | (Neg, Zero) | (Neg, Pos) | (Zero, Pos) -> true
    | (Pos, Zero) | (Pos, Neg) | (Zero, Neg) -> false
    | _ -> true
  let alpha n =
    if n > 0 then Pos
    else if n < 0 then Neg
    else Zero
  let add a b = match (a, b) with
    | (Bot, _) | (_, Bot) -> Bot
    | (Top, _) | (_, Top) -> Top
    | (Neg, Pos) | (Pos, Neg) | (Zero, _) | (_, Zero) -> Zero
    | (Neg, Zero) | (Zero, Neg) | (Pos, Zero) | (Zero, Pos) -> Top
    | _ -> Top
  let sub a b = match (a, b) with
    | (Bot, _) | (_, Bot) -> Bot
    | (Top, _) | (_, Top) -> Top
    | (Neg, Neg) | (Pos, Pos) | (Zero, _) | (_, Zero) -> Zero
    | (Neg, Zero) | (Pos, Zero) | (Zero, Neg) | (Zero, Pos) -> Top
    | _ -> Top
  let mul a b = match (a, b) with
    | (Bot, _) | (_, Bot) -> Bot
    | (Top, _) | (_, Top) -> Top
    | (Neg, Neg) | (Pos, Pos) -> Pos
    | (Neg, Pos) | (Pos, Neg) -> Neg
    | (Zero, _) | (_, Zero) -> Zero
    | _ -> Top
  let equal a b = match (a, b) with
    | (Bot, _) | (_, Bot) -> Bot
    | (Top, _) | (_, Top) -> Top
    | (Neg, Neg) | (Pos, Pos) | (Zero, Zero) -> True
    | (Neg, Zero) | (Zero, Neg) | (Pos, Zero) | (Zero, Pos) -> False
    | _ -> Top
  let le a b = match (a, b) with
    | (Bot, _) | (_, Bot) -> Bot
    | (Top, _) | (_, Top) -> Top
    | (Neg, Neg) | (Neg, Zero) | (Neg, Pos) | (Zero, Pos) | (Zero, Zero) | (Pos, Pos) -> True
    | (Pos, Zero) | (Zero, Neg) -> False
    | _ -> Top
  let ge a b = match (a, b) with
    | (Bot, ) | (, Bot) -> Bot
    | (Top, ) | (, Top) -> Top
    | (Neg, Neg) | (Zero, Neg) | (Pos, Neg) | (Pos, Zero) | (Zero, Zero) | (Pos, Pos) -> True
    | (Neg, Zero) | (Zero, Pos) -> False
    | _ -> Top
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
  let find x m = try LocMap.find x m with _ -> Sign.Bot
  let join m1 m2 =
    LocMap.fold (fun x v m' -> add x (Sign.join v (find x m')) m') m1 m2
  let order m1 m2 =
    LocMap.for_all (fun x v -> Sign.order v (find x m2)) m1
  let print m =
    LocMap.iter (fun x v -> print_endline (x ^ " |-> " ^ Sign.to_string v))
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
        if AbsMem.order (eval_cmd c m) m then m
        else iter b c (AbsMem.join m (eval_cmd c m))
      | _ -> m
in iter b c m

let pgm = Seq [
    Assign ("q", Const 1);
    Assign ("r", Var "a");
    While (Ge (Var "r", Var "b"),
        Seq [
          Assign ("r", Sub (Var "r", Var "b"));
          Assign ("q", Plus (Var "q", Const 1))
]) ]
let mem = (AbsMem.add "b" Sign.Pos (AbsMem.add "a" Sign.Pos AbsMem.empty))
let _ = AbsMem.print (eval_cmd pgm mem)


let analyze : Spy.program -> Spvm.program -> bool 
=fun _ _ -> true (* TODO *)