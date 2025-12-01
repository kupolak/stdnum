let test_compact () =
  let test_cases =
    [
      ("30 23 217 600 053", "3023217600053"); ("3023217600053", "3023217600053")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nif.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("3023217600053", "3023217600053") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nif.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Fr.Nif.validate "3023217600054");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Nif.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Fr.Nif.validate "070198776543");
    Alcotest.fail "Expected Invalid_length exception"
  with Fr.Nif.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Fr.Nif.validate "9701987765432");
    Alcotest.fail "Expected Invalid_component exception"
  with Fr.Nif.Invalid_component -> ()

let test_validate_invalid_format () =
  try
    ignore (Fr.Nif.validate "30 23 217 60a 053");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Nif.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("3023217600053", true)
    ; ("3023217600054", false)
    ; ("070198776543", false)
    ; ("9701987765432", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nif.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("3023217600053", "30 23 217 600 053")
    ; ("30 23 217 600 053", "30 23 217 600 053")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nif.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let () =
  let open Alcotest in
  run "Fr.Nif"
    [
      ("compact", [ test_case "test_compact" `Quick test_compact ])
    ; ("validate", [ test_case "test_validate" `Quick test_validate ])
    ; ( "validate_invalid_checksum"
      , [
          test_case "test_validate_invalid_checksum" `Quick
            test_validate_invalid_checksum
        ] )
    ; ( "validate_invalid_length"
      , [
          test_case "test_validate_invalid_length" `Quick
            test_validate_invalid_length
        ] )
    ; ( "validate_invalid_component"
      , [
          test_case "test_validate_invalid_component" `Quick
            test_validate_invalid_component
        ] )
    ; ( "validate_invalid_format"
      , [
          test_case "test_validate_invalid_format" `Quick
            test_validate_invalid_format
        ] )
    ; ("is_valid", [ test_case "test_is_valid" `Quick test_is_valid ])
    ; ("format", [ test_case "test_format" `Quick test_format ])
    ]
