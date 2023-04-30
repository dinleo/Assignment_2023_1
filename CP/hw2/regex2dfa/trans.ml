open Regex
open Nfa

exception Not_implemented

let regex2nfa : Regex.t -> Nfa.t = function
    | reg -> (
        let nfa = Nfa.create_new_nfa () in
        let rec regex2nfa' r t s f = match r with
            | Empty -> (s, t)
            | Epsilon -> (
                let (se, t1) = Nfa.create_state t in
                let t2 = Nfa.add_epsilon_edge t1 (s, se) in
                if f then (se, Nfa.add_final_state t2 se) else (se, t2)
            )
            | Alpha a -> (
                let (s1, t1) = Nfa.create_state t in
                let t2 = Nfa.add_edge t1 (s, a, s1) in
                if f then (s1, Nfa.add_final_state t2 s1) else (s1, t2)
            )
            | OR (r1, r2) -> (
                let (_, t1) = regex2nfa' r1 t s f in
                let (s2, t2) = regex2nfa' r2 t1 s f in
                (s2, t2)
            )
            | CONCAT (r1, r2) -> (
                let (s1, t1) = regex2nfa' r1 t s false in
                let (s2, t2) = regex2nfa' r2 t1 s1 f in
                (s2, t2)
            )
            | STAR r -> (
                let (s1, t1) = regex2nfa' r t s f in
                let t3 = Nfa.add_epsilon_edge t1 (s1, s) in
                (s, t3)
            )
        in
        let (_,ft) = regex2nfa' reg nfa (Nfa.get_initial_state nfa) true in
        ft
    )
;;

let nfa2dfa : Nfa.t -> Dfa.t = function
    | nfa -> (
        let n_init = Nfa.get_initial_state nfa in
        let n_fin = Nfa.get_final_states nfa in
        let d_init = BatSet.union (Nfa.get_next_state_epsilon nfa n_init) (BatSet.singleton n_init) in
        let new_dfa' = Dfa.create_new_dfa d_init in
        let new_dfa = Dfa.add_state new_dfa' (BatSet.singleton(0)) in
        let rec nfa2dfa' dfa s d = match BatSet.is_empty s with
        | true -> dfa
        | false ->
            let qa = BatSet.fold (fun s' -> BatSet.union (Nfa.get_next_state nfa s' A)) s (BatSet.empty) in
            let qae = BatSet.fold (fun s' -> BatSet.union (Nfa.get_next_state_epsilon nfa s')) qa qa in
            let qb = BatSet.fold (fun s' -> BatSet.union (Nfa.get_next_state nfa s' B)) s (BatSet.empty) in
            let qbe = BatSet.fold (fun s' -> BatSet.union (Nfa.get_next_state_epsilon nfa s')) qb qb in
            let dfa_a = if (BatSet.is_empty qae)
                then Dfa.add_edge (Dfa.add_state dfa qae) (s, A, BatSet.singleton(0))
                else Dfa.add_edge (Dfa.add_state dfa qae) (s, A, qae) in
            let dfa_a' = if (BatSet.mem qae d)
                then dfa_a
                else (nfa2dfa' (if ((BatSet.subset qae n_fin) && not (BatSet.is_empty qae)) then (Dfa.add_final_state dfa_a qae) else dfa_a) qae (BatSet.add qae d)) in
            let dfa_b = if (BatSet.is_empty qbe)
                then Dfa.add_edge (Dfa.add_state dfa_a' qbe) (s, B, BatSet.singleton(0))
                else Dfa.add_edge (Dfa.add_state dfa_a' qbe) (s, B, qbe) in
            let dfa_b' = if (BatSet.mem qbe d)
                then dfa_b
                else (nfa2dfa' (if ((BatSet.subset qbe n_fin) && not (BatSet.is_empty qbe)) then (Dfa.add_final_state dfa_b qbe) else dfa_b) qbe (BatSet.add qbe d)) in
            dfa_b'
        in
        nfa2dfa' new_dfa d_init (BatSet.singleton((BatSet.singleton n_init)))
    )
;;


(* Do not modify this function *)
let regex2dfa : Regex.t -> Dfa.t
=fun regex ->
  let nfa = regex2nfa regex in
  let dfa = nfa2dfa nfa in
    dfa

let run_dfa : Dfa.t -> alphabet list -> bool
=fun dfa input ->
    let rec loop curr_state = function
    | [] -> Dfa.is_final_state dfa curr_state
    | x :: xs ->
       let next_state = Dfa.get_next_state dfa curr_state x in
       loop next_state xs
    in
    loop (Dfa.get_initial_state dfa) input
