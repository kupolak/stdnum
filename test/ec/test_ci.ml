let test_compact () =
  let result = Ec.Ci.compact " 171430710-3 " in
  Alcotest.(check string) "test_compact" "1714307103" result

let test_validate () =
  let result = Ec.Ci.validate "171430710-3" in
  Alcotest.(check string) "test_validate" "1714307103" result

let test_validate_invalid_checksum () =
  try
    ignore (Ec.Ci.validate "1714307104");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ec.Ci.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Ec.Ci.validate "171430710");
    Alcotest.fail "Expected Invalid_length exception"
  with Ec.Ci.Invalid_length -> ()

let test_validate_invalid_component_prov () =
  try
    ignore (Ec.Ci.validate "2514307101");
    Alcotest.fail "Expected Invalid_component exception"
  with Ec.Ci.Invalid_component -> ()

let test_validate_invalid_component_third () =
  try
    ignore (Ec.Ci.validate "1774307101");
    Alcotest.fail "Expected Invalid_component exception"
  with Ec.Ci.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [ ("171430710-3", true); ("1714307104", false); ("171430710", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ec.Ci.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_component_prov"
    , `Quick
    , test_validate_invalid_component_prov )
  ; ( "test_validate_invalid_component_third"
    , `Quick
    , test_validate_invalid_component_third )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ec.Ci" [ ("suite", suite) ]
