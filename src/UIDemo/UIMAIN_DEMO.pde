// CSF - added a simple demo UI to showcase the checkboxes and radiobuttons - 13/4/2024 10PM
void weekOneDemo()
{
    final int SCREEN_COLOR = #778899;
    final int WIDGET_COLOR = #F0F8FF;
    
    Screen screen1 = new Screen(SCREEN_COLOR);
    screens.addScreen(screen1);
    
    Widget mainFrame = new Widget(width/2, height/2, width-20, height-20, WIDGET_COLOR);
    screen1.addWidget(mainFrame);
    
    CheckBoxList checkBoxes = new CheckBoxList(
        25, 25,
        "Option Select",
        new String[]{"Alice", "Bob", "Charlie", "Dave", "Eve", "Frank"}
    );
    checkBoxes.fontSize=16;
    mainFrame.addChild(checkBoxes);
    
    RadioButtonList radioButtons = new RadioButtonList(
        125, 25,
        "Favorite Color",
        new String[]{"Bingo","Bango","Bongo","Bish","Bash","Bosh"}
    );
    radioButtons.fontSize=16;
    mainFrame.addChild(radioButtons);
}

void chartDemo()
{
    // our nav button, which can go forward and back with left- and right-clicks,
    // used on all screens. in practice a two-button solution might be better but
    // this is easy and showcases the versatility of our MouseListener interface

    //ReactiveWidget navButton = new ReactiveWidget(width-50, height-40, 40, 30, 255, "<R-L>");
    //navButton.addListener(e -> {
    //    if (e.getAction() != MouseEvent.PRESS) { return; }
    //    switch (e.getButton()) {
    //        case LEFT:             // on left click, next screen
    //            activeScreen++;
    //            break;
    //        case RIGHT:            // on right click, prev screen
    //            activeScreen--;
    //            break;
    //    }
    //    activeScreen = (activeScreen<0 ? screens.size()-1 : activeScreen%screens.size()); // wrap-around logic
    //});
    
    Container navButtons = initNavButtons();
    
    // ---------------------------- SCREEN 1 ---------------------------- //
    
    Screen screen1 = new Screen(128);
    screen1.addWidget(navButtons);
    screens.addScreen(screen1);
    
    // demos of the simple widgets, courtesy of the Minecraft Joke Book
    Widget w1 = new Widget(width/2, 20, 100, 30, color(255,225,225), "I do Nothing!" );
    w1.setStroke(255);
    screen1.addWidget(w1);
    
    Label l1 = new Label( 20, 20, "Label!" );
    screen1.addWidget(l1);
    
    ReactiveWidget r1 = new ReactiveWidget(width-50, 20, 80, 30, color(225,255,225), "Button!");
    r1.setStroke(0);
    r1.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) { return ; }
        println("He was destroyed in turn!");
    });
    screen1.addWidget(r1);
   
    // Histogram demo courtesy of the Knights who say 'Ni'
    Histogram h1 = new Histogram(width/2, height/2, 300, 300,
        "Utterances of 'Ni' per day reported by the knights who say 'Ni'",
        "Utterances", "Freq. of Occurrence",
        new Integer[] {0,5,10,15,20,25}, new double[] {1,4,9,5,2}, 10
    );
    h1.fontSize = 14;
    h1.labelFormatStringY = "%.0f";
    h1.numAxisTicksY = 6;
    screen1.addWidget(h1);
    
    // displaying the capabilty to add named children to a screen so
    // they can be kept track of without putting them in global space
    screen1.addNamedChild(w1, "Base Class Widget");
    screen1.addNamedChild(l1, "Label");
    screen1.addNamedChild(r1, "Button Example");
    screen1.addNamedChild(h1, "Histogram demo");
    //screen1.displayNamedChildren();
    
    // ---------------------------- SCREEN 2 ---------------------------- //
    
    Screen screen2 = new Screen(128);
    screen2.addWidget(navButtons);
    screens.addScreen(screen2);
    
    // Arbitrary shapes can be drawn by supplying a function as so.
    // Coordinates are relative to the first two parameters in the constructor (x,y)
    // Motion as a function of time can be done by using frameCount (see below commented)
    // but this degrades over time, so it's not suggested.
    Shape rotatedTriangle = new Shape(30,30, color(200,200,255),
    () -> {
        rotate(PI/4.5);
        //float period = 4.0;
        //rotate(TAU*(frameCount%(period*frameRate))/(period*frameRate));
        beginShape();
        vertex(-20,-12);
        vertex(20,-12);
        vertex(0,24);
        endShape(CLOSE);
    });
    screen2.addWidget(rotatedTriangle);
    
    // Bar Plot demo courtesy of The Bridge Keeper
    BarPlot c1 = new BarPlot(width/2, height/2, 300, 300,
        "Maximum Airspeed of an Unladen Swallow by Species",
        "Species", "Maximum Airspeed (km/h)",
        new String[] {"African", "European", "Asiatic"}, new double[] {15, 10.75, 19}, 24
    );
    c1.fontSize = 14;
    c1.labelFormatStringY = "%.0f";
    screen2.addWidget(c1);
    
    // ---------------------------- SCREEN 3 ---------------------------- //
    
    Screen screen3 = new Screen(128);
    screen3.addWidget(navButtons);
    screens.addScreen(screen3);
    
    // Scatter plot, using example data courtesy of cos()
    int numVals = 30;
    double[] xVals = new double[numVals], yVals = new double[numVals];
    for (int i=0; i<numVals; i++)
    {
        double propI = TAU/(numVals-1) * i;
        xVals[i] = propI;
        yVals[i] = cos((float)propI);
    }
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 300, 300,
        "F(x) = Cos(x)", "x", "cos(x)",
        xVals, yVals, new int[] {-1,7}, new int[]{-3,3}
    );
    s1.fontSize = 14;
    s1.labelFormatStringY = "%.1f";
    s1.labelFormatStringX = "%.0f";
    
    // play around with these to make the chart feel like a line chart or a scatter plot (or a line chart with points drawn)
    s1.connect = true;
    s1.markers = false;
    //s1.makeLinePlot();    // Or just this, for a 1-line solution
    screen3.addWidget(s1);
}

final int MARGIN = 20;
final int NAV_SIZE = 30;
final int NAV_PAD = 5;

void navDemo()
{
    final int SCREEN_COLOR = #778899;
    final int WIDGET_COLOR = #F0F8FF;
   
    imageMode(CENTER);
    
    Screen screen1 = new Screen(SCREEN_COLOR);
    screens.add(screen1);
    
    Screen screen2 = new Screen(100);
    screens.add(screen2);
    
    Widget w1 = new Widget(width/2,height/2,width-2*MARGIN,height-2*MARGIN,WIDGET_COLOR);
    screen1.addWidget(w1);
    
    Container navButtons = initNavButtons();
    for (Screen s : screens)
    {
        s.addWidget(navButtons);
    }
    
    CheckBoxList checkBoxes = new CheckBoxList(
        25, 25,
        "Option Select",
        new String[]{"Alice", "Bob", "Charlie", "Dave", "Eve", "Frank"}
    );
    checkBoxes.fontSize=16;
    screen1.addWidget(checkBoxes);
    
    RadioButtonList radioButtons = new RadioButtonList(
        125, 25,
        "Favorite Color",
        new String[]{"Bingo","Bango","Bongo","Bish","Bash","Bosh"}
    );
    radioButtons.fontSize=16;
    screen1.addWidget(radioButtons);
}

Container initNavButtons()
{
    Container navButtons = new Container();
    
    int forwardPad = MARGIN+NAV_SIZE/2+NAV_PAD;
    PImage forwardNav = loadImage("forward_nav.png");
    Image img1 = new Image(
        width-forwardPad, height-forwardPad,
        NAV_SIZE, NAV_SIZE, forwardNav
    );
    navButtons.addChild(img1);
    
    ReactiveWidget forwardButton = new ReactiveWidget(width-forwardPad, height-forwardPad, NAV_SIZE, NAV_SIZE);
    forwardButton.drawn = false;
    navButtons.addChild(forwardButton);
    forwardButton.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) { return; }
        activeScreen++; activeScreen%=screens.size();
    });
    
    int backwardPad = forwardPad + NAV_SIZE + NAV_PAD;
    PImage backwardNav = loadImage("backward_nav.png");
    Image img2 = new Image(
        width-backwardPad, height-forwardPad,    // same pad Y
        NAV_SIZE, NAV_SIZE, backwardNav
    );
    navButtons.addChild(img2);
    
    ReactiveWidget backwardButton = new ReactiveWidget(width-backwardPad, height-forwardPad, NAV_SIZE, NAV_SIZE);
    backwardButton.drawn = false;
    navButtons.addChild(backwardButton);
    backwardButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) { return; }
        activeScreen = (activeScreen == 0 ? screens.size()-1 : activeScreen-1);
    });
    
    return navButtons;
}
