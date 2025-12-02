open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

type birth_place = { province : string; county : string }

let compact number =
  Utils.clean number "" |> String.uppercase_ascii |> String.trim

(* Location database cache *)
let loc_db = ref None

let load_loc_db () =
  match !loc_db with
  | Some db -> db
  | None ->
      let db = Hashtbl.create 10000 in
      (* Find the database file - try common locations *)
      let possible_paths =
        [
          "lib/cn/loc.dat"
        ; (* From project root *)
          "../../lib/cn/loc.dat"
        ; (* From test/cn/ *)
          "../../../../lib/cn/loc.dat" (* From _build/default/test/cn/ *)
        ]
      in
      let rec find_file = function
        | [] -> raise (Sys_error "loc.dat not found")
        | path :: rest -> if Sys.file_exists path then path else find_file rest
      in
      let loc_file = find_file possible_paths in
      let ic = open_in loc_file in
      let current_province = ref "" in
      (try
         while true do
           let line = input_line ic in
           if
             String.length line > 0 && line.[0] <> '#' && String.trim line <> ""
           then
             if line.[0] <> ' ' then (
               (* Province *)
               let parts = String.split_on_char '=' line in
               if List.length parts = 2 then (
                 let province_part = List.nth parts 1 in
                 let province =
                   String.sub province_part 1 (String.length province_part - 2)
                 in
                 let code_part = List.nth parts 0 in
                 let space_idx = String.index code_part ' ' in
                 let code = String.sub code_part 0 space_idx in
                 current_province := code;
                 Hashtbl.add db (code ^ "0000") (province, "")))
             else
               (* County *)
               let trimmed = String.trim line in
               let parts = String.split_on_char '=' trimmed in
               if List.length parts = 2 then
                 let county_part = List.nth parts 1 in
                 let county =
                   String.sub county_part 1 (String.length county_part - 2)
                 in
                 let space_idx = String.index trimmed ' ' in
                 let code = String.sub trimmed 0 space_idx in
                 let full_code = !current_province ^ code in
                 (* Don't add counties with code 0000 - they duplicate province entries *)
                 if code <> "0000" then
                   (* Split county by comma to handle multiple temporal entries *)
                   let counties = String.split_on_char ',' county in
                   List.iter
                     (fun c -> Hashtbl.add db full_code (!current_province, c))
                     counties
         done
       with End_of_file -> close_in ic);
      loc_db := Some db;
      db

let get_birth_date number =
  let number = compact number in
  let year = int_of_string (String.sub number 6 4) in
  let month = int_of_string (String.sub number 10 2) in
  let day = int_of_string (String.sub number 12 2) in

  (* Validate date ranges *)
  if month < 1 || month > 12 then raise Invalid_component;
  if day < 1 || day > 31 then raise Invalid_component;

  (* Simple month-day validation *)
  if month = 2 && day > 29 then raise Invalid_component;
  if (month = 4 || month = 6 || month = 9 || month = 11) && day > 30 then
    raise Invalid_component;

  (year, month, day)

let parse_year_range range_str =
  (* Parse "[1991-2015]" or "[1991-]" or "[-2015]" *)
  if String.length range_str < 3 then None
  else
    let inner = String.sub range_str 1 (String.length range_str - 2) in
    let parts = String.split_on_char '-' inner in
    match parts with
    | [ start; end_ ] ->
        let start_year =
          if start = "" then None else Some (int_of_string start)
        in
        let end_year = if end_ = "" then None else Some (int_of_string end_) in
        Some (start_year, end_year)
    | _ -> None

let get_birth_place number =
  let number = compact number in
  let loc_code = String.sub number 0 6 in
  let year, _, _ = get_birth_date number in

  let db =
    try load_loc_db ()
    with Sys_error _ ->
      (* If database loading fails, raise Invalid_component *)
      raise Invalid_component
  in

  (* Get the province and county from database *)
  let county_candidates = Hashtbl.find_all db loc_code in
  if county_candidates = [] then raise Invalid_component;

  let valid_county = ref None in
  let province_name = ref "" in

  List.iter
    (fun (prov_code, county_full) ->
      (* Get province name if not set *)
      (if !province_name = "" then
         try
           let p, _ = Hashtbl.find db (prov_code ^ "0000") in
           province_name := p
         with Not_found -> ());

      (* county_full might be like "[1991-2015]德安县" or "德安县" *)
      if county_full <> "" && !valid_county = None then
        if String.length county_full > 0 && county_full.[0] = '[' then
          (* Has year range *)
          try
            let bracket_end = String.index county_full ']' in
            let range = String.sub county_full 0 (bracket_end + 1) in
            let county_name =
              String.sub county_full (bracket_end + 1)
                (String.length county_full - bracket_end - 1)
            in
            match parse_year_range range with
            | Some (start_opt, end_opt) ->
                let valid_start =
                  match start_opt with None -> true | Some s -> year >= s
                in
                let valid_end =
                  match end_opt with None -> true | Some e -> year <= e
                in
                if valid_start && valid_end then
                  valid_county := Some county_name
            | None -> ()
          with Not_found -> ()
        else (* No year range, always valid *)
          valid_county := Some county_full)
    county_candidates;

  match !valid_county with
  | Some county -> { province = !province_name; county }
  | None -> raise Invalid_component

let calc_check_digit number =
  (* Calculate checksum using base-13 arithmetic *)
  (* checksum = (1 - 2 * int(number[:-1], 13)) % 11 *)

  (* Convert from base-13 to decimal using Int64 for large numbers *)
  let base13_to_int64 s =
    let result = ref Int64.zero in
    for i = 0 to String.length s - 1 do
      let digit = int_of_char s.[i] - int_of_char '0' in
      result := Int64.add (Int64.mul !result 13L) (Int64.of_int digit)
    done;
    !result
  in

  let base13_value = base13_to_int64 number in
  let doubled = Int64.mul base13_value 2L in
  let subtracted = Int64.sub 1L doubled in

  (* Calculate modulo 11 properly handling negative numbers *)
  let checksum = Int64.rem subtracted 11L in
  let checksum = if checksum < 0L then Int64.add checksum 11L else checksum in
  let checksum_int = Int64.to_int checksum in

  if checksum_int = 10 then "X" else string_of_int checksum_int

let validate number =
  let number = compact number in

  if String.length number <> 18 then raise Invalid_length;

  (* Check if first 17 characters are digits *)
  let first_17 = String.sub number 0 17 in
  if not (Utils.is_digits first_17) then raise Invalid_format;

  (* Validate check digit *)
  let expected_check = calc_check_digit first_17 in
  let actual_check = String.sub number 17 1 in
  if expected_check <> actual_check then raise Invalid_checksum;

  (* Validate birth date *)
  let _ = get_birth_date number in

  (* Validate birth place *)
  let _ = get_birth_place number in

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number = compact number
