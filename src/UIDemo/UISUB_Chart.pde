// CSF - Implemented charts, plots, and their children (Bar, Histogram, Scatter (includes line plots)) - 14/3/2024 5PM


/**
* A Chart only has the minimum standard functionality - a frame and a title.
* This is to allow for non-plot charts (see below for Plot), such as a pie chart, which
* do not avail of axis labels, ticks, etc. and instead just need the above. This class is
* also abstract, as it is not intended to be used directly in code, only its subclasses.
*/
abstract class Chart extends Widget
{
    String title;
    double[] valuesY;
    
    // this is a config attribute, which can be edited by setting it manually
    // (i.e. obj.labelMargin = ... after initializing) but which doesn't belong in a constructor
    int labelMargin = 15;
    
    Chart(
        int x, int y, int w, int h,
        String title, double[] valuesY
    )
    {
        super(x,y,w,h,#FAF9F6);
        this.title = title;
        this.valuesY = valuesY;
        setStroke(0);
    }
    
    void draw()
    {
        strokeWeight(2);
        super.draw();
        textAlign(CENTER,CENTER);
        fill(0);
        
        textSize(fontSize+2);
        text(title, x, y-h/2-fontSize-labelMargin);
    }
}

/*
Plots have somewhat more functionality, supporting axis labels and a y-axis limit.
Again, Plot is abstract because it should not be used in favor of one of its subclasses
*/
abstract class Plot extends Chart
{
    String axisLabelX;
    String axisLabelY;
    int[] axisRangeY;
    
    // again, config attributes
    int numAxisTicksY;
    String labelFormatStringY = "%.1f";
    color plotColor = #CCCCFF;    // periwinkle :)
    
    Plot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        double[] valuesY, int[] axisRangeY
    )
    {
        super(x,y,w,h,title, valuesY);
        this.numAxisTicksY = 5;
        this.axisLabelX = axisLabelX;
        this.axisLabelY = axisLabelY;
        this.axisRangeY = axisRangeY;
        setStroke(0);
    }
    Plot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        double[] valuesY, int axisMaxY
    )
    {
        this(x,y,w,h,title,axisLabelX,axisLabelY,valuesY,new int[]{0,axisMaxY});
    }
    
    // transforms the origin of the transformation matrix to the middle of the y axis, where -y' (new up) = +x (old right)
    // NB: popMatrix is not called here, so this function should be treated like pushMatrix and always succeeded (eventually) by a 
    // popMatrix call. This error is fortunately easy to notice, as within 32 calls of this function the stack depth will be exceeded
    // and the program will exit, but it doesn't tell you what line causes the issue. It's the fact that you didn't call popMatrix, dummy.
    void transformToYAxis()
    {
        pushMatrix();
        translate( x-w/2-labelMargin-fontSize, y );
        rotate(3*HALF_PI);
    }
    
    float lerp (int[] range, double amt)
    {
        float start = (float)range[0], stop = (float)range[1];
        return (float)(amt*stop + (1-amt)*start);
    }
    
    void drawAxisNames()    
    {
        textSize(fontSize);
        text(axisLabelX, x, y+h/2+labelMargin + fontSize);
        transformToYAxis();
        text(axisLabelY, 0, 0);
        popMatrix();
    }
    
    void drawAxisTicks(int[] range, String fmtString, int numAxisTicks)
    {
        textSize((int)(0.8*fontSize));
        for (int i=0; i<numAxisTicks; i++)
        {
            float proportion = (float)i/(numAxisTicks-1);
            String tickLabel = String.format(fmtString, lerp(range, proportion));
            text(tickLabel,proportion*w,0);
        }
    }
    
    void drawAxisTicksY()
    {
        transformToYAxis();
        translate(-w/2,labelMargin);    // translate to the bottom-left corner of the chart
        
        drawAxisTicks(axisRangeY, labelFormatStringY, numAxisTicksY);
        popMatrix();
    }
    
    void draw()
    {
        super.draw();
        drawAxisNames();
        drawAxisTicksY();
    }
}

class BarPlot extends Plot
{
    String[] categories;
    
    // config attributes
    int barWidth;
    int gapSize;
    
    // we are here making the assumption (by not checking) that the sizes of categories and valuesY will
    // always be the same. This is (I think) ok, as this fact should always be up to the programmer's
    // prudence in initializing new charts, but if it bites us later we can throw in a check easily enough
    // (though as we will see Histogram leverages the absence of this check to deliberately mismatch sizes)
    BarPlot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        String[] categories, double[] valuesY, int axisMaxY
    )
    {
        super( x, y, w, h, title, axisLabelX, axisLabelY, valuesY, axisMaxY);
        this.categories = categories;
        this.barWidth = 40;
        this.gapSize = 20;
    }
    
    float[] xLabelCenters ()
    {
        int numBars = valuesY.length;
        float barSpacing = (this.barWidth+this.gapSize);                           // distance between the centers of adjacent bars;
        int leftX = (int)( x - barSpacing*(double)(numBars-1)/2 );

        float[] centers = new float[numBars];
        for (int i=0; i<numBars; i++)
        {
            centers[i] = leftX + i*barSpacing;
        }
        return centers;
    }
    
    void plotValues()
    {
        float[] centers = xLabelCenters();
        for (int i=0; i<valuesY.length; i++)
        {
            double yVal = valuesY[i];
            double barHeight = h * (yVal/axisRangeY[1]);
            fill(0);
            text(categories[i], centers[i], y+h/2 + fontSize/2 + labelMargin/3);
            
            strokeWeight(1);
            fill(plotColor);
            rect(centers[i], (float)(y+h/2-barHeight/2), (float)barWidth, (float)barHeight);
        }
    }
    
    void draw()
    {
        textSize((int)(0.8*fontSize));
        super.draw();
        plotValues();
    }
}

class Histogram extends BarPlot
{
    Histogram(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        Integer[] binStarts, double[] valuesY, int axisMaxY
    )
    {
        // we'll take responsibility for setting categories ourself
        super( x, y, w, h, title, axisLabelX, axisLabelY, null, valuesY, axisMaxY);
        this.categories = makeCategories(binStarts);
        this.barWidth = (int)((float)w/valuesY.length);
        this.gapSize = 0;
    }
    
    String[] makeCategories(Integer[] bins)
    {
        int numCats = bins.length-1;
        String[] categories = new String[numCats];
        for (int i=0; i<numCats; i++)
        {
            categories[i] = bins[i] + (bins[i+1] == null ? "+" : ".." + bins[i+1]);
        }
        return categories;
    }
}

class ScatterPlot extends Plot
{
    double[] valuesX;
    int[] axisRangeX;
    
    // config
    String labelFormatStringX;
    boolean connect;
    boolean markers;
    int numAxisTicksX;

    ScatterPlot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        double[] valuesX, double[] valuesY, int[] axisRangeX, int[] axisRangeY
    )
    {
        super(x,y,w,h,title,axisLabelX,axisLabelY,valuesY,axisRangeY);
        this.valuesX = valuesX;
        this.axisRangeX = axisRangeX;
        connect = false;
        markers = true;
        numAxisTicksX = 5;
    }
    
    void drawAxisTicksX()
    {
        String fmtString = (labelFormatStringX == null ? labelFormatStringY : labelFormatStringX);
        pushMatrix();
        translate(x-w/2,y+h/2+labelMargin);    // translate to the bottom-left corner of the chart
        drawAxisTicks(axisRangeX, fmtString, numAxisTicksX);
        popMatrix();
    }
    
    float[] getScreenCoords(float absX, float absY)
    {
        float minX = axisRangeX[0], minY = axisRangeY[0];
        float maxX = axisRangeX[1], maxY = axisRangeY[1];

        float propX = (absX - minX)/(maxX-minX);
        float propY = (absY-minY)/(maxY-minY);
        return new float[] {x-w/2 + propX*w, y+h/2 - propY*h};
    }
    
    void draw()
    {
        drawAxisTicksX();
        super.draw();
        
        fill(0,0,200);
        
        float[] lastCoords = null;
        for (int i=0; i<valuesX.length; i++)
        {
            float[] screenCoords = getScreenCoords((float)valuesX[i], (float)valuesY[i]);
            float sx = screenCoords[0], sy = screenCoords[1];
            if ( sx<x-w/2 || sx>x+w/2 || sy<y-h/2 || sy>y+h/2 ) { continue; }
            noStroke();
            if (connect)
            {
                if (lastCoords != null)
                {
                    stroke(0,0,200);
                    line((int)lastCoords[0], (int)lastCoords[1], (int)sx, (int)sy);
                }
                lastCoords = screenCoords;
            }
            if (markers)
            {
                circle(screenCoords[0], screenCoords[1], 5);
            }
        }
    }
    
    void makeLinePlot()
    {
        connect = true;
        markers = false;
    }
}

// Macnalll - added pie chart subclass 19/3/24
class PieChart extends Chart 
{
    float angles[];
    int chartTotalValues;
    PieChart(
        int x, int y, int w, int h,
        String title, double[] valuesY
    )
    {
        super(x,y,w,h,title, valuesY);
        this.valuesY = valuesY;
        angles = new float[valuesY.length];
    }
    
    void calculateAngles()
    {
        for (int i=0; i<valuesY.length; i++)
        {
            chartTotalValues += valuesY[i];
        }
        for (int i=0; i<valuesY.length; i++)
        {
            angles[i] = (float)(valuesY[i]/chartTotalValues)*360;
        }
    }
    
    void drawChartAndKey(String[] labelNames)
    {
        float lastAngle = 0;
        for (int i=0, xpos = x+w/2+30, ypos = 10; i<angles.length; i++) 
        {
            // draw pie chart
            float r = map(i, 0, angles.length, 255, 0);
            float g = map(i, 0, angles.length, 85, 340);
            float b = map(i, 0, angles.length, 170, 425);
            if (g > 255) g -=255;
            if (b > 255) b -=255;
            color tmpColor = color(r, g, b); 
            fill(tmpColor);
            arc(x, y, h/1.2, h/1.2, lastAngle, lastAngle+radians(angles[i]));
            lastAngle += radians(angles[i]);
            
            // draw key
            if (ypos > height-10) 
            {
                ypos = 10;
                xpos +=50;
            }
            rect(xpos, ypos+2, 10, 10);
            fill(0);
            text(labelNames[i], xpos+15, ypos);
            ypos += 20;
        }
    } 
}
