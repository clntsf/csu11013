# Documentation: `Chart` Classes
C. Simon-Fellowes

## Table of Contents:
1. [`Chart`](#1-Chart-abstract-base-class)
2. [`Plot`](#2-Plot)
3. [`BarPlot`](#3-BarPlot)
4. [`Histogram`](#4-Histogram)
5. [`ScatterPlot`](#5-ScatterPlot)

---

## 1. `Chart` (Abstract Base Class)

```
abstract class Chart
extends Widget
implements None
```

> Abstract base class for all other chart classes found in this document.

A Chart only has the minimum standard functionality - a frame and a title. This is to allow for non-plot charts (see below for Plot), such as a pie chart, which do not avail of axis labels, ticks, etc. and instead just need the above. This class is also abstract, as it is not intended to be used directly in code, only its subclasses.

### Constructor Summary:
```
Chart(int x,
    int y,
    int w,
    int h,
    String title,
    double[] valuesY
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
|valuesY|`double[]`|A list of y-values for the chart|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|labelMargin|`int`|margin (in pixels) between the labels of the <br>chart (incl. title) and the chart's frame|15px|

---

## 2. `Plot`

```
abstract class Plot
extends Chart
implements None
```

> Abstract subclass of Chart with greater functionality

Plots have somewhat more functionality, supporting axis labels and a y-axis limit.
Again, Plot is abstract because it should not be used in favor of one of its subclasses.

### Constructor Summary:
```
Plot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    double[] valuesY,
    int[] axisRangeY
)
```

An alternative version of this constructor exists:

```
Plot(int x, int y, int w, int h,
    String title, String axisLabelX,
    String axisLabelY, double[] valuesY,
    int axisMaxY
)
```

In which only the maximum value for the y-axis is passed: the minimum is taken as 0 (i.e. this is identical to the above constructor with `axisRangeY = new int[]{0,axisMaxY}` which is exactly what happens in the code)

### Constructor Parameters not inherited from parent (`Chart`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|axisLabelX|`String`|Label to be displayed on the plot's x-axis|
|axisLabelY|`String`|Label to be displayed on the plot's y-axis|
|axisRangeY|`int[2]`|range of values to be displayed on the plot's<br>y-axis.|

<span id="plot-nCons"></span>
### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|numAxisTicksY|`int`|number of ticks to display on the<br>plot's y-axis|5|
|labelFormatStringY|`String`|String by which to format y-axis<br>tick labels (degree of precision)|"%.1f"|
|plotColor|`color`|Color for plot detail elements<br>(bars etc.)|#CCCCFF|

---

## 3. `BarPlot`

```
class BarPlot
extends Plot
implements None
```

> A typical Bar Plot, with categorical labels on the x-axis and quantities on the y-axis.

### Constructor Summary:
```
BarPlot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    String[] categories,
    double[] valuesY,
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

## 4. `Histogram`

```
class Histogram
extends BarPlot
implements None
```

> A standard histogram, with a series of bins on the x-axis and frequency on the y-axis.

A closely-derived subclass of `BarPlot`, `Histogram`'s only unique behaviors are different values for its non-constructor fields (see below) and its `makeCategories` function, which turns the `Integer[]` provided in the constructor (see below) to `String[]` (see `BarPlot.categories`) allowing for open-ended bins (i.e. a...inf). 

### Constructor Summary:
```
Histogram(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    Integer[] binStarts,
    double[] valuesY,
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

## 5. `ScatterPlot`

```
class ScatterPlot
extends Plot
implements None
```

> A standard scatter plot, with numerical axes for both x and y.

Despite being nominally a scatter-plot (as this is the simplest form of this chart), instances of `ScatterPlot` can have a variety of appearances depending on the values of their non-constructor fields (see below). The most common use-case for this is setting `markers=false` and `connect=true` to create a line plot, but `markers` can also be left as true for a dotted line. In the case both are turned to false no values will render, so this configuration is discouraged.

### Constructor Summary:
```
ScatterPlot(int x,
    int y,
    int w,
    int h,
    String title,
    String axisLabelX,
    String axisLabelY,
    double[] valuesX,
    double[] valuesY,
    int[] axisRangeX,
    int[] axisRangeY
)
```

### Constructor Parameters not inherited from parent (`Plot`) constructor(s):

|Name|Type|Description|
|----|----|-----------|
|valuesX|`double[]`|A list of x-values for the plot|
|axisRangeX|`int[2]`|range of values to be displayed on the plot's<br>x-axis|

### Non-Constructor fields:

|Name|Type|Description|Default|
|----|----|-----------|-------|
|labelFormatStringX|`String`|see y-axis [counterpart](#plot-nCons) in `Plot`|uses value of `labelFormatStringY`<br>if not set|
|connect|`boolean`|whether to connect points in order<br>of appearance in valuesX/valuesY|false|
|markers|`boolean`|whether to draw markers at each<br>point|true|
|numAxisTicksX|`int`|see y-axis [counterpart](#plot-nCons) in `Plot`|5|
