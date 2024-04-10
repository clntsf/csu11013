MapWidget makeMap()
{
    PImage mapImage = loadImage("map2.jpeg");
    ArrayList<FlightPath> paths = getFlightPaths("flights10k", getAirportCode(), getDates());
    float mapW = (width/1.25);
    float mapH = mapW * (float) mapImage.height / (float) mapImage.width;
    return new MapWidget(width/2, height/2, (int)mapW, (int)mapH, mapImage, paths);
}

//TT - wrote function to instantiate a ScatterPlot as a line plot with appropriate user restrictred data by calling the getLinePlotData() function within
ScatterPlot makeLinePlot(SQLite db)
{  
    LinePlotParams testParams = getLinePlotData(getTable(), db, getAirportCode(), getDates());
    ScatterPlot s1 = new ScatterPlot(width / 2, height / 2, 400, 400,
        "Flights per day of the month",
        "Day of month", "Count of flights",
        testParams.valuesX, testParams.valuesY, testParams.axisRangeX, testParams.axisRangeY);
    s1.fontSize = 12;

    s1.labelFormatStringY = "%,.0f";
    s1.numAxisTicksY = 10;
    s1.numAxisTicksX =  testParams.valuesX.length;
    s1.makeLinePlot();
    return s1;
}

PieChart makePie()
{
    PieParams test = getPieChartData();
    return new PieChart(
        width/2, height/2, width/2, height/2,
        "Market Share by Airline",
        test.valuesY, test.categories
        );
}

BubblePlot makeBubble(BubbleParams params)
{
    // doing some norming for our axes
    float xMax = max(0.5, round(12*max(params.valuesX)) / 10.0);
    float yMax = max(0.5, round(12*max(params.valuesY)) / 10.0);

    BubblePlot bubble = new BubblePlot(width/2, height/2, 470, 470,
        "Airline Reliability vs Market Share", "% Flights Cancelled", "% Flights Diverted",
        params.valuesX, params.valuesY, params.valuesZ, params.categories, new float[]{0, xMax}, new float[]{0, yMax}
        );
    bubble.maxSize = 90;
    bubble.labelFormatStringY = "%.2f";

    return bubble;
}

HeatMap makeHeatMap(HeatMapParams params)
{
    HeatMap hm = new HeatMap(
        width/2, height/2, 420, 480,
        "Flight Volume by Day of Week/Time of Day",
        params.data, VIRIDIS_CG,
        "Day of Week", "Time of Day",
        new String[] {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"},
        new String[] {"0-2", "2-4", "4-6", "6-8", "8-10", "10-12", "12-14", "14-16", "16-18", "18-20", "20-22", "22-0"}
        );
    hm.formatString = "%.0f";
    return hm;
}

Histogram makeHistogram(HistParams histParams)
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


ScatterPlot makeScatterPlot(ScatterParams params)
{

    float xMax = params.xMax;
    float yMax = params.yMax;
    ScatterPlot s1 = new ScatterPlot(width/2, height/2, 400, 400,
        "Total Flight Distance Vs Volume by Carrier",
        "Total Volume by Carrier", "Total Flight Distance (Miles)",
        params.flightVolume, params.flightDuration,
        new float[] {0, xMax + 50}, new float[]{0, yMax + 50}
        );

    s1.setLabels(params.carriersName);
    s1.fontSize = 8;
    s1.labelFormatStringY = "%.0f";
    s1.labelFormatStringX = "%.0f";
    return s1;
}

// Will S 
// initialises an interactive barplot based on the appropriate parameter class being fed in
InteractiveBarPlot barPlotPopulate(CategoricalParams params)
{
    InteractiveBarPlot b1 = new InteractiveBarPlot(
        width/2, height/2, 450, 450,
        "Volume of Flights by Airports in a State", "Airports", "Number of Flights",
        params.categories, params.valuesY,
        int(1.05 * Math.round(max(params.valuesY))),
        50, height - 40, 30, 30
        );
    return b1;
}
// Will S
// initialises a scroll table based on the appropriate parameter class being fed in
ScrollTable scrollTablePopulate(ScrollTableParams params)
{
    ScrollTable sT1 = new ScrollTable(
        width/2, height/2, 450, 450, params.dates, params.carriers, params.origins, params.dests, #ef6b6b
        );
    return sT1;
}
