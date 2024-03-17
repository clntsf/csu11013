# Documentation: `ScreenList`, `Screen`, and `Widget`
C. Simon-Fellowes

## Table of Contents:
1. [Toplevel Organisation of Program UI: `ScreenList`](#1-toplevel-organisation-of-program-ui-screenlist)
2. [The `Screen` Class](#2-the-screen-class)
3. [The `Widget` Class](#3-the-widget-class)
    1. [`ReactiveWidget`](#3i-reactivewidget)
        1. [The `MouseEventListener` interface](#3ia-the-mouseeventlistener-interface)

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

#### `void addScreen(Screen s)`
Add `s` to `screens`

Params:
- s: the screen to add


#### `void addNamedScreen(Screen s, String name)`
Add `s` to `screens`, but also as a value to `namedScreens` with `name` as the key 

Params
- s: the screen to add
- name: the name for the screen


####  `Screen getActiveScreen()`
Get the currently active screen

Returns:
- `Screen s`: the current screen
(synonymous to `screens.get(screens.activeScreen)`)


#### `Screen getNamedScreen(String name)`
Get the screen in `namedScreens` with key `name`  

Params:
- name: the name of the screen

Returns:
- Screen 
    

#### `void nextScreen()`
set the active screen to the next screen in `screens`, wrapping around if necessary
    
#### `void prevScreen()`
set the active screen to the previous screen in `screens`, wrapping around if necessary

#### `boolean setActiveScreen(int index)`
set the active screen to the one at the specified index in `screens`

Params:
- index: the index to set `activeScreen` to

Returns:
- successful: whether the operation was successful (i.e. valid index)

#### `void setActiveScreen(String name)`
same as above, but with the index in `screens` of the screen with name `name` in `namedScreens`

Params:
- name: the name of the screen to set as active

Returns:
- successful: whether the operation was successful (i.e. valid name)

## 2. The `Screen` Class

## 3. The `Widget` Class

### 3.i. `ReactiveWidget`

#### 3.i.a The `MouseEventListener` Interface