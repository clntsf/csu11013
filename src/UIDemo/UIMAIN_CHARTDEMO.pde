void chartDemoNew()
{
    final int BG_MARGIN = 20;
    final int SCREEN_COLOR = #778899;
    final int BACKGROUND_COLOR = #F0F8FF;
    
    Container navButtons = initNavButtons();
    Widget background = new Widget(width/2, height/2, width-2*BG_MARGIN, height-2*BG_MARGIN, BACKGROUND_COLOR);
    
    // --- SCREEN 1: HISTOGRAM DEMO --- //
    Screen screen1 = new Screen(SCREEN_COLOR);        // these four lines should go more or less unchanged at the beginning of each screen
    screens.addScreen(screen1);                       // except of course change 'screen1' for the name of the screen
    screen1.addWidget(navButtons);
    screen1.addWidget(background);
    
    Histogram h1 = demoHistogram();
    screen1.addWidget(h1);

    // --- Screen 2 --- //

}

Histogram demoHistogram()
{
    Integer[] bins = new Integer[]{-60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, null};
    double[] quantities = new double[]{2, 2, 25, 644, 26824, 293591, 84166, 33941, 20416, 13843, 10087, 7712, 6104, 31095};
    
    Histogram h1 = new Histogram(width/2, height/2, 600, 600,
        "Flight Departure Delay (Minutes, negative delays represent early departures)",
        "Delay", "Freq. of Occurrence",
        bins, quantities, 300000
    );

    h1.fontSize = 13;
    h1.labelFormatStringY = "%.0f";
    h1.numAxisTicksY = 6;
    
    return h1;
}

// Other demo functions go here and get added to chartDemoNew() in a new Screen
// - for convention, make your function return the object (ex. Histogram above) so it can be manipulated in the main function
