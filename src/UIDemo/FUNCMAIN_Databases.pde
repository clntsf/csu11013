import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

// TT - created basic lineplot query function for flights per day of month 26/3/24 10AM
public LinePlotParams getLinePlotData(int minDate, int maxDate, String table) 
{
    double[] datesXAxis = new double[maxDate-minDate+1];
    double[] numFlightsYAxis = new double[maxDate-minDate+1];
    for (int i = minDate; i <= maxDate; i++) {
        datesXAxis[i-minDate] = i;
        numFlightsYAxis[i-minDate] = 0;
    }
    
    String query = "SELECT * FROM " + table + " WHERE SUBSTR(FlightDate, 1, 2) >= '"+ String.format("%02d", minDate) +"' AND SUBSTR(FlightDate, 1, 2) <= '"+ String.format("%02d", maxDate) +"'";
    db.query(query);
    
    try {
      while (db.next()) {
          String flightDate = db.getString("FlightDate");
          int day = Integer.parseInt(flightDate.substring(0, 2));
          int cancelled = db.getInt("Cancelled");
          if (day >= minDate && day <= maxDate && cancelled == 0) {
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
    float[] flightRangeY = new float[]{(float)minFlights, (float)maxFlights};
    return new LinePlotParams(datesXAxis, numFlightsYAxis, datesRangeX, flightRangeY);
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
    //println(bins);
    double[] freqs = new double[bins.length-1]; //<>//
    // RSR - improved method with extra parameters and loop - 20/3/24 5PM //<>//
    for (int i = 0; i < freqs.length; i++)
    {
        db.query("SELECT COUNT(Delay) AS freq FROM delays WHERE Delay >= "+(minBin+step*i)+ ((i == freqs.length-1)? "" : " AND Delay < "+(minBin+step+step*i)) );
        //println((minBin+step*i)+" --- "+(i==lastBin));
        freqs[i] = db.getInt("freq");
        //println(freqs[i]);
    }
    
    return new HistParams(bins, freqs);
}

public String dateToLocalDate(String stringDate) {
    // RSR - updated method to handle different date formats that are found in e.g. flights_full.csv - 13/3/24
    DateTimeFormatter[] dateFormatters =
    {
                  DateTimeFormatter.ofPattern("MM/dd/yyyy"),
                  DateTimeFormatter.ofPattern("M/d/yyyy")
    };
    String[] split = stringDate.split("\\s+", 2);
    LocalDate date;
    try
    {
        date = LocalDate.parse(split[0], dateFormatters[0]);
    }
    catch (Exception e)
    {
        date = LocalDate.parse(split[0], dateFormatters[1]);
    }
    return date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
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
