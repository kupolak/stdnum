(** BRN (사업자 등록 번호, South Korea Business Registration Number).

    The Business Registration Number is issued by the district tax office in the
    local jurisdiction for tax purposes. The number consists of 10 digits and
    contain the tax office number (3 digits), the type of business (2 digits), a
    serially assigned value (4 digits) and a single check digit.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Korea-TIN.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "[ -]" |> String.trim

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if
    String.sub number 0 3 < "101"
    || String.sub number 3 2 = "00"
    || String.sub number 5 4 = "0000"
  then raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ "-" ^ String.sub number 3 2 ^ "-"
  ^ String.sub number 5 5
