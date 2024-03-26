import java.util.concurrent.atomic.AtomicReference;

void Wk2Demo()
{
    final int BG_MARGIN = 20;
    final int SCREEN_COLOR = #778899;
    final int BACKGROUND_COLOR = #F0F8FF;

    final String MAIN_TITLE = "Flight Data Visualisation App";
    surface.setTitle(MAIN_TITLE);

    Widget background = new Widget(
        width/2, height/2, width-2*BG_MARGIN,
        height-2*BG_MARGIN, BACKGROUND_COLOR
    );
    // back to title button, add to each new screen
    ReactiveWidget titleButton = new ReactiveWidget(
        width-BG_MARGIN-60, height-BG_MARGIN-25, 100, 30,
        SCREEN_COLOR, "Back to Title"
    );
    titleButton.setStroke(0);
    titleButton.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
        screens.setActiveScreen("Title Screen");
        surface.setTitle(MAIN_TITLE);
    });

    final Screen titleScreen = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(titleScreen, "Title Screen");   
    titleScreen.addWidget(background);

    Label titleLabel = new Label(width/2, BG_MARGIN + 25, "Flight Data Visualisation App");
    titleLabel.fontSize = 36;
    titleLabel.justify = CENTER;
    titleScreen.addWidget(titleLabel);

    final int COLUMN_SIDE_PAD = 40;   
    final int COLUMN_VERT_PAD = 80; 
    final int INDENT = 15;

    // left side

    // Date restriction
    final String DATE_REGEX = "[0-9/]";
    
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

    TextEntry startDateEntry = new TextEntry(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT+160,
        BG_MARGIN+COLUMN_VERT_PAD+30,
        100, 25
    );
    titleScreen.addWidget(startDateEntry);
    titleScreen.addNamedChild(startDateEntry, "DATE_START");
    startDateEntry.regex = DATE_REGEX;

    Label endDateLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT,
        BG_MARGIN+COLUMN_VERT_PAD+90,
        "End Date:"
    );
    endDateLabel.fontSize = 20;
    titleScreen.addWidget(endDateLabel);

    TextEntry endDateEntry = new TextEntry(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT+160,
        BG_MARGIN+COLUMN_VERT_PAD+90,
        100, 25
    );
    titleScreen.addWidget(endDateEntry);
    titleScreen.addNamedChild(endDateEntry, "DATE_END");
    endDateEntry.regex = DATE_REGEX;

    // Airport selection
    Label airportSelectorLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD+150,
        "Select Airport:"
    );
    airportSelectorLabel.fontSize = 24;
    titleScreen.addWidget(airportSelectorLabel);

    String[] airports = loadStrings("airports.txt");
    ScrollSelector airportSelector = new ScrollSelector(
        BG_MARGIN + COLUMN_SIDE_PAD + 125,
        BG_MARGIN + COLUMN_SIDE_PAD + 305,
        250, 160, airports
    );
    titleScreen.addWidget(airportSelector);
    titleScreen.addNamedChild(airportSelector, "Airport Selector");

    // Table Selection
    String[] tables = new String[]{"flights2k.csv", "flights10k.csv", "flights_full.csv"};
    RadioButtonList tableSelector = new RadioButtonList(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD+350,
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
        "Flight Duration vs Volume",
        "Will's BarPlot",
        "Tim's Line Plot"
    };
    final int[] BTN_COLORS = new int[]{ #ffb3ba, #ffdfba, #ffffba, #baffc9, #bae1ff, #8686af, #c3b1e1, #ffd1dc, #f90b24 };

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
        titleScreen.addNamedChild(btn, "button: " + NAME);
    }
    // --- SCREEN 1: Market Share Pie Chart --- //

    Screen mktShareScr = new Screen(SCREEN_COLOR);        // these four lines should go more or less unchanged at the beginning of each screen        
    screens.addNamedScreen(mktShareScr, "Market Share by Airline");    // except of course change 'screen1' for the name of the screen
    mktShareScr.addWidget(background);
    mktShareScr.addWidget(titleButton);
    mktShareScr.addNamedChild(titleButton, "Title Button");

    PieChart p1 = demoPie();
    mktShareScr.addWidget(p1);    

    // --- SCREEN 2: HISTOGRAM DEMO --- //

    Screen histScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(histScr, "Departure Delay Times");
    histScr.addWidget(background);
    histScr.addWidget(titleButton);
    histScr.addNamedChild(titleButton, "Title Button");

    // RSR - if button pressed, chart is loaded. - 20/3/24 4PM
    
    ReactiveWidget histBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Departure Delay Times");
    histBtn.addListener((e,w) -> {
        AtomicReference<HistParams> hP = new AtomicReference<>(null);
        //Integer[] bins = new Integer[] {-60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, null};
        /*if (!histScr.widgets.isEmpty()) {
            histScr.widgets = new ArrayList<>();
            histScr.addWidget(background);
            histScr.addWidget(titleButton);
        }*/
        resetScreen(histScr, background);
        Thread histT = new Thread(() -> {
            hP.set(populateHistFreqs(-60, 10, 70));//bins, new double[bins.length-1]));
            Histogram h = demoHistogram(titleScreen, hP.get());
            histScr.addWidget(h);
        });
        histT.start();
    });

    // --- Screen 3: Bubble Plot --- //

    Screen reliabilityScr = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(reliabilityScr, "Reliability vs Market Share");
    reliabilityScr.addWidget(background);
    reliabilityScr.addWidget(titleButton);
    reliabilityScr.addNamedChild(titleButton, "Title Button");

    BubblePlot bubble = demoBubble();
    reliabilityScr.addWidget(bubble);
    
    // --- Screen 4: Flight Map --- //
    
    Screen mapScr = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(mapScr, "Flight Map");
    mapScr.addWidget(background);
    mapScr.addWidget(titleButton);
    mapScr.addNamedChild(titleButton, "Title Button");

    // --- Screen 6 - Scatter Plot Screen  --- //

    Screen flightVolScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(flightVolScr, "Flight Duration vs Volume");
    flightVolScr.addWidget(background);
    flightVolScr.addWidget(titleButton);
    flightVolScr.addNamedChild(titleButton, "Title Button");

    ScatterPlot s1 = demoScatterPlot();
    flightVolScr.addWidget(s1);
    
    // --- Screen 7 - Will's BarChart --- // Added by Will Sunderland 19/3/24 - updated 20/3/24

    Screen barPlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(barPlotScr, "Will's BarPlot");
    barPlotScr.addWidget(background);
    barPlotScr.addWidget(titleButton);
    barPlotScr.addNamedChild(titleButton, "Title Button");

    InteractiveBarPlot b1 = demoBarPlot();
    barPlotScr.addWidget(b1);

    // --- Screen 8 - Tim's Line Plot --- //

    Screen linePlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(linePlotScr, "Tim's Line Plot");
    linePlotScr.addWidget(background);
    linePlotScr.addWidget(titleButton);
    linePlotScr.addNamedChild(titleButton, "Title Button");
    
    ReactiveWidget linePlotBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Tim's Line Plot");
    linePlotBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
            resetScreen(linePlotScr, background);
            new Thread(() -> {
                ScatterPlot linePlot = demoLinePlot(db); 
                linePlotScr.addWidget(linePlot);
            }).start();
    });
    
    
}

boolean loadScreenWithArgs(String screenName)
{
    boolean success = screens.setActiveScreen(screenName);
    
    return success;
}

// RSR - resets screen - 26/3/24 2PM
void resetScreen(Screen s, Widget background)
{
    if (!s.widgets.isEmpty()) {
        s.widgets = new ArrayList<>();
        s.addWidget(background);
        s.addWidget(s.getNamedChild("Title Button"));
    }
}

ScatterPlot demoLinePlot(SQLite db)
{
    LinePlotParams testParams = getLinePlotData(1, 31, "flights_full", db);
    ScatterPlot s1 = new ScatterPlot(width / 2, height / 2, 400, 400,
        "Flights per day of the month",
        "Day of month", "Count of flights",
        testParams.valuesX, testParams.valuesY, testParams.axisRangeX, testParams.axisRangeY);
    s1.fontSize = 12;
    
    s1.labelFormatStringY = "%,.0f";
    s1.numAxisTicksY = 10;
    s1.numAxisTicksX = testParams.valuesX.length;
    s1.makeLinePlot();
    return s1;
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

BubblePlot demoBubble()
{
    String[] carriers = new String[]{"AA", "AS", "B6", "DL", "F9", "G4", "HA", "NK", "UA", "WN"};
    double[] cancelled_pct = new double[]{5.776, 6.289, 9.788, 4.689, 4.452, 8.308, 3.698, 3.424, 8.693, 6.618};
    double[] diverted_pct = new double[] {0.157, 0.455, 0.244, 0.234, 0.141, 0.172, 0.187, 0.114, 0.276, 0.132};
    float[] mkt_share = new float[]{0.2651, 0.0526, 0.0378, 0.2089, 0.0214, 0.0155, 0.0104, 0.0311, 0.1844, 0.1728};

    BubblePlot bubble = new BubblePlot(width/2, height/2, 470, 470,
        "Airline Reliability vs Market Share", "% Flights Cancelled",
        "% Flights Diverted", cancelled_pct, diverted_pct, mkt_share,
        carriers, new float[]{0,11}, new float[]{0,0.5}
    );
    bubble.maxSize = 90;
    bubble.labelFormatStringY = "%.2f";
    return bubble;
}

Histogram demoHistogram(Screen titleScreen, HistParams histParams)
{
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

ScatterPlot demoScatterPlot()
{
 //double DelayAA = 6.21, DelayAS = 15.79, DelayB6 = 3.88, DelayDL = 1.2, DelayF9 = 2.9, DelayG4 = 1.8, DelayHA = 5.5
 double durationAA = 309, durationAS = 310.76, durationB6 = 250, durationHA = 375, durationNK =130, durationG4 = 110, durationWN = 189, durationUA = 70, durationDL =39, durationF9 = 500; 
 int Carriers = 10;
 int AA = 149, AS = 120, B6 = 144,HA = 98, NK = 95, G4 = 47,WN = 125,UA = 31,DL = 6,F9 = 55;
    double[] xVals = new double[]{AA,AS,B6,HA,NK,G4,WN,UA,DL,F9};
    double[] yVals = new double[]{durationAA,durationAS,durationB6,durationHA, durationNK, durationG4, durationWN, durationUA, durationDL, durationF9};
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 400, 400,
        "Flight Duration Vs Volume by Carrier", "Volume by Carrier", "Average Flight Duration",
        xVals, yVals, new float[] {0,150}, new float[]{0,550}
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

InteractiveBarPlot demoBarPlot()
{
    String[] airlines2 = new String[]{"AA","UA","DL","B6","HA"};
    double[] numOfDelays = new double[]{12, 30, 20, 47, 33};
    InteractiveBarPlot b1 = new InteractiveBarPlot(width/2, height/2, 400, 400,
    "Delays by Market Carrier" , "Market Carrier", "Number of Delays",
    airlines2, numOfDelays, 50,
    50, height - 40, 30, 30);
    return b1;
}

String[] getDates()
{
    Screen title = screens.getNamedScreen("Title Screen");
    Widget startDate = (TextEntry)(title.getNamedChild("DATE_START"));
    Widget endDate = (TextEntry)(title.getNamedChild("DATE_END"));
    //println(startDate.text + " | " + endDate.text);
    return new String[] {startDate.text, endDate.text};
}

String getAirportCode()
{
    ScrollSelector sel = (ScrollSelector) (screens.getNamedScreen("Title Screen").getNamedChild("Airport Selector"));
    String selectedEntry = sel.entries[sel.selected];
    return selectedEntry.substring(0,3);
}
