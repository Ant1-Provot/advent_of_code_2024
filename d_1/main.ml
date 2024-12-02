let file = "reference.txt"
let regex = Str.regexp "\\([0-9]+\\)   \\([0-9]+\\)"

let make_lists ic =
  let rec aux lhs rhs =
    try
      let line = input_line ic in
      let _ = Str.string_match regex line 0 in
      let l = int_of_string (Str.matched_group 1 line) in
      let r = int_of_string (Str.matched_group 2 line) in
      aux (l :: lhs) (r :: rhs)
    with End_of_file -> (lhs, rhs)
  in
  aux [] []

let q_1 lhs rhs =
  let sort l = List.sort compare l in

  let lhs = sort lhs in
  let rhs = sort rhs in

  let diffs = List.map2 (fun a b -> abs (a - b)) lhs rhs in
  List.fold_left ( + ) 0 diffs

let q_2 lhs rhs =
  let count l v =
    List.fold_left (fun acc x -> if x = v then acc + 1 else acc) 0 l
  in

  List.fold_left (fun acc el -> acc + (count rhs el * el)) 0 lhs

let () =
  (* Read file and display the first line *)
  let ic = open_in file in
  let lhs, rhs = make_lists ic in
  close_in ic;

  print_string "q1 = ";
  print_int (q_1 lhs rhs);
  print_newline ();

  print_string "q2 = ";
  print_int (q_2 lhs rhs);
  print_newline ()
