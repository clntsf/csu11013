# Documentation: `Chart` Classes
C. Simon-Fellowes, L. MacNally, R. Riggi

## Table of Contents:
1. [`Chart`](#1-chart-abstract-base-class)
2. [`PieChart`](#2-piechart)
3. [`Plot`](#3-plot)
4. [`BarPlot`](#4-barplot)
5. [`Histogram`](#5-histogram)
6. [`ScatterPlot`](#6-scatterplot)
7. [`MapWidget`](#7-mapwidget)
8. [`HeatMap`](#8-heatmap)

---

## 1. `Chart` (Abstract Base Class)

```java
abstract class Chart
extends Widget
implements None
```

> Abstract base class for all other chart classes found in this document.

A Chart only has the minimum standard functionality - a frame and a title. This is to allow for non-plot charts (see below for Plot), such as a pie chart, which do not avail of axis labels, ticks, etc. and instead just need the above. This class is also abstract, as it is not intended to be used directly in code, only its subclasses.

### Constructor Summary:
```java
Chart(int x,
    int y,
    int w,
    int h,
    String title,
    float[] valuesY
)
```

### Constructor Parameters:

|Name|Type|Description|
|----|----|-----------|
|x|`int`|x coordinate of the center of the chart's frame|
|y|`int`|y coordinate of the center of the chart's frame|
|w|`int`|width (in pixels) of the chart's frame|
|h|`int`|height (in pixels) of the chart's frame|
|title|`String`|The chart's title|
|valuesY|`float[]`|A list of y-values for the chart|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|labelMargin|`int`|margin (in pixels) between the labels of the <br>chart (incl. title) and the chart's frame|15px|

---

## 2. `PieChart`

```java
class PieChart
extends Chart
implements None
```

> A standard pie chart, with a colour coded key to represent each section

A subclass of `Chart`, with a primary focus on visual representation of data, describing only one type of variable and showing the frequencies graphically rather than numerically.

### Constructor Summary:
```java
PieChart(int x,
    int y,
    int w,
    int h,
    String title,
    float[] valuesY,
    String[] labels
)
```

### Constructor Parameters not inherited from parent (`Chart`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|labels|String[]|List of names for each section of the pie chart|    


### Non-Constructor fields:

None

## 3. `Plot`

```java
abstract class Plot
extends Chart
implements None
```

> Abstract subclass of Chart with greater functionality

Plots have somewhat more functionality, supporting axis labels and a y-axis limit.
Again, Plot is abstract because it should not be used in favor of one of its subclasses.

### Constructor Summary:
```java
Plot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    float[] valuesY,
    float[] axisRangeY
)
```

An alternative version of this constructor exists:

```java
Plot(int x, int y, int w, int h,
    String title, String axisLabelX,
    String axisLabelY, float[] valuesY,
    float axisMaxY
)
```

In which only the maximum value for the y-axis is passed: the minimum is taken as 0 (i.e. this is identical to the above constructor with `axisRangeY = new int[]{0,axisMaxY}` which is exactly what happens in the code)

### Constructor Parameters not inherited from parent (`Chart`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|axisLabelX|`String`|Label to be displayed on the plot's x-axis|
|axisLabelY|`String`|Label to be displayed on the plot's y-axis|
|axisRangeY|`float[2]`|range of values to be displayed on the plot's<br>y-axis.|

<span id="plot-nCons"></span>
### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|numAxisTicksY|`int`|number of ticks to display on the<br>plot's y-axis|5|
|labelFormatStringY|`String`|String by which to format y-axis<br>tick labels (degree of precision)|"%.1f"|
|plotColor|`color`|Color for plot detail elements<br>(bars etc.)|#CCCCFF|

---

## 4. `BarPlot`

```java
class BarPlot
extends Plot
implements None
```

> A typical Bar Plot, with categorical labels on the x-axis and quantities on the y-axis.

### Constructor Summary:
```java
BarPlot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    String[] categories,
    float[] valuesY,
    int axisMaxY
)
```

### Constructor Parameters not inherited from parent (`Plot`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|categories|`String[]`|Category labels for the chart's x-axis|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|barWidth|`int`|width (in pixels) of each displayed bar|40px|
|gapSize|`int`|gap (in pixels) between each displayed bar|20px|

---

## 5. `Histogram`

```java
class Histogram
extends BarPlot
implements None
```

> A standard histogram, with a series of bins on the x-axis and frequency on the y-axis.

A closely-derived subclass of `BarPlot`, `Histogram`'s only unique behaviors are different values for its non-constructor fields (see below) and its `makeCategories` function, which turns the `Integer[]` provided in the constructor (see below) to `String[]` (see `BarPlot.categories`) allowing for open-ended bins (i.e. a...inf). 

### Constructor Summary:
```java
Histogram(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    Integer[] binStarts,
    float[] valuesY,
    int axisMaxY
)
```

### Constructor Parameters not inherited from parent (`BarPlot`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|binStarts|`Integer[]`|The start values of bins for the histogram.<br>Should be one greater in length than valuesY.<br> Nothing enforces these being equal in size,<br>though it is recommended. If the last value in<br>this array is `null` the final bin will be treated<br>as open-ended and formatted as "a+" as<br>opposed to the normal "a..b"|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|barWidth|`int`|see `BarPlot`|w/valuesY.length (fill plot area)|
|gapSize|`int`|gap (in pixels) between each displayed bar|0px|

---

## 6. `ScatterPlot`

```java
class ScatterPlot
extends Plot
implements None
```

> A standard scatter plot, with numerical axes for both x and y.

Despite being nominally a scatter-plot (as this is the simplest form of this chart), instances of `ScatterPlot` can have a variety of appearances depending on the values of their non-constructor fields (see below). The most common use-case for this is setting `markers=false` and `connect=true` to create a line plot, but `markers` can also be left as true for a dotted line. In the case both are turned to false no values will render, so this configuration is discouraged.

### Constructor Summary:
```java
ScatterPlot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    float[] valuesX,
    float[] valuesY,
    float[] axisRangeX,
    float[] axisRangeY
)
```

### Constructor Parameters not inherited from parent (`Plot`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|valuesX|`double[]`|A list of x-values for the plot|
|axisRangeX|`float[2]`|range of values to be displayed on the plot's<br>x-axis|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|labelFormatStringX|`String`|see y-axis [counterpart](#plot-nCons) in `Plot`|uses value of `labelFormatStringY`<br>if not set|
|connect|`boolean`|whether to connect points in order<br>of appearance in valuesX/valuesY|false|
|markers|`boolean`|whether to draw markers at each<br>point|true|
|numAxisTicksX|`int`|see y-axis [counterpart](#plot-nCons) in `Plot`|5|

## 7. `MapWidget`

```java
class MapWidget
extends Widget
implements None
```

### Constructor Summary:
```java
MapWidget(int x,
    int y,
    int w,
    int h,
    String mapImagePath
)
```

### Constructor Parameters not inherited from parent (`Widget`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|mapImagePath|`String`|Path to map image|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|mapImage|`PImage`|The loaded map image|`loadImage(mapImagePath)`|
|originalAspectRatio|`float`|Aspect ratio used to<br>calculate display dimensions|Loaded image's width / loaded image's height|
|displayWidth|`float`|Display width|If `originalAspectRatio > w/h`: equal to `w`. Else: equal to `h * originalAspectRatio`|
|displayHeight|`float`|Display height|If `originalAspectRatio > w/h`: equal to `w / originalAspectRatio`. Else: equal to `h`|

## 8. `HeatMap`

```java
class HeatMap
extends Chart
implements None
```

### Constructor Summary:
```java
HeatMap(int x,
    int y,
    int w,
    int h,
    String title,
    float[][] data,
    CustomGradient grad
)
```

### Constructor Parameters not inherited from parent (`Chart`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|data|`float[][]`|Array where rows: **time of day**, columns: **day of the week**|
|grad|`CustomGradient`|VIRIDIS_CG (a custom gradient found in `UISUB_ColorUtil.pde`).<br>Colour depends on **flight volume**|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|dataMin|`float`|Lowest flight volume|Lowest flight volume provided in `data`|
|dataMax|`float`|Highest flight volume|Highest flight volume provided in `data`|
|dataRange|`float`|Range of data's flight volume|`dataMax` - `dataMin`|
|tileWidth|`int`|Each cell's width|`w` / row length|
|tileHeight|`int`|Each cell's height|`h` / column length|
