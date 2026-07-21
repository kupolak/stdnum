(** OSS (European VAT on e-Commerce - One Stop Shop).

    This covers number that have been issued under the non-union scheme and the
    import scheme of the European VAT on e-Commerce one stop shop. Numbers under
    the non-union scheme are assigned to foreign companies providing digital
    services to European Union consumers. Numbers under the import scheme are
    assigned for importing goods from a third country (through an intermediary).

    This is also called MOSS (mini One Stop Shop) and VoeS (VAT on e-Services).
    The number under the import scheme is also called IOSS (Import One Stop
    Shop) number.

    Numbers under the non-union scheme are in the format EUxxxyyyyyz. For the
    import scheme the format is IMxxxyyyyyyz. An intermediary will also get an
    number in the format INxxxyyyyyyz but that may not be used as VAT
    identification number.

    More information:
    - https://vat-one-stop-shop.ec.europa.eu/one-stop-shop/register-oss_en *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let iso_3166_1_member_states =
  [
    "040"
  ; "056"
  ; "100"
  ; "191"
  ; "196"
  ; "203"
  ; "208"
  ; "233"
  ; "246"
  ; "250"
  ; "276"
  ; "300"
  ; "348"
  ; "372"
  ; "380"
  ; "428"
  ; "440"
  ; "442"
  ; "470"
  ; "528"
  ; "616"
  ; "620"
  ; "642"
  ; "703"
  ; "705"
  ; "724"
  ; "752"
  ; "900"
  ]

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if String.starts_with ~prefix:"EU" number then begin
    if len <> 11 then raise Invalid_length
  end
  else if String.starts_with ~prefix:"IM" number then begin
    if len <> 12 then raise Invalid_length
  end
  else raise Invalid_component;

  if not (Utils.is_digits (String.sub number 2 (len - 2))) then
    raise Invalid_format;

  if not (List.mem (String.sub number 2 3) iso_3166_1_member_states) then
    raise Invalid_component;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
