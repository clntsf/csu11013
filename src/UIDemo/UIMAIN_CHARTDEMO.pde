void demoHistogram(Screen screen)
{
    Integer[] bins = new Integer[]{-60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, null};
    double[] quantities = new double[]{2, 2, 25, 644, 26824, 293591, 84166, 33941, 20416, 13843, 10087, 7712, 6104, 31095};
    
    Screen s = new Screen(128);
    screens.add(s);
    
    Histogram h1 = new Histogram(width/2, height/2, 600, 300,
        "Flight Departure Delay (Minutes, negative delays represent early departures)",
        "Delay", "Freq. of Occurrence",
        bins, quantities, 300000
    );

    h1.fontSize = 14;
    h1.labelFormatStringY = "%.0f";
    h1.numAxisTicksY = 6;
    screen.addWidget(h1);
    screen.addNamedChild(h1, "Delay Times");
}
