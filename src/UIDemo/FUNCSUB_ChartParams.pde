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

class CategoricalParams extends ChartParams // bar charts and pie charts
{
    String[] categories;

    CategoricalParams(float[] valuesY, String[] categories)
    {
        super(valuesY);
        this.categories = categories;
    }
}

class NumericalParams extends ChartParams   // scatter plots and histograms
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
class LinePlotParams {
      float[] valuesX;
      float[] valuesY;
      float[] axisRangeX;
      float[] axisRangeY;

      public LinePlotParams(float[] valuesX, float[] valuesY, float[] axisRangeX, float[] axisRangeY) {
          this.valuesX = valuesX;
          this.valuesY = valuesY;
          this.axisRangeX = axisRangeX;
          this.axisRangeY = axisRangeY;
      }
}
 
// macnalll - added class to return categorical parameters as type float[] instead of int 26/3/24
class PieParams
{
    float[] valuesY;
    String[] categories;
    
    PieParams(float[] valuesY, String[] categories)
    {
        this.valuesY = valuesY;
        this.categories = categories;
    }
}
// Kilian - created ScatterPlotData Class - 25/03/24 changed to work with floats 28/03
class ScatterPlotData
{
   float[] flightVolume;
   float[] flightDuration;
   int xMax;
   int yMax;
   ScatterPlotData(float[] flightVolume, float[] flightDuration, int xMax, int yMax)
   {
     this.flightVolume = flightVolume;
     this.flightDuration = flightDuration;
     this.xMax = xMax;
     this.yMax = yMax;
   }
}

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
//WS - added class to return params for barChart 27/3/24
class BarParams
{
  String[] categories;
  float[] numOfFlights;
  BarParams(String[] categories, float[] numOfFlights)
  {
    this.categories = categories;
    this.numOfFlights = numOfFlights;
  }
}
