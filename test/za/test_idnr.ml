let test_compact () =
  let cases =
    [
      ("7503305044089", "7503305044089")
    ; ("750330 5044089", "7503305044089")
    ; (" 7503305044089 ", "7503305044089")
    ; ("750330-5044-08-9", "7503305044089")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Idnr.compact input in
      Alcotest.(check string) ("compact_" ^ input) expected result)
    cases

let test_validate () =
  let cases =
    [
      ("7503305044089", Some "7503305044089") (* Valid ID *)
    ; ("8503305044089", None) (* Invalid checksum *)
    ; ("9125568", None) (* Invalid length *)
    ; ("750330504408A", None) (* Invalid format *)
    ; ("9999995044089", None) (* Invalid date *)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result =
        try Some (Za.Idnr.validate input)
        with
        | Za.Idnr.Invalid_length | Za.Idnr.Invalid_format
        | Za.Idnr.Invalid_component | Za.Idnr.Invalid_checksum
        ->
          None
      in
      Alcotest.(check (option string)) ("validate_" ^ input) expected result)
    cases

let test_is_valid () =
  let cases =
    [ ("7503305044089", true); ("8503305044089", false); ("9125568", false) ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Idnr.is_valid input in
      Alcotest.(check bool) ("is_valid_" ^ input) expected result)
    cases

let test_format () =
  let cases =
    [
      ("7503305044089", "750330 5044 08 9")
    ; ("750330 5044089", "750330 5044 08 9")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Idnr.format input in
      Alcotest.(check string) ("format_" ^ input) expected result)
    cases

let test_get_gender () =
  let cases =
    [
      ("7503305044089", 'M') (* Gender digit 5044 >= 5000 = Male *)
    ; ("7503304044089", 'F') (* Gender digit 4044 < 5000 = Female *)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Idnr.get_gender input in
      Alcotest.(check char) ("get_gender_" ^ input) expected result)
    cases

let test_get_citizenship () =
  let cases =
    [
      ("7503305044089", "citizen") (* Citizenship digit 0 *)
    ; ("7503305044189", "resident") (* Citizenship digit 1 *)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Idnr.get_citizenship input in
      Alcotest.(check string) ("get_citizenship_" ^ input) expected result)
    cases

let test_get_birth_date () =
  let cases = [ ("7503305044089", (30, 3, 1975)) (* 30 March 1975 *) ] in
  List.iter
    (fun (input, (exp_day, exp_month, exp_year)) ->
      match Za.Idnr.get_birth_date input with
      | Some (_, tm) ->
          Alcotest.(check int) ("birth_day_" ^ input) exp_day tm.Unix.tm_mday;
          Alcotest.(check int)
            ("birth_month_" ^ input) (exp_month - 1) tm.Unix.tm_mon;
          Alcotest.(check int)
            ("birth_year_" ^ input) exp_year (tm.Unix.tm_year + 1900)
      | None -> Alcotest.fail ("Expected birth date for " ^ input))
    cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_get_citizenship", `Quick, test_get_citizenship)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ]

let () = Alcotest.run "Za.Idnr" [ ("suite", suite) ]
