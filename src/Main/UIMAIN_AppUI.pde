
void AppMain()
{
    final int BG_MARGIN = 20;

    final Color SCREEN_COLOR = new ThemedColor(themes, "screen");
    final Color BACKGROUND_COLOR = new ThemedColor(themes, "background");
    final Color TEXT_COLOR = new ThemedColor(themes, "text");
    final Color OUTLINE = new ThemedColor(themes, "outline");

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
    titleButton.setStroke(OUTLINE);
    titleButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        screens.setActiveScreen("Title Screen");
        surface.setTitle(MAIN_TITLE);
    }
    );

    Container baseScreen = new Container();
    baseScreen.addChild(background);
    baseScreen.addChild(titleButton);

    final Screen titleScreen = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(titleScreen, "Title Screen");
    titleScreen.addWidget(background);

    Label titleLabel = new Label(width/2, BG_MARGIN + 25, "Flight Data Visualisation App", TEXT_COLOR);
    titleLabel.fontSize = 36;
    titleLabel.justify = CENTER;
    titleScreen.addWidget(titleLabel);

    // day/night theme buttons

    Image dayNightImage = new Image(width-55, height-40, 60, 35, loadImage("theme_buttons.png"));
    titleScreen.addWidget(dayNightImage);

    ReactiveWidget dayButton = new ReactiveWidget(width-70, height-40, 25, 25, new StaticColor(#20FF0000));
    dayButton.drawn = false;
    titleScreen.addWidget(dayButton);
    dayButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        themes.setActive("lightTheme");
    }
    );

    ReactiveWidget nightButton = new ReactiveWidget(width-40, height-40, 25, 25, new StaticColor(#20FF0000));
    nightButton.drawn = false;
    titleScreen.addWidget(nightButton);
    nightButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        themes.setActive("darkTheme");
    }
    );

    // main UI

    final int COLUMN_SIDE_PAD = 40;
    final int COLUMN_VERT_PAD = 80;
    final int INDENT = 15;

    // left side

    // Date restriction
    final String DATE_REGEX = "[0-9/]";

    Label dateRestrictLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD,
        BG_MARGIN+COLUMN_VERT_PAD,
        "Restrict Date Range:", TEXT_COLOR
        );
    dateRestrictLabel.fontSize = 24;
    titleScreen.addWidget(dateRestrictLabel);

    Label startDateLabel = new Label(
        BG_MARGIN+COLUMN_SIDE_PAD+INDENT,
        BG_MARGIN+COLUMN_VERT_PAD+30,
        "Start Date:", TEXT_COLOR
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
        "End Date:", TEXT_COLOR
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
        "Select Airport:", TEXT_COLOR
        );
    airportSelectorLabel.fontSize = 24;
    titleScreen.addWidget(airportSelectorLabel);

    String[] airports = loadStrings("airports.txt");
    ScrollSelector airportSelector = new ScrollSelector(
        BG_MARGIN + COLUMN_SIDE_PAD + 125,
        BG_MARGIN + COLUMN_SIDE_PAD + 305,
        250, 160, airports
        );
    airportSelector.textColor = TEXT_COLOR;
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
    tableSelector.setTextColor(TEXT_COLOR);
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
        "Data Display",
        "Flight Volume Heatmap",
        "Flight Distance vs Volume",
        "Volume of State Flights",
        "Flights per Day",
    };
    final int[] BTN_COLORS = new int[]{ #ffb3ba, #ffdfba, #ffffba, #baffc9, #b7fffa, #bae1ff, #8686af, #c3b1e1, #ffd1dc, #f90b24 };

    Label dataQueryLabel = new Label(COLUMN_RIGHT, BG_MARGIN+COLUMN_VERT_PAD, "Visualize Query Data:", TEXT_COLOR);
    dataQueryLabel.fontSize = 24;
    dataQueryLabel.justify = CENTER;
    titleScreen.addWidget(dataQueryLabel);


    for (int i=0; i<BTN_NAMES.length; i++)
    {
        final String NAME = BTN_NAMES[i];
        ReactiveWidget btn = new ReactiveWidget(
            COLUMN_RIGHT, BG_MARGIN+COLUMN_VERT_PAD + (BTN_HEIGHT+BTN_MARGIN)*(i+1),
            BTN_WIDTH, BTN_HEIGHT, new StaticColor(BTN_COLORS[i]), NAME
            );
        btn.setStroke(OUTLINE);
        btn.addListener((e, w) -> {
            if (e.getAction() != MouseEvent.PRESS) {
                return;
            }
            screens.setActiveScreen(NAME);
            surface.setTitle(NAME);
        }
        );

        titleScreen.addWidget(btn);
        titleScreen.addNamedChild(btn, "button: " + NAME);
    }
    // --- SCREEN 1: Market Share Pie Chart --- //

    Screen mktShareScr = new Screen(SCREEN_COLOR);        // these 5 lines should go more or less unchanged at the beginning of each screen
    screens.addNamedScreen(mktShareScr, "Market Share by Airline");    // except of course change 'mktShareScr' for the name of the screen
    mktShareScr.addWidget(baseScreen);
    mktShareScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget mktShareButton = (ReactiveWidget) titleScreen.getNamedChild("button: Market Share by Airline");
    mktShareButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        resetScreen(mktShareScr);
        new Thread(() -> {
            PieChart p1 = makePie();
            mktShareScr.addWidget(p1);
        }
        ).start();
    }
    );

    // --- SCREEN 2: HISTOGRAM DEMO --- //
    // by RSR
    Screen histScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(histScr, "Departure Delay Times");
    histScr.addWidget(baseScreen);
    histScr.addNamedChild(baseScreen, "BASE_SCREEN");

    // RSR - if button pressed, chart is loaded. - 20/3/24 4PM
    ReactiveWidget histBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Departure Delay Times");
    histBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        resetScreen(histScr);
        new Thread(() -> {
            if (getTable() == "flights_full")
            {
                HistParams hp = populateHistFreqs(-60, 10, 70);
                Histogram h = makeHistogram(hp);
                resetScreen(histScr);
                histScr.addWidget(h);
            }
            else
            {
                resetScreen(histScr);
                histScr.addWidget(new Label(220, 320, "No data available for this table.", new ThemedColor(themes, "text")));
            }
        }
        ).start();
    }
    );

    // --- Screen 3: Bubble Plot --- //

    Screen reliabilityScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(reliabilityScr, "Reliability vs Market Share");
    reliabilityScr.addWidget(baseScreen);
    reliabilityScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget bubbleBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Reliability vs Market Share");
    bubbleBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }

        resetScreen(reliabilityScr);
        new Thread(() -> {
            BubbleParams bp = makeBubbleParams();
            BubblePlot bubble = makeBubble(bp);
            resetScreen(reliabilityScr);    // reset one more time in case the user has spammed the exit button
            reliabilityScr.addWidget(bubble);
        }
        ).start();
    }
    );

    // --- Screen 4: Flight Map --- //

    Screen mapScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(mapScr, "Flight Map");
    mapScr.addWidget(baseScreen);
    mapScr.addNamedChild(baseScreen, "BASE_SCREEN");
    
    
    ReactiveWidget mapBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Flight Map");
    mapBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        resetScreen(mapScr);
        new Thread(() -> {
            MapWidget map = makeMap();
            mapScr.addWidget(map);
        }
        ).start();
    }
    );

    // --- Screen 5 - Data Display --- //

    Screen dataScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(dataScr, "Data Display");
    dataScr.addWidget(baseScreen);
    dataScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget displayBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Data Display");
    displayBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        resetScreen(dataScr);
        new Thread(() -> {
            ScrollTableParams params = populateDataList();
            ScrollTable sT1 = scrollTablePopulate(params);
            dataScr.addWidget(sT1);
            dataScr.addNamedChild(sT1, "Airport Selector");
        }
        ).start();
    }
    );
    // --- Screen 6: Flight Volume Heatmap -- //

    Screen heatMapScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(heatMapScr, "Flight Volume Heatmap");
    heatMapScr.addWidget(baseScreen);
    heatMapScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget heatmapButton = (ReactiveWidget) titleScreen.getNamedChild("button: Flight Volume Heatmap");
    heatmapButton.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        new Thread(() -> {
            resetScreen(reliabilityScr);
            HeatMapParams params = generateFlightVolumeHeatmap();
            HeatMap hm = makeHeatMap(params);
            heatMapScr.addWidget(hm);
        }
        ).start();
    }
    );


    // --- Screen 7 - Kilian's Scatter Plot Screen  23/03 --- //

    Screen flightVolScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(flightVolScr, "Flight Distance vs Volume");
    flightVolScr.addWidget(baseScreen);
    flightVolScr.addNamedChild(baseScreen, "BASE_SCREEN");


    //  Kilian 
    //  02/04  - implemented listeners in main ui screen to load data once button for this graph is pressed 
    ReactiveWidget scatterBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Flight Distance vs Volume");
    scatterBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }

        resetScreen(flightVolScr);
        new Thread(() -> {
            ScatterParams params = populateScatterPlot();
            ScatterPlot s1 = makeScatterPlot(params);
            resetScreen(flightVolScr);    // reset one more time in case the user has spammed the exit button
            flightVolScr.addWidget(s1);
        }
        ).start();
    }
    );

    // --- Screen 8 - Will's BarChart --- // Added by Will Sunderland 19/3/24 - updated 20/3/24

    Screen barPlotScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(barPlotScr, "Volume of State Flights");
    barPlotScr.addWidget(baseScreen);
    barPlotScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget barPlotBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Volume of State Flights");
    barPlotBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }
        resetScreen(barPlotScr);
        new Thread(() -> {
            CategoricalParams params = populateBarParams();
            InteractiveBarPlot b1 = barPlotPopulate(params);
            barPlotScr.addWidget(b1);
        }
        ).start();
    }
    );

    // --- Screen 9 - Tim's Line Plot --- //

    Screen linePlotScr = new Screen(SCREEN_COLOR);
    screens.addNamedScreen(linePlotScr, "Flights per Day");
    linePlotScr.addWidget(baseScreen);
    linePlotScr.addNamedChild(baseScreen, "BASE_SCREEN");

    ReactiveWidget linePlotBtn = (ReactiveWidget) titleScreen.getNamedChild("button: Flights per Day");
    linePlotBtn.addListener((e, w) -> {
        if (e.getAction() != MouseEvent.PRESS) {
            return;
        }

        resetScreen(linePlotScr);
        new Thread(() -> {
            ScatterPlot linePlot = makeLinePlot(db);
            linePlotScr.addWidget(linePlot);
        }
        ).start();
    }
    );
}

// RSR - resets screen - 26/3/24 2PM
// CSF - reworked this func so it's less of a blunt implement (see above Container baseScreen)
void resetScreen(Screen s)
{
    ArrayList<Widget> newWidgets = new ArrayList<>();
    newWidgets.add(s.getNamedChild("BASE_SCREEN"));
    s.widgets = newWidgets;
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
    String start = (startDate.text == "" ? "2022-01-01" : LocalDate.parse(startDate.text, fmt).toString());
    String end = (endDate.text == "" ? "2022-01-31" : LocalDate.parse(endDate.text, fmt).toString());
    return new String[] {start, end};
}

String getAirportCode()
{
    ScrollSelector sel = (ScrollSelector) (screens.getNamedScreen("Title Screen").getNamedChild("Airport Selector"));
    String selectedEntry = sel.entries[sel.selected];
    return selectedEntry.substring(0, 3);
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
