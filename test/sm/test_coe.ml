let test_compact () =
  let test_cases =
    [ ("51", "51"); ("024165", "24165"); (" 0051 ", "51"); ("00100", "100") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sm.Coe.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases = [ ("51", "51"); ("024165", "24165"); ("100", "100") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Sm.Coe.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Sm.Coe.Invalid_format (fun () ->
      ignore (Sm.Coe.validate "2416A"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Sm.Coe.Invalid_length (fun () ->
      ignore (Sm.Coe.validate "1124165"))

let test_validate_invalid_component () =
  Alcotest.check_raises "Invalid Component" Sm.Coe.Invalid_component (fun () ->
      ignore (Sm.Coe.validate "1"))

let test_is_valid_true () =
  let result = Sm.Coe.is_valid "51" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Sm.Coe.is_valid "2416A" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_is_valid_low_number () =
  let result = Sm.Coe.is_valid "2" in
  Alcotest.(check bool) "test_is_valid_low_number" true result

let test_is_valid_invalid_low_number () =
  let result = Sm.Coe.is_valid "1" in
  Alcotest.(check bool) "test_is_valid_invalid_low_number" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_is_valid_low_number", `Quick, test_is_valid_low_number)
  ; ( "test_is_valid_invalid_low_number"
    , `Quick
    , test_is_valid_invalid_low_number )
  ]

let () = Alcotest.run "Sm.Coe" [ ("suite", suite) ]
