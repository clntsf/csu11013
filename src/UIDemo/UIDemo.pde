import de.bezier.data.sql.SQLite;
import java.util.Map;

ScreenList screens = new ScreenList();
PFont font;
String DB_NAME;
SQLite db;

void setup()
{
    size(640, 640);
    font = createFont("Outfit-Regular.ttf", 13);
    DB_NAME = "tables";

    // RSR - added SQLite functionality and font - 12/3/24 7PM
    if (createDBFile())
    {
        initDB();
    }
    db = new SQLite(this, DB_NAME+".db");
    if (db.connect())
    {
        println("Connected to DB!");
    } else println("ERROR connecting to DB!");

    Wk2Demo();
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
