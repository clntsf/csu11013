import java.util.Map;

ArrayList<Screen> screens = new ArrayList<>();
int activeScreen = 0;

void setup()
{
    Screen screen1 = new Screen(255);
    screens.add(screen);
}

Screen getActiveScreen()
{
    return screens.get(activeScreen);
}

void printText(){}

void draw()
{
    getActiveScreen().draw();
    printText();
}
