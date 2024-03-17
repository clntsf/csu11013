# Documentation: `ScreenList`, `Screen`, `Widget` and its Descendants
C. Simon-Fellowes

## Table of Contents:
1. [Toplevel Organisation of Program UI: `ScreenList`](#1-toplevel-organisation-of-program-ui-screenlist)
2. [The `Screen` Class](#2-the-screen-class)
3. [The `Widget` Class](#3-the-widget-class)
    1. [`ReactiveWidget`](#3ii-reactivewidget)
        1. [The `MouseEventListener` interface](#3iia-the-mouseeventlistener-interface)
        2. Checkboxes, CheckBoxLists and RadioButtonLists
    2. Static Children
        1. Label
        2. Shape
        3. Image
        4. Container
    3. [`Chart` (and subclasses)](Chart.md)
---

## 1. Toplevel Organisation of Program UI: `ScreenList`

```
class ScreenList
extends None
implements None
```

A class to hold, manage and keep track of the screens for a UI application

A program utilizing these classes should have an instance of `ScreenList` declared in global scope, preferably at the start of the main file (the one containing setup() and draw()).

### Constructor Summary:
```
ScreenList()
```

### Attributes:
`ArrayList<Screen> screens`:
All screens contained within this object.
They are ordered in the program by their order here.

`HashMap<String, Screen> namedScreens`: Stores all named screens within this object. These are in no particular order. All screens in `namedScreens` are also in `screens` (see below, `addNamedScreen()`)

`int activeScreen`: the index (in `screens`) of the currently displayed screen

### Methods:

#### - `void addScreen(Screen s)`
> Add `s` to `screens`
> 
> Params:
> - s: the screen to add
<br>

#### - `void addNamedScreen(Screen s, String name)`
> Add `s` to `screens`, but also as a value to `namedScreens` with `name` as the key 
> 
> Params
> - s: the screen to add
> - name: the name for the screen

<br>

#### - `Screen getActiveScreen()`
> Get the currently active screen
> 
> Returns:
> - s: the current screen
(synonymous with `screens.get(screens.activeScreen)`)

<br>

#### - `Screen getNamedScreen(String name)`
> Get the screen in `namedScreens` with key `name`  
> 
> Params:
> - name: the name of the screen
> 
> Returns:
> - Screen 

<br>

#### - `void nextScreen()`
> set the active screen to the next screen in `screens`, wrapping around if necessary

<br>

#### - `void prevScreen()`
> set the active screen to the previous screen in `screens`, wrapping around if necessary

<br>

#### - `boolean setActiveScreen(int index)`
> set the active screen to the one at the specified index in `screens`
> 
> Params:
> - index: the index to set `activeScreen` to
> 
> Returns:
> - successful: whether the operation was successful (i.e. valid index)

<br>

#### 8. `boolean setActiveScreen(String name)`
> same as above, but with the index in `screens` of the screen with name `name` in `namedScreens`
> 
> Params:
> - name: the name of the screen to set as active
> 
> Returns:
> - successful: whether the operation was successful (i.e. valid name)

## 2. The `Screen` Class
```
class Screen
extends None
implements None
```

## 3. The `Widget` Class
```
class Widget
extends None
implements None
```



1. Label
        2. Shape
        3. Image
        4. Container

### 3.i. `ReactiveWidget`
```
class ReactiveWidget
extends Widget
implements None
```

#### 3.i.a. The `MouseEventListener` Interface

`MouseEventListener` is a [functional interface][func-inter] which allows the user to create streamlined, highly-customiseable callbacks for `ReactiveWidget`s without the need to pollute global scope with lambda expressions.

The interface's signature is as follows:

```
interface MouseListener
{
    void performAction(MouseEvent e, ReactiveWidget widget);
}
```
`ReactiveWidget.onMouseEvent()` (see above) provides the interface with:
- the triggering `MouseEvent`, which can be used to filter out certain event types/mouse buttons (see below for an example)
- a reference to `this` so that the callback can access/alter the widget and its parents freely

These two arguments allow virtually limitless functionality to stem from a callback adhering to this interface, as any amount of arbitrary code will run if conforming to the interface and formatted correctly (though handing off control to some pre-written method, perhaps with custom arguments, is recommended)

Some examples for the use of lambda expressions implementing `MouseEventListener` in code  
(See the [above link][func-inter] for information on how to format lambda expressions)
```
ReactiveWidget btn = new ReactiveWidget(...); // initialize our button

// print a message whenever a mouse event targets the button
btn.addListener((e, w) -> println("I'm nobody! Who are you?"));

// filter for certain events with a guard clause (here, the DRAG event)
btn.addListener((e,w) -> {
    if (e.getAction() != MouseEvent.DRAG) { return; }
    println("Drag event registered!");
    w.backgroundColor = #CCCCFF; // manipulate widget from within callback
});
```
(see [here][github-mevent] for a list of MouseEvent events)

### 3.ii. Static Children

There are several compelling use cases for widgets even without reactive functionality, and so several 'static' (in the english sense, not the java sense) subclasses of `Widget` exist. They are outlined below:

<br>

#### 3.ii.a. Label

```
class Label
extends Widget
implements None
```

Labels are perhaps the easiest imaginable use case for a widget without mouse functionality. these are simple text displays with few configuration options.

##### Constructor Summary:
```
Label(int x, int y, String text)
Label(int x, int y, String text, color textColor)
```

`x` and `y` in each case denote the left (x) and center (y) of the label respectively, chosen in an attempt to make placing labels on the screen as intuitive as possible. `text` is whatever text the user wishes to display, and the optional parameter `textColor` is a color value for the text.

It is worth noting that despite their designation as 'static', these widgets' attributes can still be altered at runtime by the program, e.g. through a callback from a `ReactiveWidget`. A common example of this would be a radiobutton/checkbox list that updates a label to display the current selection.

<br>

#### 3.ii.b. Shape

```
class Shape
extends Widget
implements None
```

Shapes are another simple use case for unreactive widgets, providing the user the ability to draw arbitrary geometry by way of passing in a lambda expression adhering to the `Runnable` interface (no params, no returns) to the constructor

##### Constructor Summary:
```
Shape(int x, int y, color backgroundColor, Runnable onDraw)
```

`x` and `y` represent the origin of the shape (the coordinates relative to which all points in `onDraw()` are drawn), `backgroundColor` is the color with which to `fill` when drawing the `Shape` (though the user can put other calls to `fill` inside `onDraw` which will overwrite as normal), and `onDraw` is the function to execute each time the `Shape` is drawn

<br>

#### 3.ii.c. Image

```
class Image
extends Shape
implements None
```

Similar to `Shape`, there are many reasons a user might want to draw an image on-screen, and so this class allows such behavior by passing a `PImage` through its constructor. This class subclasses `Shape` to take advantage of its `onDraw` functionality.

##### Constructor Summary:
```
Image(int x, int y, PImage image)
Image(int x, int y, int w, int h, PImage image)
```

Images can either be drawn at native size, or at a size (in pixels) determined by the optional `w` and `h` parameters.

<br>

#### 3.ii.d. Container

```
class Container
extends Widget
implements None
```

`Container` strips `Widget` down to the bare-bones, preserving only its functionality as a member of a tree of parent/child widgets. This can be quite useful when the user wants to 'package' a tree of widgets and allow them to be added to mutiple screens (e.g. nav buttons), or just be a reference point as a named child of a screen.

##### Constructor Summary:
```
Container()
```

Container takes no arguments, as it has no relevant features other than being a parent/child object.

[func-inter]: https://www.geeksforgeeks.org/functional-interfaces-java/
[github-mevent]: https://github.com/processing/processing/blob/master/core/src/processing/event/MouseEvent.java