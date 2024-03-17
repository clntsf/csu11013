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
Add `s` to `screens`

Params:
- s: the screen to add
<br><br>

#### - `void addNamedScreen(Screen s, String name)`
Add `s` to `screens`, but also as a value to `namedScreens` with `name` as the key 

Params
- s: the screen to add
- name: the name for the screen
<br><br>

#### - `Screen getActiveScreen()`
Get the currently active screen

Returns:
- s: the current screen
(synonymous with `screens.get(screens.activeScreen)`)
<br><br>

#### - `Screen getNamedScreen(String name)`
Get the screen in `namedScreens` with key `name`  

Params:
- name: the name of the screen

Returns:
- Screen 
<br><br>

#### - `void nextScreen()`
set the active screen to the next screen in `screens`, wrapping around if necessary
<br><br>

#### - `void prevScreen()`
set the active screen to the previous screen in `screens`, wrapping around if necessary
<br><br>

#### - `boolean setActiveScreen(int index)`
set the active screen to the one at the specified index in `screens`

Params:
- index: the index to set `activeScreen` to

Returns:
- successful: whether the operation was successful (i.e. valid index)
<br><br>

#### 8. `boolean setActiveScreen(String name)`
same as above, but with the index in `screens` of the screen with name `name` in `namedScreens`

Params:
- name: the name of the screen to set as active

Returns:
- successful: whether the operation was successful (i.e. valid name)

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

#### 3.ii.a. Label

#### 3.ii.b. Shape

#### 3.ii.c. Image

#### 3.ii.d. Container

[func-inter]: https://www.geeksforgeeks.org/functional-interfaces-java/
[github-mevent]: https://github.com/processing/processing/blob/master/core/src/processing/event/MouseEvent.java