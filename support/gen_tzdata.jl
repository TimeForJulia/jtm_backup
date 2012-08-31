TM4JULIA_HOME="/home/jas/Desktop/julia/extras/tm4julia"
export TM4JULIA_HOME
require("tm4julia/config/JTM_dirpaths.jl")
import JTM_dirpaths.*
require("tm4julia/util/JTM_util.jl")
require("tm4julia/config/JTM_config_tz.jl")
import JTM_config_tz.*
require("tm4julia/config/JTM_config_etc.jl")
import JTM_config_etc.*
require("tm4julia/days/daynum.jl")
import daynum.*

# for timezone data
start_year = 1799
end_year   = 2031


const _tai_minus_utc_1972_2012_daynum = [
    daynumber( 1972, 1, 1 ), # 1
    daynumber( 1972, 7, 1 ),
    daynumber( 1973, 1, 1 ),
    daynumber( 1974, 1, 1 ),
    daynumber( 1975, 1, 1 ),
    daynumber( 1976, 1, 1 ),
    daynumber( 1977, 1, 1 ),
    daynumber( 1978, 1, 1 ),
    daynumber( 1979, 1, 1 ),
    daynumber( 1980, 1, 1 ),
    daynumber( 1981, 7, 1 ),
    daynumber( 1982, 7, 1 ),
    daynumber( 1983, 7, 1 ),
    daynumber( 1985, 7, 1 ),
    daynumber( 1988, 1, 1 ),
    daynumber( 1990, 1, 1 ),
    daynumber( 1991, 1, 1 ),
    daynumber( 1992, 7, 1 ),
    daynumber( 1993, 7, 1 ),
    daynumber( 1994, 7, 1 ),
    daynumber( 1996, 1, 1 ),
    daynumber( 1997, 7, 1 ),
    daynumber( 1999, 1, 1 ),
    daynumber( 2006, 1, 1 ),
    daynumber( 2009, 1, 1 ),
    daynumber( 2012, 7, 1 ), # 26
];

const _tai_minus_utc_1972_2012_secnum = 
   86400 * _tai_minus_utc_1972_2012_daynum

const _tai_minus_utc_1972_2012_secs =
[
  10 ,
  11 ,
  12 ,
  13 ,
  14 ,
  15 ,
  16 ,
  17 ,
  18 ,
  19 ,
  20 ,
  21 ,
  22 ,
  23 ,
  24 ,
  25 ,
  26 ,
  27 ,
  28 ,
  29 ,
  30 ,
  31 ,
  32 ,
  33 ,
  34 ,
  35 ,
]



const _tai_minus_utc_1961_1972_daynum =
[
    daynumber( 1961,  1, 1 ), #  1
    daynumber( 1961,  8, 1 ),
    daynumber( 1962,  1, 1 ),
    daynumber( 1963, 10, 1 ),
    daynumber( 1964,  1, 1 ),
    daynumber( 1964,  4, 1 ),
    daynumber( 1964,  9, 1 ),
    daynumber( 1965,  1, 1 ),
    daynumber( 1965,  3, 1 ),
    daynumber( 1965,  7, 1 ),
    daynumber( 1965,  9, 1 ),
    daynumber( 1966,  1, 1 ),
    daynumber( 1968,  2, 1 ),
    daynumber( 1971, 12,31 ), # 14
]

const _tai_minus_utc_1961_1972_secs =
[
  (daynum::Int64) -> (1.4228180 + (daynum - 2323308)*0.0012960) ,
  (daynum::Int64) -> (1.3728180 + (daynum - 2323308)*0.0012960) ,
  (daynum::Int64) -> (1.8458580 + (daynum - 2323673)*0.0011232) ,
  (daynum::Int64) -> (1.9458580 + (daynum - 2323673)*0.0011232) ,
  (daynum::Int64) -> (3.2401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.3401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.4401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.5401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.6401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.7401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.8401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (4.3131700 + (daynum - 2325134)*0.0025920) ,
  (daynum::Int64) -> (4.2131700 + (daynum - 2325134)*0.0025920) ,
  (daynum::Int64) -> (4.2131700 + (daynum - 2325134)*0.0025920) ,
]

function search_gte(a::Array{Int,1}, x::Int)
  # Define f(0) == false and f(length(a)+1)== true.
  # Invariant: f(i-1) == false, f(j) == true.
  i, j = 1, (length(a)+1)
  while(i < j)
    h = i + ((j-i) >> 1) # i <= h < j, avoids overflow
    if (a[h] <= x)
      i = h + 1        # preserves f(i-1) == false
    else
      j = h            # preserves f(j) == true
    end
  end
  # i == j, f(i-1) == false, and f(j) (= f(i)) == true  =>  answer is i.
  return i-1
end

# cume leapsecs as of daynum 0h
#function __tai_minus_utc(daynum::Int64) # function tai_minus_utc_1961_2012(daynum::Int64)
function cumeleapsecs(daynum::Int64)
  if      (daynum >= daynumber(2012, 7, 1))
      return 35
  elseif  (daynum <  daynumber(1961, 1, 1))
      return  0
  elseif  (daynum >= daynumber(1972, 1, 1))
      return _tai_minus_utc_1972_2012_secs[
                 search_gte( _tai_minus_utc_1972_2012_daynum, daynum )
                                          ]
  else
      return round(100_000 *
         _tai_minus_utc_1961_1972_secs[
          search_gte( _tai_minus_utc_1961_1972_daynum, daynum )
                                          ](daynum))/100_000
  end
end

function cumeleapsecs_atsec(secnum::Int64)
  daynum = iround(secnum/86400)
  if      (secnum >= daynumber(2012, 7, 1)*86400)
      return 35
  elseif  (secnum <  daynumber(1961, 1, 1)*86400)
      return  0
  elseif  (secnum >= daynumber(1972, 1, 1)*86400)
      return _tai_minus_utc_1972_2012_secs[
                 search_gte( _tai_minus_utc_1972_2012_secnum, secnum )
                                          ]
  else
      return round(100_000 *
         _tai_minus_utc_1961_1972_secs[
          search_gte( _tai_minus_utc_1961_1972_daynum, daynum )
                                          ](daynum))/100_000
  end
end

#  module iana-timezones {
#    yang-version 1;
#
#    namespace
#      "urn:ietf:params:xml:ns:yang:iana-timezones";
#
#    prefix ianatz;
#
#    organization "IANA";
#
#    contact
#             Internet Assigned Numbers Authority
#
#     Postal: ICANN
#             4676 Admiralty Way, Suite 330
#             Marina del Rey, CA 90292
#
#        Tel:    +1 310 823 9358  Tel:    +1 310 823 9358     Tel:    +1 310 823 9358
#     E-Mail: iana@iana.org";
#
#    description
#      "This YANG module defines the iana-timezone typedef, which
#     contains YANG definitions for IANA-registered timezones.
#
#     This YANG module is maintained by IANA, and reflects the
#     IANA Time Zone Database.
#     (http://www.iana.org/time-zones)
#
#     The latest revision of this YANG module can be obtained from
#     the IANA web site.
#
#     Copyright (c) 2011 IETF Trust and the persons identified as
#     authors of the code.  All rights reserved.
#
#     Redistribution and use in source and binary forms, with or
#     without modification, is permitted pursuant to, and subject
#     to the license terms contained in, the Simplified BSD License
#     set forth in Section 4.c of the IETF Trust's Legal Provisions
#     Relating to IETF Documents
#     (http://trustee.ietf.org/license-info).
#
#     This version of this YANG module is part of RFC XXXX; see
#     the RFC itself for full legal notices.";
#
#    revision "2012-07-09" {
#      description
#        "Initial revision. Using IANA Time Zone Data v. 2012c
#       (Released 2012-03-27)";
#      reference
#        "RFC XXXX: TITLE";
#



const iana_tzname_to_tzenum = {
        "Europe/Andorra" => 0,
        "Asia/Dubai" => 1,
        "Asia/Kabul" => 2,
        "America/Antigua" => 3,
        "America/Anguilla" => 4,
        "Europe/Tirane" => 5,
        "Asia/Yerevan" => 6,
        "Africa/Luanda" => 7,
        "Antarctica/McMurdo" => 8,
        "Antarctica/South_Pole" => 9,
        "Antarctica/Rothera" => 10,
        "Antarctica/Palmer" => 11,
        "Antarctica/Mawson" => 12,
        "Antarctica/Davis" => 13,
        "Antarctica/Casey" => 14,
        "Antarctica/Vostok" => 15,
        "Antarctica/DumontDUrville" => 16,
        "Antarctica/Syowa" => 17,
        "Antarctica/Macquarie" => 18,
        "America/Argentina/Buenos_Aires" => 19,
        "America/Argentina/Cordoba" => 20,
        "America/Argentina/Salta" => 21,
        "America/Argentina/Jujuy" => 22,
        "America/Argentina/Tucuman" => 23,
        "America/Argentina/Catamarca" => 24,
        "America/Argentina/La_Rioja" => 25,
        "America/Argentina/San_Juan" => 26,
        "America/Argentina/Mendoza" => 27,
        "America/Argentina/San_Luis" => 28,
        "America/Argentina/Rio_Gallegos" => 29,
        "America/Argentina/Ushuaia" => 30,
        "Pacific/Pago_Pago" => 31,
        "Europe/Vienna" => 32,
        "Australia/Lord_Howe" => 33,
        "Australia/Hobart" => 34,
        "Australia/Currie" => 35,
        "Australia/Melbourne" => 36,
        "Australia/Sydney" => 37,
        "Australia/Broken_Hill" => 38,
        "Australia/Brisbane" => 39,
        "Australia/Lindeman" => 40,
        "Australia/Adelaide" => 41,
        "Australia/Darwin" => 42,
        "Australia/Perth" => 43,
        "Australia/Eucla" => 44,
        "America/Aruba" => 45,
        "Europe/Mariehamn" => 46,
        "Asia/Baku" => 47,
        "Europe/Sarajevo" => 48,
        "America/Barbados" => 49,
        "Asia/Dhaka" => 50,
        "Europe/Brussels" => 51,
        "Africa/Ouagadougou" => 52,
        "Europe/Sofia" => 53,
        "Asia/Bahrain" => 54,
        "Africa/Bujumbura" => 55,
        "Africa/Porto-Novo" => 56,
        "America/St_Barthelemy" => 57,
        "Atlantic/Bermuda" => 58,
        "Asia/Brunei" => 59,
        "America/La_Paz" => 60,
        "America/Kralendijk" => 61,
        "America/Noronha" => 62,
        "America/Belem" => 63,
        "America/Fortaleza" => 64,
        "America/Recife" => 65,
        "America/Araguaina" => 66,
        "America/Maceio" => 67,
        "America/Bahia" => 68,
        "America/Sao_Paulo" => 69,
        "America/Campo_Grande" => 70,
        "America/Cuiaba" => 71,
        "America/Santarem" => 72,
        "America/Porto_Velho" => 73,
        "America/Boa_Vista" => 74,
        "America/Manaus" => 75,
        "America/Eirunepe" => 76,
        "America/Rio_Branco" => 77,
        "America/Nassau" => 78,
        "Asia/Thimphu" => 79,
        "Africa/Gaborone" => 80,
        "Europe/Minsk" => 81,
        "America/Belize" => 82,
        "America/St_Johns" => 83,
        "America/Halifax" => 84,
        "America/Glace_Bay" => 85,
        "America/Moncton" => 86,
        "America/Goose_Bay" => 87,
        "America/Blanc-Sablon" => 88,
        "America/Montreal" => 89,
        "America/Toronto" => 90,
        "America/Nipigon" => 91,
        "America/Thunder_Bay" => 92,
        "America/Iqaluit" => 93,
        "America/Pangnirtung" => 94,
        "America/Resolute" => 95,
        "America/Atikokan" => 96,
        "America/Rankin_Inlet" => 97,
        "America/Winnipeg" => 98,
        "America/Rainy_River" => 99,
        "America/Regina" => 100,
        "America/Swift_Current" => 101,
        "America/Edmonton" => 102,
        "America/Cambridge_Bay" => 103,
        "America/Yellowknife" => 104,
        "America/Inuvik" => 105,
        "America/Creston" => 106,
        "America/Dawson_Creek" => 107,
        "America/Vancouver" => 108,
        "America/Whitehorse" => 109,
        "America/Dawson" => 110,
        "Indian/Cocos" => 111,
        "Africa/Kinshasa" => 112,
        "Africa/Lubumbashi" => 113,
        "Africa/Bangui" => 114,
        "Africa/Brazzaville" => 115,
        "Europe/Zurich" => 116,
        "Africa/Abidjan" => 117,
        "Pacific/Rarotonga" => 118,
        "America/Santiago" => 119,
        "Pacific/Easter" => 120,
        "Africa/Douala" => 121,
        "Asia/Shanghai" => 122,
        "Asia/Harbin" => 123,
        "Asia/Chongqing" => 124,
        "Asia/Urumqi" => 125,
        "Asia/Kashgar" => 126,
        "America/Bogota" => 127,
        "America/Costa_Rica" => 128,
        "America/Havana" => 129,
        "Atlantic/Cape_Verde" => 130,
        "America/Curacao" => 131,
        "Indian/Christmas" => 132,
        "Asia/Nicosia" => 133,
        "Europe/Prague" => 134,
        "Europe/Berlin" => 135,
        "Africa/Djibouti" => 136,
        "Europe/Copenhagen" => 137,
        "America/Dominica" => 138,
        "America/Santo_Domingo" => 139,
        "Africa/Algiers" => 140,
        "America/Guayaquil" => 141,
        "Pacific/Galapagos" => 142,
        "Europe/Tallinn" => 143,
        "Africa/Cairo" => 144,
        "Africa/El_Aaiun" => 145,
        "Africa/Asmara" => 146,
        "Europe/Madrid" => 147,
        "Africa/Ceuta" => 148,
        "Atlantic/Canary" => 149,
        "Africa/Addis_Ababa" => 150,
        "Europe/Helsinki" => 151,
        "Pacific/Fiji" => 152,
        "Atlantic/Stanley" => 153,
        "Pacific/Chuuk" => 154,
        "Pacific/Pohnpei" => 155,
        "Pacific/Kosrae" => 156,
        "Atlantic/Faroe" => 157,
        "Europe/Paris" => 158,
        "Africa/Libreville" => 159,
        "Europe/London" => 160,
        "America/Grenada" => 161,
        "Asia/Tbilisi" => 162,
        "America/Cayenne" => 163,
        "Europe/Guernsey" => 164,
        "Africa/Accra" => 165,
        "Europe/Gibraltar" => 166,
        "America/Godthab" => 167,
        "America/Danmarkshavn" => 168,
        "America/Scoresbysund" => 169,
        "America/Thule" => 170,
        "Africa/Banjul" => 171,
        "Africa/Conakry" => 172,
        "America/Guadeloupe" => 173,
        "Africa/Malabo" => 174,
        "Europe/Athens" => 175,
        "Atlantic/South_Georgia" => 176,
        "America/Guatemala" => 177,
        "Pacific/Guam" => 178,
        "Africa/Bissau" => 179,
        "America/Guyana" => 180,
        "Asia/Hong_Kong" => 181,
        "America/Tegucigalpa" => 182,
        "Europe/Zagreb" => 183,
        "America/Port-au-Prince" => 184,
        "Europe/Budapest" => 185,
        "Asia/Jakarta" => 186,
        "Asia/Pontianak" => 187,
        "Asia/Makassar" => 188,
        "Asia/Jayapura" => 189,
        "Europe/Dublin" => 190,
        "Asia/Jerusalem" => 191,
        "Europe/Isle_of_Man" => 192,
        "Asia/Kolkata" => 193,
        "Indian/Chagos" => 194,
        "Asia/Baghdad" => 195,
        "Asia/Tehran" => 196,
        "Atlantic/Reykjavik" => 197,
        "Europe/Rome" => 198,
        "Europe/Jersey" => 199,
        "America/Jamaica" => 200,
        "Asia/Amman" => 201,
        "Asia/Tokyo" => 202,
        "Africa/Nairobi" => 203,
        "Asia/Bishkek" => 204,
        "Asia/Phnom_Penh" => 205,
        "Pacific/Tarawa" => 206,
        "Pacific/Enderbury" => 207,
        "Pacific/Kiritimati" => 208,
        "Indian/Comoro" => 209,
        "America/St_Kitts" => 210,
        "Asia/Pyongyang" => 211,
        "Asia/Seoul" => 212,
        "Asia/Kuwait" => 213,
        "America/Cayman" => 214,
        "Asia/Almaty" => 215,
        "Asia/Qyzylorda" => 216,
        "Asia/Aqtobe" => 217,
        "Asia/Aqtau" => 218,
        "Asia/Oral" => 219,
        "Asia/Vientiane" => 220,
        "Asia/Beirut" => 221,
        "America/St_Lucia" => 222,
        "Europe/Vaduz" => 223,
        "Asia/Colombo" => 224,
        "Africa/Monrovia" => 225,
        "Africa/Maseru" => 226,
        "Europe/Vilnius" => 227,
        "Europe/Luxembourg" => 228,
        "Europe/Riga" => 229,
        "Africa/Tripoli" => 230,
        "Africa/Casablanca" => 231,
        "Europe/Monaco" => 232,
        "Europe/Chisinau" => 233,
        "Europe/Podgorica" => 234,
        "America/Marigot" => 235,
        "Indian/Antananarivo" => 236,
        "Pacific/Majuro" => 237,
        "Pacific/Kwajalein" => 238,
        "Europe/Skopje" => 239,
        "Africa/Bamako" => 240,
        "Asia/Rangoon" => 241,
        "Asia/Ulaanbaatar" => 242,
        "Asia/Hovd" => 243,
        "Asia/Choibalsan" => 244,
        "Asia/Macau" => 245,
        "Pacific/Saipan" => 246,
        "America/Martinique" => 247,
        "Africa/Nouakchott" => 248,
        "America/Montserrat" => 249,
        "Europe/Malta" => 250,
        "Indian/Mauritius" => 251,
        "Indian/Maldives" => 252,
        "Africa/Blantyre" => 253,
        "America/Mexico_City" => 254,
        "America/Cancun" => 255,
        "America/Merida" => 256,
        "America/Monterrey" => 257,
        "America/Matamoros" => 258,
        "America/Mazatlan" => 259,
        "America/Chihuahua" => 260,
        "America/Ojinaga" => 261,
        "America/Hermosillo" => 262,
        "America/Tijuana" => 263,
        "America/Santa_Isabel" => 264,
        "America/Bahia_Banderas" => 265,
        "Asia/Kuala_Lumpur" => 266,
        "Asia/Kuching" => 267,
        "Africa/Maputo" => 268,
        "Africa/Windhoek" => 269,
        "Pacific/Noumea" => 270,
        "Africa/Niamey" => 271,
        "Pacific/Norfolk" => 272,
        "Africa/Lagos" => 273,
        "America/Managua" => 274,
        "Europe/Amsterdam" => 275,
        "Europe/Oslo" => 276,
        "Asia/Kathmandu" => 277,
        "Pacific/Nauru" => 278,
        "Pacific/Niue" => 279,
        "Pacific/Auckland" => 280,
        "Pacific/Chatham" => 281,
        "Asia/Muscat" => 282,
        "America/Panama" => 283,
        "America/Lima" => 284,
        "Pacific/Tahiti" => 285,
        "Pacific/Marquesas" => 286,
        "Pacific/Gambier" => 287,
        "Pacific/Port_Moresby" => 288,
        "Asia/Manila" => 289,
        "Asia/Karachi" => 290,
        "Europe/Warsaw" => 291,
        "America/Miquelon" => 292,
        "Pacific/Pitcairn" => 293,
        "America/Puerto_Rico" => 294,
        "Asia/Gaza" => 295,
        "Asia/Hebron" => 296,
        "Europe/Lisbon" => 297,
        "Atlantic/Madeira" => 298,
        "Atlantic/Azores" => 299,
        "Pacific/Palau" => 300,
        "America/Asuncion" => 301,
        "Asia/Qatar" => 302,
        "Indian/Reunion" => 303,
        "Europe/Bucharest" => 304,
        "Europe/Belgrade" => 305,
        "Europe/Kaliningrad" => 306,
        "Europe/Moscow" => 307,
        "Europe/Volgograd" => 308,
        "Europe/Samara" => 309,
        "Asia/Yekaterinburg" => 310,
        "Asia/Omsk" => 311,
        "Asia/Novosibirsk" => 312,
        "Asia/Novokuznetsk" => 313,
        "Asia/Krasnoyarsk" => 314,
        "Asia/Irkutsk" => 315,
        "Asia/Yakutsk" => 316,
        "Asia/Vladivostok" => 317,
        "Asia/Sakhalin" => 318,
        "Asia/Magadan" => 319,
        "Asia/Kamchatka" => 320,
        "Asia/Anadyr" => 321,
        "Africa/Kigali" => 322,
        "Asia/Riyadh" => 323,
        "Pacific/Guadalcanal" => 324,
        "Indian/Mahe" => 325,
        "Africa/Khartoum" => 326,
        "Europe/Stockholm" => 327,
        "Asia/Singapore" => 328,
        "Atlantic/St_Helena" => 329,
        "Europe/Ljubljana" => 330,
        "Arctic/Longyearbyen" => 331,
        "Europe/Bratislava" => 332,
        "Africa/Freetown" => 333,
        "Europe/San_Marino" => 334,
        "Africa/Dakar" => 335,
        "Africa/Mogadishu" => 336,
        "America/Paramaribo" => 337,
        "Africa/Juba" => 338,
        "Africa/Sao_Tome" => 339,
        "America/El_Salvador" => 340,
        "America/Lower_Princes" => 341,
        "Asia/Damascus" => 342,
        "Africa/Mbabane" => 343,
        "America/Grand_Turk" => 344,
        "Africa/Ndjamena" => 345,
        "Indian/Kerguelen" => 346,
        "Africa/Lome" => 347,
        "Asia/Bangkok" => 348,
        "Asia/Dushanbe" => 349,
        "Pacific/Fakaofo" => 350,
        "Asia/Dili" => 351,
        "Asia/Ashgabat" => 352,
        "Africa/Tunis" => 353,
        "Pacific/Tongatapu" => 354,
        "Europe/Istanbul" => 355,
        "America/Port_of_Spain" => 356,
        "Pacific/Funafuti" => 357,
        "Asia/Taipei" => 358,
        "Africa/Dar_es_Salaam" => 359,
        "Europe/Kiev" => 360,
        "Europe/Uzhgorod" => 361,
        "Europe/Zaporozhye" => 362,
        "Europe/Simferopol" => 363,
        "Africa/Kampala" => 364,
        "Pacific/Johnston" => 365,
        "Pacific/Midway" => 366,
        "Pacific/Wake" => 367,
        "America/New_York" => 368,
        "America/Detroit" => 369,
        "America/Kentucky/Louisville" => 370,
        "America/Kentucky/Monticello" => 371,
        "America/Indiana/Indianapolis" => 372,
        "America/Indiana/Vincennes" => 373,
        "America/Indiana/Winamac" => 374,
        "America/Indiana/Marengo" => 375,
        "America/Indiana/Petersburg" => 376,
        "America/Indiana/Vevay" => 377,
        "America/Chicago" => 378,
        "America/Indiana/Tell_City" => 379,
        "America/Indiana/Knox" => 380,
        "America/Menominee" => 381,
        "America/North_Dakota/Center" => 382,
        "America/North_Dakota/New_Salem" => 383,
        "America/North_Dakota/Beulah" => 384,
        "America/Denver" => 385,
        "America/Boise" => 386,
        "America/Shiprock" => 387,
        "America/Phoenix" => 388,
        "America/Los_Angeles" => 389,
        "America/Anchorage" => 390,
        "America/Juneau" => 391,
        "America/Sitka" => 392,
        "America/Yakutat" => 393,
        "America/Nome" => 394,
        "America/Adak" => 395,
        "America/Metlakatla" => 396,
        "Pacific/Honolulu" => 397,
        "America/Montevideo" => 398,
        "Asia/Samarkand" => 399,
        "Asia/Tashkent" => 400,
        "Europe/Vatican" => 401,
        "America/St_Vincent" => 402,
        "America/Caracas" => 403,
        "America/Tortola" => 404,
        "America/St_Thomas" => 405,
        "Asia/Ho_Chi_Minh" => 406,
        "Pacific/Efate" => 407,
        "Pacific/Wallis" => 408,
        "Pacific/Apia" => 409,
        "Asia/Aden" => 410,
        "Indian/Mayotte" => 411,
        "Africa/Johannesburg" => 412,
        "Africa/Lusaka" => 413,
        "Africa/Harare" => 414,
};


# (("StdTimeAbbr",StdTimeGMToffset),("DstTimeAbbr",DstTimeGMToffset))
# if no Savings time, DstTime == StdTime tuple
function getzabbrs(tzname)
  fromyear = "2010"; uptoyear = "2011";
  zdumped = `zdump -v -c$(fromyear),$(uptoyear) $(tzname)`
  zdumped = split(readchomp(zdumped),'\n')
  zdumped = zdumped[3:(length(zdumped)-2)] # first 2 and last 2 are unhelpful
  stdabbr = ("",-1); dstabbr = ("";-1)
  if (length(zdumped)==0)
    fromyear ="1800"; uptoyear = "2020"
    zdumped = `zdump -v -c$(fromyear),$(uptoyear) $(tzname)`
    zdumped = split(readchomp(zdumped),'\n')
    zdumped = zdumped[3:(end-2)] # first 2 and last 2 are unhelpful
    if (length(zdumped)>0)
      ans = split(split(zdumped[end]," = ")[2]," ")[(end-3):]
      stdabbr = (ans[2],int64(split(ans[4],"=")[2]))
      dstabbr = (ans[2],int64(split(ans[4],"=")[2]))
    else
      if (tzname == "Pacific/Johnston")
          stdabbr = ("HST",-36000); dstabbr = ("HST",-36000);
      elseif any(tzname .== ["UTC","TAI","UT1","GMT","GPS","LCL"])
          stdabbr = (tzname,0); dstabbr = (tzname,0);
      else
          print("unhandled: ", tzname,"\n");flush(stdout_stream);
      end
    end  
  elseif (length(zdumped)>1)
      ans1 = split(split(zdumped[1],"2010 ")[3]," ")
      ans2 = split(split(zdumped[2],"2010 ")[3]," ")
      if (ans1[2] == "isdst=0")
         stdabbr = (ans1[1],int64(split(ans1[3],"=")[2]))
         dstabbr = (ans2[1],int64(split(ans2[3],"=")[2]))
     elseif (ans1[2] == "isdst=1")
         dstabbr = (ans1[1],int64(split(ans1[3],"=")[2]))
         stdabbr = (ans2[1],int64(split(ans2[3],"=")[2]))
     end    
  end
  (stdabbr,dstabbr)
end


#             IANA name       STD abbr UTC+secs  Savings abbr  UTC+secs
iana_tzname_to_abbroffset = Dict{ASCIIString, ((ASCIIString,Int64),(ASCIIString,Int64))}(511)

for k in keys(iana_tzname_to_tzenum)
    try
        iana_tzname_to_abbroffset[k] = getzabbrs(k)
    catch e
        print("tzabbr error: ",k,"\n")
    end
end


_tzname_to_tznum = Dict{ASCIIString,Int64}(1080)
tznum_offset = 8 # 1-based indexing, room for specials: "UTC" "GMT"
# add specials with numbers < 8
_tzname_to_tznum["LCL"] = 0 # Local Timezone
_tzname_to_tznum["TDB"] = 1 # Barycentric Dynamical Time
_tzname_to_tznum["TDT"] = 2 # Terrestrial Dynamical Time
_tzname_to_tznum["TAI"] = 3 # International Atomic Time 
_tzname_to_tznum["UT1"] = 4 # Mean Solar Time corrected for Polar Motion
_tzname_to_tznum["UTC"] = 5 # Coordinated Universal Time
_tzname_to_tznum["GMT"] = 6 # UT ignoring leapsecs
_tzname_to_tznum["GPS"] = 7 # Global Positioning System Time

# fill in iana timezone names mapped to iana+offset nums
for (k,v) in iana_tzname_to_tzenum
   _tzname_to_tznum[k] = v + tznum_offset
end
# provide reverse lookup
_tznum_to_tzname = Dict{Int64,ASCIIString}(length(_tzname_to_tznum))
for (k,v) in _tzname_to_tznum
    _tznum_to_tzname[v] = k
end

# timezone std,savings abbreviations and GMToffsets in seconds
_tznum_to_abbroffset = Dict{Int64, ((ASCIIString,Int64),(ASCIIString,Int64))}(511)
# make entries for specials
# !!FIXME!! LCL
_tznum_to_abbroffset[0] = (("LCL",0),("LCL",0)) 
_tznum_to_abbroffset[1] = (("TDB",0),("TDB",0))
_tznum_to_abbroffset[2] = (("TDT",0),("TDT",0))
_tznum_to_abbroffset[3] = (("TAI",0),("TAI",0))
_tznum_to_abbroffset[4] = (("UT1",0),("UT1",0))
_tznum_to_abbroffset[5] = (("UTC",0),("UTC",0))
_tznum_to_abbroffset[6] = (("GMT",0),("GMT",0))
_tznum_to_abbroffset[7] = (("GPS",0),("GPS",0))

for (k,v) in iana_tzname_to_abbroffset
    _tznum_to_abbroffset[ _tzname_to_tznum[k] ] = v
end


# ( 1970, 1, 1) --> 2326595  [UNIX date zero] is our daynum 2326595
#   and there are no leap seconds prior to 1970 
#   so our secnum for UNIX Epoch is 2326595*86400 = 201_017_808_000 

const _seconds_at_UNIX_Epoch_ = 201_017_808_000;


mnmxabs(a,b) = (abs(a) < abs(b)) ? (a,b) : (b,a);


function ensure_increasing(a,b)
    if     (a<b)
      (a, b)
    elseif (a!=b)
      (b, a)
    else
      (a, b+1)
    end
end

ends_with_NULL(s::String) = (s[(strlen(s)-3),:] == "NULL")

function getzdump(tzname,fromyear,uptoyear)
   fromyear, uptoyear = ensure_increasing(fromyear,uptoyear)
   fromyear = string(fromyear); uptoyear = string(uptoyear);
   zdump = `zdump -v -c$(fromyear),$(uptoyear) $(tzname)`
   zdump = split(readchomp(zdump),'\n')
   zdump[3:(length(zdump)-2)] # first 2 and last 2 are unhelpful
end


function zdump2secs(tzname,fromyear,uptoyear)

  const zdumpregex = r"(?>\S+\s+\S+\s+)([A-Z|a-z|0-9|:|\s]+UTC)(?>\s+=\s+\S+\s)([A-Z\a-z|0-9|:|\s]+)isdst=(\d)\sgmtoff=(\S+)"

  zdumped  = getzdump(tzname,fromyear,uptoyear);
  n        = length(zdumped)

  zutc_secs = zeros(Int64,n);
  zutc2lcl  = copy(zutc_secs);
  zisdst    = copy(zutc_secs);

  for i in 1:n
      m=match(zdumpregex, zdumped[i]);
      zutc_secs[i] = int64(strptime("%b %d %H:%M:%S %Y",m.captures[1][1:20]));
      zutc2lcl[i]  = int64(m.captures[4]);
      zisdst[i]    = int64(m.captures[3]);
  end
  idx_even_gmt_secs = filter(x->(x>0),[if iseven(zutc_secs[i]) i else 0 end for i=1:length(zutc_secs)])

  zutc_secs  = [zutc_secs[i]::Int64 for i=idx_even_gmt_secs] ;  
  zutc_secs  += _seconds_at_UNIX_Epoch_;
  zutc2lcl   = [zutc2lcl[i]::Int64  for i=idx_even_gmt_secs] ;
  zisdst     = [zisdst[i]::Int64    for i=idx_even_gmt_secs] ;  

  dups = find(0 .== diff(zisdst));
  if (length(dups)>0)
    dups += 1; # remove the second occurance in a paired repeat
    while (length(dups)>0)
      n = pop(dups)  # last to first !! important
      if (n == 1)    # should never occur
        begin
           zisdst    = zisdst[2:end]
           zutc_secs = zutc_secs[2:end]
           zutc2lcl  = zutc2lcl[2:end]
        end   
      elseif (n == length(zisdst))
        begin
           zisdst    = zisdst[1:(end-1)]
           zutc_secs = zutc_secs[1:(end-1)]
           zutc2lcl  = zutc2lcl[1:(end-1)]
        end   
      else
        begin
           zisdst    = vcat(zisdst[1:(n-1)],zisdst[(n+1):end])
           zutc_secs = vcat(zutc_secs[1:(n-1)],zutc_secs[(n+1):end])
           zutc2lcl  = vcat(zutc2lcl[1:(n-1)],zutc2lcl[(n+1):end])
        end   
      end
    end  
  end

  # without correction
  #julia> s=zdump2secs("America/New_York",1993,1995)
  #4x3 Int64 Array:
  # 201751729200  -14400  1
  # 201769873200  -18000  0
  # 201783178800  -14400  1
  # 201801319200  -18000  0
  #
  # with correction
  # a> s=zdump2secs("America/New_York",1993,1995)
  # 4x3 Int64 Array:
  # 201751729227  -14400  1
  # 201769869628  -18000  0
  # 201783182428  -14400  1
  # 201801319229  -18000  0


  # correct zutc_secs for cumeleapseconds
  zutc_secs_corr = map(x->iround(x+cumeleapsecs_atsec(x)),zutc_secs)
  #for i in 1:length(zutc_secs)
  #   zutc_secs[i] += cumeleapsecs_atsec(zutc_secs[i])
  #end

  #hcat(zutc_secs,zutc2lcl,zisdst)
  hcat(zutc_secs_corr,zutc2lcl,zisdst)
end

tzdata_dir = "$(TM4JULIA_HOME)/tzdata"
tm4julia_data(astr) = "$(TM4JULIA_HOME)/tzdata/$(astr)"
tm4julia_datapath(astr) = "$(TM4JULIA_HOME)/tzdata/$(astr)"

_tznum_to_filepath = Dict{Int64,ASCIIString}(511)       
for i=0:max(keys(_tznum_to_tzname))
  tzname = _tznum_to_tzname[i]
  fname   = split(tzname,"/");
  basedir = fname[1]; localedir=fname[end];
  if (basedir == localedir)
     basedir = "Special"
  end   
  fname = tm4julia_data("$(basedir)/$(localedir)/")
  _tznum_to_filepath[ i ] = fname
end
fio = open(tm4julia_data("_tznum_to_filepath.jld"),"w")
serialize(fio,_tznum_to_filepath)
close(fio)

# tzid2file => (basedir,basefilename,tznum)
function _tzname_to_file_and_num(tzname)
  fnames = split(tzname,"/");
  basedir = fnames[1]; basefilename=fnames[end];
  if (basedir == basefilename)
     basedir = "Special"
  end   
  num = _tzname_to_tznum[tzname]
  (basedir,basefilename,num)
end


# const gmtsecs_file = "$(tzdata_dir)gmtsecs.jld"
# const gmt2lcl_file = "$(tzdata_dir)gmt2lcl.jld"
# const isitdst_file = "$(tzdata_dir)isitdst.jld"
# const tzabbrs_file = "$(tzdata_dir)tzabbrs.jld"
# const tzonenum_file = "$(tzdata_dir)tzonenum.jld"

if (stat(tzdata_dir).mode==0)
     a = readchomp(`mkdir $(tzdata_dir)`)
end   

tzregions = [ "Africa", "America", "Antarctica", "Arctic", "Asia",
              "Atlantic", "Australia", "Europe", "Indian", "Pacific",
              "Special"];
for region in tzregions
    filedir = tm4julia_datapath("$(region)")
    if (stat(filedir).mode==0)
        a = readchomp(`mkdir $(filedir)`)
    end    
end



for tzname in keys(_tzname_to_tznum)

  #tzname = _tznum_to_tzname[ _tzname_to_tznum[ tzname ] ]
  country,region,tznum = _tzname_to_file_and_num(tzname)
  tznum    = int64(tznum)

  datasubdir = "$(country)/$(region)"
  filedir    = tm4julia_datapath(datasubdir)
  if (stat(filedir).mode==0)
     a = readchomp(`mkdir $(filedir)`)
  end   

  #    datasubdir = tm4julia_datapath(datasubdir)
  #    a = readchomp(`rm -rf $(datasubdir)*`)



  tzabbrs  = getzabbrs(tzname)
  print(tzname," ",tzabbrs,"\n");flush(stdout_stream);
  stdabbr,gmt2std  = tzabbrs[1]; gmt2std=int64(gmt2std);
  dstabbr,gmt2dst  = tzabbrs[2]; gmt2dst=int64(gmt2dst);


  gmtsecs  = int64([0,0,0]);
  gmt2lcl  = int64([0,0,0]);
  isitdst  = int64([0,0,0]);
  
  try
    tzvalues = zdump2secs(tzname,start_year,end_year);
    gmtsecs  = int64(tzvalues[:,1]);
    gmt2lcl  = int64(tzvalues[:,2]);
    isitdst  = int64(tzvalues[:,3]);
  end    

  tz_basic = TimezoneBasic(tznum,gmt2std,gmt2dst,tzname,stdabbr,dstabbr)
  tz_vects = TimezoneVects(gmtsecs,gmt2lcl,isitdst)
  tz_basic_file = "$(datasubdir)/$(tz_basic_fname)"
  tz_vects_file = "$(datasubdir)/$(tz_vects_fname)"

  fio=open(tm4julia_data(tz_basic_file),"w"); 
  serialize(fio,tz_basic); 
  close(fio);


  fio=open(tm4julia_data(tz_vects_file),"w"); 
  serialize(fio,tz_vects); 
  close(fio);
  
#   gmtsecsfile = "$(filebase)gmtsecs.jld"
#   gmt2lclfile = "$(filebase)gmt2lcl.jld"
#   isitdstfile = "$(filebase)isitdst.jld"
#   tzabbrsfile = "$(filebase)tzabbrs.jld"
#   tzonenumfile = "$(filebase)tzonenum.jld"

#   if (stat(gmtsecsfile).mode==0)
#      a = readchomp(`cp -f $(gmtsecs_file) $(gmtsecsfile)`)
#      a = readchomp(`chmod 777 $(gmtsecsfile)`)
#   end     
#   if (stat(gmt2lclfile).mode==0)
#      a = readchomp(`cp -f $(gmt2lcl_file) $(gmt2lclfile)`)
#      a = readchomp(`chmod 755 $(gmt2lclfile)`)
#   end
#   if (stat(isitdstfile).mode==0)
#      a = readchomp(`cp -f $(isitdst_file) $(isitdstfile)`)
#      a = readchomp(`chmod 755 $(isitdstfile)`)
#   end
#   if (stat(tzabbrsfile).mode==0)
#      a = readchomp(`cp -f $(tzabbrs_file) $(tzabbrsfile)`)
#      a = readchomp(`chmod 755 $(tzabbrsfile)`)
#   end
#   if (stat(tzonenumfile).mode==0)
#      a = readchomp(`cp -f $(tzonenum_file) $(tzonenumfile)`)
#      a = readchomp(`chmod 755 $(gmtsecsfile)`)
#   end    

# #try
#   fio=open(gmtsecsfile,"w"); serialize(fio,gmtsecs); close(fio); 
#   fio=open(gmt2lclfile,"w"); serialize(fio,gmt2lcl); close(fio); 
#   fio=open(isitdstfile,"w"); serialize(fio,isitdst); close(fio); 
#   fio=open(tzonenumfile,"w"); serialize(fio,tznum); close(fio); 
#   fio=open(tzabbrsfile,"w"); serialize(fio,tzabbrs); close(fio); 
# #catch e
# #  print(filebase,"\n");flush(stdout_stream);
# #end
end


# add city names
for (k,v) in iana_tzname_to_tzenum
   locale = split(k,"/")[end] 
   _tzname_to_tznum[locale] = v + tznum_offset
   if (strchr(locale,'-') > 0)
      locale = join(split(locale,'-'),'_')
      _tzname_to_tznum[locale] = v + tznum_offset
   end
   if (strchr(locale,'_') > 0)
      locale = camelcase(locale,'_')
      _tzname_to_tznum[locale] = v + tznum_offset
   end       
end



# Mapping from Windows Time Zone Names to Olson Time Zone Keys
# source: http://www.chronos-st.org/Windows-to-Olson.html
# license: http://www.chronos-st.org/License.html
# the following do not map
# Greenwich Standard Time => GMT
# GMT Standard Time => GMT
# Greenwich => GMT
# Dateline => GMT-1200
# Dateline Standard Time => GMT-1200

# in windows cmd: tzutil /g returns current time zone ID
# all windows time zone IDs end with  "Standard Time" 
# there are a few without corresponding "Standard Time" entries
# they are included for completeness (94 entries)
win_tzid_to_iana_tznum = {
"Afghanistan Standard Time" => iana_tzname_to_tzenum["Asia/Kabul"],
"Alaskan Standard Time" => iana_tzname_to_tzenum["America/Anchorage"],
"Arab Standard Time" => iana_tzname_to_tzenum["Asia/Riyadh"],
"Arabian Standard Time" => iana_tzname_to_tzenum["Asia/Muscat"],
"Arabic Standard Time" => iana_tzname_to_tzenum["Asia/Baghdad"],
"Atlantic Standard Time" => iana_tzname_to_tzenum["America/Halifax"],
"AUS Central Standard Time" => iana_tzname_to_tzenum["Australia/Darwin"],
"AUS Eastern Standard Time" => iana_tzname_to_tzenum["Australia/Sydney"],
"Azerbaijan Standard Time" => iana_tzname_to_tzenum["Asia/Baku"],
"Azores Standard Time" => iana_tzname_to_tzenum["Atlantic/Azores"],
"Bangkok Standard Time" => iana_tzname_to_tzenum["Asia/Bangkok"],
"Canada Central Standard Time" => iana_tzname_to_tzenum["America/Regina"],
"Cape Verde Standard Time" => iana_tzname_to_tzenum["Atlantic/Cape_Verde"],
"Caucasus Standard Time" => iana_tzname_to_tzenum["Asia/Yerevan"],
"Cen. Australia Standard Time" => iana_tzname_to_tzenum["Australia/Adelaide"],
"Central America Standard Time" => iana_tzname_to_tzenum["America/Regina"],
"Central Asia Standard Time" => iana_tzname_to_tzenum["Asia/Dhaka"],
"Central Brazilian Standard Time" => iana_tzname_to_tzenum["America/Manaus"],
"Central Europe Standard Time" => iana_tzname_to_tzenum["Europe/Prague"],
"Central European Standard Time" => iana_tzname_to_tzenum["Europe/Belgrade"],
"Central Pacific Standard Time" => iana_tzname_to_tzenum["Pacific/Guadalcanal"],
"Central Standard Time" => iana_tzname_to_tzenum["America/Chicago"],
"Central Standard Time (Mexico)" => iana_tzname_to_tzenum["America/Mexico_City"],
"China Standard Time" => iana_tzname_to_tzenum["Asia/Shanghai"],
#"Dateline Standard Time" => iana_tzname_to_tzenum["GMT-1200"],
"E. Africa Standard Time" => iana_tzname_to_tzenum["Africa/Nairobi"],
"E. Australia Standard Time" => iana_tzname_to_tzenum["Australia/Brisbane"],
"E. Europe Standard Time" => iana_tzname_to_tzenum["Europe/Minsk"],
"E. South America Standard Time" => iana_tzname_to_tzenum["America/Sao_Paulo"],
"Eastern Standard Time" => iana_tzname_to_tzenum["America/New_York"],
"Egypt Standard Time" => iana_tzname_to_tzenum["Africa/Cairo"],
"Ekaterinburg Standard Time" => iana_tzname_to_tzenum["Asia/Yekaterinburg"],
"Fiji Standard Time" => iana_tzname_to_tzenum["Pacific/Fiji"],
"FLE Standard Time" => iana_tzname_to_tzenum["Europe/Helsinki"],
"Georgian Standard Time" => iana_tzname_to_tzenum["Asia/Tbilisi"],
"GFT Standard Time" => iana_tzname_to_tzenum["Europe/Athens"],
#"GMT" => iana_tzname_to_tzenum["GMT"],
"GMT Standard Time" => iana_tzname_to_tzenum["Europe/London"],
"Greenland Standard Time" => iana_tzname_to_tzenum["America/Godthab"],
#"Greenwich" => iana_tzname_to_tzenum["GMT"],
#"Greenwich Standard Time" => iana_tzname_to_tzenum["GMT"],
"GTB Standard Time" => iana_tzname_to_tzenum["Europe/Athens"],
"Hawaiian Standard Time" => iana_tzname_to_tzenum["Pacific/Honolulu"],
"India Standard Time" => iana_tzname_to_tzenum["Asia/Choibalsan"],
"Iran Standard Time" => iana_tzname_to_tzenum["Asia/Tehran"],
"Israel Standard Time" => iana_tzname_to_tzenum["Asia/Jerusalem"],
"Jordan Standard Time" => iana_tzname_to_tzenum["Asia/Amman"],
"Korea Standard Time" => iana_tzname_to_tzenum["Asia/Seoul"],
"Mexico Standard Time" => iana_tzname_to_tzenum["America/Mexico_City"],
"Mexico Standard Time 2" => iana_tzname_to_tzenum["America/Chihuahua"],
"Mid-Atlantic Standard Time" => iana_tzname_to_tzenum["Atlantic/South_Georgia"],
"Middle East Standard Time" => iana_tzname_to_tzenum["Asia/Beirut"],
"Mountain Standard Time" => iana_tzname_to_tzenum["America/Denver"],
"Mountain Standard Time (Mexico)" => iana_tzname_to_tzenum["America/Chihuahua"],
"Myanmar Standard Time" => iana_tzname_to_tzenum["Asia/Rangoon"],
"N. Central Asia Standard Time" => iana_tzname_to_tzenum["Asia/Novosibirsk"],
"Namibia Standard Time" => iana_tzname_to_tzenum["Africa/Windhoek"],
"Nepal Standard Time" => iana_tzname_to_tzenum["Asia/Kathmandu"],
"New Zealand Standard Time" => iana_tzname_to_tzenum["Pacific/Auckland"],
"Newfoundland Standard Time" => iana_tzname_to_tzenum["America/St_Johns"],
"North Asia East Standard Time" => iana_tzname_to_tzenum["Asia/Ulaanbaatar"],
"North Asia Standard Time" => iana_tzname_to_tzenum["Asia/Krasnoyarsk"],
"Pacific SA Standard Time" => iana_tzname_to_tzenum["America/Santiago"],
"Pacific Standard Time" => iana_tzname_to_tzenum["America/Los_Angeles"],
"Pacific Standard Time (Mexico)" => iana_tzname_to_tzenum["America/Tijuana"],
"Prague Bratislava" => iana_tzname_to_tzenum["Europe/Prague"],
"Romance Standard Time" => iana_tzname_to_tzenum["Europe/Paris"],
"Russian Standard Time" => iana_tzname_to_tzenum["Europe/Moscow"],
"SA Eastern Standard Time" => iana_tzname_to_tzenum["America/Argentina/Buenos_Aires"],
"SA Pacific Standard Time" => iana_tzname_to_tzenum["America/Bogota"],
"SA Western Standard Time" => iana_tzname_to_tzenum["America/Caracas"],
"Samoa Standard Time" => iana_tzname_to_tzenum["Pacific/Apia"],
"Saudi Arabia Standard Time" => iana_tzname_to_tzenum["Asia/Riyadh"],
"SE Asia Standard Time" => iana_tzname_to_tzenum["Asia/Bangkok"],
"Singapore Standard Time" => iana_tzname_to_tzenum["Asia/Singapore"],
"South Africa Standard Time" => iana_tzname_to_tzenum["Africa/Harare"],
"Sri Lanka Standard Time" => iana_tzname_to_tzenum["Asia/Colombo"],
"Sydney Standard Time" => iana_tzname_to_tzenum["Australia/Sydney"],
"Taipei Standard Time" => iana_tzname_to_tzenum["Asia/Taipei"],
"Tasmania Standard Time" => iana_tzname_to_tzenum["Australia/Hobart"],
"Tokyo Standard Time" => iana_tzname_to_tzenum["Asia/Tokyo"],
"Tonga Standard Time" => iana_tzname_to_tzenum["Pacific/Tongatapu"],
"US Eastern Standard Time" => iana_tzname_to_tzenum["America/Indiana/Indianapolis"],
"US Mountain Standard Time" => iana_tzname_to_tzenum["America/Phoenix"],
"Vladivostok Standard Time" => iana_tzname_to_tzenum["Asia/Vladivostok"],
"W. Australia Standard Time" => iana_tzname_to_tzenum["Australia/Perth"],
"W. Central Africa Standard Time" => iana_tzname_to_tzenum["Africa/Luanda"],
"W. Europe Standard Time" => iana_tzname_to_tzenum["Europe/Berlin"],
# "Warsaw" => iana_tzname_to_tzenum["Europe/Warsaw"],
"West Asia Standard Time" => iana_tzname_to_tzenum["Asia/Karachi"],
"West Pacific Standard Time" => iana_tzname_to_tzenum["Pacific/Guam"],
"Western Brazilian Standard Time" => iana_tzname_to_tzenum["America/Rio_Branco"],
"Yakutsk Standard Time" => iana_tzname_to_tzenum["Asia/Yakutsk"],
}


# add in windows timezone IDs (not used in reverse lookup)
for (k,v) in win_tzid_to_iana_tznum
   _tzname_to_tznum[k] = v + tznum_offset
   # add windows display name form
   # if ((strlen(k) > 13) && (k[(end-13):end] == " Standard Time"))
   #   nm = k[1:(end-14)]
   #   if (nm != "GMT")
   #      _tzname_to_tznum[ k[1:(end-14)] ] = v + tznum_offset
   #   end   
   # end
end

fio = open(tm4julia_data("_tzname_to_tznum.jld"),"w")
serialize(fio,_tzname_to_tznum)
close(fio)

fio = open(tm4julia_data("_tznum_to_tzname.jld"),"w")
serialize(fio,_tznum_to_tzname)
close(fio)




function gte_search(a::Array{Int,1}, x::Int)
  # Define f(0) == false and f(length(a)+1)== true.
  # Invariant: f(i-1) == false, f(j) == true.
  i, j = 1, (length(a)+1)
  while(i < j)
    h = i + ((j-i) >> 1) # i <= h < j, avoids overflow
    if (a[h] <= x)
      i = h + 1        # preserves f(i-1) == false
    else
      j = h            # preserves f(j) == true
    end
  end
  # i == j, f(i-1) == false, and f(j) (= f(i)) == true  =>  answer is i.
  return i-1
end

# function get_gmt2lcl(tz::tzdata,gmtsec)
#   idx = gte_search(tz.gmtsecs, gmtsec)
#   if (idx > 0)
#      tz.gmt2lcl[idx]
#   else
#      tz.gmt2std
#   end
# end




