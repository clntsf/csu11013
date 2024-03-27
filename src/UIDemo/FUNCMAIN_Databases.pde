import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

//macnalll - created method of accessing data from the database into a piechart 26/3/24
public PieParams getPieChartData(String table, String selectedAirport)
{    
    String column = "IATA_Code_Marketing_Airline";
    if (selectedAirport != "ALL") db.query("SELECT " +column+ ", COUNT(*) AS frequency FROM " +table+ " WHERE Origin LIKE '%" +selectedAirport+ "%' GROUP BY " +column);
    else db.query("SELECT " +column+ ", COUNT(*) AS frequency FROM " +table+ " GROUP BY " +column);
    Map<String, Integer> frequencyMap = new HashMap<>();
    while (db.next())
    {
        String value = db.getString(column);
        int frequency = db.getInt("frequency"); //<>//
        frequencyMap.put(value, frequency); 
    }
    
    int size = frequencyMap.size();
    String[] categories = new String[size];
    double[] valuesY = new double[size];
    
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

// TT - created basic lineplot query function for flights per day of month 26/3/24 10AM
public LinePlotParams getLinePlotData(String table, SQLite db, String airport, String[] dates) 
{
    
    int minDate = Integer.valueOf(dates[0].substring(8, 10));
    int maxDate = Integer.valueOf(dates[1].substring(8, 10));
    System.out.println("" + minDate + " to " + maxDate);
    double[] datesXAxis = new double[maxDate-minDate+1];
    double[] numFlightsYAxis = new double[maxDate-minDate+1];
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
          int day = Integer.parseInt(flightDate.substring(8, 10)); //<>//
          int cancelled = db.getInt("Cancelled"); //<>//
          if (day >= minDate && day <= maxDate && cancelled == 0) { //<>//
              numFlightsYAxis[day - minDate] += 1; 
          }
      }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    
        
    float[] datesRangeX = new float[]{minDate, maxDate};
    double minFlights = numFlightsYAxis[0];
    for (double i : numFlightsYAxis) {
      if (i < minFlights) {
          minFlights = i;
      }
    }
    double maxFlights = numFlightsYAxis[0];
    for (double i : numFlightsYAxis) {
      if (i > maxFlights) {
          maxFlights = i;
      }
    }
    float[] flightRangeY = new float[]{0, (float)maxFlights+(float)(maxFlights/10)};
    return new LinePlotParams(datesXAxis, numFlightsYAxis, datesRangeX, flightRangeY);
}

// RSR - created method to populate Histogram with following bins - 19/3/24 8PM //<>//
public HistParams populateHistFreqs(int minBin, int step, int lastBin) //<>//
{ //<>//
    String[] dateRange = getDates();
    //if (dateRange[0] == "" || dateRange[1] == "") {println("null");}
    Integer[] bins = new Integer[(lastBin-minBin)/step+2];
    for (int i = 0; i < bins.length; i++)
    {
        if (i == bins.length-1) bins[i] = null;
        else bins[i] = minBin+step*i;
    }
    //println(bins);
    double[] freqs = new double[bins.length-1];
    // RSR - improved method with extra parameters and loop - 20/3/24 5PM
    for (int i = 0; i < freqs.length; i++)
    {
        db.query("SELECT COUNT(Delay) AS freq FROM delays WHERE Delay >= "+(minBin+step*i)+
                ( (i == freqs.length-1)? "" : " AND Delay < "+(minBin+step+step*i) )+
                " AND \"Date\" BETWEEN \""+dateRange[0]+"\" AND \""+dateRange[1]+"\""+
                ( (getAirportCode().equals("ALL")) ? "" : " AND Origin = \""+getAirportCode()+"\"" )+";");
        //println((minBin+step*i)+" --- "+(i==lastBin));
        freqs[i] = db.getInt("freq");
        println(freqs[i]);
    }
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
    //println("maxFreq is "+max);
    return new HistParams(bins, freqs, max);
}

public BubbleParams makeBubbleParams()
{

    String[] carriers = new String[]{"AA", "AS", "B6", "DL", "F9", "G4", "HA", "NK", "UA", "WN"};
    double[] cancelledPct = new double[]{5.776, 6.289, 9.788, 4.689, 4.452, 8.308, 3.698, 3.424, 8.693, 6.618};
    double[] divertedPct = new double[] {0.157, 0.455, 0.244, 0.234, 0.141, 0.172, 0.187, 0.114, 0.276, 0.132};
    float[] mktShare = new float[]{0.2651, 0.0526, 0.0378, 0.2089, 0.0214, 0.0155, 0.0104, 0.0311, 0.1844, 0.1728};

    return new BubbleParams(cancelledPct, divertedPct, mktShare, carriers);
}

//Will S finds all airports within a select state from the scroll bar 27/3/24
public String[] getStateAirports(String stateCode)
{
  String[] airportsInState = new String[0];
  String[] airportsInCountry = loadStrings("airports.txt");
  for (String a: airportsInCountry)
  {
    String aState = a.substring(a.length() - 2, a.length());
    if (aState.equals(stateCode))
    {
      airportsInState = append(airportsInState, a);
    }
  }
  //db.query("SELECT DISTINCT ORIGIN from flights_full WHERE ORIGIN_STATE_ABR=" + stateCode);
  //while(db.next()){
  //  airportsInState = append(airportsInState, db.getString("ORIGIN"));
  //}
  return airportsInState;
}
// Will S  finds all flights from an airport 27/3/24
public BarParams populateBarParams(String[] airports)
{
  double[] numOfFlights = new double[airports.length];
  for(int i = 0; i < airports.length; i++)
  {
    db.query("SELECT COUNT(Origin) AS freq FROM flights_full WHERE Origin='" + airports[i] + "';");
    numOfFlights[i] = db.getInt("freq");
    println(numOfFlights[i]);
  }
  return new BarParams(airports, numOfFlights);
}

public String dateToLocalDate(String stringDate) {
    // RSR - updated method to handle different date formats that are found in e.g. flights_full.csv - 13/3/24
    String[] split = stringDate.split("\\s+", 2);
    LocalDate date = LocalDate.parse(split[0], DateTimeFormatter.ofPattern("[MM/dd/yyyy][M/d/yyyy]"));
    return date.toString();
}

public LocalTime timeToLocalTime(String stringTime) {
    try
    {
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
