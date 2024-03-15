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

// RSR - created method to populate the SQLite database. See commented        - 12/3/24 10PM
//       below for the original methods that used an ArrayList of DataPoints.
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
                                    currentRow.getString("FL_DATE"), currentRow.getString("MKT_CARRIER"), currentRow.getString("MKT_CARRIER_FL_NUM"), currentRow.getString("ORIGIN"),
                                    currentRow.getString("ORIGIN_CITY_NAME"), currentRow.getString("ORIGIN_STATE_ABR"), currentRow.getInt("ORIGIN_WAC"), currentRow.getString("DEST"),
                                    currentRow.getString("DEST_CITY_NAME"), currentRow.getString("DEST_STATE_ABR"), currentRow.getInt("DEST_WAC"), currentRow.getString("CRS_DEP_TIME"),
                                    currentRow.getString("DEP_TIME"), currentRow.getString("CRS_ARR_TIME"), currentRow.getString("ARR_TIME"), currentRow.getInt("CANCELLED"),
                                    currentRow.getInt("CANCELLED"), currentRow.getInt("DISTANCE"));
    }
    println("Database successfully populated!\n");
    dbPopulated = true;
}

// public void populateDatabase(String tableName) {
//   DataPoint currentDP;
//   db.query("DELETE FROM "+tableName);
//   createDataPointArray();
//   println("Started to populate database...");
//   String columns = "\"FlightDate\", \"IATA_Code_Marketing_Airline\", \"Flight_Number_Marketing_Airline\", \"Origin\", \"OriginCityName\", \"OriginState\", \"OriginWac\", \"Dest\", \"DestCityName\", \"DestState\", \"DestWac\", \"CRSDepTime\", \"DepTime\", \"CRSArrTime\", \"ArrTime\", \"Cancelled\", \"Diverted\", \"Distance\"";
//   for (int i = 0; i < table.getRowCount(); i++) {
//     currentDP = dataPoints.get(i);
//     print(i+"\n");
//     db.query("INSERT INTO "+tableName+" ("+columns+") VALUES(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\", %d, %d, %d)",
//                                     currentDP.getFlightDate(), currentDP.getMarketingCarrier(), currentDP.getMarketingCarrierFlightNumber(),
//                                     currentDP.getOrigin(), currentDP.getOriginCityName(), currentDP.getOriginStateAbr(), currentDP.getOriginWac(),
//                                     currentDP.getDestination(), currentDP.getDestinationCityName(), currentDP.getDestStateAbr(), currentDP.getDestWac(),
//                                     currentDP.getCrsDepTime(), currentDP.getDepTime(), currentDP.getCrsArrTime(), currentDP.getArrTime(),
//                                     currentDP.getCancelled(), currentDP.getDiverted(), currentDP.getDistance());
//   }
//   println("Database successfully populated!\n");
// }

public void createDataPointArray() {
  TableRow currentRow;
  DataPoint currentDP;
  for (int i = 0; i < table.getRowCount(); i++) {
    currentRow = table.getRow(i);
    currentDP = new DataPoint(currentRow.getString("FL_DATE"), currentRow.getString("MKT_CARRIER"), currentRow.getString("MKT_CARRIER_FL_NUM"), currentRow.getString("ORIGIN"),
                                    currentRow.getString("ORIGIN_CITY_NAME"), currentRow.getString("ORIGIN_STATE_ABR"), currentRow.getInt("ORIGIN_WAC"), currentRow.getString("DEST"),
                                    currentRow.getString("DEST_CITY_NAME"), currentRow.getString("DEST_STATE_ABR"), currentRow.getInt("DEST_WAC"), currentRow.getString("CRS_DEP_TIME"),
                                    currentRow.getString("DEP_TIME"), currentRow.getString("CRS_ARR_TIME"), currentRow.getString("ARR_TIME"), currentRow.getInt("CANCELLED"),
                                    currentRow.getInt("CANCELLED"), currentRow.getInt("DISTANCE"));
    dataPoints.add(currentDP);
  }
}