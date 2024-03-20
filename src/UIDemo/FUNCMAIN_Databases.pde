import java.time.*;
import java.time.format.DateTimeFormatter;

void printText() {
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
}

DateTimeFormatter[] dateFormatters = {
                  DateTimeFormatter.ofPattern("dd/MM/yyyy"),
                  DateTimeFormatter.ofPattern("M/d/yyyy")
};

// RSR - created method to populate the SQLite database I made. See commented   - 12/3/24 10PM
//       below the original methods that used an ArrayList of DataPoints.
public void populateDatabase(Table table, String databaseTableName)
{
    db.query("DELETE FROM "+databaseTableName);

    println("Started to populate database...");
    String columns = "FlightDate, IATA_Code_Marketing_Airline, Flight_Number_Marketing_Airline, Origin, OriginCityName, OriginState, OriginWac, Dest, DestCityName, DestState, DestWac, CRSDepTime, DepTime, CRSArrTime, ArrTime, Cancelled, Diverted, Distance";
    /*StringBuilder valueBuilder = new StringBuilder();
    valueBuilder.append("INSERT INTO "+databaseTableName+" ("+columns+") VALUES");
    for (int i = 0; i < 2; i++)
    {
        TableRow currentRow = table.getRow(i);
        valueBuilder.append(" ('"+dateToLocalDate(currentRow.getString("FL_DATE"))+"', '"+currentRow.getString("MKT_CARRIER")+"', "+currentRow.getInt("MKT_CARRIER_FL_NUM")+", '"+currentRow.getString("ORIGIN")+"', '"+currentRow.getString("ORIGIN_CITY_NAME")+"', '"+currentRow.getString("ORIGIN_STATE_ABR")+"', "+currentRow.getInt("ORIGIN_WAC")+", '"+currentRow.getString("DEST")+"', '"+currentRow.getString("DEST_CITY_NAME")+"', '"+currentRow.getString("DEST_STATE_ABR")+"', "+currentRow.getInt("DEST_WAC")+", '"+timeToLocalTime(currentRow.getString("CRS_DEP_TIME"))+"', '"+timeToLocalTime(currentRow.getString("DEP_TIME"))+"', '"+timeToLocalTime(currentRow.getString("CRS_ARR_TIME"))+"', '"+timeToLocalTime(currentRow.getString("ARR_TIME"))+"', "+currentRow.getInt("CANCELLED")+", "+currentRow.getInt("DIVERTED")+", "+currentRow.getInt("DISTANCE")+((i == 2-1) ? ");":"),"));
    }
    String values = valueBuilder.toString();*/
    //println(values);
    
    //for (int i = 0; i < table.getRowCount(); i++)
    //{
        // if (i%100 == 0) { println(i); }
        //TableRow currentRow = table.getRow(i);
        /*db.query("INSERT INTO "+databaseTableName+" ("+columns+") VALUES(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\", %d, %d, %d)",
                          dateToLocalDate(currentRow.getString("FL_DATE")), currentRow.getString("MKT_CARRIER"), currentRow.getString("MKT_CARRIER_FL_NUM"), currentRow.getString("ORIGIN"),
                          currentRow.getString("ORIGIN_CITY_NAME"), currentRow.getString("ORIGIN_STATE_ABR"), currentRow.getInt("ORIGIN_WAC"), currentRow.getString("DEST"),
                          currentRow.getString("DEST_CITY_NAME"), currentRow.getString("DEST_STATE_ABR"), currentRow.getInt("DEST_WAC"), timeToLocalTime(currentRow.getString("CRS_DEP_TIME")),
                          timeToLocalTime(currentRow.getString("DEP_TIME")), timeToLocalTime(currentRow.getString("CRS_ARR_TIME")), timeToLocalTime(currentRow.getString("ARR_TIME")),
                          currentRow.getInt("CANCELLED"), currentRow.getInt("DIVERTED"), currentRow.getInt("DISTANCE"));*/
    
    // RSR - updated method to be a lot more efficient - 20/3/24 2PM
    db.query("BEGIN TRANSACTION;");
    for (int i = 0; i < table.getRowCount(); i++)
    {
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO "+databaseTableName+" ("+columns+") VALUES ('"+dateToLocalDate(currentRow.getString("FL_DATE"))+"', '"+currentRow.getString("MKT_CARRIER")+"', "+currentRow.getInt("MKT_CARRIER_FL_NUM")+", '"+currentRow.getString("ORIGIN")+"', '"+currentRow.getString("ORIGIN_CITY_NAME")+"', '"+currentRow.getString("ORIGIN_STATE_ABR")+"', "+currentRow.getInt("ORIGIN_WAC")+", '"+currentRow.getString("DEST")+"', '"+currentRow.getString("DEST_CITY_NAME")+"', '"+currentRow.getString("DEST_STATE_ABR")+"', "+currentRow.getInt("DEST_WAC")+", '"+timeToLocalTime(currentRow.getString("CRS_DEP_TIME"))+"', '"+timeToLocalTime(currentRow.getString("DEP_TIME"))+"', '"+timeToLocalTime(currentRow.getString("CRS_ARR_TIME"))+"', '"+timeToLocalTime(currentRow.getString("ARR_TIME"))+"', "+currentRow.getInt("CANCELLED")+", "+currentRow.getInt("DIVERTED")+", "+currentRow.getInt("DISTANCE")+");");
    }
    db.query("COMMIT;");
    println("Database successfully populated!\n");
    dbPopulated = true;
}

// RSR - demo function to populate a delay table in the database - 19/3/24 7PM
public void populateDelays(Table table)
{
    //db.query("DELETE FROM delays");
    for (int i = 0; i < table.getRowCount(); i++)
    {
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO delays (\"Delay\") VALUES(%d)", currentRow.getInt("DEP_DELAY"));
    }
    print("done");
}

// RSR - created method to populate Histogram with following bins - 19/3/24 8PM
public HistParams populateHistFreqs(Integer[] bins, double[] freqs)
{
    // RSR - improved method with extra vars and loop - 20/3/24 5PM
    int minBin = -60;
    int step = 10;
    for (int i = 0; i < freqs.length; i++)
    {
        db.query("SELECT COUNT(Delay) AS freq FROM delays WHERE Delay >= "+(minBin+step*i) + ((i == freqs.length-1)?"":" AND Delay < "+(minBin+step+step*i)));
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
