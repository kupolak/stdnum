let test_compact () =
  let result = Il.Idnr.compact " 3933742-3 " in
  Alcotest.(check string) "test_compact" "039337423" result

let test_validate () =
  let result = Il.Idnr.validate "3933742-3" in
  Alcotest.(check string) "test_validate" "039337423" result

let test_validate_invalid_checksum () =
  try
    ignore (Il.Idnr.validate "3933742-2");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Il.Idnr.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Il.Idnr.validate "490154203237518");
    Alcotest.fail "Expected Invalid_length exception"
  with Il.Idnr.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("3933742-3", true)
    ; ("3933742-2", false)
    ; ("490154203237518", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Il.Idnr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Il.Idnr.format "39337423" in
  Alcotest.(check string) "test_format" "03933742-3" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Il.Idnr" [ ("suite", suite) ]
