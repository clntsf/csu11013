import de.bezier.data.sql.*;
import java.util.Map;

ArrayList<Screen> screens = new ArrayList<>();
int activeScreen = 0;
Table table;
ArrayList<DataPoint> dataPoints;
SQLite db;

void setup()
{
    Screen screen1 = new Screen(255);
    screens.add(screen1);
    size(400, 400);
    table = loadTable("flights2k.csv", "header");
    String tableName = "flights2k";
    dataPoints = new ArrayList();
    db = new SQLite(this, "test.db");
    if (db.connect())
    {
      populateDatabase(tableName);
    } else {println("Error connecting to database!");}
}

Screen getActiveScreen()
{
    return screens.get(activeScreen);
}

void printText() {
  int y = 10;
  fill(0);
  db.query("SELECT * FROM flights2k LIMIT 10");
  for (int i = 0; i < 10; i++) {
    if (db.next()) { 
      String flightDate = db.getString("FlightDate");
      String origin = db.getString("Origin");
      String destination = db.getString("Dest");
      text("Flight Date: " + flightDate + ", Origin: " + origin + ", Destination: " + destination, 10, y);
    } else {
      text("No data found.", 10, y);
    }
    y += 15;
  }
}


void draw()
{
    getActiveScreen().draw();
    printText();

}

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

public void populateDatabase(String tableName) {
  DataPoint currentDP;
  db.query("DELETE FROM "+tableName);
  createDataPointArray();
  println("Started to populate database...");
  String columns = "\"FlightDate\", \"IATA_Code_Marketing_Airline\", \"Flight_Number_Marketing_Airline\", \"Origin\", \"OriginCityName\", \"OriginState\", \"OriginWac\", \"Dest\", \"DestCityName\", \"DestState\", \"DestWac\", \"CRSDepTime\", \"DepTime\", \"CRSArrTime\", \"ArrTime\", \"Cancelled\", \"Diverted\", \"Distance\"";
  for (int i = 0; i < table.getRowCount(); i++) {
    currentDP = dataPoints.get(i);
    print(i+"\n");
    db.query("INSERT INTO "+tableName+" ("+columns+") VALUES(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\", %d, %d, %d)",
                                    currentDP.getFlightDate(), currentDP.getMarketingCarrier(), currentDP.getMarketingCarrierFlightNumber(),
                                    currentDP.getOrigin(), currentDP.getOriginCityName(), currentDP.getOriginStateAbr(), currentDP.getOriginWac(),
                                    currentDP.getDestination(), currentDP.getDestinationCityName(), currentDP.getDestStateAbr(), currentDP.getDestWac(),
                                    currentDP.getCrsDepTime(), currentDP.getDepTime(), currentDP.getCrsArrTime(), currentDP.getArrTime(),
                                    currentDP.getCancelled(), currentDP.getDiverted(), currentDP.getDistance());
  }
  println("Database successfully populated!\n");
}
