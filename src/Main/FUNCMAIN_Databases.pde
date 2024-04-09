import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

//macnalll - created method of accessing data from the database into a piechart 26/3/24
public PieParams getPieChartData()
{
    String table = getTable();
    String selectedAirport = getAirportCode();
    String date[] = getDates();
    String startDate = date[0];
    String endDate = date[1];
    String column = "IATA_Code_Marketing_Airline";
    if (selectedAirport.equals("ALL")) 
    {
        db.query("SELECT " + column + ", COUNT(*) AS frequency FROM " + table +
            " WHERE FlightDate BETWEEN '" + startDate + "' AND '" + endDate + "' GROUP BY " + column);
    }
    else 
    {
        db.query("SELECT " + column + ", COUNT(*) AS frequency FROM " + table + " WHERE FlightDate BETWEEN '" + startDate +  
            "' AND '" + endDate + "' AND Origin = '" + selectedAirport + "' GROUP BY " + column); //<>//
    }
    Map<String, Integer> frequencyMap = new HashMap<>();
    while (db.next())
    {
        String value = db.getString(column);
        int frequency = db.getInt("frequency");
        frequencyMap.put(value, frequency);
    }

    int size = frequencyMap.size();
    String[] categories = new String[size];
    float[] valuesY = new float[size];

    int i = 0;
    for (Map.Entry<String, Integer> entry : frequencyMap.entrySet())
    {
        String value = entry.getKey();
        int frequency = entry.getValue();
        categories[i] = value;
        valuesY[i] = frequency;
        i++;
    }

    return new PieParams(valuesY, categories);
}

public String getStateFromAirport(String airport)
{
    String query;
    if (airport.equals("ALL")) {
        println("Cannot attribute ALL to a state");
        return "NY";
    }
    else {
        query =  "SELECT * FROM flights_full WHERE Origin LIKE '%" + airport + "%' LIMIT 1";
        db.query(query);
        if (db.next()) {
            return db.getString("OriginState"); 
        }
        else {
            println("No matching airport found.");
        }  
    }
    return "NY";
}


float[] getCoordinates(String state)
{
    TableRow row = coordTable.findRow(state, "state");
    float x = row.getFloat(" x");
    float y = row.getFloat(" y");
    return new float[]{x, y};
}
// TT - query function for MapWidget which takes in an ArrayList of FlightPath objects 
public ArrayList<FlightPath> getFlightPaths(String table, String airport, String[] dates)
{
    String query; String destState; float[] destCoords;
    ArrayList<FlightPath> paths = new ArrayList<FlightPath>();
    String state = getStateFromAirport(airport);
    float[] originCoords = getCoordinates(state);
    int minDate = Integer.valueOf(dates[0].substring(8, 10));
    int maxDate = Integer.valueOf(dates[1].substring(8, 10));
    query = "SELECT * FROM " + table +
        " WHERE SUBSTR(FlightDate, 9, 2) >= '" + String.format("%02d", minDate) +
        "' AND SUBSTR(FlightDate, 9, 2) <= '" + String.format("%02d", maxDate) +
        "' AND OriginState LIKE '%" + state + "%'";
    db.query(query);  
    try
    { 
        while (db.next())
        {
            destState = db.getString("DestState");
            destCoords = getCoordinates(destState);
            paths.add(new FlightPath(originCoords[0], originCoords[1], destCoords[0], destCoords[1]));
        }
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }
    return paths;
}

// TT - created lineplot query function for flights per day of month 26/3/24 10AM
public LinePlotParams getLinePlotData(String table, SQLite db, String airport, String[] dates)
{

    int minDate = Integer.valueOf(dates[0].substring(8, 10));
    int maxDate = Integer.valueOf(dates[1].substring(8, 10));
    if (table == "flights10k" && maxDate >= 07) maxDate = 6;
    else if (table == "flights2k" && maxDate >= 01) maxDate = 1;

    // println("" + minDate + " to " + maxDate);
    float[] datesXAxis = new float[maxDate-minDate+1];
    float[] numFlightsYAxis = new float[maxDate-minDate+1];

    for (int i = minDate; i <= maxDate; i++) {
        datesXAxis[i-minDate] = i;
        numFlightsYAxis[i-minDate] = 0;
    }
    String query;
    if (airport.equals("ALL"))
        query = "SELECT * FROM " + table + " WHERE SUBSTR(FlightDate, 9, 2) >= '"+ String.format("%02d", minDate) +"' AND SUBSTR(FlightDate, 9, 2) <= '"+ String.format("%02d", maxDate)+"'";
    else
        query = "SELECT * FROM " + table +
            " WHERE SUBSTR(FlightDate, 9, 2) >= '" + String.format("%02d", minDate) +
            "' AND SUBSTR(FlightDate, 9, 2) <= '" + String.format("%02d", maxDate) +
            "' AND Origin LIKE '%" + airport + "%'";

    
    db.query(query);

    try { 
        while (db.next()) { 
            String flightDate = db.getString("FlightDate"); 
            int day = Integer.parseInt(flightDate.substring(8, 10));
            int cancelled = db.getInt("Cancelled");
            if (day >= minDate && day <= maxDate && cancelled == 0) {
                numFlightsYAxis[day - minDate] += 1;
            }
        }
    }
    catch (Exception e) {
        e.printStackTrace();
    }

    float[] datesRangeX = new float[]{minDate, maxDate};
    float minFlights = numFlightsYAxis[0];
    for (float i : numFlightsYAxis) {
        if (i < minFlights) {
            minFlights = i;
        }
    }
    float maxFlights = numFlightsYAxis[0];
    for (float i : numFlightsYAxis) {
        if (i > maxFlights) {
            maxFlights = i;
        } 
    }
    float[] flightRangeY = new float[]{0, (float)maxFlights+(float)(maxFlights/10)};
    return new LinePlotParams(datesXAxis, numFlightsYAxis, datesRangeX, flightRangeY); 
} 
 
// RSR - created method to populate Histogram with following bins - 19/3/24 8PM 
public HistParams populateHistFreqs(int minBin, int step, int lastBin) 
{
    String[] dateRange = getDates();
    Integer[] bins = new Integer[(lastBin-minBin)/step+2];
    
    // Generates bins to display using minBin, lastBin, and step
    for (int i = 0; i < bins.length; i++)
    {
        if (i == bins.length-1) bins[i] = null;
        else bins[i] = minBin+step*i;
    }
    
    // RSR - improved method with extra parameters and loop - 20/3/24 5PM
    // Gets frequencies for each bin from db and stores them in float[] freqs
    float[] freqs = new float[bins.length-1];
    for (int i = 0; i < freqs.length; i++)
    {
        db.query("SELECT COUNT(Delay) AS freq FROM delays WHERE Delay >= "+(minBin+step*i)+
            ( (i == freqs.length-1)? "" : " AND Delay < "+(minBin+step+step*i) )+
            " AND \"Date\" BETWEEN \""+dateRange[0]+"\" AND \""+dateRange[1]+"\""+
            ( (getAirportCode().equals("ALL")) ? "" : " AND Origin = \""+getAirportCode()+"\"" )+";");
        // println((minBin+step*i)+" --- "+(i==lastBin));
        freqs[i] = db.getInt("freq");
        // println(freqs[i]);
    }
    
    // Resizes y-axis depending on frequency range
    int max = 0;
    for (int i = 0; i < freqs.length; i++) {
        if (freqs[i] > max) {
            max = (int) freqs[i];
        }
    }
    int mag = 1;
    while (max > mag*10)
    {
        mag *= 10;
    }
    max = (max/mag + 1) * mag;
    
    return new HistParams(bins, freqs, max);
}

// CSF - wrote the back-end for the bubble chart
public BubbleParams makeBubbleParams()
{
    String query = """SELECT IATA_Code_Marketing_Airline as airline,
        COUNT(Cancelled) as len,
        SUM(Cancelled) as cancelled,
        SUM(Diverted) as diverted
        FROM flights_full
        """;

    String[] dates = getDates();
    query += " WHERE FlightDate BETWEEN '" + dates[0] + "' AND '" + dates[1] + "'";

    String airport = getAirportCode();
    if (!airport.equals("ALL"))
    {
        query += " AND Origin = '" + airport + "'";
    }
    query += "\nGROUP BY airline";

    db.query(query);

    String[] carriers = new String[0];
    float[] cancelledPct = new float[0];
    float[] divertedPct = new float[0];
    float[] marketShare = new float[0];
    int totalFlights = 0;

    while (db.next())
    {
        int numFlights = db.getInt("len");
        totalFlights += numFlights;

        carriers = append(carriers, db.getString("airline"));
        cancelledPct = append(cancelledPct, 100.0 * db.getInt("cancelled")/numFlights);
        divertedPct = append(divertedPct, 100.0 * db.getInt("diverted")/numFlights);
        marketShare = append(marketShare, 100.0 * numFlights);
    }
    for (int i=0; i<marketShare.length; i++)
    {
        marketShare[i] = marketShare[i]/totalFlights;
    }
    return new BubbleParams(cancelledPct, divertedPct, marketShare, carriers);
}

//Will S finds all airports within a select state from the scroll bar 27/3/24
//Queries database to find number of flights in a state from a database and returns it in a parameter class
CategoricalParams populateBarParams()
{
    String query = """SELECT Origin as airport,
    COUNT(Origin) as num_flights
        FROM flights_full
        """;

    String[] dates = getDates();
    query += " WHERE FlightDate BETWEEN '" + dates[0] + "' AND '" + dates[1] + "'";

    String airport = getAirportCode();
    if (!airport.equals("ALL"))
    {
        query += " AND OriginState = '" + getAirportState() + "'";
    }
    query += "\nGROUP BY airport";
    db.query(query);

    String[] airports = new String[0];
    float[] numFlights = new float[0];
    while (db.next())
    {
        airports = append(airports, db.getString("airport"));
        numFlights = append(numFlights, db.getInt("num_flights"));
    }
    return new CategoricalParams(numFlights, airports);
}

//Will S
//Queries database for 4 columns for a scrollTable and returns them in the appropriate parameter class
ScrollTableParams populateDataList()
{
  String query = "SELECT FlightDate, IATA_Code_Marketing_Airline, OriginCityName, DestCityName FROM "+getTable();
  db.query(query);
  String[] dates = new String[0];
  String[] carriers = new String[0];
  String[] origins = new String[0];
  String[] dests = new String[0];
  while(db.next())
  {
    dates = append(dates, db.getString("FlightDate"));
    carriers = append(carriers, db.getString("IATA_Code_Marketing_Airline"));
    origins = append(origins, db.getString("OriginCityName"));
    dests = append(dests, db.getString("DestCityName"));
  }
  return new ScrollTableParams(dates, carriers, origins, dests);
}

public HeatMapParams makeHeatMapParams()
{
    String query = """SELECT
        DepTime/2 as timeBin,
        strftime('%w', flightDate) as dayOfWeek,
        COUNT(*) as flightVolume
    FROM flights_full
        WHERE CANCELLED = 0
    """;

    String[] dates = getDates();
    query += " AND FlightDate BETWEEN '" + dates[0] + "' AND '" + dates[1] + "'";

    String airport = getAirportCode();
    if (!airport.equals("ALL"))
    {
        query += " AND Origin = '" + airport + "'";
    }
    query += "\nGROUP BY timeBin, dayOfWeek";
    println(query);
    db.query(query);

    float[][] data = new float[12][7];
    while (db.next())
    {
        int timeBin = db.getInt("timeBin");
        int dayOfWeek = db.getInt("dayOfWeek");
        data[timeBin][dayOfWeek] = db.getInt("flightVolume");
    }
    return new HeatMapParams(data);
}

//Kilian 27/03/24 - created function to retrieve data from database to populate the graph
//       04/04    - fixed to use actual data and populate delayed to start of program,
//                  also added ability to query data also now has real time labels
//       08/04    - fixed issue with x and y scale when restricting data
public ScatterParams populateScatterPlot()
{
   
    int carriers;
    int numberOfQueries;
    String table = getTable();
    String selectedAirport = getAirportCode();
   
    String query = "";
    
    String[] dates = getDates();
    query += " WHERE FlightDate BETWEEN '" + dates[0] + "' AND '" + dates[1] + "'";
    
    String airport = getAirportCode();
    if (!airport.equals("ALL"))
    {
        query += " AND OriginState = '" + getAirportState() + "'";
    }

    float[] flightVolume = new float[0];
    float[] flightDuration = new float[0];

    db.query("SELECT MAX(flight_volume) AS HighestFlightVolume FROM(SELECT IATA_Code_Marketing_Airline, COUNT(*) AS flight_volume FROM "+ table + query +" GROUP BY IATA_Code_Marketing_Airline) AS subquery");
    int xMax = db.getInt("HighestFlightVolume");
    print(xMax + " ");

    db.query("SELECT MAX(TotalDistance) AS HighestFlightDuration FROM (SELECT IATA_Code_Marketing_Airline, SUM(Distance) AS TotalDistance FROM " + table + query +" GROUP BY IATA_Code_Marketing_Airline) AS subquery");
    int yMax = db.getInt("HighestFlightDuration");
    print(yMax + " ");
    
    db.query("SELECT IATA_Code_Marketing_Airline, SUM(Distance) AS TotalDistance FROM "+table + query +" GROUP BY IATA_Code_Marketing_Airline");
    while (db.next())
    {
        flightDuration = append(flightDuration, db.getFloat("TotalDistance"));
    }

    db.query("SELECT IATA_Code_Marketing_Airline, COUNT(*) AS flight_volume FROM " + table + query+ " GROUP BY IATA_Code_Marketing_Airline");
    while (db.next())
    {
        flightVolume  = append(flightVolume, db.getFloat("flight_volume"));
    }
    String[] carriersName = new String[0];
    db.query("SELECT DISTINCT IATA_Code_Marketing_Airline AS airline FROM "+ table + query);
    while (db.next())
    {
      carriersName = append(carriersName, db.getString("airline"));
    }
    return new ScatterParams(flightVolume, flightDuration, xMax, yMax, carriersName);
}
// TT - wrote initial version within DataPoint class which was then updated by RSR as seen below

// Receives a date from downloaded csv with format: MM/dd/yyyy OR M/d/yyyy
// and converts it to default format: dd-MM-yyyy
public String dateToLocalDate(String stringDate) {
    // RSR - updated method to handle different date formats that are found in e.g. flights_full.csv - 13/3/24
    String[] split = stringDate.split("\\s+", 2);
    LocalDate date = LocalDate.parse(split[0], DateTimeFormatter.ofPattern("[MM/dd/yyyy][M/d/yyyy]"));
    return date.toString();
}
// TT - wrote initial version within DataPoint class which was then updated by RSR as seen below

// Receives a time from downloaded csv with format: HHmm
// and converts it to HH:mm
public LocalTime timeToLocalTime(String stringTime) {
    // RSR - updated method to handle empty time values (if flight was e.g. cancelled) - 12/3/24
    try
    {
        String paddedTime = String.format("%04d", Integer.parseInt(stringTime));
        String formattedTime = paddedTime.substring(0, 2) + ":" + paddedTime.substring(2, 4);
        return LocalTime.parse(formattedTime, DateTimeFormatter.ofPattern("HH:mm"));
    }
    catch (NumberFormatException e)
    {
        return null;
    }
}

/*
 RSR - methods to create an ArrayList of DataPoints from the loaded table  - 12/3/24 9PM
 and to populate the database with that ArrayList.
   (Since removed because DataPoint, which was made by Tim, was scrapped)
*/
