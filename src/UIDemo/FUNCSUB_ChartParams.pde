// CSF - 14/3/2024 9PM
// added ChartParams classes and ChartParamsGenerator<T> interface (since removed) to allow for the creation of
// generic database query routines which output in a format directly suitable for use in chart creation
abstract class ChartParams
{
    double[] valuesY;
    
    ChartParams(double[] valuesY)
    {
        this.valuesY = valuesY;
    }
}

class CategoricalParams extends ChartParams // bar charts and pie charts
{
    String[] categories;

    CategoricalParams(double[] valuesY, String[] categories)
    {
        super(valuesY);
        this.categories = categories;
    }
}

class NumericalParams extends ChartParams   // scatter plots and histograms
{
    double[] valuesX;
    
    NumericalParams(double[] valuesX, double[] valuesY)
    {
        super(valuesY);
        this.valuesX = valuesX;
    }
}

// RSR - created HistParams class - 19/3/24 6PM
class HistParams
{
    Integer[] bins;
    double[] freqs;
    int maxFreq;
    
    HistParams(Integer[] bins, double[] freqs, int maxFreq)
    {
        this.freqs = freqs;
        this.bins = bins;
        this.maxFreq = maxFreq;
    }
}

// TT - created class to use to return line plot data for a query 26/3/24 9AM
class LinePlotParams {
      double[] valuesX;
      double[] valuesY;
      float[] axisRangeX;
      float[] axisRangeY;

      public LinePlotParams(double[] valuesX, double[] valuesY, float[] axisRangeX, float[] axisRangeY) {
          this.valuesX = valuesX;
          this.valuesY = valuesY;
          this.axisRangeX = axisRangeX;
          this.axisRangeY = axisRangeY;
      }
}
 
// macnalll - added class to return categorical parameters as type double[] instead of int 26/3/24
class PieParams
{
    double[] valuesY;
    String[] categories;
    
    PieParams(double[] valuesY, String[] categories)
    {
        this.valuesY = valuesY;
        this.categories = categories;
    }
}

class BubbleParams extends NumericalParams
{
    float[] valuesZ;
    String[] categories;
    
    BubbleParams(double[] valuesX, double[] valuesY, float[] valuesZ, String[] categories)
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
  double[] numOfFlights;
  BarParams(String[] categories, double[] numOfFlights)
  {
    this.categories = categories;
    this.numOfFlights = numOfFlights;
  }
}
