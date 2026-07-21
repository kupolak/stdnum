let test_compact () =
  let result = Py.Ruc.compact " 80028061-0 " in
  Alcotest.(check string) "test_compact" "800280610" result

let test_validate () =
  let result = Py.Ruc.validate "80028061-0" in
  Alcotest.(check string) "test_validate" "800280610" result

let test_validate_short () =
  let result = Py.Ruc.validate "9991603" in
  Alcotest.(check string) "test_validate_short" "9991603" result

let test_validate_shorter () =
  let result = Py.Ruc.validate "2660-3" in
  Alcotest.(check string) "test_validate_shorter" "26603" result

let test_validate_invalid_checksum () =
  try
    ignore (Py.Ruc.validate "800532492");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Py.Ruc.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Py.Ruc.validate "80123456789");
    Alcotest.fail "Expected Invalid_length exception"
  with Py.Ruc.Invalid_length -> ()

let test_format () =
  let result = Py.Ruc.format "800000358" in
  Alcotest.(check string) "test_format" "80000035-8" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_short", `Quick, test_validate_short)
  ; ("test_validate_shorter", `Quick, test_validate_shorter)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Py.Ruc" [ ("suite", suite) ]
