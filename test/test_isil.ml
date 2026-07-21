let test_compact () =
  let result = Stdnum.Isil.compact " IT-RM0267 " in
  Alcotest.(check string) "test_compact" "IT-RM0267" result

let test_validate () =
  let result = Stdnum.Isil.validate "IT-RM0267" in
  Alcotest.(check string) "test_validate" "IT-RM0267" result

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Isil.validate "IT-RM0267-12345678");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Isil.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Isil.validate "IT-RM0267!");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Isil.Invalid_format -> ()

let test_format () =
  let result = Stdnum.Isil.format "it-RM0267" in
  Alcotest.(check string) "test_format" "IT-RM0267" result

let test_is_valid () =
  let test_cases =
    [
      ("IT-RM0267", true); ("IT-RM0267-12345678", false); ("IT-RM0267!", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isil.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_format", `Quick, test_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Isil" [ ("suite", suite) ]
