import java.util.Map;

ArrayList<Screen> screens;
int activeScreen = 0;


void setup()
{
    Screen screen1 = new Screen();
    screens.add(screen);
}

Screen getActiveScreen()
{
    return screens.get(activeScreen);
}

// void printText(){}

void draw()
{
    getActiveScreen().draw();

}
