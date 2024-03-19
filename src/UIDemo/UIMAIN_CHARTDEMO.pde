
void Wk2Demo()
{
    final int BG_MARGIN = 20;
    final int SCREEN_COLOR = #778899;
    final int BACKGROUND_COLOR = #F0F8FF;
    
    Container navButtons = initNavButtons();
    Widget background = new Widget(width/2, height/2, width-2*BG_MARGIN, height-2*BG_MARGIN, BACKGROUND_COLOR);
    
    surface.setTitle("Flight Data Visualisation App");

    Screen titleScreen = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(titleScreen, "Title Screen");   
    titleScreen.addWidget(background);
    titleScreen.addWidget(navButtons);

    Label titleLabel = new Label(width/2, BG_MARGIN + 25, "Flight Data Visualisation App");
    titleLabel.fontSize = 36;
    titleLabel.justify = CENTER;
    titleScreen.addWidget(titleLabel);

    final int COLUMN_SIDE_PAD = 40;   
    final int COLUMN_VERT_PAD = 80; 
    final int INDENT = 15;

    // left side

    // Date restriction
    Label dateRestrictLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD,
        "Restrict Date Range:"
    );
    dateRestrictLabel.fontSize = 24;
    titleScreen.addWidget(dateRestrictLabel);

    Label startDateLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT,
        BG_MARGIN+COLUMN_VERT_PAD+30,
        "Start Date:"
    );
    startDateLabel.fontSize = 20;
    titleScreen.addWidget(startDateLabel);

    Label endDateLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT,
        BG_MARGIN+COLUMN_VERT_PAD+90,
        "End Date:"
    );
    endDateLabel.fontSize = 20;
    titleScreen.addWidget(endDateLabel);

    // Airport selection
    Label airportSelectorLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD+150,
        "Select Airport:"
    );
    airportSelectorLabel.fontSize = 24;
    titleScreen.addWidget(airportSelectorLabel);

    // Table Selection
    String[] tables = new String[]{"flights2k.csv", "flights10k.csv", "flights_full.csv"};
    RadioButtonList tableSelector = new RadioButtonList(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD+300,
        "Select Table to Query:",
        tables, 24, 20
    );
    titleScreen.addWidget(tableSelector);

    // Right side
    final int COLUMN_RIGHT = 3*width/4;
    final int BTN_WIDTH = 200, BTN_HEIGHT = 40, BTN_MARGIN = 10;

    final String[] BTN_NAMES = new String[]{
        "Market Share by Airline",
        "Departure Delay Times",
        "Reliability vs Market Share",
        "Flight Map",
        "Flight Volume Heatmap",
        "Flight Duration Vs Volume",
        "Tim's Line Plot"
    };
    final int[] BTN_COLORS = new int[]{
        #ffb3ba, #ffdfba, #ffffba, #baffc9, #bae1ff, #c3b1e1, #ffd1dc
    };

    Label dataQueryLabel = new Label(COLUMN_RIGHT, BG_MARGIN+COLUMN_VERT_PAD, "Visualize Query Data:");
    dataQueryLabel.fontSize = 24;
    dataQueryLabel.justify = CENTER;
    titleScreen.addWidget(dataQueryLabel);


    for (int i=0; i<BTN_NAMES.length; i++)
    {
        final String NAME = BTN_NAMES[i];
        ReactiveWidget btn = new ReactiveWidget(
            COLUMN_RIGHT, BG_MARGIN+COLUMN_VERT_PAD + (BTN_HEIGHT+BTN_MARGIN)*(i+1),
            BTN_WIDTH, BTN_HEIGHT, BTN_COLORS[i], NAME
        );
        btn.setStroke(0);
        btn.addListener((e,w) -> {
            if (e.getAction() != MouseEvent.PRESS) {return;}
            if (loadScreenWithArgs(NAME)) { surface.setTitle(NAME); }
        });
        titleScreen.addWidget(btn);
        titleScreen.addNamedChild(btn, NAME);
    }
    // --- SCREEN 1: Market Share Pie Chart --- //

    Screen screen1 = new Screen(SCREEN_COLOR);        // these four lines should go more or less unchanged at the beginning of each screen        
    screens.addNamedScreen(screen1, "Market Share by Airline");    // except of course change 'screen1' for the name of the screen
    screen1.addWidget(background);
    screen1.addWidget(navButtons);

    double[] marketShare = new double[]{5,30,100,24,60};
    String[] airlines = new String[]{"AA","UA","DL","B6","HA"};
    PieChart p1 = new PieChart(width/2,height/2,width/2,height/2,"Market Share by Airline", marketShare, airlines);
    screen1.addWidget(p1);    

    // --- SCREEN 2: HISTOGRAM DEMO --- //

    Screen screen2 = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(screen2, "Departure Delay Times");
    screen2.addWidget(background);
    screen2.addWidget(navButtons);
    
    Histogram h1 = demoHistogram();
    screen2.addWidget(h1);

    // --- Screen 4: Flight Map --- //
    
    Screen screen4 = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(screen4, "Flight Map");
    screen4.addWidget(background);
    screen4.addWidget(navButtons);
    
    
    // --- Screen 6 - Avg Departure Delay  --- //

    Screen screen6 = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(screen6, "Flight Duration Vs Volume");
    screen6.addWidget(background);
    screen6.addWidget(navButtons);
    
    ScatterPlot s1 = demoScatterPlot();
    screen6.addWidget(s1);

    // --- Screen 7 - Tim's Line Plot --- //

    Screen screen7 = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(screen7, "Tim's Line Plot");
    screen7.addWidget(background);
    screen7.addWidget(navButtons);

}

boolean loadScreenWithArgs(String screenName)
{
    boolean success = screens.setActiveScreen(screenName);
    
    // processing goes here
    
    return success;
}

Histogram demoHistogram()
{
    Integer[] bins = new Integer[]{-60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, null};
    double[] quantities = new double[]{2, 2, 25, 644, 26824, 293591, 84166, 33941, 20416, 13843, 10087, 7712, 6104, 31095};
    
    Histogram h1 = new Histogram(width/2, height/2, 480, 480,
        "Flight Departure Delay (Minutes, negative delays represent early departures)",
        "Delay", "Freq. of Occurrence",
        bins, quantities, 300000
    );

    h1.fontSize = 12;
    h1.labelFormatStringY = "%,.0f";
    h1.numAxisTicksY = 6;
    
    return h1;
}

ScatterPlot demoScatterPlot(){
 //double DelayAA = 6.21, DelayAS = 15.79, DelayB6 = 3.88, DelayDL = 1.2, DelayF9 = 2.9, DelayG4 = 1.8, DelayHA = 5.5
 double durationAA = 309, durationAS = 310.76, durationB6 = 250, durationHA = 375, durationNK =130, durationG4 = 110, durationWN = 189, durationUA = 70, durationDL =39, durationF9 = 500; 
 int Carriers = 10;
 int AA = 149, AS = 120, B6 = 144,HA = 98, NK = 95, G4 = 47,WN = 125,UA = 31,DL = 6,F9 = 55;
    double[] xVals = new double[]{AA,AS,B6,HA,NK,G4,WN,UA,DL,F9}, yVals = new double[]{durationAA,durationAS,durationB6,durationHA, durationNK, durationG4, durationWN, durationUA, durationDL, durationF9};
    for (int i=1; i<Carriers; i++)
    {
        xVals[i] =xVals[i];
        yVals[i] = yVals[i];
    }
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 400, 400,
        "Flight Duration Vs Volume by Carrier", "Volume by Carrier", "Average Flight Duration",
        xVals, yVals, new int[] {0,150}, new int[]{0,550}
    );
    s1.fontSize = 14;
    s1.labelFormatStringY = "%.1f";
    s1.labelFormatStringX = "%.0f";
    
    // play around with these to make the chart feel like a line chart or a scatter plot (or a line chart with points drawn)
    s1.connect = false;
    s1.markers = true;
    //s1.makeLinePlot();    // Or just this, for a 1-line solution
    return s1;
    
}

// Other demo functions go here and get added to chartDemoNew() in a new Screen
// - for convention, make your function return the object (ex. Histogram above) so it can be manipulated in the main function
