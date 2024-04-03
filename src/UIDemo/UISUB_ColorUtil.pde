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

color applyAlpha(color c, int alpha)
{
    return (alpha << 24) + c;
}

// CSF 2/4/2024 implemented CustomGradient class for use in HeatMap as well as
// auxiliary color function complement for visible labels
color complement(color c)
{
    return c ^ #00FFFFFF; // flip all the bits except the alpha channel
}

class CustomGradient
{
    float[] thresholds;
    color[] colors;
    
    CustomGradient(float[] thresholds, color[] colors)
    {
        this.thresholds = thresholds;
        for (int thresholdIdx=0; thresholdIdx<thresholds.length; thresholdIdx++)
        {
            thresholds[thresholdIdx] /= max(thresholds);
        }
        this.colors = colors;
    }
    
    color getColor(float x)
    {
        float lastThreshold = thresholds[0];
        for (int thresholdIdx=1; thresholdIdx<thresholds.length; thresholdIdx++)
        {
            float threshold = thresholds[thresholdIdx];
            if (x<=threshold)
            {
                float proportion = (x-lastThreshold)/(threshold-lastThreshold);
                color lastColor = colors[thresholdIdx-1];
                color thisColor = colors[thresholdIdx];
                
                return lerpColor(lastColor, thisColor, proportion);
            }
            lastThreshold = threshold;
        }
        return 0;
    }
}

// viridis color scale
final CustomGradient VIRIDIS_CG = new CustomGradient(
    new float[]{0,3,6,9,12,15,17,19},
    new color[]{#450C54, #453681, #31648D, #218A8D, #28AF7F, #75D056, #B9DE28, #FDE724}
);

// CSF 3/4/2024 5PM Implemented classes and the Color interface to allow configurable, modular color-themes

class ThemeSet
{
    HashMap<String, IntDict> themes;
    String active;
    
    ThemeSet()
    {
        themes = new HashMap<>();
    }
    
    public void addTheme(String name, IntDict theme)
    {
        themes.put(name, theme);
        if (active == null) { setActive(name); }
        return;
    }
    
    IntDict getActive()
    {
        return themes.get(active);
    }
    
    void setActive(String newActive)
    {
        if (!themes.containsKey(newActive)) { return; }
        active = newActive;
    }
}

public ThemeSet loadThemeJSON(String filepath)
{
    JSONObject fileJSON = loadJSONObject(filepath);
    ThemeSet themeSet = new ThemeSet();

    for (Object k : fileJSON.keys())
    {
        String name = (String) k;
        IntDict theme = new IntDict();
        
        JSONObject themeJSON = fileJSON.getJSONObject(name);
        for (Object subKey : themeJSON.keys())
        {
            String subKeyName = (String) subKey;
            int value = (int) themeJSON.get(subKeyName);
            theme.set(subKeyName, value);
        }
        themeSet.addTheme(name, theme);
    }
    return themeSet;
}

public interface Color
{
    public color getColor();
}

class StaticColor implements Color
{
    color c;
    StaticColor(color c)
    {
        this.c = c;
    }
    public color getColor()
    {
        return c;
    }
}

class ThemedColor implements Color
{
    ThemeSet themes;
    String themeKey;
    
    ThemedColor(ThemeSet themes, String themeKey)
    {
        this.themes = themes;
        this.themeKey = themeKey;
    }
    
    color getColor()
    {
        return themes.getActive().get(themeKey);
    }
}
