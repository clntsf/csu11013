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
    String columns = "\"FlightDate\", \"IATA_Code_Marketing_Airline\", \"Flight_Number_Marketing_Airline\", \"Origin\", \"OriginCityName\", \"OriginState\", \"OriginWac\", \"Dest\", \"DestCityName\", \"DestState\", \"DestWac\", \"CRSDepTime\", \"DepTime\", \"CRSArrTime\", \"ArrTime\", \"Cancelled\", \"Diverted\", \"Distance\"";
    for (int i = 0; i < table.getRowCount(); i++)
    {
        // if (i%100 == 0) { println(i); }
        TableRow currentRow = table.getRow(i);
        db.query("INSERT INTO "+databaseTableName+" ("+columns+") VALUES(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\", %d, %d, %d)",
                          dateToLocalDate(currentRow.getString("FL_DATE")), currentRow.getString("MKT_CARRIER"), currentRow.getString("MKT_CARRIER_FL_NUM"), currentRow.getString("ORIGIN"),
                          currentRow.getString("ORIGIN_CITY_NAME"), currentRow.getString("ORIGIN_STATE_ABR"), currentRow.getInt("ORIGIN_WAC"), currentRow.getString("DEST"),
                          currentRow.getString("DEST_CITY_NAME"), currentRow.getString("DEST_STATE_ABR"), currentRow.getInt("DEST_WAC"), timeToLocalTime(currentRow.getString("CRS_DEP_TIME")),
                          timeToLocalTime(currentRow.getString("DEP_TIME")), timeToLocalTime(currentRow.getString("CRS_ARR_TIME")), timeToLocalTime(currentRow.getString("ARR_TIME")),
                          currentRow.getInt("CANCELLED"), currentRow.getInt("DIVERTED"), currentRow.getInt("DISTANCE"));
    }
    println("Database successfully populated!\n");
    dbPopulated = true;
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