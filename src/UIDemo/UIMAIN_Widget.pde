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
        textColor = new StaticColor(0);
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
    
    void setStroke(Color strokeColor)
    {
        this.strokeColor = strokeColor;
        this.hasStroke = true;
    }
    
    void applyStroke()
    {
        if (!hasStroke) { noStroke(); }
        else {
            stroke(strokeColor.getColor());
            strokeWeight(1);
        }
    }
    
    void applyFill()
    {
        fill(backgroundColor.getColor());
    }
    
    void addChild(Widget child)
    {
        children.add(child);
    }
    
    void updateHover()
    {
        for (Widget child : children)
        {
            child.updateHover();
        }
    }
    
    void onEvent(Event e)
    {
        for (Widget child : children)
        {
            child.onEvent(e);
        }
    }
    
    void drawChildren()
    {
        for (Widget w : children)
        {
            w.draw();
        }
    }
    
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
