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

class HistParams
{
    Integer[] bins;
    double[] freqs;
    
    HistParams(Integer[] bins, double[] freqs)
    {
        this.freqs = freqs;
        this.bins = bins;
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
