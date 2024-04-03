color complement(color c)
{
    return c ^ #00FFFFFF; // flip all the bits except the alpha channel
}

int getRed(color c)
{
    return (c>>16) & 0xFF;
}
int getGreen(color c)
{
    return (c>>8) & 0xFF;
}
int getBlue(color c)
{
    return c & 0xFF;
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
