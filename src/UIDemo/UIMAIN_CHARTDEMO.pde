
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
        "Will's BarPlot",
        "Average Departure Delay",
        "Tim's Line Plot"
    };
    final int[] BTN_COLORS = new int[]{
        #ffb3ba, #ffdfba, #ffffba, #baffc9, #bae1ff, #8686af, #c3b1e1, #ffd1dc
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

    Screen mktShareScr = new Screen(SCREEN_COLOR);        // these four lines should go more or less unchanged at the beginning of each screen        
    screens.addNamedScreen(mktShareScr, "Market Share by Airline");    // except of course change 'screen1' for the name of the screen
    mktShareScr.addWidget(background);
    mktShareScr.addWidget(navButtons);

    PieChart p1 = demoPie();
    mktShareScr.addWidget(p1);    

    // --- SCREEN 2: HISTOGRAM DEMO --- //

    Screen histScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(histScr, "Departure Delay Times");
    histScr.addWidget(background);
    histScr.addWidget(navButtons);
    
    Histogram h1 = demoHistogram();
    screen2.addWidget(h1);

    // --- Screen 4: Flight Map --- //
    
    Screen mapScr = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(mapScr, "Flight Map");
    mapScr.addWidget(background);
    mapScr.addWidget(navButtons);
    
    // --- Screen 6 - Bar Plot Screen  --- //

    Screen barPlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(barPlotScr, "Will's BarPlot");
    barPlotScr.addWidget(background);
    barPlotScr.addWidget(navButtons);
    
    BarPlot b1 = demoBarPlot();
    barPlotScr.addWidget(b1);
    
    // --- Screen 7 - Avg Departure Delay  --- //

    Screen depDelayScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(depDelayScr, "Average Departure Delay");
    depDelayScr.addWidget(background);
    depDelayScr.addWidget(navButtons);
    
    ScatterPlot s1 = demoScatterPlot();
    depDelayScr.addWidget(s1);

    // --- Screen 8 - Tim's Line Plot --- //

    Screen linePlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(linePlotScr, "Tim's Line Plot");
    linePlotScr.addWidget(background);
    linePlotScr.addWidget(navButtons);

}

boolean loadScreenWithArgs(String screenName)
{
    boolean success = screens.setActiveScreen(screenName);
    
    // processing goes here
    
    return success;
}

PieChart demoPie()
{
    double[] marketShare = new double[]{5,30,100,24,60};
    String[] airlines = new String[]{"AA","UA","DL","B6","HA"};
    return new PieChart(
        width/2,height/2,width/2,height/2,
        "Market Share by Airline",
        marketShare, airlines
    );
}
Histogram demoHistogram()
{
    Integer[] bins = new Integer[]{-60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, null};
    double[] freqs = new double[]{2, 2, 25, 644, 26824, 293591, 84166, 33941, 20416, 13843, 10087, 7712, 6104, 31095};
    HistParams histParams = new HistParams(bins, freqs);
    
    Histogram h = new Histogram(width/2, height/2, 480, 480,
        "Flight Departure Delay (Minutes, negative delays represent early departures)",
        "Delay", "Frequency",
        histParams.bins, histParams.freqs, 300000
    );

    h.fontSize = 12;
    h.labelFormatStringY = "%,.0f";
    h.numAxisTicksY = 6;
    
    return h;
}

ScatterPlot demoScatterPlot(){
 int numVals = 50;
 int daysOfWeek = 8;
    double[] xVals = new double[daysOfWeek], yVals = new double[numVals];
    for (int i=1; i<daysOfWeek; i++)
    {
   // String flightDate = db.getString("FlightDate");
    //System.out.println(flightDate);
  //  String origin = db.getString("Origin");
    //String destination = db.getString("Dest");
      double averageDelay = 0;
      
        double propI = TAU/(numVals-1) * i;
        xVals[i] = i;
        yVals[i] = cos((float)propI);
    }
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 300, 300,
        "Average Departure Delay by Day", "Day of Week", "Average Delay (minutes)",
        xVals, yVals, new int[] {1,7}, new int[]{0,180}
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

void demoBarPlot() {}