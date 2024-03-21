// CSF - implemented ScreenList to streamline toplevel UI - 16/3/2024 7PM
class ScreenList
{
    ArrayList<Screen> screens;
    HashMap<String, Screen> namedScreens;
    int activeScreen;
    
    ScreenList()
    {
        screens = new ArrayList<>();
        namedScreens = new HashMap<>();
    }
    
    public void addScreen(Screen s)
    {
        screens.add(s);
    }
    
    public void addNamedScreen(Screen s, String name)
    {
        addScreen(s);
        namedScreens.put(name, s);
    }
    
    public Screen getActiveScreen()
    {
        return screens.get(activeScreen);
    }
    
    public Screen getNamedScreen(String name)
    {
        return namedScreens.get(name);
    }
    
    public void nextScreen()
    {
        activeScreen++;
        activeScreen%=screens.size();
    }
    
    public void prevScreen()
    {
        activeScreen = (activeScreen==0 ? screens.size() : activeScreen) - 1;
    }

    public boolean setActiveScreen(int index)
    {
        if (0>index || index>screens.size())
        {
            return false;
        }
        activeScreen = index;
        return true;
    }

    public boolean setActiveScreen(String name)
    {
        Screen newActive = namedScreens.get(name);
        if (newActive == null)
        {
            return false;
        } 
        activeScreen = screens.indexOf(newActive);
        return true;
    }
}

// CSF - Implemented Screen by extending Exercise 6 reponse/challenge 12/3/2024 5PM
class Screen
{
    ArrayList<Widget> widgets;
    HashMap<String, Widget> namedChildren;
    color bgColor;
    
    Screen(color bgColor)
    {
        widgets = new ArrayList<>();
        namedChildren = new HashMap<>();
        this.bgColor = bgColor;
    }
    
    void addWidget(Widget w)
    {
        widgets.add(w);
    }
    
    void addNamedChild(Widget w, String name)
    {
        namedChildren.put(name,w);
    }
    
    void displayNamedChildren()
    {
        for (Map.Entry<String, Widget> entry : namedChildren.entrySet())
        {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }

    Widget getNamedChild(String name)
    {
        return namedChildren.get(name);
    }
    
    void draw()
    {
        background(bgColor);
        for (Widget w : widgets)
        {
            w.draw();
        }
    }
    
    void handleMouseEvent(MouseEvent e)
    {
        for (Widget w : widgets)
        {
            w.onMouseEvent(e);
        }
    }
    
    void mouseMoved()
    {
        for (Widget w : widgets)
        {
            w.updateHover();
        }
    }
}
