let test_compact () =
  let test_cases =
    [
      ("GR16 0110 1050 0000 1054 7023 795", "GR1601101050000010547023795")
    ; ("BE31435411161155", "BE31435411161155")
    ; ("gb29 NWBK 6016 1331 9268 19", "GB29NWBK60161331926819")
    ; ("es72 2013-0692-81-0201150993", "ES7220130692810201150993")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iban.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digits () =
  let test_cases = [ ("BExx435411161155", "31") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iban.calc_check_digits input in
      Alcotest.(check string) "test_calc_check_digits" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("GR1601101050000010547023795", "GR16 0110 1050 0000 1054 7023 795")
    ; ("BE31435411161155", "BE31 4354 1116 1155")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iban.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let test_validate_valid_numbers () =
  (* These should all be valid numbers from the IBAN REGISTRY as sample numbers *)
  let valid_numbers =
    [
      "AD12 0001 2030 2003 5910 0100"
    ; "AD1200012030200359100100"
    ; "AE070331234567890123456"
    ; "AL47 2121 1009 0000 0002 3569 8741"
    ; "AL47212110090000000235698741"
    ; "AT61 1904 3002 3457 3201"
    ; "AT611904300234573201"
    ; "AZ21NABZ00000000137010001944"
    ; "BA39 1290 0794 0102 8494"
    ; "BA391290079401028494"
    ; "BG80 BNBG 9661 1020 3456 78"
    ; "BG80BNBG96611020345678"
    ; "BH67BMAG00001299123456"
    ; "BR1800000000141455123924100C2"
    ; "BR9700360305000010009795493P1"
    ; "CH93 0076 2011 6238 5295 7"
    ; "CH9300762011623852957"
    ; "CY17 0020 0128 0000 0012 0052 7600"
    ; "CY17002001280000001200527600"
    ; "CZ65 0800 0000 1920 0014 5399"
    ; "CZ6508000000192000145399"
    ; "CZ94 5500 0000 0010 1103 8930"
    ; "CZ9455000000001011038930"
    ; "DE89 3704 0044 0532 0130 00"
    ; "DE89370400440532013000"
    ; "DK50 0040 0440 1162 43"
    ; "DK5000400440116243"
    ; "DO28BAGR00000001212453611324"
    ; "EE38 2200 2210 2014 5685"
    ; "EE382200221020145685"
    ; "FI21 1234 5600 0007 85"
    ; "FI2112345600000785"
    ; "FI5542345670000081"
    ; "FO62 6460 0001 6316 34"
    ; "FO6264600001631634"
    ; "FR14 2004 1010 0505 0001 3M02 606"
    ; "FR1420041010050500013M02606"
    ; "GB29 NWBK 6016 1331 9268 19"
    ; "GB29NWBK60161331926819"
    ; "GE29 NB00 0000 0101 9049 17"
    ; "GE29NB0000000101904917"
    ; "GI75 NWBK 0000 0000 7099 453"
    ; "GI75NWBK000000007099453"
    ; "GL89 6471 0001 0002 06"
    ; "GL8964710001000206"
    ; "GR16 0110 1250 0000 0001 2300 695"
    ; "GR1601101250000000012300695"
    ; "GT82TRAJ01020000001210029690"
    ; "HR12 1001 0051 8630 0016 0"
    ; "HR1210010051863000160"
    ; "HU42 1177 3016 1111 1018 0000 0000"
    ; "HU42117730161111101800000000"
    ; "IE29 AIBK 9311 5212 3456 78"
    ; "IE29AIBK93115212345678"
    ; "IL62 0108 0000 0009 9999 999"
    ; "IL620108000000099999999"
    ; "IS14 0159 2600 7654 5510 7303 39"
    ; "IS140159260076545510730339"
    ; "IT60 X054 2811 1010 0000 0123 456"
    ; "IT60X0542811101000000123456"
    ; "JO94CBJO0010000000000131000302"
    ; "KZ86125KZT5004100100"
    ; "LB62 0999 0000 0001 0019 0122 9114"
    ; "LB62099900000001001901229114"
    ; "LI21 0881 0000 2324 013A A"
    ; "LI21088100002324013AA"
    ; "LT12 1000 0111 0100 1000"
    ; "LT121000011101001000"
    ; "LU28 0019 4006 4475 0000"
    ; "LU280019400644750000"
    ; "LV80 BANK 0000 4351 9500 1"
    ; "LV80BANK0000435195001"
    ; "MC11 1273 9000 7000 1111 1000 h79"
    ; "MC1112739000700011111000h79"
    ; "MD24AG000225100013104168"
    ; "ME 25 5403 0000 2379 9201 09"
    ; "ME 2551 0000 0000 0623 4133"
    ; "ME 25510260797324001246"
    ; "ME 25525007010044076639"
    ; "ME 25535005130000020047"
    ; "ME 25540000007300246820"
    ; "ME 25550005080000004970"
    ; "ME25 5050 0001 2345 6789 51"
    ; "ME25505000012345678951"
    ; "MK072 5012 0000 0589 84"
    ; "MK07250120000058984"
    ; "MR13 0002 0001 0100 0012 3456 753"
    ; "MR1300020001010000123456753"
    ; "MT84 MALT 0110 0001 2345 MTLC AST0 01S"
    ; "MT84MALT011000012345MTLCAST001S"
    ; "MU17 BOMM 0101 1010 3030 0200 000M UR"
    ; "MU17 BOMM0101101030300200000MUR"
    ; "NL91 ABNA 0417 1643 00"
    ; "NL91ABNA0417164300"
    ; "NO 02 15037577003"
    ; "NO 05 15030383041"
    ; "NO 0560110516994"
    ; "NO 0571 3905 25162"
    ; "NO 0828014322061"
    ; "NO 1232600465693"
    ; "NO 19 4920 06 96270"
    ; "NO 21 650 405 251 19"
    ; "NO 2342009668904"
    ; "NO 26 7032 0516 038"
    ; "NO 3036245391786"
    ; "NO 31 6018 04 47124"
    ; "NO 33 4270 06 08551"
    ; "NO 35 9650 05 73667"
    ; "NO 39 4750 07 95936"
    ; "NO 39 6318 05 01489"
    ; "NO 39 7874 0597 506"
    ; "NO 40 1503 7355 353"
    ; "NO 402333 06 01019"
    ; "NO 43 651 204 471 94"
    ; "NO 44 1850.05.14562"
    ; "NO 4575600702548"
    ; "NO 5314300642641"
    ; "NO 57 78740655867"
    ; "NO 5997501101463"
    ; "NO 62 650 204 441 20"
    ; "NO 6865040505746"
    ; "NO 6940872430085"
    ; "NO 6947780786090"
    ; "NO 71 7694 05 00903"
    ; "NO 7615030839797"
    ; "NO 89 42004151326"
    ; "NO 91 16024246306"
    ; "NO05 7058 0555 568"
    ; "NO07.8380.08.06006"
    ; "NO1782000193468"
    ; "NO2476940517075"
    ; "NO38 8200 06 10190"
    ; "NO4697500641723"
    ; "NO5876940518888"
    ; "NO71.4202.47.14777"
    ; "NO77 7694 0511 077"
    ; "NO89 4760 5692 776"
    ; "NO8976940512510"
    ; "NO93 8601 1117 947"
    ; "NO9386011117947"
    ; "NO9832271000153"
    ; "PK36SCBL0000001123456702"
    ; "PL61 1090 1014 0000 0712 1981 2874"
    ; "PL61109010140000071219812874"
    ; "PS92PALS000000000400123456702"
    ; "PT50 0002 0123 1234 5678 9015 4"
    ; "PT50000201231234567890154"
    ; "QA58DOHB00001234567890ABCDEFG"
    ; "RO49 AAAA 1B31 0075 9384 0000"
    ; "RO49AAAA1B31007593840000"
    ; "RS35 2600 0560 1001 6113 79"
    ; "RS35260005601001611379"
    ; "SA03 8000 0000 6080 1016 7519"
    ; "SA0380000000608010167519"
    ; "SE45 5000 0000 0583 9825 7466"
    ; "SE4550000000058398257466"
    ; "SI56 1910 0000 0123 438"
    ; "SI56191000000123438"
    ; "SK31 1200 0000 1987 4263 7541"
    ; "SK3112000000198742637541"
    ; "SM86 U032 2509 8000 0000 0270 100"
    ; "SM86U0322509800000000270100"
    ; "TL 38 008 00123456789101 57"
    ; "TN59 1000 6035 1835 9847 8831"
    ; "TN5910006035183598478831"
    ; "TR33 0006 1005 1978 6457 8413 26"
    ; "TR330006100519786457841326"
    ; "VG96VPVG0000012345678901"
    ; "XK051212012345678906"
    ]
  in
  List.iter
    (fun number ->
      let result = Stdnum.Iban.is_valid ~check_country:false number in
      if not result then
        Alcotest.fail (Printf.sprintf "Expected %s to be valid" number))
    valid_numbers

let test_validate_invalid_checksum () =
  (* These all have broken checksums or are mangled *)
  let invalid_numbers =
    [
      "AL48212110090000000235698741"
    ; "AD1210012030200359100100"
    ; "AT611804300234573201"
    ; "BE68530907547034"
    ; "BA391290709401028494"
    ; "BG80BNBG99611020345678"
    ; "HR1210010052863000160"
    ; "CY17002001281000001200527600"
    ; "CZ6508000000129000145399"
    ; "CZ9455000000000101038930"
    ; "DK5000400440116342"
    ]
  in
  List.iter
    (fun number ->
      let result = Stdnum.Iban.is_valid ~check_country:false number in
      if result then
        Alcotest.fail
          (Printf.sprintf "Expected %s to be invalid (bad checksum)" number))
    invalid_numbers

let test_validate_invalid_length () =
  (* These are the wrong length but otherwise have valid checksums *)
  let invalid_numbers =
    [
      "AD48 0001 2030 2003 5910 01"
    ; "AT93 1904 3002 3457 3201 99"
    ; "BE36 5390 0754 7034 1234"
    ; "BA30 1290 0794 0102 84"
    ]
  in
  List.iter
    (fun number ->
      let result = Stdnum.Iban.is_valid ~check_country:false number in
      if result then
        Alcotest.fail
          (Printf.sprintf "Expected %s to be invalid (wrong length)" number))
    invalid_numbers

let test_validate_invalid_format () =
  (* These have alphabetic characters where they are not allowed, or unknown country codes *)
  let invalid_numbers =
    [
      "BG93 BNBG 9661 1A20 3456 78"
    ; "GI22 NW3K 0000 0000 7099 453"
    ; "NL56 3003 0A17 1643 00"
    ; "QQ93 1234 5678"
    ]
  in
  List.iter
    (fun number ->
      let result = Stdnum.Iban.is_valid ~check_country:false number in
      if result then
        Alcotest.fail
          (Printf.sprintf "Expected %s to be invalid (bad format)" number))
    invalid_numbers

let test_validate_corner_cases () =
  (* Corner case: empty BBAN, unknown country, but valid checksum structure *)
  (try
     ignore (Stdnum.Iban.validate "0001");
     Alcotest.fail "Expected Invalid_component or Invalid_length exception"
   with Stdnum.Iban.Invalid_component | Stdnum.Iban.Invalid_length -> ());

  (* Unknown country code *)
  try
    ignore (Stdnum.Iban.validate "XX431234");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Iban.Invalid_component -> ()

let test_spanish_iban_country_specific () =
  (* Test with country-specific validation disabled - should pass *)
  let result1 =
    Stdnum.Iban.is_valid ~check_country:false "ES2121000418450200051331"
  in
  Alcotest.(check bool) "ES number valid without country check" true result1;

  let result2 =
    Stdnum.Iban.is_valid ~check_country:false "ES89 3183 1500 9500 0121 0562"
  in
  Alcotest.(check bool) "ES number valid without country check" true result2;

  (* Test with country-specific validation enabled - should fail *)
  let result3 =
    Stdnum.Iban.is_valid ~check_country:true "ES2121000418450200051331"
  in
  Alcotest.(check bool) "ES number invalid with country check" false result3;

  let result4 =
    Stdnum.Iban.is_valid ~check_country:true "ES89 3183 1500 9500 0121 0562"
  in
  Alcotest.(check bool) "ES number invalid with country check" false result4

let test_is_valid () =
  let test_cases =
    [
      ("GR16 0110 1050 0000 1054 7023 795", true)
    ; ("BE31435411161155", true)
    ; ("AL48212110090000000235698741", false) (* bad checksum *)
    ; ("QQ93 1234 5678", false) (* unknown country *)
    ; ("GB29 NWBK 6016 1331 9268 19", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iban.is_valid ~check_country:false input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_valid_numbers", `Quick, test_validate_valid_numbers)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_corner_cases", `Quick, test_validate_corner_cases)
  ; ( "test_spanish_iban_country_specific"
    , `Quick
    , test_spanish_iban_country_specific )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Iban" [ ("suite", suite) ]
