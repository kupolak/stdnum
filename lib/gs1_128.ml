(** GS1-128 (Standard to encode product information in Code 128 barcodes). *)

exception Invalid_component
exception Invalid_format
exception Invalid_length
exception Invalid_checksum

type info = { format : string; typ : string; fnc1 : bool; max_length : int }

let get_ai_info ai =
  match ai with
  | "00" -> Some { format = "N18"; typ = "str"; fnc1 = false; max_length = 18 }
  | "01" -> Some { format = "N14"; typ = "str"; fnc1 = false; max_length = 14 }
  | "02" -> Some { format = "N14"; typ = "str"; fnc1 = false; max_length = 14 }
  | "03" -> Some { format = "N14"; typ = "str"; fnc1 = false; max_length = 14 }
  | "10" -> Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "11" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "12" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "13" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "15" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "16" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "17" -> Some { format = "N6"; typ = "date"; fnc1 = false; max_length = 6 }
  | "20" -> Some { format = "N2"; typ = "str"; fnc1 = false; max_length = 2 }
  | "21" -> Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "22" -> Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "235" ->
      Some { format = "X..28"; typ = "str"; fnc1 = true; max_length = 28 }
  | "240" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "241" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "242" -> Some { format = "N..6"; typ = "str"; fnc1 = true; max_length = 6 }
  | "243" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "250" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "251" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "253" ->
      Some { format = "N13[+X..17]"; typ = "str"; fnc1 = true; max_length = 30 }
  | "254" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "255" ->
      Some { format = "N13[+N..12]"; typ = "str"; fnc1 = true; max_length = 25 }
  | "30" -> Some { format = "N..8"; typ = "int"; fnc1 = true; max_length = 8 }
  | "3100" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3101" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3102" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3103" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3104" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3105" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3110" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3111" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3112" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3113" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3114" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3115" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3120" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3121" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3122" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3123" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3124" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3125" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3130" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3131" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3132" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3133" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3134" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3135" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3140" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3141" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3142" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3143" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3144" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3145" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3150" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3151" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3152" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3153" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3154" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3155" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3160" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3161" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3162" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3163" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3164" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3165" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3200" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3201" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3202" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3203" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3204" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3205" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3210" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3211" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3212" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3213" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3214" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3215" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3220" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3221" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3222" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3223" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3224" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3225" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3230" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3231" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3232" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3233" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3234" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3235" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3240" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3241" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3242" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3243" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3244" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3245" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3250" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3251" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3252" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3253" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3254" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3255" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3260" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3261" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3262" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3263" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3264" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3265" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3270" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3271" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3272" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3273" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3274" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3275" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3280" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3281" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3282" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3283" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3284" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3285" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3290" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3291" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3292" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3293" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3294" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3295" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3300" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3301" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3302" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3303" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3304" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3305" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3310" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3311" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3312" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3313" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3314" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3315" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3320" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3321" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3322" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3323" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3324" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3325" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3330" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3331" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3332" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3333" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3334" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3335" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3340" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3341" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3342" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3343" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3344" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3345" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3350" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3351" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3352" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3353" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3354" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3355" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3360" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3361" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3362" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3363" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3364" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3365" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3370" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3371" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3372" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3373" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3374" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3375" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3400" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3401" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3402" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3403" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3404" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3405" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3410" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3411" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3412" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3413" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3414" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3415" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3420" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3421" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3422" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3423" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3424" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3425" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3430" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3431" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3432" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3433" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3434" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3435" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3440" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3441" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3442" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3443" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3444" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3445" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3450" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3451" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3452" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3453" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3454" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3455" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3460" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3461" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3462" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3463" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3464" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3465" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3470" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3471" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3472" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3473" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3474" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3475" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3480" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3481" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3482" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3483" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3484" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3485" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3490" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3491" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3492" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3493" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3494" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3495" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3500" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3501" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3502" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3503" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3504" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3505" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3510" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3511" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3512" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3513" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3514" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3515" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3520" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3521" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3522" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3523" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3524" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3525" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3530" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3531" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3532" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3533" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3534" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3535" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3540" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3541" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3542" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3543" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3544" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3545" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3550" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3551" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3552" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3553" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3554" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3555" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3560" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3561" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3562" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3563" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3564" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3565" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3570" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3571" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3572" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3573" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3574" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3575" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3600" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3601" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3602" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3603" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3604" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3605" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3610" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3611" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3612" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3613" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3614" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3615" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3620" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3621" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3622" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3623" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3624" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3625" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3630" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3631" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3632" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3633" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3634" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3635" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3640" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3641" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3642" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3643" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3644" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3645" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3650" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3651" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3652" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3653" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3654" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3655" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3660" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3661" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3662" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3663" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3664" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3665" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3670" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3671" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3672" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3673" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3674" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3675" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3680" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3681" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3682" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3683" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3684" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3685" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3690" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3691" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3692" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3693" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3694" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "3695" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = false; max_length = 6 }
  | "37" -> Some { format = "N..8"; typ = "int"; fnc1 = true; max_length = 8 }
  | "3900" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3901" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3902" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3903" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3904" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3905" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3906" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3907" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3908" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3909" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3910" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3911" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3912" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3913" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3914" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3915" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3916" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3917" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3918" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3919" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3920" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3921" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3922" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3923" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3924" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3925" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3926" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3927" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3928" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3929" ->
      Some { format = "N..15"; typ = "decimal"; fnc1 = true; max_length = 15 }
  | "3930" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3931" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3932" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3933" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3934" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3935" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3936" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3937" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3938" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3939" ->
      Some
        { format = "N3+N..15"; typ = "decimal"; fnc1 = true; max_length = 18 }
  | "3940" ->
      Some { format = "N4"; typ = "decimal"; fnc1 = true; max_length = 4 }
  | "3941" ->
      Some { format = "N4"; typ = "decimal"; fnc1 = true; max_length = 4 }
  | "3942" ->
      Some { format = "N4"; typ = "decimal"; fnc1 = true; max_length = 4 }
  | "3943" ->
      Some { format = "N4"; typ = "decimal"; fnc1 = true; max_length = 4 }
  | "3950" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "3951" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "3952" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "3953" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "3954" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "3955" ->
      Some { format = "N6"; typ = "decimal"; fnc1 = true; max_length = 6 }
  | "400" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "401" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "402" -> Some { format = "N17"; typ = "str"; fnc1 = true; max_length = 17 }
  | "403" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "410" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "411" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "412" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "413" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "414" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "415" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "416" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "417" -> Some { format = "N13"; typ = "str"; fnc1 = false; max_length = 13 }
  | "420" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "421" ->
      Some { format = "N3+X..9"; typ = "str"; fnc1 = true; max_length = 12 }
  | "422" -> Some { format = "N3"; typ = "int"; fnc1 = true; max_length = 3 }
  | "423" ->
      Some { format = "N3+N..12"; typ = "str"; fnc1 = true; max_length = 15 }
  | "424" -> Some { format = "N3"; typ = "int"; fnc1 = true; max_length = 3 }
  | "425" ->
      Some { format = "N3+N..12"; typ = "str"; fnc1 = true; max_length = 15 }
  | "426" -> Some { format = "N3"; typ = "int"; fnc1 = true; max_length = 3 }
  | "427" -> Some { format = "X..3"; typ = "str"; fnc1 = true; max_length = 3 }
  | "4300" ->
      Some { format = "X..35"; typ = "str"; fnc1 = true; max_length = 35 }
  | "4301" ->
      Some { format = "X..35"; typ = "str"; fnc1 = true; max_length = 35 }
  | "4302" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4303" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4304" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4305" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4306" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4307" -> Some { format = "X2"; typ = "str"; fnc1 = true; max_length = 2 }
  | "4308" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "4309" -> Some { format = "N20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "4310" ->
      Some { format = "X..35"; typ = "str"; fnc1 = true; max_length = 35 }
  | "4311" ->
      Some { format = "X..35"; typ = "str"; fnc1 = true; max_length = 35 }
  | "4312" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4313" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4314" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4315" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4316" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "4317" -> Some { format = "X2"; typ = "str"; fnc1 = true; max_length = 2 }
  | "4318" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "4319" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "4320" ->
      Some { format = "X..35"; typ = "str"; fnc1 = true; max_length = 35 }
  | "4321" -> Some { format = "N1"; typ = "str"; fnc1 = true; max_length = 1 }
  | "4322" -> Some { format = "N1"; typ = "str"; fnc1 = true; max_length = 1 }
  | "4323" -> Some { format = "N1"; typ = "str"; fnc1 = true; max_length = 1 }
  | "4324" ->
      Some { format = "N10"; typ = "date"; fnc1 = true; max_length = 10 }
  | "4325" ->
      Some { format = "N10"; typ = "date"; fnc1 = true; max_length = 10 }
  | "4326" -> Some { format = "N6"; typ = "date"; fnc1 = true; max_length = 6 }
  | "4330" ->
      Some { format = "N6+[-]"; typ = "str"; fnc1 = true; max_length = 0 }
  | "4331" ->
      Some { format = "N6+[-]"; typ = "str"; fnc1 = true; max_length = 0 }
  | "4332" ->
      Some { format = "N6+[-]"; typ = "str"; fnc1 = true; max_length = 0 }
  | "4333" ->
      Some { format = "N6+[-]"; typ = "str"; fnc1 = true; max_length = 0 }
  | "7001" -> Some { format = "N13"; typ = "str"; fnc1 = true; max_length = 13 }
  | "7002" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7003" ->
      Some { format = "N10"; typ = "date"; fnc1 = true; max_length = 10 }
  | "7004" -> Some { format = "N..4"; typ = "str"; fnc1 = true; max_length = 4 }
  | "7005" ->
      Some { format = "X..12"; typ = "str"; fnc1 = true; max_length = 12 }
  | "7006" -> Some { format = "N6"; typ = "date"; fnc1 = true; max_length = 6 }
  | "7007" ->
      Some { format = "N6[+N6]"; typ = "date"; fnc1 = true; max_length = 12 }
  | "7008" -> Some { format = "X..3"; typ = "str"; fnc1 = true; max_length = 3 }
  | "7009" ->
      Some { format = "X..10"; typ = "str"; fnc1 = true; max_length = 10 }
  | "7010" -> Some { format = "X..2"; typ = "str"; fnc1 = true; max_length = 2 }
  | "7011" ->
      Some { format = "N6[+N4]"; typ = "date"; fnc1 = true; max_length = 10 }
  | "7020" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "7021" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "7022" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "7023" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7030" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7031" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7032" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7033" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7034" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7035" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7036" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7037" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7038" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7039" ->
      Some { format = "N3+X..27"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7040" ->
      Some { format = "N1+X3"; typ = "str"; fnc1 = true; max_length = 4 }
  | "7041" -> Some { format = "X..4"; typ = "str"; fnc1 = true; max_length = 4 }
  | "710" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "711" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "712" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "713" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "714" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "715" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "716" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "717" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "7230" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7231" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7232" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7233" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7234" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7235" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7236" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7237" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7238" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7239" ->
      Some { format = "X2+X..28"; typ = "str"; fnc1 = true; max_length = 30 }
  | "7240" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "7241" -> Some { format = "N2"; typ = "str"; fnc1 = true; max_length = 2 }
  | "7242" ->
      Some { format = "X..25"; typ = "str"; fnc1 = true; max_length = 25 }
  | "7250" -> Some { format = "N8"; typ = "date"; fnc1 = true; max_length = 8 }
  | "7251" ->
      Some { format = "N12"; typ = "date"; fnc1 = true; max_length = 12 }
  | "7252" -> Some { format = "N1"; typ = "str"; fnc1 = true; max_length = 1 }
  | "7253" ->
      Some { format = "X..40"; typ = "str"; fnc1 = true; max_length = 40 }
  | "7254" ->
      Some { format = "X..40"; typ = "str"; fnc1 = true; max_length = 40 }
  | "7255" ->
      Some { format = "X..10"; typ = "str"; fnc1 = true; max_length = 10 }
  | "7256" ->
      Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "7257" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "7258" ->
      Some { format = "N1+X1+N1"; typ = "str"; fnc1 = true; max_length = 3 }
  | "7259" ->
      Some { format = "X..40"; typ = "str"; fnc1 = true; max_length = 40 }
  | "8001" -> Some { format = "N14"; typ = "str"; fnc1 = true; max_length = 14 }
  | "8002" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "8003" ->
      Some { format = "N14[+X..16]"; typ = "str"; fnc1 = true; max_length = 30 }
  | "8004" ->
      Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "8005" -> Some { format = "N6"; typ = "str"; fnc1 = true; max_length = 6 }
  | "8006" ->
      Some { format = "N14+N2+N2"; typ = "str"; fnc1 = true; max_length = 18 }
  | "8007" ->
      Some { format = "X..34"; typ = "str"; fnc1 = true; max_length = 34 }
  | "8008" ->
      Some { format = "N8[+N..4]"; typ = "date"; fnc1 = true; max_length = 12 }
  | "8009" ->
      Some { format = "X..50"; typ = "str"; fnc1 = true; max_length = 50 }
  | "8010" ->
      Some { format = "Y..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "8011" ->
      Some { format = "N..12"; typ = "str"; fnc1 = true; max_length = 12 }
  | "8012" ->
      Some { format = "X..20"; typ = "str"; fnc1 = true; max_length = 20 }
  | "8013" ->
      Some { format = "X..25"; typ = "str"; fnc1 = true; max_length = 25 }
  | "8014" ->
      Some { format = "X..25"; typ = "str"; fnc1 = true; max_length = 25 }
  | "8017" -> Some { format = "N18"; typ = "str"; fnc1 = true; max_length = 18 }
  | "8018" -> Some { format = "N18"; typ = "str"; fnc1 = true; max_length = 18 }
  | "8019" ->
      Some { format = "N..10"; typ = "str"; fnc1 = true; max_length = 10 }
  | "8020" ->
      Some { format = "X..25"; typ = "str"; fnc1 = true; max_length = 25 }
  | "8026" ->
      Some { format = "N14+N2+N2"; typ = "str"; fnc1 = true; max_length = 18 }
  | "8030" ->
      Some { format = "Z..90"; typ = "str"; fnc1 = true; max_length = 0 }
  | "8040" -> Some { format = "N15"; typ = "str"; fnc1 = true; max_length = 15 }
  | "8041" -> Some { format = "N15"; typ = "str"; fnc1 = true; max_length = 15 }
  | "8042" -> Some { format = "N32"; typ = "str"; fnc1 = true; max_length = 32 }
  | "8043" ->
      Some { format = "N18+[N1..N2]"; typ = "str"; fnc1 = true; max_length = 0 }
  | "8110" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "8111" -> Some { format = "N4"; typ = "str"; fnc1 = true; max_length = 4 }
  | "8112" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "8200" ->
      Some { format = "X..70"; typ = "str"; fnc1 = true; max_length = 70 }
  | "90" -> Some { format = "X..30"; typ = "str"; fnc1 = true; max_length = 30 }
  | "91" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "92" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "93" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "94" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "95" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "96" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "97" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "98" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | "99" -> Some { format = "X..90"; typ = "str"; fnc1 = true; max_length = 90 }
  | _ -> None

let compact number = Tools.Utils.clean number "[()]" |> String.trim

let info ?separator number =
  ignore separator;
  ignore number;
  raise (Failure "info is not implemented yet")

let encode ?separator ?parentheses data =
  ignore separator;
  ignore parentheses;
  ignore data;
  raise (Failure "encode is not implemented yet")

let validate ?separator number =
  ignore separator;
  ignore number;
  raise (Failure "validate is not implemented yet")

let is_valid ?separator number =
  try
    ignore (validate ?separator number);
    true
  with _ -> false
