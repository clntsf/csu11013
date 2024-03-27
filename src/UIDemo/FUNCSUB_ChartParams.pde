// CSF - 14/3/2024 9PM
// added ChartParams classes and ChartParamsGenerator<T> interface to allow for the creation of
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
    float[] valuesY;
    
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
    float[] sizes;
    
    BubbleParams(float[] valuesX, float[] valuesY, float[] sizes)
    {
        super(valuesX, valuesY);
        this.sizes = sizes;
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
