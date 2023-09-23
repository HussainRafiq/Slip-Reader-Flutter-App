import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:slip_readerv2/Database/Model/ItemModel.dart';
import 'package:sqflite/sqflite.dart';

/// delete the db, create the folder and returnes its path
Future<Database> initDb() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'RLR.db');
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Customer (_id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Address TEXT, Extra TEXT)');
    await db.execute(
        'CREATE TABLE Item (ItemCode INTEGER PRIMARY KEY , Name TEXT, Extra TEXT)');
    await db.execute(
        'CREATE TABLE Slip (_id INTEGER PRIMARY KEY AUTOINCREMENT, CustomerKey INTEGER, SlipNo Text, Name TEXT, Date DateTime )');
    await db.execute(
        'CREATE TABLE SlipItems (_id INTEGER PRIMARY KEY AUTOINCREMENT, SlipKey INTEGER, ItemCode INTEGER, Qty INTEGER)');
    await db.execute(
        "INSERT INTO Item(ItemCode, Name, Extra) VALUES('56','WONDER 100%WW TEXA',''),('65','DELI WORLD RYE 500',''),('201','WONDER WHITE 570G',''),('213','WONDER WHITE+FIBRE',''),('244','DITAL THICKSLIC B',''),('246','DITAL SEED BRD 67',''),('260','DITAL WW THIC SLI',''),('338','P DW LGT RYE 900G',''),('453','DW REST WHITE SAND',''),('530','WONDER 100% WW 570',''),('1125','P 6 WON XCSP ENG',''),('2002','D''ITAL SAUS BUN 6S',''),('2006','DITAL CRUSTINI BUN',''),('2048','10\" CASA MEN TORTILLA',''),('2050','CASA MEN TORTILLA',''),('2060','WDR + WH HOT DOGS',''),('2062','WDR + WH HAM',''),('2064','WDR HOTDOG 12S',''),('2066','WDR HAMB 12S (EA)',''),('2356','12 DW 4.5 SES HAM',''),('2536','CASA MEN TORT 10IN',''),('2644','P 6 WON PL MUF',''),('2664','CASA MEN SPINACH 1',''),('3519','FS 4\" SES HAM 12S',''),('4257','DI BRIZZOLIO BUNS',''),('4293','WONDER 100% WW HOT',''),('4298','WONDER 100% WW HAM',''),('5204','OLD MILL HAMBURGER',''),('5342','OLD MILL HOT DOG B',''),('5949','DITAL BRIZZOLIO SA',''),('9800','12243 LD OATMEAL C',''),('9816','12249 LD SWISS CAK',''),('9910','DAY OLD BREAD',''),('10074','OLD MILL WHITE BRE',''),('10076','OLD MILL 100% WW 5',''),('10085','DITALIANO BRIZZOLI',''),('10843','DW 100% WW BREAD S',''),('11079','CH CINNAMON RSN BG',''),('12117','CM TOMATO SALSA (E',''),('12135','CM CORN (EA) 103233',''),('12171','RUBSCHLAGER MARBLE',''),('12257','OM DINNER ROLL 10S',''),('12325','DI ITALIAN STYLE G',''),('12458','WDR BALL PARK HAMS',''),('12464','WONDER BALL PARK H',''),('12609','WDR WRAPS WHITE 10',''),('12622','OG DKB BRD21 WHLGR',''),('12625','OG DKB BRD21 WHL G',''),('12631','OG DKB BRD GOOD SE',''),('13457','CENTSIBLES WW BREA',''),('13458','CENTSIBLES WH BREA',''),('13520','WDR WH THIN SAND 5',''),('13824','CH 14 GRAIN BAGEL',''),('13825','CH EVERYTHING BAGE',''),('13826','CH ORIGINAL BAGEL',''),('13827','CH SESAME BAGEL  4',''),('13871','CH 14 GRAIN',''),('13880','CH ANCIENT GRAIN &',''),('13882','CH SEEDS & GRAINS',''),('13884','CH CINNAMON RAISIN',''),('13892','CH NO SG WHT WHEAT',''),('13962','CASA MEND BURRITO',''),('13969','CASA 100% CORN 5\"T',''),('15534','SHB LITTLE BIG BRD',''),('15551','SHB SQUIRRELY BRD',''),('15553','SHB BIG 16 BRD 1X6',''),('16092','CH FLX & QUINOA BR',''),('16093','CH PROTEIN GRAIN B',''),('16095','CH EVERYTHING BRD',''),('16096','CH SOURDOUGH BRD 6',''),('16102','CENT HAMB BUN 8S 1',''),('16104','CENT HTDG BUN 8S 1',''),('16114','DITAL BRIOCHE HAMB',''),('16117','DITAL BRCHE SAUSAG','')");
  });
  return database;
}
