let test_compact () =
  let result = Is_.Vsk.compact " IS 00621 " in
  Alcotest.(check string) "test_compact" "00621" result

let test_validate () =
  let result = Is_.Vsk.validate "IS 00621" in
  Alcotest.(check string) "test_validate" "00621" result

let test_validate_invalid_length () =
  try
    ignore (Is_.Vsk.validate "IS 0062199");
    Alcotest.fail "Expected Invalid_length exception"
  with Is_.Vsk.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Is_.Vsk.validate "0062A");
    Alcotest.fail "Expected Invalid_format exception"
  with Is_.Vsk.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("IS 00621", true)
    ; ("IS 0062199", false)
    ; ("0062A", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Is_.Vsk.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Is_.Vsk" [ ("suite", suite) ]
