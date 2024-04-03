// CSF 14/3/2024 5PM - Implemented charts, plots, and their children (Bar, Histogram, Scatter (includes line plots))

/**
 * A Chart only has the minimum standard functionality - a frame and a title.
 * This is to allow for non-plot charts (see below for Plot), such as a pie chart, which
 * do not avail of axis labels, ticks, etc. and instead just need the above. This class is
 * also abstract, as it is not intended to be used directly in code, only its subclasses.
 */
abstract class Chart extends Widget
{
    String title;
    float[] valuesY;

    // this is a config attribute, which can be edited by setting it manually
    // (i.e. obj.labelMargin = ... after initializing) but which doesn't belong in a constructor
    int labelMargin = 15;

    Chart(
        int x, int y, int w, int h,
        String title, float[] valuesY
        )
    {
        super(x, y, w, h, #FAF9F6);
        this.title = title;
        this.valuesY = valuesY;
        setStroke(0);
    }

    int[] genColors(int len)
    {
        color[] colors = new int[len];
        for (int i=0; i<len; i++)
        {
            colors[i] = randomPastel(0.3+0.25*i);    // random linear gen I've found works well
        }
        return colors;
    }

    void draw()
    {
        strokeWeight(2);
        super.draw();
        textAlign(CENTER, CENTER);
        fill(0);

        textSize(fontSize+2);
        text(title, x, y-h/2-fontSize-labelMargin);
    }
}

color applyAlpha(color c, int alpha)
{
    return (alpha << 24) + c;
}

/* CSF 19/3/24 7:30PM - Added Random Pastel color generator loosely inspired
 by https://mdigi.tools/random-pastel-color/ (see "How to Generate Random Pastel Colors?")
 */
int channelToPastel(float orig, float rm)
{
    return (int)(orig-rm+255)/2;
}

int randomPastel(float seed)
{
    float r = 255*pow(sin(seed), 2);
    float g = 255*pow(sin(seed+PI/3), 2);
    float b = 255*pow(sin(seed+TAU/3), 2);

    float gray = (float) min(r, g, b);
    float saturation_amt = 0.8;
    float rm = gray*saturation_amt;

    return color(channelToPastel(r, rm), channelToPastel(g, rm), channelToPastel(b, rm));
}

// Macnalll - added pie chart subclass 19/3/24
class PieChart extends Chart
{
    float angles[];
    String[] labels;
    color[] colors;

    PieChart(
        int x, int y, int w, int h,
        String title, float[] valuesY,
        String[] labels
        )
    {
        super(x, y, w, h, title, valuesY);
        this.labels = labels;

        angles = new float[valuesY.length];
        colors = genColors(valuesY.length);

        int chartTotalValues = 0;
        for (int i=0; i<valuesY.length; i++)
        {
            chartTotalValues += valuesY[i];
        }
        for (int i=0; i<valuesY.length; i++)
        {
            angles[i] = (float)(valuesY[i]/chartTotalValues)*360;
        }
    }

    void drawChartAndKey()
    {
        float lastAngle = 0;
        int xpos = x+w/2+30, ypos = y-h/2+10;
        for (int i=0; i<angles.length; i++)
        {
            // draw pie chart
            fill(colors[i]);
            arc(x, y, h/1.2, h/1.2, lastAngle, lastAngle+radians(angles[i]));
            lastAngle += radians(angles[i]);

            // draw key
            rect(xpos, ypos + 20*i, 10, 10);
            textSize(fontSize - 4);
            fill(0);
            text(labels[i], xpos+20, ypos + 20*i);
        }
    }

    void draw()
    {
        super.draw();
        drawChartAndKey();
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
    float[] axisRangeY;

    // again, config attributes
    int numAxisTicksY;
    String labelFormatStringY = "%.1f";
    color plotColor = #CCCCFF;    // periwinkle :)

    Plot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        float[] valuesY, float[] axisRangeY
        )
    {
        super(x, y, w, h, title, valuesY);
        this.numAxisTicksY = 5;
        this.axisLabelX = axisLabelX;
        this.axisLabelY = axisLabelY;
        this.axisRangeY = axisRangeY;
        setStroke(0);
    }
    Plot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        float[] valuesY, float axisMaxY
        )
    {
        this(x, y, w, h, title, axisLabelX, axisLabelY, valuesY, new float[]{0, axisMaxY});
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

    float lerp (float[] range, float amt)
    {
        //float start = range[0], stop = (float)range[1];
        return (float)(amt*range[1] + (1-amt)*range[0]);
    }

    void drawAxisNames()
    {
        textSize(fontSize);
        text(axisLabelX, x, y+h/2+labelMargin + fontSize);
        transformToYAxis();
        text(axisLabelY, 0, 0);
        popMatrix();
    }

    void drawAxisTicks(float[] range, String fmtString, int numAxisTicks)
    {
        textSize((int)(0.8*fontSize));
        for (int i=0; i<numAxisTicks; i++)
        {
            float proportion = (float)i/(numAxisTicks-1);
            String tickLabel = String.format(fmtString, lerp(range, proportion));
            text(tickLabel, proportion*w, 0);
        }
    }

    void drawAxisTicksY()
    {
        transformToYAxis();
        translate(-w/2, labelMargin);    // translate to the bottom-left corner of the chart

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


// CSF - Trying to fix hierarchy and Histogram 21 Mar 3:45PM
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
        String[] categories, float[] valuesY, int axisMaxY
        )
    {
        super( x, y, w, h, title, axisLabelX, axisLabelY, valuesY, axisMaxY);
        this.categories = categories;
        barWidth = 40;
        gapSize = 20;
    }

    float[] xLabelCenters ()
    {
        int numBars = valuesY.length;
        float barSpacing = (this.barWidth+this.gapSize);                           // distance between the centers of adjacent bars;
        int leftX = (int)( x - barSpacing*(float)(numBars-1)/2 );

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
            float yVal = valuesY[i];
            float barHeight = h * (yVal/axisRangeY[1]);
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

// Will S made minor changes to allow interactive barPlot;
class ColorBar extends BarPlot
{

    // config attributes
    color[] barColors;
    float[] centers;
    ColorBar(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        String[] categories, float[] valuesY, int axisMaxY
        )
    {
        super( x, y, w, h, title, axisLabelX, axisLabelY, categories, valuesY, axisMaxY);
        if ( (categories.length * barWidth) + ((categories.length - 1) *gapSize) > w)
        {
            gapSize = w /((3 * categories.length)- 1);
            barWidth = 2 * gapSize;
        }
        setBarColors(0.2, 0.5);
        centers = xLabelCenters();
    }

    void setCenters(float[] newCenters)
    {
        centers = newCenters;
    }
    // Will S added in functionality to allow a pastel color to be added and accessed by outside classes.
    void setBarColors(float constant, float multiple)
    {
        barColors = new color[valuesY.length];
        for (int i = 0; i < valuesY.length; i++)
        {
            barColors[i] = randomPastel(constant + (multiple * i));
        }
    }

    void plotValues()
    {
        for (int i=0; i<valuesY.length; i++)
        {
            float yVal = valuesY[i];
            float barHeight = h * (yVal/axisRangeY[1]);
            fill(0);
            text(categories[i], centers[i], y+h/2 + fontSize/2 + labelMargin/3);
            strokeWeight(1);
            fill(barColors[i]);
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

//Will S cooked a storm in here and made Gordon Ramsay proud 20/3/24
class InteractiveBarPlot extends Container
{
    ColorBar bar;
    ReactiveWidget[] handles;
    color[] barColors;
    float[] barCenters;
    int[] barOrder;
    int handlesAxis;
    boolean holding = false;
    int currentHeld;

    InteractiveBarPlot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        String[] categories, float[] valuesY, int axisMaxY,
        int handlesX, int handlesY, int handlesW, int handlesH
        )
    {
        super();
        bar = new ColorBar(x, y, w, h, title, axisLabelX, axisLabelY, categories, valuesY, axisMaxY);
        handles = new ReactiveWidget[categories.length];
        barOrder = new int[categories.length];
        barCenters = bar.xLabelCenters();
        barColors = bar.barColors;
        handlesAxis = handlesY;
        if (bar.barWidth < handlesW)
        {
            handlesW = bar.barWidth;
        }
        for (int i = 0; i < handles.length; i++)
        {
            handles[i]= new ReactiveWidget(int(barCenters[i]), handlesY, handlesW, handlesH, barColors[i]);
            barOrder[i] = i;
            int index = i;
            handles[i].addListener((e, widg) -> {
                if (e.getAction() != MouseEvent.RELEASE) {
                    return;
                }
                println("let go");
                holding = false;
            }
            );
            // handles[i].addListener((e,widg) -> {
            //  if (e.getAction() != MouseEvent.PRESS) { return; }
            //    println("held");
            //    holding = true;
            //});
            handles[i].addListener((e, widg) -> {
                if (e.getAction() != MouseEvent.DRAG) {
                    return;
                }
                //println("Drag event registered!");
                if (!holding || (holding && currentHeld == index ))
                {
                    handles[index].setX(mouseX);
                    handles[index].setY(mouseY);
                    currentHeld = index;
                    holding = true;
                }
            }
            );
            children.add(handles[i]);
        }
    }
    void swapHandles()
    {
        if (!holding) {
            for (int i = 0; i< barOrder.length; i++)
            {
                for (int aboveIndex = i + 1; aboveIndex < handles.length; aboveIndex++)
                {
                    if (handles[barOrder[i]].x > handles[barOrder[aboveIndex]].x)
                    {
                        float temp = barCenters[barOrder[i]];
                        barCenters[barOrder[i]] = barCenters[barOrder[aboveIndex]];        //swap barCenter
                        barCenters[barOrder[aboveIndex]] = temp;
                        bar.setCenters(barCenters);
                        handles[barOrder[i]].setX(int(barCenters[barOrder[i]]));             //set new handle positions
                        handles[barOrder[i]].setY(handlesAxis);
                        handles[barOrder[aboveIndex]].setX(int(barCenters[barOrder[aboveIndex]]));
                        handles[barOrder[aboveIndex]].setY(handlesAxis);
                        int temp2 = barOrder[i];                                            //set barOrder
                        barOrder[i] = barOrder[aboveIndex];
                        barOrder[aboveIndex] = temp2;
                    }
                }
            }
        }
    }
    //void handlesPlace()
    //{
    //  for(int i = 0; i < handles.length; i++)
    //  {
    //    handles[i].setX(int(barCenters[i]));
    //    handles[i].setY(handlesAxis);
    //  }
    //}
    void handlesDraw()
    {
        for (ReactiveWidget h : handles)
        {
            h.updateHover();
            h.draw();
        }
    }
    void draw()
    {
        super.draw();
        bar.draw();
        swapHandles();
        handlesDraw();
    }
}

class Histogram extends BarPlot
{
    Histogram(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        Integer[] binStarts, float[] valuesY, int axisMaxY
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
    float[] valuesX;
    float[] axisRangeX;

    // config
    String labelFormatStringX;
    boolean connect;
    boolean markers;
    int numAxisTicksX;

    ScatterPlot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        float[] valuesX, float[] valuesY, float[] axisRangeX, float[] axisRangeY
        )
    {
        super(x, y, w, h, title, axisLabelX, axisLabelY, valuesY, axisRangeY);
        this.valuesX = valuesX;
        this.axisRangeX = axisRangeX;
        connect = false;
        markers = true;
        numAxisTicksX = 20;
    }

    void drawAxisTicksX()
    {
        String fmtString = (labelFormatStringX == null ? labelFormatStringY : labelFormatStringX);
        pushMatrix();
        translate(x-w/2, y+h/2+labelMargin);    // translate to the bottom-left corner of the chart
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

    void drawFrame()
    {
        drawAxisTicksX();
        super.draw();
    }

    void draw()
    {
        drawFrame();
        fill(0, 0, 200);

        float[] lastCoords = null;
        for (int i=0; i<valuesX.length; i++)
        {
            float[] screenCoords = getScreenCoords((float)valuesX[i], (float)valuesY[i]);
            float sx = screenCoords[0], sy = screenCoords[1];
            if ( sx<x-w/2 || sx>x+w/2 || sy<y-h/2 || sy>y+h/2 ) {
                continue;
            }
            noStroke();
            if (connect)
            {
                if (lastCoords != null)
                {
                    stroke(0, 0, 200);
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

class BubblePlot extends ScatterPlot
{
    float[] valuesZ;
    float maxZ;
    String[] labels;
    color[] colors;
    int maxSize = 60;

    BubblePlot(
        int x, int y, int w, int h,
        String title, String axisLabelX, String axisLabelY,
        float[] valuesX, float[] valuesY, float[] valuesZ, String[] labels,
        float[] axisRangeX, float[] axisRangeY
        )
    {
        super(x, y, w, h, title, axisLabelX, axisLabelY, valuesX, valuesY, axisRangeX, axisRangeY);
        this.valuesZ = valuesZ;
        this.maxZ = max(valuesZ);
        this.labels = labels;
        colors = genColors(valuesY.length);
        for (int i=0; i<colors.length; i++)
        {
            colors[i] = applyAlpha(colors[i], 127);    // 50% transparency
        }
    }

    void draw()
    {
        super.drawFrame();
        for (int i=0; i<colors.length; i++)
        {
            color c = colors[i];
            fill(c);
            float[] screenCoords = getScreenCoords((float)valuesX[i], (float)valuesY[i]);
            circle(screenCoords[0], screenCoords[1], maxSize*pow(valuesZ[i]/maxZ, 0.5));
            fill(0);
            text(labels[i], screenCoords[0], screenCoords[1]);
        }
    }
}

class HeatMap extends Chart
{
    float[][] data;
    float dataMin;
    float dataMax;
    float dataRange;
    int tileWidth;
    int tileHeight;
    CustomGradient grad;

    HeatMap(int x, int y, int w, int h, String title, float[][] data, CustomGradient grad)
    {
        super(x,y,w,h,title,null);
        this.tileWidth = w/data[0].length;
        this.tileHeight = h/data.length;
        this.data = data;
        this.grad = grad;
        
        dataMin = min(data[0]);
        dataMax = max(data[0]);
        for (float[] row : data)
        {
            dataMin = min(dataMin, min(row));
            dataMax = max(dataMax, max(row));
        }
        dataRange = dataMax - dataMin;
    }

    void draw()
    {
        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        
        int marg = 2;
        fill(0);
        noStroke();
        rect(x, y, w+2*marg, h+2*marg);

        for (int idxY = 0; idxY < data.length; idxY++)
        {
            for (int idxX = 0; idxX < data[0].length; idxX++)
            {
                float dataPoint = data[idxY][idxX];
                color dataColor = grad.getColor((dataPoint-dataMin)/(dataRange));
                int centerX = (int)(x - w/2 + (idxX + 0.5) * tileWidth);
                int centerY = (int)(y - h/2 + (idxY + 0.5) * tileHeight);
                fill(dataColor);
                rect( centerX, centerY, tileWidth, tileHeight );
                
                fill(complement(dataColor));
                text( String.format("%.2f", dataPoint), centerX, centerY); 
            }
        }
        
        // handle legend
        float legendMax = 100.0, legendBarW = 20;
        rectMode(CORNER); fill(0);
        rect(x + w/2 + legendBarW - marg, y - h/2 - marg, legendBarW + 2*marg, legendMax + 2*marg);
        for (float barY=legendMax-1; barY>=0; barY--)
        {
            fill(grad.getColor(1 - barY/legendMax));
            rect(x + w/2 + legendBarW, y - h/2 + barY, legendBarW, 1);
        }
    }
}
