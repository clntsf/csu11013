import de.bezier.data.sql.*;
import java.util.Map;

ArrayList<Screen> screens = new ArrayList<>();
int activeScreen = 0;

SQLite db;
boolean dbPopulated;

void setup()
{
    size(400,400);
    initUI();

    Table table = loadTable("flights2k.csv", "header");
    String tableName = "flights2k";
    db = new SQLite(this, "test.db");

    if (db.connect())
    {
      new Thread(() -> populateDatabase(table, tableName)).start(); // shouldn't have to do always but we'll add a check later
    }
    else
    {
        println("Error connecting to database!");
    }
    
}

// CSF - added a simple demo UI to showcase the checkboxes and radiobuttons - 13/4/2024 10PM
void initUI()
{
    final int SCREEN_COLOR = #778899;
    final int WIDGET_COLOR = #F0F8FF;
    
    Screen screen1 = new Screen(SCREEN_COLOR);
    screens.add(screen1);
    
    Widget mainFrame = new Widget(width/2, height/2, width-20, height-20, WIDGET_COLOR);
    screen1.addWidget(mainFrame);
    
    CheckBoxList checkBoxes = new CheckBoxList(
        25, 25,
        "Option Select",
        new String[]{"Alice", "Bob", "Charlie", "Dave", "Eve", "Frank"}
    );
    checkBoxes.fontSize=16;
    mainFrame.addChild(checkBoxes);
    
    RadioButtonList radioButtons = new RadioButtonList(
        125, 25,
        "Favorite Color",
        new String[]{"Bingo","Bango","Bongo","Bish","Bash","Bosh"}
    );
    radioButtons.fontSize=16;
    mainFrame.addChild(radioButtons);
}

Screen getActiveScreen()
{
    return screens.get(activeScreen);
}

void printText() {
    int y = 10;
    final int TEXT_X = 20;
    fill(0);
    db.query("SELECT * FROM flights2k LIMIT 10");
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

void draw()
{
    getActiveScreen().draw();
    if(dbPopulated) { printText(); }
}

// CSF - added functions to pass inputs to the UI elements 13/3/2024 10PM
void mousePressed(MouseEvent evt)
{
    getActiveScreen().handleMouseEvent(evt);
}

void mouseMoved()
{
    getActiveScreen().mouseMoved();
}
