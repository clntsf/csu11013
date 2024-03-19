import de.bezier.data.sql.SQLite;
import java.util.Map;

ScreenList screens = new ScreenList();
PFont font;

SQLite db;
boolean dbPopulated;

void setup()
{
    size(600,600);
    font = createFont("Outfit-Regular.ttf", 13);
    
    //chartDemo();
    //navDemo();
    Wk2Demo();

    // RSR - added SQLite functionality and font - 12/3/24 7PM
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

void draw()
{
    screens.getActiveScreen().draw();
    // if(dbPopulated) { printText(); }
}

// CSF - added functions to pass inputs to the UI elements 13/3/2024 10PM
void mousePressed(MouseEvent evt)
{
    screens.getActiveScreen().handleMouseEvent(evt);
}

void mouseMoved()
{
    screens.getActiveScreen().mouseMoved();
}
