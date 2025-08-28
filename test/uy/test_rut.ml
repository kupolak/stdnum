let test_validate_examples () =
  let v1 = Uy.Rut.validate "21-100342-001-7" in
  Alcotest.(check string) "compact 1" "211003420017" v1;
  let v2 = Uy.Rut.validate "UY 21 140634 001 1" in
  Alcotest.(check string) "compact 2" "211406340011" v2

let test_invalid_checksum () =
  Alcotest.check_raises "InvalidChecksum" Uy.Rut.Invalid_checksum (fun () ->
      ignore (Uy.Rut.validate "210303670014"))

let test_invalid_length () =
  Alcotest.check_raises "InvalidLength" Uy.Rut.Invalid_length (fun () ->
      ignore (Uy.Rut.validate "12345678"))

let test_format () =
  let f = Uy.Rut.format "211003420017" in
  Alcotest.(check string) "format" "21-100342-001-7" f

let suite =
  [
    ("test_validate_examples", `Quick, test_validate_examples)
  ; ("test_invalid_checksum", `Quick, test_invalid_checksum)
  ; ("test_invalid_length", `Quick, test_invalid_length)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Uy.Rut" [ ("suite", suite) ]
