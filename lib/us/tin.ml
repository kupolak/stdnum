open Tools

exception Invalid_format

let compact number = Utils.clean number "-" |> String.trim

let validate number =
  let cleaned = compact number in
  (* Check if this looks like an ATIN first (9XX-93-XXXX pattern) *)
  if
    String.contains number '-'
    && String.length number = 11
    && String.length cleaned = 9
    && String.get cleaned 0 = '9'
    && String.get cleaned 3 = '9'
    && String.get cleaned 4 = '3'
  then
    try Atin.validate number
    with Invalid_format ->
      (* If ATIN fails, try other modules with cleaned number *)
      let modules =
        [
          (fun () -> Ssn.validate cleaned)
        ; (fun () -> Itin.validate cleaned)
        ; (fun () -> Ein.validate cleaned)
        ; (fun () -> Ptin.validate cleaned)
        ]
      in
      let rec try_modules = function
        | [] -> raise Invalid_format
        | validator :: rest -> (
            try validator () with Invalid_format -> try_modules rest)
      in
      try_modules modules
  else
    (* For non-ATIN numbers, try all modules *)
    let modules =
      [
        (fun () -> Ssn.validate cleaned)
      ; (fun () -> Itin.validate cleaned)
      ; (fun () -> Ein.validate cleaned)
      ; (fun () -> Ptin.validate cleaned)
      ]
    in
    let rec try_modules = function
      | [] -> raise Invalid_format
      | validator :: rest -> (
          try validator () with Invalid_format -> try_modules rest)
    in
    try_modules modules

let is_valid number =
  try
    ignore (validate number);
    true
  with _ -> false

let guess_type number =
  let cleaned = compact number in
  let modules =
    [
      (Ssn.is_valid, "ssn")
    ; (Itin.is_valid, "itin")
    ; (Ein.is_valid, "ein")
    ; (Ptin.is_valid, "ptin")
    ; ((fun _ -> Atin.is_valid number), "atin")
    ]
  in
  List.fold_left
    (fun acc (validator, name) ->
      if validator cleaned then name :: acc else acc)
    [] modules
  |> List.rev

let format number =
  let cleaned = compact number in
  (* Try formatting with each module *)
  if String.length cleaned = 9 && Utils.is_digits cleaned then
    (* Try SSN format first *)
    if Ssn.is_valid cleaned then Ssn.format cleaned
    else if Itin.is_valid cleaned then Itin.format cleaned
    else if Ein.is_valid cleaned then Ein.format cleaned
    else if Ptin.is_valid cleaned then Ptin.format cleaned
    else if Atin.is_valid number then Atin.format number
    else number
  else number
