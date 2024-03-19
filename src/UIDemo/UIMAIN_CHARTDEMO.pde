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
        "Kilian's Scatter Plot"
    };
    final int[] BTN_COLORS = new int[]{
        #ffb3ba, #ffdfba, #ffffba, #baffc9, #bae1ff, #c3b1e1
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

    // --- SCREEN 1: HISTOGRAM DEMO --- //
    Screen screen1 = new Screen(SCREEN_COLOR);        // these four lines should go more or less unchanged at the beginning of each screen        
    screens.addNamedScreen(screen1, "Departure Delay Times");    // except of course change 'screen1' for the name of the screen
    screen1.addWidget(background);
    screen1.addWidget(navButtons);
    
    Histogram h1 = demoHistogram();
    screen1.addWidget(h1);

    // --- Screen 2 --- //
    
    Screen screen2 = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(screen2, "Flight Map");
    screen2.addWidget(background);
    screen2.addWidget(navButtons);

    Screen screen3 = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(screen3, "Kilian's Scatter Plot");
    screen3.addWidget(background);
    screen3.addWidget(navButtons);
    
    Screen screen4 = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(screen4, "Tim's Line Plot");
    screen4.addWidget(background);
    screen4.addWidget(navButtons);

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

// Other demo functions go here and get added to chartDemoNew() in a new Screen
// - for convention, make your function return the object (ex. Histogram above) so it can be manipulated in the main function
