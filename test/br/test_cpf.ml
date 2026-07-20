let test_compact () =
  let test_cases =
    [
      ("390.533.447-05", "39053344705")
    ; ("390 533 447 05", "39053344705")
    ; (" 231.002.999-81 ", "23100299981")
    ; ("23100299981", "23100299981")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Br.Cpf.compact input in
      Alcotest.(check string) ("compact: " ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('390.533.447-05') returns '39053344705' *)
  let result = Br.Cpf.validate "390.533.447-05" in
  Alcotest.(check string) "validate valid CPF" "39053344705" result

let test_validate_valid_unformatted () =
  let result = Br.Cpf.validate "23100299981" in
  Alcotest.(check string) "validate valid unformatted CPF" "23100299981" result

let test_validate_invalid_checksum () =
  (* Test with number that has wrong check digits (00 instead of 81) *)
  Alcotest.check_raises "Invalid Checksum" Br.Cpf.Invalid_checksum (fun () ->
      ignore (Br.Cpf.validate "231.002.999-00"))

let test_validate_invalid_format () =
  (* From Python doctest: validate('390.533.447=0') raises InvalidFormat *)
  Alcotest.check_raises "Invalid Format (bad delimiter)" Br.Cpf.Invalid_format
    (fun () -> ignore (Br.Cpf.validate "390.533.447=0"))

let test_validate_invalid_format_letters () =
  Alcotest.check_raises "Invalid Format (contains letters)"
    Br.Cpf.Invalid_format (fun () -> ignore (Br.Cpf.validate "390ABC44705"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length (too short)" Br.Cpf.Invalid_length
    (fun () -> ignore (Br.Cpf.validate "390533447"))

let test_validate_invalid_length_long () =
  Alcotest.check_raises "Invalid Length (too long)" Br.Cpf.Invalid_length
    (fun () -> ignore (Br.Cpf.validate "390533447055"))

let test_format () =
  (* Format a valid CPF number *)
  let result = Br.Cpf.format "23100299981" in
  Alcotest.(check string) "format CPF" "231.002.999-81" result

let test_format_already_formatted () =
  let result = Br.Cpf.format "390.533.447-05" in
  Alcotest.(check string) "format already formatted CPF" "390.533.447-05" result

let test_is_valid_true () =
  let result = Br.Cpf.is_valid "390.533.447-05" in
  Alcotest.(check bool) "is_valid returns true for valid CPF" true result

let test_is_valid_false () =
  let result = Br.Cpf.is_valid "231.002.999-00" in
  Alcotest.(check bool) "is_valid returns false for invalid checksum" false result

let test_is_valid_true_alternative () =
  let result = Br.Cpf.is_valid "231.002.999-81" in
  Alcotest.(check bool) "is_valid returns true for another valid CPF" true result

let test_is_valid_false_format () =
  let result = Br.Cpf.is_valid "390.533.447=0" in
  Alcotest.(check bool) "is_valid returns false for invalid format" false result

let () =
  let open Alcotest in
  run "Br.Cpf"
    [
      ( "compact",
        [
          test_case "Compact various formats" `Quick test_compact
        ] )
    ; ( "validate",
        [
          test_case "Validate valid CPF" `Quick test_validate_valid
        ; test_case "Validate valid unformatted CPF" `Quick
            test_validate_valid_unformatted
        ; test_case "Validate invalid checksum" `Quick
            test_validate_invalid_checksum
        ; test_case "Validate invalid format" `Quick test_validate_invalid_format
        ; test_case "Validate invalid format (letters)" `Quick
            test_validate_invalid_format_letters
        ; test_case "Validate invalid length (short)" `Quick
            test_validate_invalid_length
        ; test_case "Validate invalid length (long)" `Quick
            test_validate_invalid_length_long
        ] )
    ; ( "format",
        [
          test_case "Format CPF" `Quick test_format
        ; test_case "Format already formatted CPF" `Quick
            test_format_already_formatted
        ] )
    ; ( "is_valid",
        [
          test_case "is_valid returns true for valid CPF" `Quick
            test_is_valid_true
        ; test_case "is_valid returns true for another valid CPF" `Quick
            test_is_valid_true_alternative
        ; test_case "is_valid returns false for invalid checksum" `Quick
            test_is_valid_false
        ; test_case "is_valid returns false for invalid format" `Quick
            test_is_valid_false_format
        ] )
    ]
