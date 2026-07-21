let test_compact () =
  let result = Ru.Ogrn.compact " 102 220 0525 819 " in
  Alcotest.(check string) "test_compact" "1022200525819" result

let test_validate_13 () =
  let result = Ru.Ogrn.validate "1022200525819" in
  Alcotest.(check string) "test_validate_13" "1022200525819" result

let test_validate_15 () =
  let result = Ru.Ogrn.validate "385768585948949" in
  Alcotest.(check string) "test_validate_15" "385768585948949" result

let test_validate_invalid_checksum () =
  try
    ignore (Ru.Ogrn.validate "1022500001328");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ru.Ogrn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Ru.Ogrn.validate "10277395526422");
    Alcotest.fail "Expected Invalid_length exception"
  with Ru.Ogrn.Invalid_length -> ()

let test_validate_invalid_component_0 () =
  try
    ignore (Ru.Ogrn.validate "0022500001325");
    Alcotest.fail "Expected Invalid_component exception"
  with Ru.Ogrn.Invalid_component -> ()

let test_validate_invalid_component_15 () =
  try
    ignore (Ru.Ogrn.validate "985768585948944");
    Alcotest.fail "Expected Invalid_component exception"
  with Ru.Ogrn.Invalid_component -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_13", `Quick, test_validate_13)
  ; ("test_validate_15", `Quick, test_validate_15)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_component_0"
    , `Quick
    , test_validate_invalid_component_0 )
  ; ( "test_validate_invalid_component_15"
    , `Quick
    , test_validate_invalid_component_15 )
  ]

let () = Alcotest.run "Stdnum.Ru.Ogrn" [ ("suite", suite) ]
