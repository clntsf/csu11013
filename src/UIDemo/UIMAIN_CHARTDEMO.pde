import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.geo.*;

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
    String[] tables = new String[]{"flights2k", "flights10k", "flights_full"};
    RadioButtonList tableSelector = new RadioButtonList(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD+350,
        "Select Table to Query:",
        tables, 24, 20
    );
    titleScreen.addWidget(tableSelector);
    titleScreen.addNamedChild(tableSelector, "Table Selector");

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
        "Volume of State Flights",
        "Flights per Day",
        "Data Display"
    };
    final int[] BTN_COLORS = new int[]{ #ffb3ba, #ffdfba, #ffffba, #baffc9, #bae1ff, #8686af, #c3b1e1, #ffd1dc, #f90b24, #f90b24 };

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

    Screen mktShareScr = new Screen(SCREEN_COLOR);        // these 5 lines should go more or less unchanged at the beginning of each screen        
    screens.addNamedScreen(mktShareScr, "Market Share by Airline");    // except of course change 'mktShareScr' for the name of the screen
    mktShareScr.addWidget(background);
    mktShareScr.addWidget(titleButton);
    mktShareScr.addNamedChild(titleButton, "Title Button");

    ReactiveWidget mktShareButton = (ReactiveWidget) titleScreen.getNamedChild("button: Market Share by Airline");
    mktShareButton.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
            resetScreen(mktShareScr, background);
            new Thread(() -> {
                PieChart p1 = demoPie();
                mktShareScr.addWidget(p1); 
            }).start();
    });

    // --- SCREEN 2: HISTOGRAM DEMO --- //

    Screen histScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(histScr, "Departure Delay Times");
    histScr.addWidget(background);
    histScr.addWidget(titleButton);
    histScr.addNamedChild(titleButton, "Title Button");

    // RSR - if button pressed, chart is loaded. - 20/3/24 4PM
    ReactiveWidget histBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Departure Delay Times");
    histBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
        //AtomicReference<HistParams> hP = new AtomicReference<>(null);
        resetScreen(histScr, background);
        new Thread(() -> {
            HistParams hp = populateHistFreqs(-60, 10, 70);
            //hP.set(populateHistFreqs(-60, 10, 70));//bins, new float[bins.length-1]));
            Histogram h = demoHistogram(hp);
            resetScreen(histScr, background);
            histScr.addWidget(h);
        }).start();
    });

    // --- Screen 3: Bubble Plot --- //

    Screen reliabilityScr = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(reliabilityScr, "Reliability vs Market Share");
    reliabilityScr.addWidget(background);
    reliabilityScr.addWidget(titleButton);
    reliabilityScr.addNamedChild(titleButton, "Title Button");

    ReactiveWidget bubbleBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Reliability vs Market Share");
    bubbleBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}

        resetScreen(reliabilityScr, background);
        new Thread(() -> {
            BubbleParams bp = makeBubbleParams();
            BubblePlot bubble = demoBubble(bp);
            resetScreen(reliabilityScr, background);    // reset one more time in case the user has spammed the exit button
            reliabilityScr.addWidget(bubble);
        }).start();
    });

    // --- Screen 4: Flight Map --- //
    
    Screen mapScr = new Screen(SCREEN_COLOR);        
    screens.addNamedScreen(mapScr, "Flight Map");
    mapScr.addWidget(background);
    mapScr.addWidget(titleButton);
    mapScr.addNamedChild(titleButton, "Title Button");
    MapWidget map = new MapWidget(this, width / 2, height / 2, width, height);
    mapScr.addWidget(map);
    
    
    // --- Screen 5: Flight Volume Heatmap -- //
    
    Screen heatMapScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(heatMapScr, "Flight Volume Heatmap");
    heatMapScr.addWidget(background);
    heatMapScr.addWidget(titleButton);
    heatMapScr.addNamedChild(titleButton, "Title Button");

    ReactiveWidget heatmapButton = (ReactiveWidget) titleScreen.getNamedChild("button: Flight Volume Heatmap");
    heatmapButton.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
        new Thread(() -> {
            resetScreen(reliabilityScr, background);
            HeatMapParams params = generateFlightVolumeHeatmap();
            HeatMap hm = demoHeatMap(params);
            heatMapScr.addWidget(hm);
        }).start();
    });


    // --- Screen 6 - Kilian's Scatter Plot Screen  --- //

    Screen flightVolScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(flightVolScr, "Flight Duration vs Volume");
    flightVolScr.addWidget(background);
    flightVolScr.addWidget(titleButton);
    flightVolScr.addNamedChild(titleButton, "Title Button");

    
    // implemented listeners in main ui screen to load data once button for this graph is pressed 02/04
       ReactiveWidget scatterBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Flight Duration vs Volume");
    scatterBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}

        resetScreen(reliabilityScr, background);
        new Thread(() -> {
            ScatterPlot s1 = demoScatterPlot(populateScatterPlot());
            flightVolScr.addWidget(s1);
            resetScreen(reliabilityScr, background);    // reset one more time in case the user has spammed the exit button
        }).start();
    });
    
    // --- Screen 7 - Will's BarChart --- // Added by Will Sunderland 19/3/24 - updated 20/3/24

    Screen barPlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(barPlotScr, "Volume of State Flights");
    barPlotScr.addWidget(background);
    barPlotScr.addWidget(titleButton);
    barPlotScr.addNamedChild(titleButton, "Title Button");

    ReactiveWidget barPlotBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Volume of State Flights");
    barPlotBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}
          resetScreen(barPlotScr, background);
          new Thread(() -> {
          //InteractiveBarPlot b1 = demoBarPlot();
          CategoricalParams params = populateBarParamsRefined();
          InteractiveBarPlot b1 = barPlotPopulate(params);
          barPlotScr.addWidget(b1);
        }).start();
    });

    // --- Screen 8 - Tim's Line Plot --- //

    Screen linePlotScr = new Screen(SCREEN_COLOR);      
    screens.addNamedScreen(linePlotScr, "Flights per Day");
    linePlotScr.addWidget(background);
    linePlotScr.addWidget(titleButton);
    linePlotScr.addNamedChild(titleButton, "Title Button");
    
    ReactiveWidget linePlotBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Flights per Day");
    linePlotBtn.addListener((e,w) -> {
        if (e.getAction() != MouseEvent.PRESS) {return;}

        resetScreen(linePlotScr, background);
        new Thread(() -> {
            ScatterPlot linePlot = demoLinePlot(db); 
            linePlotScr.addWidget(linePlot);
        }).start();
    });
    
     // --- Screen 9 - Data Display --- //
     Screen dataScr = new Screen(SCREEN_COLOR);
     screens.addNamedScreen(dataScr, "Data Display");
     dataScr.addWidget(background);
     dataScr.addWidget(titleButton);
     dataScr.addNamedChild(titleButton, "Title Button");
     ScrollTable tempdata = new ScrollTable(
        width/2, height/2, 450, 450, airports, #ef6b6b
     );
     dataScr.addWidget(tempdata);
     dataScr.addNamedChild(tempdata, "Airport Selector");
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
    LinePlotParams testParams = getLinePlotData("flights_full", db, getAirportCode(), getDates());
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
    PieParams test = getPieChartData();
    return new PieChart(
        width/2,height/2,width/2,height/2,
        "Market Share by Airline",
        test.valuesY, test.categories
    );
}

BubblePlot demoBubble(BubbleParams params)
{
    // doing some norming for our axes
    float xMax = max(0.5, round(12*max(params.valuesX)) / 10.0);
    float yMax = max(0.5, round(12*max(params.valuesY)) / 10.0);

    BubblePlot bubble = new BubblePlot(width/2, height/2, 470, 470,
        "Airline Reliability vs Market Share", "% Flights Cancelled", "% Flights Diverted",
        params.valuesX, params.valuesY, params.valuesZ, params.categories, new float[]{0,xMax}, new float[]{0,yMax}
    );
    bubble.maxSize = 90;
    bubble.labelFormatStringY = "%.2f";
    
    return bubble;
}

HeatMap demoHeatMap(HeatMapParams params)
{
    HeatMap hm = new HeatMap(
        width/2, height/2, 420, 480, 
        "Flight Volume by Day of Week/Time of Day",
        params.data, VIRIDIS_CG
    );
    return hm;
}

Histogram demoHistogram(HistParams histParams)
{
    Histogram h = new Histogram(width/2, height/2, 480, 480,
        "Flight Departure Delay (Minutes, negative delays represent early departures)",
        "Delay", "Frequency",
        histParams.bins, histParams.freqs, histParams.maxFreq
    );
    
    h.fontSize = 12;
    h.labelFormatStringY = "%,.0f";
    h.numAxisTicksY = 6;
    return h;
}


ScatterPlot demoScatterPlot(ScatterPlotData theScatterPlotData)
{

    float xMax = theScatterPlotData.xMax;
    float yMax = theScatterPlotData.yMax;
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 400, 400,
        "Flight Duration Vs Volume by Carrier", "Volume by Carrier", "Average Flight Duration (minutes)",
        theScatterPlotData.flightVolume, theScatterPlotData.flightDuration, new float[] {0,xMax}, new float[]{0,yMax}
    );
    s1.fontSize = 14;
    s1.labelFormatStringY = "%.1f";
    s1.labelFormatStringX = "%.0f";
    return s1;
    
}
    

/*
InteractiveBarPlot demoBarPlot()
{
    String[] airlines2 = new String[]{"AA","UA","DL","B6","HA"};
    float[] numOfDelays = new float[]{12, 30, 20, 47, 33};
    String state = getAirportState();
    println(state);
    String[] airports = getStateAirports(state);
    //for (int i = 0; i < airports.length; i++){
    //  airports[i] = airports[i].substring(0, 3);
    //}
    BarParams test1 = populateBarParams(airports);
    // CategoricalParams test1 = populateBarParamsRefined();
    float maxHeight = 0;
    for(float size : test1.valuesY){
      if (size > maxHeight)
      {
        maxHeight = size;
      }
    } // test1.categories, test1.valuesY
    InteractiveBarPlot b1 = new InteractiveBarPlot(width/2, height/2, 450, 450,
    "Volume of Flights by Airports in a State" , "Airports", "Number of Flights",
    airports, test1.numOfFlights, int(1.05 * Math.round(maxHeight)),
    50, height - 40, 30, 30);
    return b1;
    
}*/

InteractiveBarPlot barPlotPopulate(CategoricalParams params)
{
    InteractiveBarPlot b1 = new InteractiveBarPlot(
        width/2, height/2, 450, 450,
        "Volume of Flights by Airports in a State" , "Airports", "Number of Flights",
        params.categories, params.valuesY,
        int(1.05 * Math.round(max(params.valuesY))),
        50, height - 40, 30, 30
    );
    return b1;
}

String[] getDates()
{
    Screen title = screens.getNamedScreen("Title Screen");
    Widget startDate = (TextEntry)(title.getNamedChild("DATE_START"));
    Widget endDate = (TextEntry)(title.getNamedChild("DATE_END"));
    //println(startDate.text + " | " + endDate.text);                   // debug
    // RSR - updated method to format automatically from dd/MM/yyyy to sqlite's standard: yyyy-MM-dd - 27/3/2024 3PM
    // CSF - rearranged functionality (guts?) so that one date could be supplied and the other left blank - 27/3/2024 8:40PM
    
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("[dd/MM/yyyy][d/M/yyyy]");
    String start = (startDate.text == "" ? "2022-01-01" : LocalDate.parse(startDate.text,fmt).toString());
    String end = (endDate.text == "" ? "2022-01-31" : LocalDate.parse(endDate.text,fmt).toString());
    return new String[] {start, end};
}

String getAirportCode()
{
    ScrollSelector sel = (ScrollSelector) (screens.getNamedScreen("Title Screen").getNamedChild("Airport Selector"));
    String selectedEntry = sel.entries[sel.selected];
    return selectedEntry.substring(0,3);
}

String getTable()
{
    RadioButtonList tbl = (RadioButtonList) (screens.getNamedScreen("Title Screen").getNamedChild("Table Selector"));
    return tbl.boxes.get(tbl.selected).text;
}

String getAirportState()
{
    ScrollSelector sel = (ScrollSelector) (screens.getNamedScreen("Title Screen").getNamedChild("Airport Selector"));
    String selectedEntry = sel.entries[sel.selected];
    String State = selectedEntry.substring(selectedEntry.length() - 2, selectedEntry.length());
    return State;
}
