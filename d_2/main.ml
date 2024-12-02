let file = "reference.txt"
let count_true = List.fold_left (fun acc x -> if x then acc + 1 else acc) 0

let report_is_safe r =
  let rec aux is_inc is_dec = function
    | [] | [ _ ] -> is_inc || is_dec
    | h :: g :: t ->
        let is_inc = is_inc && g - h >= 1 && g - h <= 3 in
        let is_dec = is_dec && h - g >= 1 && h - g <= 3 in
        aux is_inc is_dec (g :: t)
  in
  aux true true r

let make_lists ic =
  let rec aux acc =
    try
      let line = input_line ic in
      let l = line |> String.split_on_char ' ' |> List.map int_of_string in
      aux (l :: acc)
    with End_of_file -> acc
  in
  aux []

let q_1 l = l |> List.map report_is_safe |> count_true

let q_2 l =
  let has_a_safe_perm report =
    let without_i index report =
      report |> List.filteri (fun i _ -> i <> index)
    in

    report
    |> List.mapi (fun i _ -> report |> without_i i)
    |> List.map report_is_safe
    |> List.fold_left ( || ) false
  in

  let safe_reports = l |> List.filter report_is_safe |> List.length in
  let unsafe_reports = l |> List.filter (fun x -> not (report_is_safe x)) in

  let safe_dampened_reports =
    unsafe_reports |> List.map has_a_safe_perm |> count_true
  in

  safe_reports + safe_dampened_reports

let () =
  (* Read file and display the first line *)
  let ic = open_in file in
  let reports = make_lists ic in
  close_in ic;

  print_string "q1 = ";
  print_int (q_1 reports);
  print_newline ();
  print_string "q2 = ";
  print_int (q_2 reports);
  print_newline ()
