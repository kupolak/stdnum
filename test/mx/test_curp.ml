let test_compact () =
  let result = Mx.Curp.compact " BOXW-310820-HNERXN09 " in
  Alcotest.(check string) "test_compact" "BOXW310820HNERXN09" result

let test_validate () =
  let result = Mx.Curp.validate "BOXW310820HNERXN09" in
  Alcotest.(check string) "test_validate" "BOXW310820HNERXN09" result

let test_validate_invalid_checksum () =
  try
    ignore (Mx.Curp.validate "BOXW310820HNERXN08");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Mx.Curp.Invalid_checksum -> ()

let test_get_birth_date () =
  let y, m, d = Mx.Curp.get_birth_date "BOXW310820HNERXN09" in
  Alcotest.(check int) "test_get_birth_date_year" 1931 y;
  Alcotest.(check int) "test_get_birth_date_month" 8 m;
  Alcotest.(check int) "test_get_birth_date_day" 20 d

let test_get_gender () =
  let gender = Mx.Curp.get_gender "BOXW310820HNERXN09" in
  Alcotest.(check string) "test_get_gender" "M" gender

let test_is_valid () =
  let test_cases =
    [ ("BOXW310820HNERXN09", true); ("BOXW310820HNERXN08", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Mx.Curp.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Mx.Curp" [ ("suite", suite) ]
