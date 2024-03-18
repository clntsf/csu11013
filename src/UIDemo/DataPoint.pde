import java.time.*;
import java.time.format.DateTimeFormatter;

public class DataPoint {
  DateTimeFormatter[] dateFormatters = {
                  DateTimeFormatter.ofPattern("dd/MM/yyyy"),
                  DateTimeFormatter.ofPattern("M/d/yyyy")
  };
  private LocalDate flightDate;
  private String marketingCarrier;
  private String marketingCarrierFlightNumber;
  private String origin;
  private String originCityName;
  private String originStateAbr;
  private int originWac;
  private String destination;
  private String destinationCityName;
  private String destStateAbr;
  private int destWac;
  private LocalTime crsDepTime;
  private LocalTime depTime;
  private LocalTime crsArrTime;
  private LocalTime arrTime;
  private int cancelled;
  private int diverted;
  private int distance;
  
  public DataPoint(String flightDate, String marketingCarrier, String marketingCarrierFlightNumber,
                   String origin, String originCityName, String originStateAbr, int originWac,
                   String destination, String destinationCityName, String destStateAbr, int destWac,
                   String crsDepTime, String depTime, String crsArrTime, String arrTime,
                   int cancelled, int diverted, int distance) {
      this.flightDate = dateToLocalDate(flightDate);
      this.marketingCarrier = marketingCarrier;
      this.marketingCarrierFlightNumber = marketingCarrierFlightNumber;
      this.origin = origin;
      this.originCityName = originCityName;
      this.originStateAbr = originStateAbr;
      this.originWac = originWac;
      this.destination = destination;
      this.destinationCityName = destinationCityName;
      this.destStateAbr = destStateAbr;
      this.destWac = destWac;
      this.crsDepTime = timeToLocalTime(crsDepTime);
      this.depTime = timeToLocalTime(depTime);
      this.crsArrTime = timeToLocalTime(crsArrTime);
      this.arrTime = timeToLocalTime(arrTime);
      this.cancelled = cancelled;
      this.diverted = diverted;
      this.distance = distance;
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
    } catch(NumberFormatException e) {return null;}
    // RSR - updated method to handle empty time values (if flight was e.g. cancelled) - 12/3/24
  }

  public LocalDate getFlightDate() {
      return flightDate;
  }

  public void setFlightDate(LocalDate flightDate) {
      this.flightDate = flightDate;
  }
  
  public String getMarketingCarrier() {
      return marketingCarrier;
  }
  
  public void setMarketingCarrier(String marketingCarrier) {
      this.marketingCarrier = marketingCarrier;
  }
  
  public String getMarketingCarrierFlightNumber() {
      return marketingCarrierFlightNumber;
  }
  
  public void setMarketingCarrierFlightNumber(String marketingCarrierFlightNumber) {
      this.marketingCarrierFlightNumber = marketingCarrierFlightNumber;
  }
  
  public String getOrigin() {
      return origin;
  }
  
  public void setOrigin(String origin) {
      this.origin = origin;
  }
  
  public String getOriginCityName() {
      return originCityName;
  }
  
  public void setOriginCityName(String originCityName) {
      this.originCityName = originCityName;
  }
  
  public String getOriginStateAbr() {
      return originStateAbr;
  }
  
  public void setOriginStateAbr(String originStateAbr) {
      this.originStateAbr = originStateAbr;
  }
  
  public int getOriginWac() {
      return originWac;
  }
  
  public void setOriginWac(int originWac) {
      this.originWac = originWac;
  }
  
  public String getDestination() {
      return destination;
  }
  
  public void setDestination(String destination) {
      this.destination = destination;
  }
  
  public String getDestinationCityName() {
      return destinationCityName;
  }
  
  public void setDestinationCityName(String destinationCityName) {
      this.destinationCityName = destinationCityName;
  }
  
  public String getDestStateAbr() {
      return destStateAbr;
  }
  
  public void setDestStateAbr(String destStateAbr) {
      this.destStateAbr = destStateAbr;
  }
  
  public int getDestWac() {
      return destWac;
  }
  
  public void setDestWac(int destWac) {
      this.destWac = destWac;
  }
  
  public LocalTime getCrsDepTime() {
      return crsDepTime;
  }
  
  public void setCrsDepTime(LocalTime crsDepTime) {
      this.crsDepTime = crsDepTime;
  }
  
  public LocalTime getDepTime() {
      return depTime;
  }
  
  public void setDepTime(LocalTime depTime) {
      this.depTime = depTime;
  }
  
  public LocalTime getCrsArrTime() {
      return crsArrTime;
  }
  
  public void setCrsArrTime(LocalTime crsArrTime) {
      this.crsArrTime = crsArrTime;
  }
  
  public LocalTime getArrTime() {
      return arrTime;
  }
  
  public void setArrTime(LocalTime arrTime) {
      this.arrTime = arrTime;
  }
  
  public int getCancelled() {
      return cancelled;
  }
  
  public void setCancelled(int cancelled) {
      this.cancelled = cancelled;
  }
  
  public int getDiverted() {
      return diverted;
  }
  
  public void setDiverted(int diverted) {
      this.diverted = diverted;
  }
  
  public int getDistance() {
      return distance;
  }
  
  public void setDistance(int distance) {
      this.distance = distance;
  }
  
  public boolean isCancelled() {
      return cancelled == 1;
  }
  
  public boolean isDiverted() {
      return diverted == 1;
  }
}
