class Label extends Widget
{   

    Label(int x, int y, String text)
    {
        super(x,y,0,0);
        this.text = text;
    }
    
    Label(int x, int y, String text, color textColor)
    {
        this(x,y,text);
        this.textColor = textColor;
    }
    
    void draw()
    {
        //rectMode(CORNER);
        textAlign(LEFT, CENTER);
        textSize(fontSize);
        fill(textColor);
        text(text,x,y);
    }
}

class Shape extends Widget
{
    Runnable onDraw;

    Shape(int x, int y, color backgroundColor, Runnable onDraw)
    {
        super(x,y,0,0,backgroundColor);
        this.onDraw = onDraw;
    }
    
    void draw()
    {
        applyStroke();
        fill(backgroundColor);

        pushMatrix();
        translate(x,y);
        onDraw.run();
        popMatrix();
    }
}

class Image extends Shape
{
    Image(int x, int y, PImage image)
    {
        super(x,y,0,null);
        this.onDraw = ()->{imageMode(CENTER); image(image,0,0);};
    }
    Image(int x, int y, int w, int h, PImage image)
    {
        super(x,y,0,null);
        this.onDraw = ()->{imageMode(CENTER); image(image,0,0,w,h);};
    }
}

class Container extends Widget{
    Container()
    {
        super(0,0,0,0);
    }
    void draw() {drawChildren();}
}
