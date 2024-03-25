import java.time.*;
import java.time.format.DateTimeFormatter;

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
