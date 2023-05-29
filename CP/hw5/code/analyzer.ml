open Spvm
exception TypeError of string
exception Not_implemented of string
exception No_next_label of string
exception No_function of string
exception Arg_unmatched of string
exception No_list of string
exception Index_out_of_range of string

module Ptype = struct
type t =
    | PInt of int
    | PStr of string
    | PList of t list
    | PTuple of t list
    | PFunc of (id list) * program
    | PNone
    | PMix
let join a b = if a = b then a else PMix
let rec to_string = function
    | PMix -> "PMix"
    | PInt(i) -> "PInt("^(string_of_int i)^")"
    | PStr(s) -> "PStr("^s^")"
    | PList(t1) -> "PList("^(List.fold_left (fun acc x -> acc^", "^to_string x) "" t1)^")"
    | PTuple(t1) -> "PTuple("^(List.fold_left (fun acc x -> acc^", "^to_string x) "" t1)^")"
    | PFunc(id_list, _) -> "PFunc("^(List.fold_left (fun acc x -> acc^", "^ x) "" id_list)^")"
    | PNone -> "PNone"
let eval_bop = fun t1 o t2 -> begin match t1, o, t2 with
    | PInt n1, ADD, PInt n2 -> PInt (n1+n2)
    | PInt n1, SUB, PInt n2 -> PInt (n1-n2)
    | PInt n1, MUL, PInt n2 -> PInt (n1*n2)
    | PInt n1, DIV, PInt n2 -> PInt (n1/n2)
    | PInt n1, MOD, PInt n2 -> PInt (let r = n1 mod n2 in if r < 0 then r + n2 else r)
    | PInt n1, POW, PInt n2 -> PInt (pow n1 n2)
    | PInt n1, LT, PInt n2 -> if n1 < n2 then PInt 1 else PInt 0
    | PInt n1, LE, PInt n2 -> if n1 <= n2 then PInt 1 else PInt 0
    | PInt n1, GT, PInt n2 -> if n1 > n2 then PInt 1 else PInt 0
    | PInt n1, GE, PInt n2 -> if n1 >= n2 then PInt 1 else PInt 0
    | PInt n1, EQ, PInt n2 -> if n1 = n2 then PInt 1 else PInt 0
    | PInt n1, NEQ, PInt n2 -> if n1 != n2 then PInt 1 else PInt 0
    | PInt n1, AND, PInt n2 -> if n1 != 0 && n2 != 0 then PInt 1 else PInt 0
    | PInt n1, OR, PInt n2 -> if n1 != 0 || n2 != 0 then PInt 1 else PInt 0
    | PInt _, EQ, PNone -> PInt 0
    | PNone, EQ, PInt _ -> PInt 0
    | PNone, EQ, PNone -> PInt 1
    | PStr s1, ADD, PStr s2 -> PStr (s1 ^ s2)
    | PInt n, MUL, PStr s
    | PStr s, MUL, PInt n ->
        let rec repeat s n =
        if n <= 0 then "" else s ^ repeat s (n-1) in
        PStr (repeat s n)
    | _ -> raise (TypeError "b_operation type not matched")
    end
let eval_uop = fun o v -> match o, v with
    | UPLUS, PInt n -> PInt (n)
    | UMINUS, PInt n -> PInt (-n)
    | NOT, PInt n -> if n = 0 then PInt 1 else PInt 0
    | _ -> raise (TypeError "u_operation type not matched")
let iter_store n v lst =
    List.mapi (fun i x -> if i = n then v else x) lst
let rec range a b =
    if a >= b then []
    else PInt(a) :: range (a + 1) b
end

module PMem = struct
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

let rec analyze_m
= fun _ -> true

and find_next_label lb lst =
match lst with
    | [] -> raise (No_next_label (string_of_int lb))
    | (k, _) :: (k', _) :: _ when k = lb -> k'
    | _ :: tail -> find_next_label lb tail

and find
= fun k m -> PMem.find k m

and eval_prog : program -> PMem.t -> PMem.t
=fun prog init_m ->
    let (init_lb, _) = List.hd prog in
    let rec eval_linstr = fun c_lb e_lb m ->
    (* curr_label, end_label, next_label, jump_label *)
    if c_lb = e_lb then m
    else begin match (List.assoc c_lb prog) with
        | HALT -> m
        | inst' -> begin let n_lb = find_next_label c_lb prog in
        match inst' with
        | SKIP -> eval_linstr n_lb e_lb m
        | FUNC_DEF(f, id_list, body) -> eval_linstr (n_lb) (e_lb) (PMem.add f (Ptype.PFunc(id_list, body)) m)
        | RETURN(x) -> (PMem.add "@" (find x m) m)
        | CALL(x, f, arg_list) -> begin match (find f m) with
            | Ptype.PFunc(id_list, body) ->
                let rec id_arg_match =
                fun i_l a_l m -> begin match (i_l, a_l) with
                    | ([], []) -> m
                    | (i_hd::i_tl, a_hd::a_tl) -> id_arg_match (i_tl) (a_tl) (PMem.add i_hd (find (a_hd) m) m)
                    | _ -> raise (Arg_unmatched f)
                    end
                in
                let id_mem = id_arg_match id_list arg_list m in
                let f_mem = eval_prog body id_mem in
                eval_linstr (n_lb) (e_lb) (PMem.add x (find "@" (f_mem)) m)
            | _ -> raise (No_function f)
        end
        | UJUMP(j_lb) -> eval_linstr (j_lb) (e_lb) m
        | CJUMP(x, j_lb) ->
            let t_x = (find x m) in
            begin match t_x with
            | Ptype.PInt(0) -> (eval_linstr n_lb e_lb m)
            | Ptype.PInt(_) -> (eval_linstr j_lb e_lb m)
            | _ -> raise (TypeError "CJUMP not int typer")
            end
        | CJUMPF(x, j_lb) ->
            let t_x = (find x m) in
            begin match t_x with
            | Ptype.PInt(0) -> (eval_linstr j_lb e_lb m)
            | Ptype.PInt(_) -> (eval_linstr n_lb e_lb m)
            | _ -> raise (TypeError "CJUMPF not int type")
            end
        | ASSERT(_) -> m
        | inst -> eval_linstr n_lb e_lb (eval_instr inst m)
        end
    end in
    eval_linstr (init_lb) (-1) (init_m)
and eval_instr : instr -> PMem.t -> PMem.t
=fun inst m -> match inst with
| RANGE(x, l, h) ->
    let t_l = (find l m) in
    let t_h = (find h m) in
    begin match (t_l, t_h) with
    | (Ptype.PInt(n_l), Ptype.PInt(n_h)) -> PMem.add x (Ptype.PList(Ptype.range n_l n_h)) m
    | _ -> raise (TypeError "RANGE not int type")
    end
| LIST_EMPTY(x) -> PMem.add x (Ptype.PList([])) m
| LIST_APPEND(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PList(p_list) -> PMem.add x (Ptype.PList(p_list@[t_y])) m
        | _ -> raise (No_list x)
    end
| LIST_INSERT(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PList(p_list) -> PMem.add x (Ptype.PList([t_y]@p_list)) m
        | _ -> raise (No_list x)
    end
| LIST_REV(x) ->
    let t_x = (find x m) in
    begin match t_x with
        | Ptype.PList(p_list) -> PMem.add x (Ptype.PList(List.rev p_list)) m
        | _ -> raise (No_list x)
    end
| TUPLE_EMPTY(x) -> PMem.add x (Ptype.PTuple([])) m
| TUPLE_INSERT(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PTuple(p_list) -> PMem.add x (Ptype.PTuple([t_y]@p_list)) m
        | _ -> raise (No_list x)
    end
| ITER_LOAD(x, a ,i) ->
    let t_a = (find a m) in
    let t_i = (find i m) in
    begin match (t_a, t_i) with
        | (Ptype.PList(p_list), Ptype.PInt(n))
        | (Ptype.PTuple(p_list), Ptype.PInt(n)) ->
            let len_list = (List.length p_list) in
            let nth = (List.nth p_list n) in
            if n < len_list
            then PMem.add x nth m
            else raise (Index_out_of_range a)
        | _ -> raise (No_list a)
    end
| ITER_STORE(a, i, y) ->
    let t_a = (find a m) in
    let t_i = (find i m) in
    let t_y = (find y m) in
    begin match (t_a, t_i) with
        | (Ptype.PList(p_list), Ptype.PInt(n)) ->
            let len_list = (List.length p_list) in
            if n < len_list
            then begin
                let n_list = (Ptype.iter_store n t_y p_list) in
                PMem.add a (Ptype.PList(n_list)) m
            end
            else raise (Index_out_of_range a)
        | (Ptype.PTuple(p_list), Ptype.PInt(n)) ->
            let len_list = (List.length p_list) in
            if n < len_list
            then begin
            	let n_list = (Ptype.iter_store n t_y p_list) in
            	PMem.add a (Ptype.PTuple(n_list)) m
            end
            else raise (Index_out_of_range a)
        | _ -> raise (No_list a)
    end
| ITER_LENGTH(x, y) ->
    let t_y = (find y m) in
    begin match t_y with
        | Ptype.PTuple(p_list)
        | Ptype.PList(p_list) -> PMem.add x (Ptype.PInt(List.length p_list)) m
        | _ -> raise (No_list x)
    end
| ASSIGNV(x, o, y, z) ->
    let t_y = (find y m) in
    let t_z = (find z m) in
    (PMem.add x (Ptype.eval_bop (t_y) o (t_z)) m)
| ASSIGNC(x, o, y, n) ->
    let t_y = (find y m) in
    (PMem.add x (Ptype.eval_bop (t_y) (o) (Ptype.PInt(n))) m)
| ASSIGNU(x, o, y) ->
    let t_y = (find y m) in
    (PMem.add x (Ptype.eval_uop (o) (t_y)) m)
| COPY(x, y) -> PMem.add x (find y m) m
| COPYC(x, n) -> PMem.add x (Ptype.PInt(n)) m
| COPYS(x, s) -> PMem.add x (Ptype.PStr(s)) m
| COPYN(x) -> PMem.add x (Ptype.PNone) m
| READ(x) -> PMem.add x (Ptype.PStr("1")) m
| WRITE(_) -> m
| INT_OF_STR(x, y) ->
    let t_y = (find y m) in
    begin match t_y with
        | Ptype.PStr(s) -> PMem.add x (Ptype.PInt(int_of_string s)) m
        | _ -> raise (TypeError "int() Operation not str type")
    end
| IS_INSTANCE(x, y, typ) ->
    let t_y = (find y m) in
    begin match (t_y, typ) with
        | (Ptype.PInt(_), "int")
        | (Ptype.PStr(_), "str")
        | (Ptype.PList(_), "list")
        | (Ptype.PTuple(_), "tuple") -> PMem.add x (Ptype.PInt(1)) m
        | _ -> PMem.add x (Ptype.PInt(0)) m
    end
| _ -> raise (Not_implemented "Not implemented instruction")

let analyze : Spy.program -> Spvm.program -> bool
=fun _ s_prog ->
(*let _ = PMem.print (eval_prog s_prog PMem.empty) in*)
try analyze_m (eval_prog s_prog PMem.empty) with _ -> false