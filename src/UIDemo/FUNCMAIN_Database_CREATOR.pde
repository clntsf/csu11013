// RSR - If .db does not exist in data folder, it will be created and filled. - 21/3/24 10PM

public void initDB()
{
    String[] flightTableNames = {"flights2k", "flights10k", "flights_full"};
    db = new SQLite(this, DB_NAME+".db");
    if (db.connect())
    {
        initSchema(flightTableNames);
        populateWacDB(); // must populate this before flights!!!
        populateFlightDBs(flightTableNames);
        populateDelays();
    }
}

// RSR - creates database file if it does not already exist - 21/3/24 7PM
public boolean createDBFile()
{
    File dbFile = new File(dataPath(DB_NAME+".db"));
    try
    {
        return dbFile.createNewFile();
    } catch (IOException e) {e.printStackTrace(); return false;}
}

public void initSchema(String[] flightTableNames)
{
    db.query("CREATE TABLE \"delays\" (\"Date\" TEXT NOT NULL, \"Origin\" TEXT NOT NULL, \"Delay\"  INTEGER)");
    db.query("""CREATE TABLE "wac_codes" (
                  "WAC"  INTEGER NOT NULL,
                  "WAC_Name"  TEXT NOT NULL,
                  "Country_Name"  TEXT NOT NULL,
                  "Country_Code_ISO"  TEXT NOT NULL,
                  "State_Code"  TEXT,
                  PRIMARY KEY("WAC")
    )""");
    String flightSchema = """(
            "FlightDate"  TEXT NOT NULL,
            "IATA_Code_Marketing_Airline"  TEXT NOT NULL,
            "Flight_Number_Marketing_Airline"  INTEGER NOT NULL,
            "Origin"  TEXT NOT NULL,
            "OriginCityName"  TEXT NOT NULL,
            "OriginState"  TEXT NOT NULL,
            "OriginWac"  INTEGER NOT NULL,
            "Dest"  TEXT NOT NULL,
            "DestCityName"  TEXT NOT NULL,
            "DestState"  TEXT NOT NULL,
            "DestWac"  INTEGER NOT NULL,
            "CRSDepTime"  TEXT NOT NULL,
            "DepTime"  TEXT,
            "CRSArrTime"  TEXT NOT NULL,
            "ArrTime"  TEXT,
            "Cancelled"  INTEGER NOT NULL DEFAULT 0,
            "Diverted"  INTEGER NOT NULL DEFAULT 0,
            "Distance"  INTEGER NOT NULL,
            FOREIGN KEY("DestWac") REFERENCES "wac_codes"("WAC"),
            FOREIGN KEY("OriginWac") REFERENCES "wac_codes"("WAC")
    )""";
    for (int i = 0; i < flightTableNames.length; i++)
    {
        db.query("CREATE TABLE "+flightTableNames[i]+flightSchema);
    }
}

public void populateWacDB()
{
    Table table = loadTable("wac_codes.csv", "header");
    db.query("BEGIN TRANSACTION;");
    for (int i = 0; i < table.getRowCount(); i++)
    {
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO wac_codes (WAC, WAC_Name, Country_Name, Country_Code_ISO, State_Code) VALUES(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\");",
                  currentRow.getInt("WAC"), currentRow.getString("WAC_Name"), currentRow.getString("Country_Name"), currentRow.getString("Country_Code_ISO"),
                  currentRow.getString("State_Code"));
    }
    db.query("COMMIT;");
    println("wac_codes successfully populated!");
}

// RSR - created method to populate the SQLite database I made. See commented   - 12/3/24 10PM
//       below the old methods that used an ArrayList of DataPoints.
public void populateFlightDBs(String[] flightTableNames)
{
    for (int i = 0; i < flightTableNames.length; i++)
    {
        Table table = loadTable(flightTableNames[i]+".csv", "header");
        println("Started to populate database "+flightTableNames[i]);
        String columns = "FlightDate, IATA_Code_Marketing_Airline, Flight_Number_Marketing_Airline, Origin, OriginCityName, "+
                         "OriginState, OriginWac, Dest, DestCityName, DestState, DestWac, CRSDepTime, DepTime, CRSArrTime, ArrTime, Cancelled, Diverted, Distance";
        // RSR - updated method to be a lot more efficient - 20/3/24 2PM
        db.query("BEGIN TRANSACTION;");
        for (int j = 0; j < table.getRowCount(); j++)
        {
            if (j%1000 == 0) { println(flightTableNames[i]+", row: "+j); }
            TableRow currentRow = table.getRow(j);
            db.query("INSERT INTO "+flightTableNames[i]+" ("+columns+") VALUES (\"%s\",\"%s\",%d,\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\",\"%s\",\"%s\",%d,%d,%d);",
                        dateToLocalDate(currentRow.getString("FL_DATE")), currentRow.getString("MKT_CARRIER"), currentRow.getInt("MKT_CARRIER_FL_NUM"), 
                        currentRow.getString("ORIGIN"), currentRow.getString("ORIGIN_CITY_NAME"), currentRow.getString("ORIGIN_STATE_ABR"), 
                        currentRow.getInt("ORIGIN_WAC"), currentRow.getString("DEST"), currentRow.getString("DEST_CITY_NAME"), 
                        currentRow.getString("DEST_STATE_ABR"), currentRow.getInt("DEST_WAC"), timeToLocalTime(currentRow.getString("CRS_DEP_TIME")), 
                        timeToLocalTime(currentRow.getString("DEP_TIME")), timeToLocalTime(currentRow.getString("CRS_ARR_TIME")), 
                        timeToLocalTime(currentRow.getString("ARR_TIME")), currentRow.getInt("CANCELLED"), currentRow.getInt("DIVERTED"), 
                        currentRow.getInt("DISTANCE"));
        }
        db.query("COMMIT;");
        println(flightTableNames[i]+" successfully populated!");
    }
}

// RSR - demo function to populate a delay table in the database - 19/3/24 7PM
public void populateDelays()
{
    Table table = loadTable("delaysdemo.csv", "header");
    db.query("BEGIN TRANSACTION;");
    for (int i = 0; i < table.getRowCount(); i++)
    {
        if (i%1000 == 0) { println("delays, row: "+i); }
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO delays (\"Date\",\"Origin\", \"Delay\") VALUES(\"%s\", \"%s\", %d);", dateToLocalDate(currentRow.getString("FL_DATE")), currentRow.getString("ORIGIN"), currentRow.getInt("DEP_DELAY"));
    }
    db.query("COMMIT;");
    print("delays successfully populated!");
}
