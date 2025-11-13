let test_compact () =
  let test_cases =
    [
      ("004495445B01", "004495445B01")
    ; ("NL4495445B01", "004495445B01")
    ; ("NL002455799B11", "002455799B11")
    ; ("NL 004495445 B01", "004495445B01")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Btw.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("004495445B01", "004495445B01") (* Valid BSN-based *)
    ; ("NL4495445B01", "004495445B01")
    ; ("NL002455799B11", "002455799B11") (* Valid mod 97-10, valid since 2020 *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Btw.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("004495445B01", true) (* Valid BSN-based *)
    ; ("NL4495445B01", true)
    ; ("NL002455799B11", true) (* Valid mod 97-10 *)
    ; ("123456789B90", false) (* Invalid checksum *)
    ; ("004495445B", false) (* Too short *)
    ; ("004495445C01", false) (* Wrong letter (C instead of B) *)
    ; ("000000000B01", false) (* Zero BSN *)
    ; ("004495445B00", false) (* Zero suffix *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Btw.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Nl_stdnum.Btw" [ ("suite", suite) ]
