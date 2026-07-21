let test_compact () =
  let result = Lv.Pvn.compact " LV 4000 3521 600 " in
  Alcotest.(check string) "test_compact" "40003521600" result

let test_validate () =
  let result1 = Lv.Pvn.validate "LV 4000 3521 600" in
  Alcotest.(check string) "test_validate_org" "40003521600" result1;
  let result2 = Lv.Pvn.validate "161175-19997" in
  Alcotest.(check string) "test_validate_pers_old" "16117519997" result2;
  let result3 = Lv.Pvn.validate "328673-00679" in
  Alcotest.(check string) "test_validate_pers_new" "32867300679" result3

let test_validate_invalid_checksum () =
  try
    ignore (Lv.Pvn.validate "40003521601");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Lv.Pvn.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Lv.Pvn.validate "161375-19997");
    Alcotest.fail "Expected Invalid_component exception"
  with Lv.Pvn.Invalid_component -> ()

let test_validate_invalid_checksum_pers_new () =
  try
    ignore (Lv.Pvn.validate "328673-00677");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Lv.Pvn.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("LV 4000 3521 600", true)
    ; ("161175-19997", true)
    ; ("328673-00679", true)
    ; ("40003521601", false)
    ; ("161375-19997", false)
    ; ("328673-00677", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Lv.Pvn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ( "test_validate_invalid_checksum_pers_new"
    , `Quick
    , test_validate_invalid_checksum_pers_new )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Lv.Pvn" [ ("suite", suite) ]
