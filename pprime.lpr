program pprime;

uses
  DateUtils,
  SysUtils;

const
  MAX_DELKA_DEC = 200;
  MAX_DELKA_BASE = 80;
  POCET_MALYCH_PRVOCISEL = 998;
  MAX_DELKA_BIN = 1330;
  VYSTUPNI_SOUBOR = 'vystup.txt';
  PRESNOST = 5;
  BASE = 2097151;
  BASE_HALF = 1048575;
type
  dlouheCislo = array [0..MAX_DELKA_DEC] of byte;

type
  dCislo = array [0..MAX_DELKA_BASE] of longint;
type
  cisloT = record
    cislo: dlouheCislo;
    delka: integer;
    isNegative: boolean;
  end;

type
  cisloLT = record
    cislo: dCislo;
    delka: integer;
    isNegative: boolean;
  end;
type
  dlouheCisloBin = array [1..MAX_DELKA_BIN] of boolean;
type
  cisloBin = record
    delka: integer;
    cislo: dlouheCisloBin;
  end;
type
  vysledekFaktorizace = record
    exponent: integer;
    zbytek: cisloT;
  end;
type
  vysledekFaktorizace2 = record
    exponent: integer;
    zbytek: cisloLT;
  end;
type
  vysledekDeleniDec = record
    quot: cisloT;
    rem: cisloT;
  end;

type
  vysledekDeleniBase = record
    quot: cisloLT;
    rem: cisloLT;
  end;
type
  vysledekDeleniDvema = record
    vysl: cisloT;
    zbytek: byte;
  end;
var
  prazdneCislo: cisloT;
  prazdneCislo2, DVA: cisloLT;
  prazdneCisloBin : cisloBin;
var
  malaPrvocisla: array[1..POCET_MALYCH_PRVOCISEL] of cisloLT;
var
  malaPrvocislaString: array[1..POCET_MALYCH_PRVOCISEL] of
  string[4] = ('3', '7', '11', '13', '17', '19', '23', '29', '31',
    '37', '41', '43', '47', '53', '59', '61', '67', '71', '73', '79',
    '83', '89', '97', '101', '103', '107', '109', '113', '127', '131',
    '137', '139', '149', '151', '157', '163', '167', '173', '179',
    '181', '191', '193', '197', '199', '211', '223', '227', '229',
    '233', '239', '241', '251', '257', '263', '269', '271', '277',
    '281', '283', '293', '307', '311', '313', '317', '331', '337',
    '347', '349', '353', '359', '367', '373', '379', '383', '389',
    '397', '401', '409', '419', '421', '431', '433', '439', '443',
    '449', '457', '461', '463', '467', '479', '487', '491', '499',
    '503', '509', '521', '523', '541', '547', '557', '563', '569',
    '571', '577', '587', '593', '599', '601', '607', '613', '617',
    '619', '631', '641', '643', '647', '653', '659', '661', '673',
    '677', '683', '691', '701', '709', '719', '727', '733', '739',
    '743', '751', '757', '761', '769', '773', '787', '797', '809',
    '811', '821', '823', '827', '829', '839', '853', '857', '859',
    '863', '877', '881', '883', '887', '907', '911', '919', '929',
    '937', '941', '947', '953', '967', '971', '977', '983', '991',
    '997', '1009', '1013', '1019', '1021', '1031', '1033', '1039',
    '1049', '1051', '1061', '1063', '1069', '1087', '1091', '1093',
    '1097', '1103', '1109', '1117', '1123', '1129', '1151', '1153',
    '1163', '1171', '1181', '1187', '1193', '1201', '1213', '1217',
    '1223', '1229', '1231', '1237', '1249', '1259', '1277', '1279',
    '1283', '1289', '1291', '1297', '1301', '1303', '1307', '1319',
    '1321', '1327', '1361', '1367', '1373', '1381', '1399', '1409',
    '1423', '1427', '1429', '1433', '1439', '1447', '1451', '1453',
    '1459', '1471', '1481', '1483', '1487', '1489', '1493', '1499',
    '1511', '1523', '1531', '1543', '1549', '1553', '1559', '1567',
    '1571', '1579', '1583', '1597', '1601', '1607', '1609', '1613',
    '1619', '1621', '1627', '1637', '1657', '1663', '1667', '1669',
    '1693', '1697', '1699', '1709', '1721', '1723', '1733', '1741',
    '1747', '1753', '1759', '1777', '1783', '1787', '1789', '1801',
    '1811', '1823', '1831', '1847', '1861', '1867', '1871', '1873',
    '1877', '1879', '1889', '1901', '1907', '1913', '1931', '1933',
    '1949', '1951', '1973', '1979', '1987', '1993', '1997', '1999',
    '2003', '2011', '2017', '2027', '2029', '2039', '2053', '2063',
    '2069', '2081', '2083', '2087', '2089', '2099', '2111', '2113',
    '2129', '2131', '2137', '2141', '2143', '2153', '2161', '2179',
    '2203', '2207', '2213', '2221', '2237', '2239', '2243', '2251',
    '2267', '2269', '2273', '2281', '2287', '2293', '2297', '2309',
    '2311', '2333', '2339', '2341', '2347', '2351', '2357', '2371',
    '2377', '2381', '2383', '2389', '2393', '2399', '2411', '2417',
    '2423', '2437', '2441', '2447', '2459', '2467', '2473', '2477',
    '2503', '2521', '2531', '2539', '2543', '2549', '2551', '2557',
    '2579', '2591', '2593', '2609', '2617', '2621', '2633', '2647',
    '2657', '2659', '2663', '2671', '2677', '2683', '2687', '2689',
    '2693', '2699', '2707', '2711', '2713', '2719', '2729', '2731',
    '2741', '2749', '2753', '2767', '2777', '2789', '2791', '2797',
    '2801', '2803', '2819', '2833', '2837', '2843', '2851', '2857',
    '2861', '2879', '2887', '2897', '2903', '2909', '2917', '2927',
    '2939', '2953', '2957', '2963', '2969', '2971', '2999', '3001',
    '3011', '3019', '3023', '3037', '3041', '3049', '3061', '3067',
    '3079', '3083', '3089', '3109', '3119', '3121', '3137', '3163',
    '3167', '3169', '3181', '3187', '3191', '3203', '3209', '3217',
    '3221', '3229', '3251', '3253', '3257', '3259', '3271', '3299',
    '3301', '3307', '3313', '3319', '3323', '3329', '3331', '3343',
    '3347', '3359', '3361', '3371', '3373', '3389', '3391', '3407',
    '3413', '3433', '3449', '3457', '3461', '3463', '3467', '3469',
    '3491', '3499', '3511', '3517', '3527', '3529', '3533', '3539',
    '3541', '3547', '3557', '3559', '3571', '3581', '3583', '3593',
    '3607', '3613', '3617', '3623', '3631', '3637', '3643', '3659',
    '3671', '3673', '3677', '3691', '3697', '3701', '3709', '3719',
    '3727', '3733', '3739', '3761', '3767', '3769', '3779', '3793',
    '3797', '3803', '3821', '3823', '3833', '3847', '3851', '3853',
    '3863', '3877', '3881', '3889', '3907', '3911', '3917', '3919',
    '3923', '3929', '3931', '3943', '3947', '3967', '3989', '4001',
    '4003', '4007', '4013', '4019', '4021', '4027', '4049', '4051',
    '4057', '4073', '4079', '4091', '4093', '4099', '4111', '4127',
    '4129', '4133', '4139', '4153', '4157', '4159', '4177', '4201',
    '4211', '4217', '4219', '4229', '4231', '4241', '4243', '4253',
    '4259', '4261', '4271', '4273', '4283', '4289', '4297', '4327',
    '4337', '4339', '4349', '4357', '4363', '4373', '4391', '4397',
    '4409', '4421', '4423', '4441', '4447', '4451', '4457', '4463',
    '4481', '4483', '4493', '4507', '4513', '4517', '4519', '4523',
    '4547', '4549', '4561', '4567', '4583', '4591', '4597', '4603',
    '4621', '4637', '4639', '4643', '4649', '4651', '4657', '4663',
    '4673', '4679', '4691', '4703', '4721', '4723', '4729', '4733',
    '4751', '4759', '4783', '4787', '4789', '4793', '4799', '4801',
    '4813', '4817', '4831', '4861', '4871', '4877', '4889', '4903',
    '4909', '4919', '4931', '4933', '4937', '4943', '4951', '4957',
    '4967', '4969', '4973', '4987', '4993', '4999', '5003', '5009',
    '5011', '5021', '5023', '5039', '5051', '5059', '5077', '5081',
    '5087', '5099', '5101', '5107', '5113', '5119', '5147', '5153',
    '5167', '5171', '5179', '5189', '5197', '5209', '5227', '5231',
    '5233', '5237', '5261', '5273', '5279', '5281', '5297', '5303',
    '5309', '5323', '5333', '5347', '5351', '5381', '5387', '5393',
    '5399', '5407', '5413', '5417', '5419', '5431', '5437', '5441',
    '5443', '5449', '5471', '5477', '5479', '5483', '5501', '5503',
    '5507', '5519', '5521', '5527', '5531', '5557', '5563', '5569',
    '5573', '5581', '5591', '5623', '5639', '5641', '5647', '5651',
    '5653', '5657', '5659', '5669', '5683', '5689', '5693', '5701',
    '5711', '5717', '5737', '5741', '5743', '5749', '5779', '5783',
    '5791', '5801', '5807', '5813', '5821', '5827', '5839', '5843',
    '5849', '5851', '5857', '5861', '5867', '5869', '5879', '5881',
    '5897', '5903', '5923', '5927', '5939', '5953', '5981', '5987',
    '6007', '6011', '6029', '6037', '6043', '6047', '6053', '6067',
    '6073', '6079', '6089', '6091', '6101', '6113', '6121', '6131',
    '6133', '6143', '6151', '6163', '6173', '6197', '6199', '6203',
    '6211', '6217', '6221', '6229', '6247', '6257', '6263', '6269',
    '6271', '6277', '6287', '6299', '6301', '6311', '6317', '6323',
    '6329', '6337', '6343', '6353', '6359', '6361', '6367', '6373',
    '6379', '6389', '6397', '6421', '6427', '6449', '6451', '6469',
    '6473', '6481', '6491', '6521', '6529', '6547', '6551', '6553',
    '6563', '6569', '6571', '6577', '6581', '6599', '6607', '6619',
    '6637', '6653', '6659', '6661', '6673', '6679', '6689', '6691',
    '6701', '6703', '6709', '6719', '6733', '6737', '6761', '6763',
    '6779', '6781', '6791', '6793', '6803', '6823', '6827', '6829',
    '6833', '6841', '6857', '6863', '6869', '6871', '6883', '6899',
    '6907', '6911', '6917', '6947', '6949', '6959', '6961', '6967',
    '6971', '6977', '6983', '6991', '6997', '7001', '7013', '7019',
    '7027', '7039', '7043', '7057', '7069', '7079', '7103', '7109',
    '7121', '7127', '7129', '7151', '7159', '7177', '7187', '7193',
    '7207', '7211', '7213', '7219', '7229', '7237', '7243', '7247',
    '7253', '7283', '7297', '7307', '7309', '7321', '7331', '7333',
    '7349', '7351', '7369', '7393', '7411', '7417', '7433', '7451',
    '7457', '7459', '7477', '7481', '7487', '7489', '7499', '7507',
    '7517', '7523', '7529', '7537', '7541', '7547', '7549', '7559',
    '7561', '7573', '7577', '7583', '7589', '7591', '7603', '7607',
    '7621', '7639', '7643', '7649', '7669', '7673', '7681', '7687',
    '7691', '7699', '7703', '7717', '7723', '7727', '7741', '7753',
    '7757', '7759', '7789', '7793', '7817', '7823', '7829', '7841',
    '7853', '7867', '7873', '7877', '7879', '7883', '7901', '7907', '7919');

var
  celkemMs, pocetExp: longint;
var
  BASE_CISLO_DEC: cisloT;
  BASE_CISLO : cisloLT;

  procedure vynuluj(var c: cisloT);
  var
    i: integer;
  begin
    for i := (c.delka + 1) to MAX_DELKA_DEC do
      c.cislo[i] := 0;
  end;

  procedure vynuluj2(var c: cisloLT);
  var
    i: integer;
  begin
    for i := (c.delka + 1) to MAX_DELKA_BASE do
      c.cislo[i] := 0;
  end;

  procedure init(var c: cisloT);
  begin
    c := prazdneCislo;
  end;

  procedure init2(var c: cisloLT);
  begin
    c := prazdneCislo2;
  end;

  procedure initBin(var c: cisloBin);
  begin
    c := prazdneCisloBin;
  end;

  procedure vypisCisloDec(c: cisloT; writeDelka: boolean; msg: string);
  var
    i: integer;
  begin
    if (length(msg) > 0) then
      Write(msg, ': ');
    if (writeDelka) then
      Write('d: ', c.delka, ' | ');
    if (c.isNegative) then
      Write('-');
    for i := 1 to c.delka do
    begin
      if (c.cislo[i] > 9) then
        Write(' ');
      Write(c.cislo[i]);
      if (c.cislo[i] > 9) then
        Write(' ');
    end;
    writeln;
    writeln;
  end;

  procedure vypisCisloBase(c: cisloLT; writeDelka: boolean; msg: string);
  var
    i: integer;
  begin
    if (length(msg) > 0) then
      Write(msg, ': ');
    if (writeDelka) then
      Write('d: ', c.delka, ' | ');
    if (c.isNegative) then
      Write('-');
    for i := 1 to c.delka do
    begin
      Write(' ');
      Write(c.cislo[i]);
      Write(' ');
    end;
    writeln;
    writeln;
  end;

  function generujPrvocislo(delka: byte): cisloT;
  var
    p: cisloT;
  var
    i: byte;
  var
    lichaCisla: array[1..4] of byte = (1, 3, 7, 9);
  begin
    init(p);
    p.cislo[1] := Random(9) + 1;
    for i := 2 to delka do
    begin
      if (i <> delka) then
        p.cislo[i] := Random(10)
      else
        p.cislo[delka] := lichaCisla[Random(4) + 1];
    end;
    p.delka := delka;
    generujPrvocislo := p;
  end;

{
1 : c1>c2
0 : c1=c2
2 : c1<c2
musí byt ve formatu ze na cislo[1] je nejmensi cifra
}
  function porovnaniDec(var c1, c2: cisloT): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnaniDec := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnaniDec := 2
      else //stejna delka
      begin
        i := c1.delka;
        while ((c1.cislo[i] = c2.cislo[i]) and (i > 0)) do
          i := i - 1;
        if (i = 0) then
          porovnaniDec := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
            porovnaniDec := 1
          else
            porovnaniDec := 2;
        end;
      end;
    end;
  end;

  function porovnaniBase(var c1, c2: cisloLT): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnaniBase := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnaniBase := 2
      else //stejna delka
      begin
        i := c1.delka;
        while ((i > 0) and (c1.cislo[i] = c2.cislo[i])) do
          i := i - 1;
        if (i = 0) then
          porovnaniBase := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
          begin
            porovnaniBase := 1;
          end
          else
            porovnaniBase := 2;
        end;
      end;
    end;
  end;
  //2<=n<hodniHranice
  function generujNahodneCisloMensiNez(var horniHranice: cisloLT): cisloLT;
  var
    i: integer;
  var
    nahodneCislo: cisloLT;
  begin
    init2(nahodneCislo);
    repeat
      nahodneCislo.delka := Random(horniHranice.delka) + 1;
      nahodneCislo.cislo[nahodneCislo.delka] :=
        Random(horniHranice.cislo[horniHranice.delka]) + 1;
      for i := 1 to nahodneCislo.delka - 1 do
      begin
        nahodneCislo.cislo[i] := Random(2097151);
      end;
    until ((porovnaniBase(horniHranice, nahodneCislo) = 1) and
        ((nahodneCislo.delka > 1) or (nahodneCislo.cislo[1] > 1)));
    generujNahodneCisloMensiNez := nahodneCislo;
  end;

  function otocCisloDec(c: cisloT): cisloT;
  var
    zac, kon, temp: integer;
  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocCisloDec := c;
  end;

  function otocCisloBase(c: cisloLT): cisloLT;
  var
    zac, kon: integer;
    temp: longint;

  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocCisloBase := c;
  end;

  function sectiDec(c1, c2: cisloT): cisloT;
  var
    vysledek: cisloT;
  var
    delka, i: integer;
  var
    zb: byte;
  begin
    init(vysledek);
    delka := 0;
    zb := 0;
    if (porovnaniDec(c1, c2) = 1) then
      delka := c1.delka
    else
      delka := c2.delka;
    for i := 1 to delka do
    begin
      vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
      zb := vysledek.cislo[i] div 10;
      if (zb > 0) then
        vysledek.cislo[i] := vysledek.cislo[i] mod 10;
    end;
    if (zb > 0) then
    begin
      vysledek.delka := delka + 1;
      vysledek.cislo[vysledek.delka] := zb;
    end
    else
      vysledek.delka := delka;
    sectiDec := vysledek;
  end;

  function sectiDecVar(var c1, c2: cisloT): cisloT;
  var
    vysledek: cisloT;
  var
    delka, i: integer;
  var
    zb: byte;
  begin
    init(vysledek);
    delka := 0;
    zb := 0;
    if (porovnaniDec(c1, c2) = 1) then
      delka := c1.delka
    else
      delka := c2.delka;
    for i := 1 to delka do
    begin
      vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
      zb := vysledek.cislo[i] div 10;
      if (zb > 0) then
        vysledek.cislo[i] := vysledek.cislo[i] mod 10;
    end;
    if (zb > 0) then
    begin
      vysledek.delka := delka + 1;
      vysledek.cislo[vysledek.delka] := zb;
    end
    else
      vysledek.delka := delka;
    sectiDecVar := vysledek;
  end;


  function sectiBase(c1, c2: cisloLT): cisloLT;
  var
    vysledek: cisloLT;
  var
    delka, i: integer;
  var
    zb: longint;
  begin
    init2(vysledek);
    delka := 0;
    zb := 0;
    if (porovnaniBase(c1, c2) = 1) then
      delka := c1.delka
    else
      delka := c2.delka;
    for i := 1 to delka do
    begin
      vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
      zb := vysledek.cislo[i] div BASE;
      if (zb > 0) then
        vysledek.cislo[i] := vysledek.cislo[i] mod BASE;
    end;
    if (zb > 0) then
    begin
      vysledek.delka := delka + 1;
      vysledek.cislo[vysledek.delka] := zb;
    end
    else
      vysledek.delka := delka;
    sectiBase := vysledek;
  end;

  function sectiBaseVar(var c1, c2: cisloLT): cisloLT;
  var
    vysledek: cisloLT;
  var
    delka, i: integer;
  var
    zb: longint;
  begin
    init2(vysledek);
    delka := 0;
    zb := 0;
    if (porovnaniBase(c1, c2) = 1) then
      delka := c1.delka
    else
      delka := c2.delka;
    for i := 1 to delka do
    begin
      vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
      zb := vysledek.cislo[i] div BASE;
      if (zb > 0) then
        vysledek.cislo[i] := vysledek.cislo[i] mod BASE;
    end;
    if (zb > 0) then
    begin
      vysledek.delka := delka + 1;
      vysledek.cislo[vysledek.delka] := zb;
    end
    else
      vysledek.delka := delka;
    sectiBaseVar := vysledek;
  end;

  function vynasobDec(var c1, c2: cisloT): cisloT;
  var
    vysl: cisloT;
  var
    i, j, c, temp: integer;
  begin
    init(vysl);
    if ((c1.delka < 2) and (c1.cislo[1] = 0)) then
    begin
      vynasobDec := vysl;
      exit;
    end;
    for i := 0 to (c2.delka - 1) do
    begin
      c := 0;
      for j := 0 to (c1.delka - 1) do
      begin
        temp := vysl.cislo[i + j + 1] + (c1.cislo[j + 1] * c2.cislo[i + 1]) + c;
        vysl.cislo[i + j + 1] := temp mod 10;
        c := temp div 10;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
      if (vysl.cislo[i + c1.delka + 1] > 0) then
        vysl.delka := i + c1.delka + 1
      else
        vysl.delka := i + c1.delka;
    end;
    vysl.isNegative := c1.isNegative xor c2.isNegative;
    vynasobDec := vysl;
  end;

  function vynasobBase(var c1, c2: cisloLT): cisloLT;
  var
    vysl: cisloLT;
  var
    i, j: integer;
  var
    c, temp: int64;

  begin
    init2(vysl);
    if ((c1.delka < 2) and (c1.cislo[1] = 0)) then
    begin
      vynasobBase := vysl;
      exit;
    end;
    for i := 0 to (c2.delka - 1) do
    begin
      c := 0;
      for j := 0 to (c1.delka - 1) do
      begin
        temp := vysl.cislo[i + j + 1] + (c1.cislo[j + 1] * c2.cislo[i + 1]) + c;
        vysl.cislo[i + j + 1] := temp mod BASE;
        c := temp div BASE;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
      if (vysl.cislo[i + c1.delka + 1] > 0) then
        vysl.delka := i + c1.delka + 1
      else
        vysl.delka := i + c1.delka;
    end;
    vysl.isNegative := c1.isNegative xor c2.isNegative;
    vynasobBase := vysl;
  end;

  function vynasobDeseti(c1: cisloT; kolikrat: integer): cisloT;
  var
    i: integer;
  begin
    if (kolikrat <= 0) then
    begin
      vynasobDeseti := c1;
      exit;
    end;
    if (c1.delka + kolikrat > MAX_DELKA_DEC) then
    begin
      writeln('CHYBA delka');
      halt(1);
    end;
    for i := c1.delka downto 1 do
    begin
      c1.cislo[i + kolikrat] := c1.cislo[i];
      c1.cislo[i] := 0;
    end;
    c1.delka := c1.delka + kolikrat;
    vynuluj(c1);
    vynasobDeseti := c1;
  end;

  function shiftLeft(c1: cisloLT; kolikrat: integer): cisloLT;
    {dolni jsou nejmensi <=> citelnyFormat = false}
  var
    i: integer;
  begin
    if (kolikrat <= 0) then
    begin
      shiftLeft := c1;
      exit;
    end;
    if (c1.delka + kolikrat > MAX_DELKA_BASE) then
    begin
      writeln('CHYBA delka');
      halt(1);
    end;
    for i := c1.delka downto 1 do
    begin
      c1.cislo[i + kolikrat] := c1.cislo[i];
      c1.cislo[i] := 0;
    end;
    c1.delka := c1.delka + kolikrat;
    vynuluj2(c1);
    shiftLeft := c1;
  end;


  function vydelDeseti(c1: cisloT; kolikrat: integer): cisloT;
    {dolni jsou nejmensi <=> citelnyFormat = false}
  var
    i: integer;
  begin
    if (kolikrat <= 0) then
    begin
      vydelDeseti := c1;
      exit;
    end;
    for i := 1 to c1.delka do
    begin
      if (i <= kolikrat) then
        c1.cislo[i] := 0
      else
        c1.cislo[i - kolikrat] := c1.cislo[i];
    end;
    c1.delka := c1.delka - kolikrat;
    vynuluj(c1);
    vydelDeseti := c1;
  end;

  function betterMod(i, modulus: int64): integer;
  var
    temp: int64;
  begin
    temp := i mod modulus;
    if (temp < 0) then
      temp := temp + modulus;
    betterMod := temp;
  end;

  function shiftRight(c1: cisloLT; kolikrat: integer): cisloLT;
    {dolni jsou nejmensi <=> citelnyFormat = false}
  var
    i: integer;
  begin
    if (kolikrat <= 0) then
    begin
      shiftRight := c1;
      exit;
    end;
    for i := 1 to c1.delka do
    begin
      if (i <= kolikrat) then
        c1.cislo[i] := 0
      else
        c1.cislo[i - kolikrat] := c1.cislo[i];
    end;
    c1.delka := c1.delka - kolikrat;
    vynuluj2(c1);
    shiftRight := c1;
  end;

  function odectiDec(var c1, c2: cisloT): cisloT;
  var
    vysledek, temp: cisloT;
  var
    delka, i, porov, zb: integer;
  begin
    init(vysledek);

    if ((not c1.isNegative) and c2.isNegative) then
    begin
      vysledek := sectiDecVar(c1, c2);
      odectiDec := vysledek;
      exit;
    end;

    if (c1.isNegative and (not c2.isNegative)) then
    begin
      vysledek := sectiDecVar(c1, c2);
      vysledek.isNegative := True;
      odectiDec := vysledek;
      exit;
    end;

    if (c1.isNegative and c2.isNegative) then
    begin
      init(temp);
      temp := c2;
      temp.isNegative := False;
      vysledek := odectiDec(temp, c1);
      odectiDec := vysledek;
      exit;
    end;

    porov := porovnaniDec(c1, c2);
    if (porov = 0) then
    begin
      odectiDec := vysledek;
      exit;
    end
    else if (porov = 2) then //c1 < c2, prohodime a vysledek je zaporny
    begin
      vysledek := odectiDec(c2, c1);
      vysledek.isNegative := True;
      odectiDec := vysledek;
      exit;
    end;
    delka := c1.delka;
    zb := 0;

    for i := 1 to delka do
    begin
      if (c1.cislo[i] < (c2.cislo[i] + zb)) then
      begin
        vysledek.cislo[i] := (c1.cislo[i] + 10) - (c2.cislo[i] + zb);
        zb := 1;
      end
      else
      begin
        vysledek.cislo[i] := c1.cislo[i] - (c2.cislo[i] + zb);
        zb := 0;
      end;
      if (vysledek.cislo[i] <> 0) then
        vysledek.delka := i;
    end;

    odectiDec := vysledek;
  end;

  function odectiBase(var c1, c2: cisloLT): cisloLT;
  var
    vysledek, temp: cisloLT;
  var
    delka, i, porov, zb: longint;
  begin
    init2(vysledek);

    if ((not c1.isNegative) and c2.isNegative) then
    begin
      vysledek := sectiBaseVar(c1, c2);
      odectiBase := vysledek;
      exit;
    end;

    if (c1.isNegative and (not c2.isNegative)) then
    begin
      vysledek := sectiBaseVar(c1, c2);
      vysledek.isNegative := True;
      odectiBase := vysledek;
      exit;
    end;

    if (c1.isNegative and c2.isNegative) then
    begin
      init2(temp);
      temp := c2;
      temp.isNegative := False;
      vysledek := odectiBase(temp, c1);
      odectiBase := vysledek;
      exit;
    end;

    porov := porovnaniBase(c1, c2);
    if (porov = 0) then
    begin
      odectiBase := vysledek;
      exit;
    end
    else if (porov = 2) then //c1 < c2, prohodime a vysledek je zaporny
    begin
      vysledek := odectiBase(c2, c1);
      vysledek.isNegative := True;
      odectiBase := vysledek;
      exit;
    end;
    delka := c1.delka;
    zb := 0;

    for i := 1 to delka do
    begin
      vysledek.cislo[i] := betterMod((c1.cislo[i] - c2.cislo[i]) + zb, BASE);
      if (((c1.cislo[i] - c2.cislo[i]) + zb) >= 0) then
        zb := 0
      else
        zb := -1;
      if (vysledek.cislo[i] <> 0) then
        vysledek.delka := i;
    end;
    odectiBase := vysledek;
  end;

  function vydelDec(var c1, c2: cisloT): vysledekDeleniDec;
  var
    vysl: vysledekDeleniDec;
  var
    vynasobeneDeseti, temp: cisloT;
  var
    t, n, i: integer;
  var
    longTemp, longTemp2: longint;
  begin
    if (c2.delka = 0) then
    begin
      writeln('DELENI NULOU');
      halt(1);
    end;
    init(vysl.rem);
    init(vysl.quot);
    init(vynasobeneDeseti);
    init(temp);
    vysl.rem := c1;
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobeneDeseti := vynasobDeseti(c2, n - t);
    while (porovnaniDec(vysl.rem, vynasobeneDeseti) <> 2) do
    begin
      vysl.quot.cislo[n - t + 1] := vysl.quot.cislo[n - t + 1] + 1;
      vysl.rem := odectiDec(vysl.rem, vynasobeneDeseti);
    end;
    for i := n downto c2.delka do
    begin
      if (vysl.rem.cislo[i + 1] = c2.cislo[c2.delka]) then
        vysl.quot.cislo[i - t] := 9
      else
      begin
        vysl.quot.cislo[i - t] :=
          (vysl.rem.cislo[i + 1] * 100 + vysl.rem.cislo[i] * 10 +
          vysl.rem.cislo[i - 1]) div (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      end;
      longTemp := vysl.quot.cislo[i - t] * (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      longTemp2 := vysl.rem.cislo[i + 1] * 100 + vysl.rem.cislo[i] *
        10 + vysl.rem.cislo[i - 1];
      while (longTemp > longTemp2) do
      begin
        vysl.quot.cislo[i - t] := vysl.quot.cislo[i - t] - 1;
      end;
      vynasobeneDeseti := vynasobDeseti(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := vysl.quot.cislo[i - t];
      temp := vynasobDec(temp, vynasobeneDeseti);
      vysl.rem := odectiDec(vysl.rem, temp);
      if (vysl.rem.isNegative = True) then
      begin
        vysl.rem.isNegative := False;
        vysl.rem := odectiDec(vynasobeneDeseti, vysl.rem);
        vysl.quot.cislo[i - t] := vysl.quot.cislo[i - t] - 1;
      end;
    end;
    for i := n - t + 1 downto 1 do
    begin
      if (vysl.quot.cislo[i] <> 0) then
      begin
        vysl.quot.delka := i;
        break;
      end;
    end;
    vydelDec := vysl;
  end;

  function vydelBase(c1, c2: cisloLT): cisloLT;
  var
    vysl, vynasobene, temp, norm: cisloLT;
  var
    t, n, i: integer;
  var
    tempInt, q: int64;
  var
    normalizeQuot: longint;
  begin
    if (c2.delka = 0) then
    begin
      writeln('DELENI NULOU');
      halt(1);
    end;

    init2(norm);
    normalizeQuot := 1;
    if (c2.cislo[c2.delka] < BASE_HALF) then
    begin
      normalizeQuot := (BASE_HALF div c2.cislo[c2.delka]) + 1;
      norm.delka := 1;
      norm.cislo[1] := normalizeQuot;
      c1 := vynasobBase(c1, norm);
      c2 := vynasobBase(c2, norm);
    end;
    init2(vysl);
    init2(vynasobene);
    init2(temp);
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobene := shiftLeft(c2, n - t);
    while (porovnaniBase(c1, vynasobene) <> 2) do
    begin
      vysl.cislo[n - t + 1] := vysl.cislo[n - t + 1] + 1;
      c1 := odectiBase(c1, vynasobene);
    end;
    for i := n downto c2.delka do
    begin
      tempInt := (c1.cislo[i + 1] * (BASE * BASE) + c1.cislo[i] *
        BASE + c1.cislo[i - 1]);
      if (c1.cislo[i + 1] = c2.cislo[c2.delka]) then
        q := BASE - 1
      else
      begin
        q := tempInt div (c2.cislo[c2.delka] * BASE + c2.cislo[t]);
      end;
      while ((q * (c2.cislo[c2.delka] * BASE + c2.cislo[t])) > tempInt) do
      begin
        q := q - 1;
      end;
      vynasobene := shiftLeft(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := q;
      temp := vynasobBase(temp, vynasobene);
      c1 := odectiBase(c1, temp);
      if (c1.isNegative = True) then
      begin
        c1.isNegative := False;
        c1 := odectiBase(vynasobene, c1);
        q := q - 1;
      end;
      vysl.cislo[i - t] := q;
    end;
    for i := n - t + 1 downto 1 do
    begin
      if (vysl.cislo[i] <> 0) then
      begin
        vysl.delka := i;
        break;
      end;
    end;
    vydelBase := vysl;
  end;

  function vydelBaseWithRem(var c1: cisloLT; c2: cisloLT): vysledekDeleniBase;
  var
    vysl: vysledekDeleniBase;
  var
    vynasobene, temp, norm: cisloLT;
  var
    t, n, i: integer;
  var
    tempInt, q: int64;
  var
    normalizeQuot: longint;
  begin
    if (c2.delka = 0) then
    begin
      writeln('DELENI NULOU');
      halt(1);
    end;
    init2(norm);
    init2(vysl.quot);
    init2(vysl.rem);
    normalizeQuot := 1;
    vysl.rem := c1;   //vysl.rem = c1
    if (c2.cislo[c2.delka] < BASE_HALF) then
    begin
      normalizeQuot := (BASE_HALF div c2.cislo[c2.delka]) + 1;
      norm.delka := 1;
      norm.cislo[1] := normalizeQuot;
      vysl.rem := vynasobBase(vysl.rem, norm);
      c2 := vynasobBase(c2, norm);
    end;
    init2(vynasobene);
    init2(temp);
    n := vysl.rem.delka - 1;
    t := c2.delka - 1;
    vynasobene := shiftLeft(c2, n - t);
    while (porovnaniBase(vysl.rem, vynasobene) <> 2) do
    begin
      vysl.quot.cislo[n - t + 1] := vysl.quot.cislo[n - t + 1] + 1;
      vysl.rem := odectiBase(vysl.rem, vynasobene);
    end;
    for i := n downto c2.delka do
    begin
      tempInt := (vysl.rem.cislo[i + 1] * (BASE * BASE) + vysl.rem.cislo[i] *
        BASE + vysl.rem.cislo[i - 1]);
      if (vysl.rem.cislo[i + 1] = c2.cislo[c2.delka]) then
        q := BASE - 1
      else
      begin
        q := tempInt div (c2.cislo[c2.delka] * BASE + c2.cislo[t]);
      end;
      while ((q * (c2.cislo[c2.delka] * BASE + c2.cislo[t])) > tempInt) do
      begin
        q := q - 1;
      end;
      vynasobene := shiftLeft(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := q;
      temp := vynasobBase(temp, vynasobene);
      vysl.rem := odectiBase(vysl.rem, temp);
      if (vysl.rem.isNegative = True) then
      begin
        vysl.rem.isNegative := False;
        vysl.rem := odectiBase(vynasobene, vysl.rem);
        q := q - 1;
      end;
      vysl.quot.cislo[i - t] := q;
    end;
    for i := n - t + 1 downto 1 do
    begin
      if (vysl.quot.cislo[i] <> 0) then
      begin
        vysl.quot.delka := i;
        break;
      end;
    end;
    vydelBaseWithRem := vysl;
  end;

  function moduloDec(c1: cisloT; var c2: cisloT): cisloT;
  var
    vynasobeneDeseti, temp: cisloT;
  var
    t, n, i: integer;
  var
    longTemp, longTemp2: longint;
  var
    q: byte;
  begin
    if (c2.delka = 0) then
    begin
      writeln('DELENI NULOU');
      halt(1);
    end;
    init(vynasobeneDeseti);
    init(temp);
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobeneDeseti := vynasobDeseti(c2, n - t);
    while (porovnaniDec(c1, vynasobeneDeseti) <> 2) do
      c1 := odectiDec(c1, vynasobeneDeseti);
    for i := n downto c2.delka do
    begin
      longTemp2 := c1.cislo[i + 1] * 100 + c1.cislo[i] * 10 + c1.cislo[i - 1];
      if (c1.cislo[i + 1] = c2.cislo[c2.delka]) then
      begin
        q := 9;
      end
      else
      begin
        q := longTemp2 div (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      end;
      longTemp := q * (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      while (longTemp > longTemp2) do
      begin
        q := q - 1;
      end;
      vynasobeneDeseti := vynasobDeseti(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := q;
      temp := vynasobDec(temp, vynasobeneDeseti);
      c1 := odectiDec(c1, temp);
      if (c1.isNegative = True) then
      begin
        c1.isNegative := False;
        c1 := odectiDec(vynasobeneDeseti, c1);
      end;
    end;
    moduloDec := c1;
  end;

  function moduloBase(c1: cisloLT; c2: cisloLT): cisloLT;
  var
    vynasobene, temp, norm: cisloLT;
  var
    t, n, i: integer;
  var
    q, tempInt: int64;
  var
    normalizeQuot: longint;
  var
    normalizationUsed: boolean;

  begin
    if (c2.delka = 0) then
    begin
      writeln('DELENI NULOU');
      halt(1);
    end;
    if(porovnaniBase(c1,c2) = 2) then
    begin
      exit(c1);
    end;
    init2(vynasobene);
    init2(temp);
    init2(norm);
    normalizeQuot := 1;
    normalizationUsed := False;
    if (c2.cislo[c2.delka] < BASE_HALF) then
    begin
      normalizeQuot := (BASE_HALF div c2.cislo[c2.delka]) + 1;
      normalizationUsed := True;
      norm.delka := 1;
      norm.cislo[1] := normalizeQuot;
      c1 := vynasobBase(c1, norm);
      c2 := vynasobBase(c2, norm);
    end;
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobene := shiftLeft(c2, n - t);
    while (porovnaniBase(c1, vynasobene) <> 2) do
    begin
      c1 := odectiBase(c1, vynasobene);
    end;
    for i := n downto c2.delka do
    begin
      tempInt := (c1.cislo[i + 1] * (BASE * BASE) + c1.cislo[i] *
        BASE + c1.cislo[i - 1]);
      if (c1.cislo[i + 1] = c2.cislo[c2.delka]) then
        q := BASE - 1
      else
      begin
        q := tempInt div (c2.cislo[c2.delka] * BASE + c2.cislo[t]);
      end;
      while ((q * (c2.cislo[c2.delka] * BASE + c2.cislo[t])) > tempInt) do
      begin
        q := q - 1;
      end;
      vynasobene := shiftLeft(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := q;
      temp := vynasobBase(temp, vynasobene);
      c1 := odectiBase(c1, temp);
      if (c1.isNegative = True) then
      begin
        c1.isNegative := False;
        c1 := odectiBase(vynasobene, c1);
      end;
    end;
    if (normalizationUsed and (c1.delka <> 0)) then
    begin
      c1 := vydelBase(c1, norm);
    end;
    moduloBase := c1;
  end;


  function vydelDvema(var p: cisloT): vysledekDeleniDvema;
  var
    i, j: integer;
  var
    akt: byte;
  var
    vysledek: vysledekDeleniDvema;
  begin
    init(vysledek.vysl);
    vysledek.zbytek := 0;
    j := 1;
    for i := 1 to p.delka do
    begin
      akt := vysledek.zbytek * 10 + p.cislo[i];
      if ((akt div 2) = 0) then
      begin
        vysledek.zbytek := akt;
        if (i > 1) then
        begin
          vysledek.vysl.cislo[j] := 0;
          Inc(j);
        end;
      end
      else
      begin
        vysledek.zbytek := akt mod 2;
        vysledek.vysl.cislo[j] := akt div 2;
        Inc(j);
      end;
    end;
    vysledek.vysl.delka := j - 1;
    vydelDvema := vysledek;
  end;

  function factor(p: cisloT): vysledekFaktorizace;
  var
    vyslD: vysledekDeleniDvema;
  var
    vyslF: vysledekFaktorizace;
  begin
    init(vyslD.vysl);
    vyslD.zbytek := 0;
    p.cislo[p.delka] := p.cislo[p.delka] - 1;
    vyslF.exponent := 0;
    init(vyslF.zbytek);
    vyslF.zbytek := p;
    vyslD := vydelDvema(p);
    while ((vyslD.zbytek = 0) and ((vyslD.vysl.delka <> 1) or
        (vyslD.vysl.cislo[1] <> 0))) do
    begin
      Inc(vyslF.exponent);
      vyslF.zbytek := vyslD.vysl;
      vyslD := vydelDvema(vyslD.vysl);
    end;
    factor := vyslF;
  end;
  // factors of p-1 (even)
  function factor2(var p: cisloLT): vysledekFaktorizace2;
  var
    vyslF: vysledekFaktorizace2;
  var
    vyslD: vysledekDeleniBase;
  begin
    init2(vyslD.rem);
    init2(vyslD.quot);
    init2(vyslF.zbytek);
    vyslF.exponent := 0;
    vyslF.zbytek := p;
    vyslF.zbytek.cislo[1] :=
      vyslF.zbytek.cislo[1] - 1;
    vyslD := vydelBaseWithRem(vyslF.zbytek, DVA);
    while ((vyslD.rem.delka = 0) and (vyslD.quot.delka > 0)) do
    begin
      Inc(vyslF.exponent);
      vyslF.zbytek := vyslD.quot;
      vyslD := vydelBaseWithRem(vyslD.quot, DVA);
    end;
    factor2 := vyslF;
  end;

  function squareDec(var c1: cisloT): cisloT;
  var
    vysl: cisloT;
  var
    i, j, temp, c: integer;
  begin
    init(vysl);
    for i := 0 to (c1.delka - 1) do
    begin
      temp := vysl.cislo[2 * i + 1] + (c1.cislo[i + 1] * c1.cislo[i + 1]);
      vysl.cislo[(2 * i) + 1] := temp mod 10;
      c := temp div 10;
      for j := (i + 1) to (c1.delka - 1) do
      begin
        temp := vysl.cislo[(i + j) + 1] + (2 * c1.cislo[j + 1] * c1.cislo[i + 1]) + c;
        vysl.cislo[(i + j) + 1] := temp mod 10;
        c := temp div 10;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
    end;
    if (vysl.cislo[c1.delka * 2] > 0) then
      vysl.delka := c1.delka * 2
    else
      vysl.delka := c1.delka * 2 - 1;

    squareDec := vysl;
  end;

  function squareBase(var c1: cisloLT): cisloLT;
  var
    vysl: cisloLT;
  var
    i, j, temp, c: int64;
  begin
    init2(vysl);
    for i := 0 to (c1.delka - 1) do
    begin
      temp := vysl.cislo[2 * i + 1] + (c1.cislo[i + 1] * c1.cislo[i + 1]);
      vysl.cislo[(2 * i) + 1] := temp mod BASE;
      c := temp div BASE;
      for j := (i + 1) to (c1.delka - 1) do
      begin
        temp := vysl.cislo[(i + j) + 1] + (2 * c1.cislo[j + 1] * c1.cislo[i + 1]) + c;
        vysl.cislo[(i + j) + 1] := temp mod BASE;
        c := temp div BASE;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
    end;
    if (vysl.cislo[c1.delka * 2] > 0) then
      vysl.delka := c1.delka * 2
    else
      vysl.delka := c1.delka * 2 - 1;

    squareBase := vysl;
  end;

  function modular_pow(var base: cisloLT; exponent: cisloLT;
  var modulus: cisloLT): cisloLT;
  var
    vysledek, temp: cisloLT;
  var
    tempDeleni: vysledekDeleniBase;
  begin
    init2(vysledek);
    if ((modulus.delka = 1) and (modulus.cislo[1] = 1)) then
    begin
      modular_pow := vysledek;
      exit;
    end;
    init2(temp);
    vysledek.delka := 1;
    vysledek.cislo[1] := 1;
    init2(tempDeleni.quot);
    init2(tempDeleni.rem);
    //base := moduloBase(base, modulus);
    while exponent.delka > 0 do
    begin
      tempDeleni := vydelBaseWithRem(exponent, DVA);
      if (tempDeleni.rem.delka = 1) then
      begin
        temp := vynasobBase(vysledek, base);
        vysledek := moduloBase(temp, modulus);
      end;
      temp := squareBase(base);
      base := moduloBase(temp, modulus);
      exponent := tempDeleni.quot;
    end;
    modular_pow := vysledek;
  end;

  function stringToCislo(s: string): cisloT;
  var
    i: integer;
  var
    Value: byte;
  var
    vysl: cisloT;
  begin
    init(vysl);
    vysl.delka := length(s);
    for i := length(s) downto 1 do
    begin
      Val(s[i], Value);
      vysl.cislo[vysl.delka - i + 1] := Value;
    end;
    stringToCislo := vysl;
  end;

  function getLongInt(c: cisloT): longint;
  var
    vysl: longint;
  var
    i: integer;
  begin
    vysl := 0;
    for i := 1 to c.delka do
    begin
      vysl := vysl + c.cislo[i] * round(exp((i - 1) * ln(10)));
    end;
    getLongInt := vysl;
  end;

  function convertToDec(c: cisloLT): cisloT;
  var
    tempC, newC, digit: cisloT;
  var
    i: integer;
  var
    tempS: string;
  begin
    init(tempC);
    init(newC);
    init(digit);
    tempS := '';
    c := otocCisloBase(c);
    for i := 1 to c.delka do
    begin
      Str(c.cislo[i], tempS);
      digit := stringToCislo(tempS);
      newC := sectiDec(vynasobDec(newC, BASE_CISLO_DEC), digit);
    end;
    convertToDec := newC;
  end;

  function convertFromDec(c: cisloT): cisloLT;
  var
    newC: cisloLT;
  var
    vyslDel: vysledekDeleniDec;
  var
    rem: longint;
  var
    i: integer;
  begin
    init2(newC);
    init(vyslDel.rem);
    init(vyslDel.quot);
    i := 1;
    while (c.delka > 0) do
    begin
      vyslDel := vydelDec(c, BASE_CISLO_DEC);
      rem := getLongInt(vyslDel.rem);
      c := vyslDel.quot;
      newC.cislo[i] := rem;
      newC.delka := i;
      Inc(i);
    end;
    convertFromDec := newC;
  end;

  procedure loadPrimes;  //v necitelnem formatu
  var
    i: integer;
  begin
    for i := 1 to POCET_MALYCH_PRVOCISEL do
    begin
      malaPrvocisla[i] := convertFromDec(stringToCislo(malaPrvocislaString[i]));
    end;
  end;

  function dumbCheck(var p: cisloLT): boolean;
  var
    i: integer;
  begin
    for i := 1 to POCET_MALYCH_PRVOCISEL do
    begin
      if (moduloBase(p, malaPrvocisla[i]).delka = 0) then
      begin
        exit(False);
      end;
    end;
    dumbCheck := True;
  end;

  function modInverse(a, m: cisloLT): cisloLT;
  var
    m0, t, q, x0, x1, inverse, nasobTemp: cisloLT;
  var vyslD : vysledekDeleniBase;
  begin
    init2(m0);
    init2(t);
    init2(q);
    init2(x0);
    init2(x1);
    init2(inverse);
    init2(nasobTemp);
    init2(vyslD.quot);
    init2(vyslD.rem);
    m0 := m;
    x1.delka := 1;
    x1.cislo[1] := 1;
    if ((m.delka = 1) and (m.cislo[1] = 1)) then
    begin
      exit(inverse);
    end;

    while ((a.delka > 1) or (a.cislo[1] > 1)) do
    begin
      if (m.delka = 0) then
      begin
        //writeln('deleni nulou');
        //halt(1);
        exit(inverse);
      end;
      q := vydelBase(a, m);
      t := m;
      m := moduloBase(a, m);
      a := t;
      t := x0;
      nasobTemp := vynasobBase(q, x0);
      x0 := odectiBase(x1, nasobTemp);
      x1 := t;
    end;

    if (x1.isNegative) then
    begin
      x1.isNegative := False;
      x1 := odectiBase(m0, x1);
    end;
    modInverse := x1;
  end;

  function montMult(var x, y, m, mDash: cisloLT): cisloLT;
  var
    A, u, xTemp, temp, temp2: cisloLT;
  var
    i: integer;
  begin
    init2(A);
    init2(u);
    init2(xTemp);
    init2(temp);
    init2(temp2);
    u.delka := 1;
    xTemp.delka := 1;
    for i := 0 to (m.delka - 1) do
    begin
      u.cislo[1] := betterMod((A.cislo[1] + x.cislo[i + 1] * y.cislo[1]) *
        mDash.cislo[1], BASE);
      xTemp.cislo[1] := x.cislo[i + 1];
      temp := sectiBase(A, sectiBase(vynasobBase(xTemp, y), vynasobBase(u, m)));
      A := shiftRight(temp, 1);
    end;
    if (porovnaniBase(A, m) <> 2) then
      A := odectiBase(A, m);
    montMult := A;
  end;

  function otocBin(c: cisloBin): cisloBin;
  var
    zac, kon: integer;
  var
    temp: boolean;
  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocBin := c;
  end;

  function prevedDoBin(c: cisloLT): cisloBin; //c je necitelne a vraci bin necitelne
  var
    binaryNum: cisloBin;
  var vyslD : vysledekDeleniBase;
  begin
    initBin(binaryNum);
    init2(vyslD.quot);
    init2(vyslD.rem);
    while ((c.cislo[1] <> 0) or (c.delka <> 0)) do
    begin
      vyslD := vydelBaseWithRem(c, DVA);
      Inc(binaryNum.delka);
      if (vyslD.rem.delka = 0) then
        binaryNum.cislo[binaryNum.delka] := False
      else
        binaryNum.cislo[binaryNum.delka] := True;
      c := vyslD.quot;
    end;
    prevedDoBin := binaryNum;
  end;

procedure vypisBin(c: cisloBin);
  var
    i: integer;
  begin
    writeln('delka : ', c.delka);
    for i := 1 to c.delka do
    begin
      if (c.cislo[i]) then
        Write(1)
      else
        Write(0);
    end;
    writeln;
  end;

  function montExp(var x, exp, m, mDash, R, RSqr: cisloLT): cisloLT;
  var
    A, xTemp, jedna: cisloLT;
  var
    expBin: cisloBin;
  var
    i: integer;
  begin
    expBin := prevedDoBin(exp);
    init2(A);
    init2(xTemp);
    init2(jedna);
    jedna.delka := 1;
    jedna.cislo[1] := 1;
    xTemp := montMult(x, RSqr, m, mDash);
    A := moduloBase(R, m);
    for i := (expBin.delka - 1) downto 0 do
    begin
      A := montMult(A, A, m, mDash);
      if (expBin.cislo[i + 1] = True) then
      begin
        A := montMult(A, xTemp, m, mDash);
      end;
    end;
    A := montMult(A, jedna, m, mDash);
    montExp := A;
  end;

  procedure zapisCisloDoSouboru(var f: Text; var c: cisloT);
  var
    i: integer;
  begin
    append(f);
    for i := 1 to c.delka do
      Write(f, c.cislo[i]);
    writeln(f, '');
  end;

  function isPrime(var p: cisloLT; k: byte): boolean;
  var
    nahodneBase, pMensiBase, x: cisloLT;
  var
    i, j: integer;
  var
    pokracuj: boolean;
  var
    faktory: vysledekFaktorizace2;
  var
    FromTime, ToTime: TDateTime;

  begin
    if (p.delka > 4) then
    begin
      if (dumbCheck(p) = False) then
        exit(False);
    end;
    init2(nahodneBase);
    init2(pMensiBase);
    init2(x);
    init2(faktory.zbytek);
    faktory.exponent := 0;
    faktory := factor2(p);
    pMensiBase := p;
    pMensiBase.cislo[1] := pMensiBase.cislo[1] - 1;
    for i := 1 to k do
    begin
      pokracuj := False;
      nahodneBase := generujNahodneCisloMensiNez(pMensiBase);
      FromTime := Now;
      x := modular_pow(nahodneBase, faktory.zbytek, p);
      ToTime := Now;
      pocetExp := pocetExp + 1;
      celkemMs := celkemMs + MilliSecondsBetween(FromTime, ToTime);
      if (((x.delka = 1) and (x.cislo[1] = 1)) or
        (porovnaniBase(pMensiBase, x) = 0)) then
      begin
        //writeln('passed ', i, '. test');
        Continue;
      end;
      for j := 1 to (faktory.exponent - 1) do
      begin
        x := moduloBase(squareBase(x), p);
        if ((x.delka = 1) and (x.cislo[1] = 1)) then
        begin
          exit(False);
        end;
        if ((porovnaniBase(pMensiBase, x) = 0)) then
        begin
          pokracuj := True;
          break;
        end;
      end;
      if (not pokracuj) then
      begin
        exit(False);
      end;
      //writeln('passed ', i, '. test');
    end;
    isPrime := True;
  end;

function isPrime2(var p: cisloLT; k: byte): boolean;
  var
    nahodneBase, pMensiBase, x, pDash, R, RSqr : cisloLT;
  var
    i, j: integer;
  var
    pokracuj: boolean;
  var
    faktory: vysledekFaktorizace2;
  var
    FromTime, ToTime: TDateTime;

  begin
    if (p.delka > 4) then
    begin
      if (dumbCheck(p) = False) then
        exit(False);
    end;
    init2(nahodneBase);
    init2(pMensiBase);
    init2(x);
    init2(faktory.zbytek);
    init2(pDash);
    init2(R);
    init2(RSqr);
    faktory.exponent := 0;
    faktory := factor2(p);
    pDash := modInverse(p, BASE_CISLO);
    if(pDash.delka = 0) then exit(False);
    //vypisCisloBase(pDash, true, 'pred mod');
    pDash.cislo[1] := betterMod(-pDash.cislo[1], BASE);
    //vypisCisloBase(pDash, true, 'po mod');
    //pDash := moduloBase(pDash, BASE_CISLO);
    //vypisCisloBase(pDash, true, 'modulos');
    R.delka := p.delka + 1;
    R.cislo[R.delka] := 1;
    RSqr.delka := (p.delka * 2) + 1;
    RSqr.cislo[RSqr.delka] := 1;
    RSqr := moduloBase(RSqr, p);
    pMensiBase := p;
    pMensiBase.cislo[1] := pMensiBase.cislo[1] - 1;
    for i := 1 to k do
    begin
      pokracuj := False;
      nahodneBase := generujNahodneCisloMensiNez(pMensiBase);
      FromTime := Now;
      //x := modular_pow(nahodneBase, faktory.zbytek, p);
      x := montExp(nahodneBase, faktory.zbytek, p, pDash, R, RSqr);
      ToTime := Now;
      pocetExp := pocetExp + 1;
      celkemMs := celkemMs + MilliSecondsBetween(FromTime, ToTime);
      if (((x.delka = 1) and (x.cislo[1] = 1)) or
        (porovnaniBase(pMensiBase, x) = 0)) then
      begin
        //writeln('passed ', i, '. test');
        Continue;
      end;
      for j := 1 to (faktory.exponent - 1) do
      begin
        x := moduloBase(squareBase(x), p);
        if ((x.delka = 1) and (x.cislo[1] = 1)) then
        begin
          exit(False);
        end;
        if ((porovnaniBase(pMensiBase, x) = 0)) then
        begin
          pokracuj := True;
          break;
        end;
      end;
      if (not pokracuj) then
      begin
        exit(False);
      end;
      //writeln('passed ', i, '. test');
    end;
    isPrime2 := True;
  end;

var
  pocetCifer, pocetPrvocisel, pocetPokusu, i, diffCas: integer;
var
  prumernyCas: real;
var
  p, n, vysl: cisloT;
var
  generuj: boolean;
var
  FromTime, ToTime: TDateTime;
var
  vystup: Text;
var
  otocenePBase, test, test2, res, remainder: cisloLT;
var
  del: vysledekDeleniBase;
var
  rem, k: longint;
var
  baseStr: string;
begin
  celkemMs := 0;
  pocetExp := 0;

  Str(BASE, baseStr);
  BASE_CISLO_DEC := stringToCislo(baseStr);
  BASE_CISLO := convertFromDec(BASE_CISLO_DEC);

  for i := 0 to MAX_DELKA_DEC do
    prazdneCislo.cislo[i] := 0;
  prazdneCislo.isNegative := False;
  prazdneCislo.delka := 0;

  for i := 0 to MAX_DELKA_BASE do
    prazdneCislo2.cislo[i] := 0;
  prazdneCislo2.isNegative := False;
  prazdneCislo2.delka := 0;

  for i := 0 to MAX_DELKA_BIN do
    prazdneCisloBin.cislo[i] := False;
  prazdneCisloBin.delka := 0;

  DVA := prazdneCislo2;
  DVA.delka := 1;
  DVA.cislo[1] := 2;

  Randomize;
  Assign(vystup, VYSTUPNI_SOUBOR);
  Write('Kolik cifer: ');
  readln(pocetCifer);
  Write('Kolik ruznych prvocisel: ');
  readln(pocetPrvocisel);
  loadPrimes();
  pocetPokusu := 0;
  prumernyCas := 0;

  rewrite(vystup);
  for i := 1 to pocetPrvocisel do
  begin
    FromTime := Now;
    generuj := True;
    while generuj do
    begin
      Inc(pocetPokusu);
      //write(pocetPokusu, ' ');
      p := generujPrvocislo(pocetCifer);
      vynuluj(p);
      otocenePBase := convertFromDec(otocCisloDec(p));
      if (isPrime(otocenePBase, PRESNOST) = True) then
      begin
        generuj := False;
        ToTime := Now;
        //Writeln('Pocet otestovanych cisel: ', pocetPokusu);
        diffCas := MilliSecondsBetween(ToTime, FromTime);
        //Writeln('Generovani prvocisla trvalo: ', diffCas, ' ms');
        //vypisCisloDec(p, True, 'je prvocislo ');
        if (prumernyCas = 0) then
          prumernyCas := diffCas
        else
          prumernyCas := (prumernyCas + diffCas) / 2;
        zapisCisloDoSouboru(vystup, p);
        //pocetPokusu := 0;
      end;
    end;
  end;

  writeln('Vygenerovano ', pocetPrvocisel, ' prvocisel delky ', pocetCifer, '. Vyzkouseno ', pocetPokusu, ' cisel');
  writeln('Prumerna doba generovani jednoho prvocisla: ', prumernyCas: 9: 0, ' ms');
  writeln('Prumerny exp cas: ', (celkemMs / pocetExp): 9: 0, ' ms');
  Close(vystup);

    {
  Str(BASE, baseStr);
  BASE_CISLO := stringToCislo(baseStr);

  p := generujPrvocislo(pocetCifer);
  vypisCislo(p, true, 'p');
  p := otocCislo(p);
  writeln;

  test := convertFromDec(p);

  test2 := test;
  test2.cislo[1] := test2.cislo[1]-2;
  del := vydel2(test, test2);

  p := convertToDec(del.quot);
  vypisCislo(otocCislo(p), true, 'quot');
  p := convertToDec(del.rem);
  vypisCislo(otocCislo(p), true, 'rem');

  p := convertToDec(modulo2(test, test2));
  vypisCislo(otocCislo(p), true, 'mod');


  writeln;
            }
end.
