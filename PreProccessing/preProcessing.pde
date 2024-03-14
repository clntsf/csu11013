Table table;
PrintWriter output;

void setup() {
  String[] originList = new String[0];
  table = loadTable("flights2k.csv", "header");
  println(table.getRowCount() + " total rows in table");
  boolean unique = true;
  for (TableRow row : table.rows()) {
    unique = true;
    String origin = row.getString("ORIGIN");
    for (int i = 0; i < originList.length; i++){
      println(origin + " "+ originList[i]);
      if (originList[i].equals(origin)){
        unique = false;
      }
    }
    if (unique == true){
      originList = append(originList, origin);
    }
  }
  output = createWriter("Origins.txt"); 
  for(int i = 0; i < originList.length; i++){
    output.println(originList[i]);
  }
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
