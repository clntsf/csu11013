// CSF - Implemented Widget by extending Exercise 6 reponse/challenge 12/3/2024 5PM
// don't touch this this is perfect
class Widget
{
    int x;
    int y;
    int w;
    int h;
    String text;
    int fontSize = 16;
    boolean isHovered;
    Color backgroundColor;
    boolean hasStroke = false;
    Color strokeColor;
    Color textColor;
    ArrayList<Widget> children;
    
    Widget(int x, int y, int w, int h)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        textColor = new ThemedColor(themes, "text");
        this.isHovered = false;
        this.children = new ArrayList<>();
    }
    
    Widget(int x, int y, int w, int h, Color backgroundColor)
    {
        this(x,y,w,h);
        this.backgroundColor = backgroundColor;
    }
    
    Widget(int x, int y, int w, int h, Color backgroundColor, String text)
    {
        this(x,y,w,h,backgroundColor);
        this.text = text;
    }
    
    Widget(int x, int y, int w, int h, Color backgroundColor, String text, Color textColor)
    {
        this(x,y,w,h,backgroundColor);
        this.text = text;
        this.textColor = textColor;
    }
    
    // set the stroke of the widget to the color provided (see ColorUtil.pde for Color subclasses)
    void setStroke(Color strokeColor)
    {
        this.strokeColor = strokeColor;
        this.hasStroke = true;
    }
    
    // deals with widget stroke during .draw()
    void applyStroke()
    {
        if (!hasStroke) { noStroke(); }
        else {
            stroke(strokeColor.getColor());
            strokeWeight(1);
        }
    }
    
    // deals with widget fill during .draw(), done this way to allow subclasses to change this behavior
    void applyFill()
    {
        fill(backgroundColor.getColor());
    }
    
    // add a child widget to this widget
    void addChild(Widget child)
    {
        children.add(child);
    }
    
    // check if the widget or its children are hovered recursively
    // (mainly used by ReactiveWidgets, but done here so the recursion can traverse the whole tree)
    void updateHover()
    {
        for (Widget child : children)
        {
            child.updateHover();
        }
    }
    
    // respond to an event of type Processing.Event (MouseEvent, KeyEvent are the principal ones)
    // again, done here so the recursion can traverse the whole tree of widgets
    void onEvent(Event e)
    {
        for (Widget child : children)
        {
            child.onEvent(e);
        }
    }
    
    // draw each child of this widget (this function will be called in the child widgets as well)
    void drawChildren()
    {
        for (Widget w : children)
        {
            w.draw();
        }
    }
    
    // draw this widget to the screen.
    void draw()
    {
        textFont(font);
        applyStroke();
        applyFill();
        rectMode(CENTER);
        rect(x,y,w,h);
        
        if (text != null)
        {
            fill(textColor.getColor());
            textAlign(CENTER,CENTER);
            textSize(fontSize);
            text(text,x,y);
        }
        
        drawChildren();
    }
}
