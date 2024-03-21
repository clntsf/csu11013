import java.time.*;
import java.time.format.DateTimeFormatter;

// RSR - If .db does not exist in data folder, it will be created and filled. - 21/3/24 10PM

DateTimeFormatter[] dateFormatters = {
                  DateTimeFormatter.ofPattern("dd/MM/yyyy"),
                  DateTimeFormatter.ofPattern("M/d/yyyy")
};

public void initDB(String dbName)
{
    String[] flightTableNames = {"flights2k", "flights10k", "flights_full"};
    db = new SQLite(this, dbName+".db");
    if (db.connect())
    {
        initSchema(dbName, flightTableNames);
        populateWacDB(); // must populate this before flights!!!
        populateFlightDBs(flightTableNames);
        populateDelays();
    }
}

// RSR - creates database file if it does not already exist - 21/3/24 7PM
public boolean createDBFile(String fileName)
{
    File dbFile = new File(sketchPath()+"\\data\\"+fileName+".db");
    try
    {
        return dbFile.createNewFile();
    } catch (IOException e) {e.printStackTrace(); return false;}
}

public void initSchema(String dbName, String[] flightTableNames)
{
    db.query("CREATE TABLE \"delays\" (\"Delay\"  INTEGER)");
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
    //db.query("DELETE FROM "+dbName);
    for (int i = 0; i < flightTableNames.length; i++)
    {
        Table table = loadTable(flightTableNames[i]+".csv", "header");
        println("Started to populate database "+flightTableNames[i]);
        String columns = """FlightDate, IATA_Code_Marketing_Airline, Flight_Number_Marketing_Airline, Origin, OriginCityName,
                            OriginState, OriginWac, Dest, DestCityName, DestState, DestWac, CRSDepTime, DepTime, CRSArrTime, ArrTime, Cancelled, Diverted, Distance""";
        // RSR - updated method to be a lot more efficient - 20/3/24 2PM
        db.query("BEGIN TRANSACTION;");
        for (int j = 0; j < table.getRowCount(); j++)
        {
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
    //dbPopulated = true;
}

// RSR - demo function to populate a delay table in the database - 19/3/24 7PM
public void populateDelays()
{
    //db.query("DELETE FROM delays");
    Table table = loadTable("delaysdemo.csv", "header");
    db.query("BEGIN TRANSACTION;");
    for (int i = 0; i < table.getRowCount(); i++)
    {
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO delays (\"Delay\") VALUES(%d);", currentRow.getInt("DEP_DELAY"));
    }
    db.query("COMMIT;");
    print("delays successfully populated!");
}

// RSR - created method to populate Histogram with following bins - 19/3/24 8PM
public HistParams populateHistFreqs(int minBin, int step, int lastBin)
{
    Integer[] bins = new Integer[(lastBin-minBin)/step+2];
    for (int i = 0; i < bins.length; i++)
    {
        if (i == bins.length-1) bins[i] = null;
        else bins[i] = minBin+step*i;
    }
    println(bins);
    double[] freqs = new double[bins.length-1]; //<>//
    // RSR - improved method with extra parameters and loop - 20/3/24 5PM //<>//
    for (int i = 0; i < freqs.length; i++)
    {
        db.query("SELECT COUNT(Delay) AS freq FROM delays WHERE Delay >= "+(minBin+step*i)+ ((i == freqs.length-1)? "" : " AND Delay < "+(minBin+step+step*i)) );
        //println((minBin+step*i)+" --- "+(i==lastBin));
        freqs[i] = db.getInt("freq");
        println(freqs[i]);
    }
    
    return new HistParams(bins, freqs);
}

public LocalDate dateToLocalDate(String stringDate) {
    // RSR - updated method to handle different date formats that are found in e.g. flights_full.csv - 13/3/24
    String[] split = stringDate.split("\\s+", 2);
    LocalDate date = null;
    try {
        date = LocalDate.parse(split[0], dateFormatters[0]);
    }
    catch (Exception e) {
        date = LocalDate.parse(split[0], dateFormatters[1]);
    }
    return date;
}

public LocalTime timeToLocalTime(String stringTime) {
    try {
        String paddedTime = String.format("%04d", Integer.parseInt(stringTime));
        String formattedTime = paddedTime.substring(0, 2) + ":" + paddedTime.substring(2, 4);
        return LocalTime.parse(formattedTime, DateTimeFormatter.ofPattern("HH:mm"));
    } catch( NumberFormatException e ) { return null; }
    // RSR - updated method to handle empty time values (if flight was e.g. cancelled) - 12/3/24
}

/* RSR - methods to create an ArrayList of DataPoints from the loaded table  - 12/3/24 9PM
         and to populate the database with that ArrayList. (Since removed because DataPoint was scrapped)
*/

// Made by Tim
/*void printText() {
    int y = 10;
    final int TEXT_X = 20;
    fill(0);
    textFont(font);
    db.query("SELECT * FROM flights2k LIMIT "+y);
    for (int i = 0; i < 10; i++)
    {
        if (db.next())
        { 
            String flightDate = db.getString("FlightDate");
            String origin = db.getString("Origin");
            String destination = db.getString("Dest");
            text("Flight Date: " + flightDate + ", Origin: " + origin + ", Destination: " + destination, TEXT_X, y+150);
        }
        else
        {
            text("No data found.", TEXT_X, y);
        }
        y += 15;
    }
}*/
