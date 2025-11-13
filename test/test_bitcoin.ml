let test_compact () =
  let test_cases =
    [
      ( "BC1QARDV855YJNGSPVXUTTQ897AQCA3LXJU2Y69JCE"
      , "bc1qardv855yjngspvxuttq897aqca3lxju2y69jce" )
    ; ( "1NEDqZPvTWRaoho48qXuLLsrYomMXPABfD"
      , "1NEDqZPvTWRaoho48qXuLLsrYomMXPABfD" )
    ; ("bc1 qar dv85", "bc1qardv85")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bitcoin.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_bech32 () =
  (* Test Bech32 addresses - checksum validation works *)
  let test_cases =
    [ "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4" (* valid *) ]
  in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Bitcoin.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format *)
  try
    ignore (Stdnum.Bitcoin.validate "invalid_address");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Bitcoin.Invalid_component -> ()

let test_validate_invalid_length_bech32 () =
  (* Bech32 too short *)
  try
    ignore (Stdnum.Bitcoin.validate "bc1q");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Bitcoin.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      (* Bech32 addresses *)
      ("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4", true)
    ; ("bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3", true)
      (* Base58 addresses - format/length check only (no SHA256 checksum) *)
    ; ("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa", true) (* Genesis block address *)
    ; ("3J98t1WpEZ73CNmYviecrnyiWrnqRhWNLy", true)
      (* P2SH address *)
      (* Invalid *)
    ; ("invalid", false)
    ; ("bc1q", false) (* Too short *)
    ; ("1234567890", false) (* Invalid Base58 *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bitcoin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_bech32", `Quick, test_validate_bech32)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ( "test_validate_invalid_length_bech32"
    , `Quick
    , test_validate_invalid_length_bech32 )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Bitcoin" [ ("suite", suite) ]
