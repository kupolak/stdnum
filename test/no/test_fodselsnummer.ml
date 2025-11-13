let test_compact () =
  let test_cases =
    [
      ("151086 95088", "15108695088")
    ; ("151086-95088", "15108695088")
    ; ("15108695088", "15108695088")
    ; ("151086:95088", "15108695088")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_get_gender () =
  let test_cases =
    [ ("151086 95088", 'F') (* Individual number 950, even 9th digit = 0 *) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.get_gender input in
      Alcotest.(check char) ("test_get_gender_" ^ input) expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      (* Test case: 15108695088 = 15 Oct 1986 *)
      ( "15108695088"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1986 - 1900
                   ; tm_mon = 9 (* October = 9 *)
                   ; tm_mday = 15
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.get_birth_date input in
      let result = Option.map (fun (secs, _) -> Int64.of_float secs) result in
      Alcotest.(check (option int64))
        ("test_get_birth_date_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("151086 95088", "15108695088"); ("151086-95088", "15108695088") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("151086 95088", true) (* Valid *)
    ; ("15108695088", true) (* Valid *)
    ; ("15108695077", false) (* Invalid checksum *)
    ; ("123456789", false) (* Invalid length *)
    ; ("1510869508A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("15108695088", "151086 95088"); ("151086 95088", "151086 95088") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Fodselsnummer.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "No.Fodselsnummer" [ ("suite", suite) ]
