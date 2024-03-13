// CSF - Implemented Screen by extending Exercise 6 reponse/challenge 12/4/2024 5PM
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
