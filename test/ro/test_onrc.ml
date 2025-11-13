let test_compact () =
  let test_cases =
    [
      ("J52/750/2012", "J52/750/2012")
    ; ("J 52/750/2012", "J52/750/2012")
    ; ("J/52/750/2012", "J52/750/2012")
    ; ("J2/750/2012", "J02/750/2012")
    ; ("J52/750/01.01.2012", "J52/750/2012")
    ; ("j52/750/2012", "J52/750/2012")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ro.Onrc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases = [ "J52/750/2012"; "F01/123/2015"; "C40/999/2020" ] in
  List.iter
    (fun input ->
      let result = Ro.Onrc.validate input in
      Alcotest.(check string)
        ("test_validate_valid_" ^ input)
        (Ro.Onrc.compact input) result)
    test_cases

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Ro.Onrc.Invalid_format (fun () ->
      ignore (Ro.Onrc.validate "J52ABC750"))

let test_validate_invalid_component_type () =
  Alcotest.check_raises "Invalid Component" Ro.Onrc.Invalid_component (fun () ->
      ignore (Ro.Onrc.validate "X52/750/2012"))

let test_validate_invalid_component_county () =
  Alcotest.check_raises "Invalid Component" Ro.Onrc.Invalid_component (fun () ->
      ignore (Ro.Onrc.validate "J99/750/2012"))

let test_validate_invalid_component_year_too_old () =
  Alcotest.check_raises "Invalid Component" Ro.Onrc.Invalid_component (fun () ->
      ignore (Ro.Onrc.validate "J52/750/1989"))

let test_validate_invalid_component_year_future () =
  Alcotest.check_raises "Invalid Component" Ro.Onrc.Invalid_component (fun () ->
      ignore (Ro.Onrc.validate "J52/750/3000"))

let test_validate_invalid_length_serial () =
  Alcotest.check_raises "Invalid Length" Ro.Onrc.Invalid_length (fun () ->
      ignore (Ro.Onrc.validate "J52/123456/2012"))

let test_validate_invalid_length_year () =
  Alcotest.check_raises "Invalid Length" Ro.Onrc.Invalid_length (fun () ->
      ignore (Ro.Onrc.validate "J52/750/12"))

let test_is_valid_true () =
  let test_cases = [ "J52/750/2012"; "F01/123/2015"; "C40/999/2020" ] in
  List.iter
    (fun input ->
      let result = Ro.Onrc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases =
    [ "X52/750/2012"; "J99/750/2012"; "J52/750/1989"; "J52/123456/2012" ]
  in
  List.iter
    (fun input ->
      let result = Ro.Onrc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ( "test_validate_invalid_component_type"
    , `Quick
    , test_validate_invalid_component_type )
  ; ( "test_validate_invalid_component_county"
    , `Quick
    , test_validate_invalid_component_county )
  ; ( "test_validate_invalid_component_year_too_old"
    , `Quick
    , test_validate_invalid_component_year_too_old )
  ; ( "test_validate_invalid_component_year_future"
    , `Quick
    , test_validate_invalid_component_year_future )
  ; ( "test_validate_invalid_length_serial"
    , `Quick
    , test_validate_invalid_length_serial )
  ; ( "test_validate_invalid_length_year"
    , `Quick
    , test_validate_invalid_length_year )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Ro.Onrc" [ ("suite", suite) ]
