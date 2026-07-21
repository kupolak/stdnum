let test_compact () =
  let result = Gr.Amka.compact " 01013099997 " in
  Alcotest.(check string) "test_compact" "01013099997" result

let test_get_birth_date () =
  let year, month, day = Gr.Amka.get_birth_date "01013099997" in
  Alcotest.(check int) "year" 1930 year;
  Alcotest.(check int) "month" 1 month;
  Alcotest.(check int) "day" 1 day

let test_get_gender () =
  let result = Gr.Amka.get_gender "01013099997" in
  Alcotest.(check string) "test_get_gender" "M" result

let test_validate () =
  let result = Gr.Amka.validate "01013099997" in
  Alcotest.(check string) "test_validate" "01013099997" result

let test_validate_invalid_checksum () =
  try
    ignore (Gr.Amka.validate "01013099999");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gr.Amka.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases = [ ("01013099997", true); ("01013099999", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Gr.Amka.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Gr.Amka" [ ("suite", suite) ]
