let test_compact () =
  let result = Id.Npwp.compact " 01.312.166.0-091.000 " in
  Alcotest.(check string) "test_compact" "013121660091000" result

let test_validate () =
  let result1 = Id.Npwp.validate "01.312.166.0-091.000" in
  Alcotest.(check string) "test_validate_1" "013121660091000" result1;
  let result2 = Id.Npwp.validate "016090524017000" in
  Alcotest.(check string) "test_validate_2" "016090524017000" result2

let test_validate_invalid_length () =
  try
    ignore (Id.Npwp.validate "123456789");
    Alcotest.fail "Expected Invalid_length exception"
  with Id.Npwp.Invalid_length -> ()

let test_format () =
  let result = Id.Npwp.format "013000666091000" in
  Alcotest.(check string) "test_format" "01.300.066.6-091.000" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Id.Npwp" [ ("suite", suite) ]
