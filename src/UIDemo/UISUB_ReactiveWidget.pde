import java.util.List;

interface MouseListener
{
    void performAction(MouseEvent e, ReactiveWidget widget);
}

// CSF - Implemented widgets which respond to input by extending Exercise 6 reponse/challenge 12/4/2024 5PM
class ReactiveWidget extends Widget
{
    ArrayList<MouseListener> eventListeners;
    boolean drawn = true;
    
    // borrowing all the parent constructors, seems there isn't a much
    // better way to do this because constructors can't be inherited
    ReactiveWidget(int x, int y, int w, int h){
        super(x,y,w,h);
        initListeners();
    }
    ReactiveWidget(int x, int y, int w, int h, color backgroundColor) {
        super(x,y,w,h,backgroundColor);
        initListeners();
    }
    ReactiveWidget(int x, int y, int w, int h, color backgroundColor, String text) {
        super(x,y,w,h,backgroundColor,text);
        initListeners();
    }
    ReactiveWidget(int x, int y, int w, int h, color backgroundColor, String text, color textColor) {
        super(x,y,w,h,backgroundColor,text,textColor);
        initListeners();
    }
    
    void updateHover()
    {
        this.isHovered = (
            x-w/2 <= mouseX && x+w/2 > mouseX &&
            y-h/2 <= mouseY && y+h/2 > mouseY
        );
        super.updateHover();
    }

    public void addListener(MouseListener listener)
    {
        eventListeners.add(listener);
    }
    
    void initListeners()
    {
        eventListeners = new ArrayList<>();
    }
    
    public void onMouseEvent(MouseEvent e)
    {
        if (!isHovered) { return; }
        
        for (MouseListener listener: eventListeners)
        {
            listener.performAction(e, this);
        }
        super.onMouseEvent(e);
    }
    
    void draw()
    {
        if (!drawn) { return; }
        super.draw();
    }
}

class CheckBox extends ReactiveWidget
{
    final color CHECKED_COLOR = #6495ED;
    final color UNCHECKED_COLOR = 225;
    
    CheckBoxList parent;
    String label;
    boolean checked;
    boolean isRectangular;

    MouseListener onClick = (e,w) -> {
        CheckBox widg = (CheckBox) w;
        widg.checked = !widg.checked;
        widg.parent.onCheck(widg);
    };

    CheckBox(int x, int y, String label)
    {
        super(x,y,10,10);
        this.addListener(onClick);
        this.label = label;
        isRectangular = true;
    }
    
    CheckBox(int x, int y, String label, boolean checked)
    {
        this(x,y,label);
        this.checked = checked;
    }
    
    void setParent(CheckBoxList parent)
    {
        this.parent = parent; 
    }
    
    void getFill()
    {
        fill(checked ? CHECKED_COLOR : UNCHECKED_COLOR);
    }
    
    void draw()
    {
        getFill();
        stroke(0);
        rectMode(CENTER);
        rect(x,y,w,h, (isRectangular ? w/4 : w/2));

        fill(0);
        textSize(fontSize);
        text(label, x+10, y);
    }
}
class CheckBoxList extends Container
{
    final int LABEL_FONT_SIZE = 14;
    final int BOX_FONT_SIZE = LABEL_FONT_SIZE-2;
    final int GAP = 15;
    final int BOX_SIZE = 10;
    final int HORIZ_PAD = 2;
    
    ArrayList<CheckBox> boxes;
    
    void onCheck(CheckBox c){}
    
    CheckBoxList(int x, int y, String labelText, String[] options)
    {
        super();
        Label listLabel = new Label(x,y+LABEL_FONT_SIZE/2,labelText);
        listLabel.fontSize = LABEL_FONT_SIZE;
        addChild(listLabel);
        
        y += LABEL_FONT_SIZE + GAP;
        for (String option : options)
        {
            CheckBox cb = new CheckBox(x+BOX_SIZE/2+HORIZ_PAD,y,option);
            cb.setParent(this);
            cb.fontSize = BOX_FONT_SIZE;
            addChild(cb);
            y += GAP;
        }
    }
    
    List<Widget> getBoxes()
    {
        return children.subList(1,children.size());
    }
    
    boolean[] getValues()
    {
        boolean[] values = new boolean[boxes.size()];
        for (int boxIdx = 0; boxIdx < boxes.size(); boxIdx++)
        { 
            values[boxIdx] = boxes.get(boxIdx).checked;
        }
        return values;
    }
}

class RadioButtonList extends CheckBoxList
{
    RadioButtonList(int x, int y, String labelText, String[] options)
    {
        super(x,y,labelText,options);
        for (Widget box : getBoxes())
        {
            ((CheckBox)box).isRectangular = false;
        }
    }
    
    void onCheck(CheckBox c)
    {
        for (Widget box : getBoxes())
        {
            ((CheckBox)box).checked = false;
        }
        c.checked = true;
    }
}
