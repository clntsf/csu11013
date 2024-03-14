Table table;
void setup() {
  table = loadTable("flights2k(1).csv", "header");
  TableRow exampleRow = table.getRow(0);
  DataPoint exampleStored = new DataPoint(exampleRow.getString("FL_DATE"), exampleRow.getString("MKT_CARRIER"), exampleRow.getString("MKT_CARRIER_FL_NUM"), exampleRow.getString("ORIGIN"),
                                      exampleRow.getString("ORIGIN_CITY_NAME"), exampleRow.getString("ORIGIN_STATE_ABR"), exampleRow.getInt("ORIGIN_WAC"), exampleRow.getString("DEST"),
                                      exampleRow.getString("DEST_CITY_NAME"), exampleRow.getString("DEST_STATE_ABR"), exampleRow.getInt("DEST_WAC"), exampleRow.getString("CRS_DEP_TIME"),
                                      exampleRow.getString("DEP_TIME"), exampleRow.getString("CRS_ARR_TIME"), exampleRow.getString("ARR_TIME"), exampleRow.getInt("CANCELLED"),
                                      exampleRow.getInt("CANCELLED"), exampleRow.getFloat("DISTANCE"));
  System.out.printf("%s %s %s %s %s", exampleStored.getFlightDate(), exampleStored.getMarketingCarrier(), exampleStored.getMarketingCarrierFlightNumber(), exampleStored.getOrigin(), exampleStored.getOriginCityName());
}
