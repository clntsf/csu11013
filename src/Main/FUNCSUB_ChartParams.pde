// CSF - 14/3/2024 9PM
// added ChartParams classes and ChartParamsGenerator<T> interface (since removed) to allow for the creation of
// generic database query routines which output in a format directly suitable for use in chart creation
abstract class ChartParams
{
    float[] valuesY;
    
    ChartParams(float[] valuesY)
    {
        this.valuesY = valuesY;
    }
}

class CategoricalParams extends ChartParams // parameters for bar charts and pie charts
{
    String[] categories;

    CategoricalParams(float[] valuesY, String[] categories)
    {
        super(valuesY);
        this.categories = categories;
    }
}

class NumericalParams extends ChartParams   // parameters for scatter plots and histograms
{
    float[] valuesX;
    
    NumericalParams(float[] valuesX, float[] valuesY)
    {
        super(valuesY);
        this.valuesX = valuesX;
    }
}

// RSR - created HistParams class - 19/3/24 6PM
class HistParams
{
    Integer[] bins;
    float[] freqs;
    int maxFreq;
    
    HistParams(Integer[] bins, float[] freqs, int maxFreq)
    {
        this.freqs = freqs;
        this.bins = bins;
        this.maxFreq = maxFreq;
    }
}

// TT - created class to use to return line plot data for a query 26/3/24 9AM
class LinePlotParams extends NumericalParams
{
    float[] axisRangeX;
    float[] axisRangeY;

    public LinePlotParams(float[] valuesX, float[] valuesY, float[] axisRangeX, float[] axisRangeY)
    {
        super(valuesX, valuesY);
        this.axisRangeX = axisRangeX;
        this.axisRangeY = axisRangeY;
    }
}
 
// macnalll - added class to return categorical parameters as type float[] instead of int 26/3/24
class PieParams extends ChartParams
{
    String[] categories;
    
    PieParams(float[] valuesY, String[] categories)
    {
        super(valuesY);
        this.categories = categories;
    }
}

// Kilian 
// 25/03  - created ScatterPlotData Class 
// 28/03  - changed to work with floats  
// 04/04  - added carrier labels 
class ScatterParams
{
   float[] flightVolume;
   float[] flightDuration;
   int xMax;
   int yMax;
   String[] carriersName;
   
   ScatterParams(float[] flightVolume, float[] flightDuration, int xMax, int yMax, String[] carriersName)
   {
     this.flightVolume = flightVolume;
     this.flightDuration = flightDuration;
     this.xMax = xMax;
     this.yMax = yMax;
     this.carriersName = carriersName;
   }
}

// CSF
class BubbleParams extends NumericalParams
{
    float[] valuesZ;
    String[] categories;
    
    BubbleParams(float[] valuesX, float[] valuesY, float[] valuesZ, String[] categories)
    {
        super(valuesX, valuesY);
        this.valuesZ = valuesZ;
        this.categories = categories;
    }
}

//Will S
// created paramater class that holds the appropriate information to fill the scrollTableClass
class ScrollTableParams
{
  String[] dates;
  String[] carriers;
  String[] origins;
  String[] dests;
  ScrollTableParams(String[] dates, String[] carriers, String[] origins, String[] dests)
  {
    this.dates = dates;
    this.carriers = carriers;
    this.origins = origins;
    this.dests = dests;
  }
  
}

// CSF
class HeatMapParams
{
    float[][] data;

    HeatMapParams(float[][] data)
    {
        this.data = data;
    }
}
