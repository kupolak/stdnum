(** VATIN (International value added tax identification number).

    The number VAT identification number (VATIN) is an identifier used in many
    countries. It starts with an ISO 3166-1 alpha-2 (2 letters) country code
    (except for Greece, which uses EL, instead of GR) and is followed by the
    country-specific identifier.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  Tools.Utils.clean number " -./," |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if String.length number < 4 then raise Invalid_length;
  let cc = String.lowercase_ascii (String.sub number 0 2) in
  let cc = match cc with "el" -> "gr" | "xi" -> "gb" | _ -> cc in
  let rest = String.sub number 2 (String.length number - 2) in
  let cc_upper = String.uppercase_ascii cc in
  match cc with
  | "ad" -> cc_upper ^ Ad.Nrt.validate rest
  | "al" -> cc_upper ^ Al.Nipt.validate rest
  | "ar" -> cc_upper ^ Ar.Cuit.validate rest
  | "at" -> cc_upper ^ At.Uid.validate rest
  | "au" -> cc_upper ^ Au.Abn.validate rest
  | "az" -> cc_upper ^ Az.Voen.validate rest
  | "be" -> cc_upper ^ Be.Vat.validate rest
  | "bg" -> cc_upper ^ Bg.Vat.validate rest
  | "br" -> cc_upper ^ Br.Cnpj.validate rest
  | "by" -> cc_upper ^ By.Unp.validate rest
  | "ca" -> cc_upper ^ Ca.Bn.validate rest
  | "ch" -> cc_upper ^ Ch.Vat.validate rest
  | "cl" -> cc_upper ^ Cl.Rut.validate rest
  | "cn" -> cc_upper ^ Cn.Uscc.validate rest
  | "co" -> cc_upper ^ Co.Nit.validate rest
  | "cr" -> cc_upper ^ Cr.Cpj.validate rest
  | "cy" -> cc_upper ^ Cy.Vat.validate rest
  | "cz" -> cc_upper ^ Cz.Dic.validate rest
  | "de" -> cc_upper ^ De.Vat.validate rest
  | "dk" -> cc_upper ^ Dk.Cvr.validate rest
  | "do" -> cc_upper ^ Do.Rnc.validate rest
  | "dz" -> cc_upper ^ Dz.Nif.validate rest
  | "ec" -> cc_upper ^ Ec.Ruc.validate rest
  | "ee" -> cc_upper ^ Ee.Kmkr.validate rest
  | "eg" -> cc_upper ^ Eg.Tn.validate rest
  | "es" -> cc_upper ^ Es.Nif.validate rest
  | "eu" -> cc_upper ^ Eu.Vat.validate rest
  | "fi" -> cc_upper ^ Fi.Alv.validate rest
  | "fo" -> cc_upper ^ Fo.Vn.validate rest
  | "fr" -> cc_upper ^ Fr.Tva.validate rest
  | "gb" -> cc_upper ^ Gb.Vat.validate rest
  | "gh" -> cc_upper ^ Gh.Tin.validate rest
  | "gn" -> cc_upper ^ Gn.Nifp.validate rest
  | "gr" -> cc_upper ^ Gr.Vat.validate rest
  | "gt" -> cc_upper ^ Gt.Nit.validate rest
  | "hr" -> cc_upper ^ Hr.Oib.validate rest
  | "hu" -> cc_upper ^ Hu.Anum.validate rest
  | "id" -> cc_upper ^ Id.Npwp.validate rest
  | "ie" -> cc_upper ^ Ie.Vat.validate rest
  | "il" -> cc_upper ^ Il.Hp.validate rest
  | "in" -> cc_upper ^ In_.Gstin.validate rest
  | "is" -> cc_upper ^ Is_.Vsk.validate rest
  | "it" -> cc_upper ^ It.Iva.validate rest
  | "jp" -> cc_upper ^ Jp.Cn.validate rest
  | "ke" -> cc_upper ^ Ke.Pin.validate rest
  | "kr" -> cc_upper ^ Kr.Brn.validate rest
  | "lt" -> cc_upper ^ Lt.Pvm.validate rest
  | "lu" -> cc_upper ^ Lu.Tva.validate rest
  | "lv" -> cc_upper ^ Lv.Pvn.validate rest
  | "ma" -> cc_upper ^ Ma.Ice.validate rest
  | "mc" -> cc_upper ^ Mc.Tva.validate rest
  | "me" -> cc_upper ^ Me.Pib.validate rest
  | "mk" -> cc_upper ^ Mk.Edb.validate rest
  | "mt" -> cc_upper ^ Mt.Vat.validate rest
  | "mx" -> cc_upper ^ Mx.Rfc.validate rest
  | "mz" -> cc_upper ^ Mz.Nuit.validate rest
  | "nl" -> cc_upper ^ Nl.Btw.validate rest
  | "no" -> cc_upper ^ No.Mva.validate rest
  | "nz" -> cc_upper ^ Nz.Ird.validate rest
  | "pe" -> cc_upper ^ Pe.Ruc.validate rest
  | "pl" -> cc_upper ^ Pl.Nip.validate rest
  | "pt" -> cc_upper ^ Pt.Nif.validate rest
  | "py" -> cc_upper ^ Py.Ruc.validate rest
  | "ro" -> cc_upper ^ Ro.Cf.validate rest
  | "rs" -> cc_upper ^ Rs.Pib.validate rest
  | "ru" -> cc_upper ^ Ru.Inn.validate rest
  | "se" -> cc_upper ^ Se.Vat.validate rest
  | "sg" -> cc_upper ^ Sg.Uen.validate rest
  | "si" -> cc_upper ^ Si.Ddv.validate rest
  | "sk" -> cc_upper ^ Sk.Dph.validate rest
  | "sm" -> cc_upper ^ Sm.Coe.validate rest
  | "sn" -> cc_upper ^ Sn.Ninea.validate rest
  | "sv" -> cc_upper ^ Sv.Nit.validate rest
  | "th" -> cc_upper ^ Th.Moa.validate rest
  | "tn" -> cc_upper ^ Tn.Mf.validate rest
  | "tr" -> cc_upper ^ Tr.Vkn.validate rest
  | "tw" -> cc_upper ^ Tw.Ubn.validate rest
  | "uy" -> cc_upper ^ Uy.Rut.validate rest
  | "ve" -> cc_upper ^ Ve.Rif.validate rest
  | "vn" -> cc_upper ^ Vn.Mst.validate rest
  | "za" -> cc_upper ^ Za.Tin.validate rest
  | _ -> raise Invalid_component

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Tools.Error.Invalid_format
  | Invalid_length -> Error Tools.Error.Invalid_length
  | Invalid_checksum -> Error Tools.Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with _ -> false
