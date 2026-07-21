exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number = Nn.compact number

let validate number =
  (* Try BIS validation first, fall back to NN on Invalid_component *)
  try Bis.validate number with
  | Bis.Invalid_component _ -> (
      (* Only try NN validation in case of an invalid component,
         other validation errors are shared between BIS and NN *)
      try Nn.validate number with
      | Nn.Invalid_length -> raise Invalid_length
      | Nn.Invalid_format -> raise Invalid_format
      | Nn.Invalid_checksum -> raise Invalid_checksum
      | Nn.Invalid_component _ -> raise Invalid_component)
  | Bis.Invalid_length -> raise Invalid_length
  | Bis.Invalid_format -> raise Invalid_format
  | Bis.Invalid_checksum -> raise Invalid_checksum

let validate_result number =
  try Ok (validate number) with
  | Invalid_length -> Error Tools.Error.Invalid_length
  | Invalid_format -> Error Tools.Error.Invalid_format
  | Invalid_checksum -> Error Tools.Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number = Result.is_ok (validate_result number)

let guess_type number =
  if Bis.is_valid number then Some "bis"
  else if Nn.is_valid number then Some "nn"
  else None

let format number = Nn.format number

let get_birth_date number =
  match Nn.get_birth_date number with
  | Some (year, month, day) ->
      Some (Printf.sprintf "%04d-%02d-%02d" year month day)
  | None -> None

let get_birth_year number =
  match Nn.get_birth_date number with
  | Some (year, _, _) -> Some year
  | None -> None

let get_birth_month number =
  match Nn.get_birth_date number with
  | Some (_, month, _) -> Some month
  | None -> None

let get_gender number =
  (* Validate and determine type first *)
  let number = compact number in
  if Bis.is_valid number then Bis.get_gender number
  else if Nn.is_valid number then Some (Nn.get_gender number)
  else None
