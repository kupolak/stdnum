let test_compact () =
  let test_cases =
    [
      ("RF18 5390 0754 7034", "RF18539007547034")
    ; ("RF18 5390 0754 70Y", "RF185390075470Y")
    ; ("RF18539007547034", "RF18539007547034")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso11649.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("RF18 5390 0754 7034", "RF18539007547034")
    ; ("RF18 5390 0754 70Y", "RF185390075470Y")
    ; ("RF03SW3EZRUFBK", "RF03SW3EZRUFBK")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso11649.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Iso11649.validate "RF17 5390 0754 7034");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Iso11649.Invalid_checksum -> ()

let test_validate_invalid_length_too_short () =
  try
    ignore (Stdnum.Iso11649.validate "RF18");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Iso11649.Invalid_length -> ()

let test_validate_invalid_length_too_long () =
  try
    ignore (Stdnum.Iso11649.validate "RF181234567890123456789012");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Iso11649.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Iso11649.validate "XX18539007547034");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Iso11649.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("RF18 5390 0754 7034", true)
    ; ("RF18 5390 0754 70Y", true)
    ; ("RF17 5390 0754 7034", false) (* bad checksum *)
    ; ("RF18", false) (* too short *)
    ; ("XX18539007547034", false) (* invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso11649.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("RF18539007547034", "RF18 5390 0754 7034"); ("RF529", "RF52 9") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso11649.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let test_validate_generated_numbers () =
  (* Numbers randomly generated from online tool - all should be valid *)
  let valid_numbers =
    [
      "RF03SW3EZRUFBK"
    ; "RF20QQHM7PAW61EOWO"
    ; "RF206KCJWVH20"
    ; "RF97XX5ZIC"
    ; "RF66A4E7BF6OI8F23P9"
    ; "RF888F7P5VQ8TOFTY3LZ"
    ; "RF41778UFIFX6LGFHAX"
    ; "RF8676YM2Q3UWC9"
    ; "RF056TXFK"
    ; "RF800PAG6O89TAU8M5H"
    ; "RF20AN1IJBLFGA"
    ; "RF23EF4UHBVNPLHKG3HZ9SGGT"
    ; "RF79KDFLO48OJW9TSCUP7L"
    ; "RF72YW"
    ; "RF14GE30YOI8"
    ; "RF95SVO25ZY0J"
    ; "RF38W1PAA2QLIPIQVMAYLOH"
    ; "RF80A0CPH"
    ; "RF15O27ZC6D86DZGO"
    ; "RF30VXZSLA8"
    ; "RF87PBDPC22JTUPL98AYLOCK"
    ; "RF14QS8OSM0SGZJHDAJI2S1"
    ; "RF724P"
    ; "RF0717UP2X0DO9UF6JGIPG8"
    ; "RF42J8H8Y0VB5MXP1T24RHM3"
    ; "RF70JNR"
    ; "RF949BJ0SHL5OELQ0M16"
    ; "RF75TR2ACY3PGL"
    ; "RF0891RPECRY4EKAIWQK4UZUP"
    ; "RF95079AYKHK4C6D8SF"
    ; "RF63RPP1PYBH4K"
    ; "RF28JGS"
    ; "RF80I4"
    ; "RF55IJ37T88JU5D0XUR6Z3N"
    ; "RF08P"
    ; "RF315S3SM4CXHLHPCCJULF36"
    ; "RF25GKZ943I"
    ; "RF10XHXROQ2ZS1"
    ; "RF032KW3MG"
    ; "RF03Z55N"
    ; "RF93SYT6JCX9BF8STKZTF"
    ; "RF910KN"
    ; "RF4480GWBS4ON16IRYL7T5VN2"
    ; "RF02YFL1INOWMIYT2AN"
    ; "RF23PCSFK51V1XJALP"
    ; "RF37K91OEQE0FMBZSBN"
    ; "RF96QP1V07AYT"
    ; "RF2939KX5US7LX3PAN1BNWC0H"
    ; "RF02RLPTC78WPBRBZFWSU"
    ; "RF85QEZRRD82"
    ; "RF529"
    ; "RF813OATFTW"
    ; "RF02MT56MM6RK3NSA88RKVK"
    ; "RF81WGYFUZZ0TWXHQK"
    ; "RF21FYKWJSLDSEV5P8XGPE2"
    ; "RF75B2UCA8B3KLEP4PNTJA"
    ; "RF401ETPTNN0E83ASNVVNPWU"
    ; "RF11JB"
    ; "RF48T7F6BF5F4H9F9JG"
    ; "RF68C"
    ; "RF53AVDW8QM7M6A62"
    ; "RF382LJGQV501HHZQ6ZS1"
    ; "RF097"
    ; "RF73XJXLAL"
    ; "RF95B"
    ; "RF57G"
    ; "RF25282M4CZ5GHSGY3G85G"
    ; "RF498F8Q7S17"
    ; "RF701XP4QUW0YV62EI5DQ"
    ; "RF16V1A2WFZ6U8RMNVLE"
    ; "RF78DB1FAB"
    ; "RF7522DRITKFXLL97L45F"
    ; "RF11A8Z"
    ; "RF04X2OY4TYLNF"
    ; "RF607WBLIGJT8FLEPYJ"
    ; "RF07YDRKBYAAJTZ9IEMA"
    ; "RF186L"
    ; "RF409UF6078QP"
    ; "RF82K6F"
    ; "RF28AGC"
    ; "RF1492GE4TE5I7"
    ; "RF12EMD86TLG46QZT9Z0WA3I"
    ; "RF056PZYKELS9JY35QWH11"
    ; "RF288UQN77O6QWX5565"
    ; "RF12Z7WS5GR9S4"
    ; "RF17B6V83RKUJCKYSIV"
    ; "RF489L8GK4"
    ; "RF41FWLX"
    ; "RF98FIKGWHA2AK04NMI"
    ; "RF86V26RQ3Z"
    ; "RF72813"
    ; "RF59OG39OS05B0RBMT"
    ; "RF67B3TIEBWV82"
    ; "RF73UYAE6PKWKA7MMR62S0B"
    ; "RF92DIALM"
    ; "RF04J4"
    ; "RF60OG76HU1XGBIHRU94K"
    ; "RF22EM"
    ; "RF67J7L"
    ]
  in
  List.iter
    (fun number ->
      let result = Stdnum.Iso11649.is_valid number in
      if not result then
        Alcotest.fail (Printf.sprintf "Expected %s to be valid" number))
    valid_numbers

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_length_too_short"
    , `Quick
    , test_validate_invalid_length_too_short )
  ; ( "test_validate_invalid_length_too_long"
    , `Quick
    , test_validate_invalid_length_too_long )
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_generated_numbers", `Quick, test_validate_generated_numbers)
  ]

let () = Alcotest.run "Stdnum.Iso11649" [ ("suite", suite) ]
