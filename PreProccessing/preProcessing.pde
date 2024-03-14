Table table;
PrintWriter output;

void setup() {
  table = loadTable("flights2k.csv", "header");
  println(table.getRowCount() + " total rows in table");
  String headerName = "DEP_TIME";
  uniqueItems(headerName);
  exit(); // Stops the program
}
void uniqueItems(String header){
  String[] sList = new String[0];
  boolean unique = true;
  for (TableRow row : table.rows()) {
    unique = true;
    String value = row.getString(header);
    for (int i = 0; i < sList.length; i++){
      println(value + " "+ sList[i]);
      if (sList[i].equals(value)){
        unique = false;
      }
    }
    if (unique == true){
      sList = append(sList, value);
    }
  }
  output = createWriter(header + ".txt"); 
  for(int i = 0; i < sList.length; i++){
    output.println(sList[i]);
  }
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}
