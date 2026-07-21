let test_validate () =
  let result = Stdnum.Vatin.validate "FR 40 303 265 045" in
  Alcotest.(check string) "test_validate" "FR40303265045" result

let test_validate_de () =
  let result = Stdnum.Vatin.validate "DE136,695 976" in
  Alcotest.(check string) "test_validate_de" "DE136695976" result

let test_validate_br () =
  let result = Stdnum.Vatin.validate "BR16.727.230/0001-97" in
  Alcotest.(check string) "test_validate_br" "BR16727230000197" result

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Vatin.validate "FR 40 303");
    Alcotest.fail "Expected Invalid_length or Invalid_format exception"
  with _ -> ()

let test_validate_invalid_component () =
  try
    ignore (Stdnum.Vatin.validate "XX12345");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Vatin.Invalid_component -> ()

let suite =
  [
    ("test_validate", `Quick, test_validate)
  ; ("test_validate_de", `Quick, test_validate_de)
  ; ("test_validate_br", `Quick, test_validate_br)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ]

let () = Alcotest.run "Stdnum.Vatin" [ ("suite", suite) ]
