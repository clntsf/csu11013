import de.bezier.data.sql.SQLite;
import java.util.Map;

ScreenList screens = new ScreenList();
PFont font;
SQLite db;

void setup()
{
    size(640, 640);
    font = createFont("Outfit-Regular.ttf", 13);

    //chartDemo();
    //navDemo();
    //weekOneDemo();


    // RSR - added SQLite functionality and font - 12/3/24 7PM
    //Table table = loadTable("flights_full.csv", "header");
    //String tableName = "flights_full";

    // println(LocalDate.parse("01/06/2022",DateTimeFormatter.ofPattern("MM/dd/yyyy")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

    if (createDBFile("tables"))
    {
        initDB("tables");
    }
    db = new SQLite(this, "tables.db");
    if (db.connect())
    {
        println("Connected to DB!");
    } else println("ERROR connecting to DB!");

    Wk2Demo();

    //Table delays = loadTable("delaysdemo.csv", "header");
    //if (db.connect())
    //{
    //new Thread(() -> populateFlightDBs(table, tableName)).start(); // shouldn't have to do always but we'll add a check later
    //new Thread(() -> populateDelays(delays)).start();
    //}
    //else println("Error connecting to database!");
}

void draw()
{
    screens.getActiveScreen().draw();
}

// CSF - added functions to pass inputs to the UI elements 13/3/2024 10PM
void mousePressed(MouseEvent mev)
{
    screens.getActiveScreen().handleEvent(mev);
}
void mouseReleased(MouseEvent mev)
{
    screens.getActiveScreen().handleEvent(mev);
}
void mouseDragged(MouseEvent mev)
{
    screens.getActiveScreen().handleEvent(mev);
}

void mouseMoved()
{
    screens.getActiveScreen().mouseMoved();
}

void mouseWheel(MouseEvent mev)
{
    screens.getActiveScreen().handleEvent(mev);
}


void keyPressed(KeyEvent kev)
{
    screens.getActiveScreen().handleEvent(kev);
}
