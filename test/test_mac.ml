let test_compact () =
  let result = Stdnum.Mac.compact " D0-50-99-84-A2-A0 " in
  Alcotest.(check string) "test_compact" "d0:50:99:84:a2:a0" result

let test_validate () =
  let result = Stdnum.Mac.validate "D0-50-99-84-A2-A0" in
  Alcotest.(check string) "test_validate" "d0:50:99:84:a2:a0" result

let test_to_eui48 () =
  let result = Stdnum.Mac.to_eui48 "d0:50:99:84:a2:a0" in
  Alcotest.(check string) "test_to_eui48" "D0-50-99-84-A2-A0" result

let test_is_unicast () =
  Alcotest.(check bool) "test_is_unicast_true" true (Stdnum.Mac.is_unicast "d0:50:99:84:a2:a0");
  Alcotest.(check bool) "test_is_unicast_false" false (Stdnum.Mac.is_unicast "ff:ff:ff:ff:ff:ff")

let test_is_multicast () =
  Alcotest.(check bool) "test_is_multicast_false" false (Stdnum.Mac.is_multicast "d0:50:99:84:a2:a0");
  Alcotest.(check bool) "test_is_multicast_true" true (Stdnum.Mac.is_multicast "ff:ff:ff:ff:ff:ff")

let test_is_broadcast () =
  Alcotest.(check bool) "test_is_broadcast_false" false (Stdnum.Mac.is_broadcast "d0:50:99:84:a2:a0");
  Alcotest.(check bool) "test_is_broadcast_true" true (Stdnum.Mac.is_broadcast "ff:ff:ff:ff:ff:ff")

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_to_eui48", `Quick, test_to_eui48)
  ; ("test_is_unicast", `Quick, test_is_unicast)
  ; ("test_is_multicast", `Quick, test_is_multicast)
  ; ("test_is_broadcast", `Quick, test_is_broadcast)
  ]

let () = Alcotest.run "Stdnum.Mac" [ ("suite", suite) ]
