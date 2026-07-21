let test_compact () =
  let result = Sk.Rc.compact " 710319/2745 " in
  Alcotest.(check string) "test_compact" "7103192745" result

let test_validate () =
  let result = Sk.Rc.validate "710319/2745" in
  Alcotest.(check string) "test_validate" "7103192745" result

let test_validate_short () =
  let result = Sk.Rc.validate "991231123" in
  Alcotest.(check string) "test_validate_short" "991231123" result

let test_format () =
  let result = Sk.Rc.format "7103192745" in
  Alcotest.(check string) "test_format" "710319/2745" result

let test_validate_invalid_checksum () =
  try
    ignore (Sk.Rc.validate "7103192746");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Sk.Rc.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Sk.Rc.validate "1103492745");
    Alcotest.fail "Expected Invalid_component exception"
  with Sk.Rc.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Sk.Rc.validate "590312/123");
    Alcotest.fail "Expected Invalid_length exception"
  with Sk.Rc.Invalid_length -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_short", `Quick, test_validate_short)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ]

let () = Alcotest.run "Stdnum.Sk.Rc" [ ("suite", suite) ]
