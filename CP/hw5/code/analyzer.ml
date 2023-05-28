open Spy
exception TypeError of string

module Ptype = struct
  type t = PMix | PInt | PString | PBool | PList | PTuple | PNone
  let join a b = match (a, b) with
    | (PInt, PInt) -> PInt
    | (PString, PString) -> PString
    | (PBool, PBool) -> PBool
    | (PList, PList) -> PList
    | (PTuple, PTuple) -> PTuple
    | (PNone, PNone) -> PNone
    | _ -> PMix
  let oper_check a b = match (a, b) with
    | (PInt, PInt) | (PString, PString) | (PBool, PBool) | (PList, PList) | (PTuple, PTuple) -> true
    | _ -> false
  let to_string = function
    | PMix -> "PMix"
    | PInt -> "PInt"
    | PString -> "PString"
    | PBool -> "PBool"
    | PList -> "PList"
    | PTuple -> "PTuple"
    | PNone -> "PNone"
end

module AbsMem = struct
  module LocMap = Map.Make(String)
  type t = Ptype.t LocMap.t
  let empty = LocMap.empty
  let add = LocMap.add
  let find k m = try LocMap.find k m with _ -> Ptype.PNone
  let join m1 m2 =
    LocMap.fold (fun m1_k m1_v m2_acc -> add m1_k (Ptype.join m1_v (find m1_k m2_acc)) m2_acc) m1 m2
  let print m =
    LocMap.iter (fun k v -> print_endline (k ^ " |-> " ^ Ptype.to_string v)) m
end


let rec eval_prog : program -> AbsMem.t -> AbsMem.t
=fun p m -> List.fold_left (fun m c -> eval_stmt c m) m p

and eval_stmt : stmt -> AbsMem.t -> AbsMem.t
=fun c m ->
  match c with
  | Assign (x, e) -> AbsMem.add x (eval_expr e m) m
  | If (b, p1, p2) -> begin
      let t_b = (eval_expr b m) in
      match t_b with
      | Ptype.PBool -> AbsMem.join (eval_prog p1 m) (eval_prog p2 m)
      | _ ->  raise (TypeError ("not bool: "^(Ptype.to_string t_b)))
    end
  | While (b, p) -> begin
  	  let t_b = (eval_expr b m) in
      match t_b with
      | Ptype.PBool -> (eval_prog p m)
      | _ ->  raise (TypeError ("not bool: "^(Ptype.to_string t_b)))
    end

and eval_expr : expr -> AbsMem.t -> Ptype.t
=fun a m ->
  match a with
  | Constant _ -> Ptype.PInt
  | Name x -> AbsMem.find x m
  | Op (e1, e2) ->
    let t1 = (eval_expr e1 m) in
    let t2 = (eval_expr e2 m) in
    if t1=t2
    then t1
    else raise (TypeError ((Ptype.to_string t1)^" and "^(Ptype.to_string t2)))

let analyze : Spy.program -> Spvm.program -> bool 
=fun _ _ -> true (* TODO *)