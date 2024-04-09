//TT - class to display flights on a map from a certain origin state to all destination states as lines representing paths

class MapWidget extends Image
{
    float originalAspectRatio;
    ArrayList<FlightPath> paths;
    
    MapWidget(int x, int y, int w, int h, PImage mapImage)
    {
        super(x, y, w, h, mapImage);
        paths = new ArrayList<>();
        this.w = w;
        this.h = h;
    }
    
    MapWidget(int x, int y, int w, int h, PImage mapImage, ArrayList<FlightPath> paths)
    {
        this(x, y, w, h, mapImage);
        this.paths = paths;
    }
    
    void addPath(float originX, float originY, float destX, float destY)
    {
        paths.add(new FlightPath(originX, originY, destX, destY));
    }

    void draw()
    {
        super.draw();
        for (FlightPath path : paths)
        {
            fill(0, 255, 0);    // start point
            circle(x+path.originX*w, y+path.originY*h, 5);
            fill(0, 0, 255);    // end point
            circle(x+path.destX*(float)w, y+path.destY*h, 5);
            stroke(0);          // line
            line(x+path.originX*w, y+path.originY*h, x+path.destX*w, y+path.destY*h);
        }
    }
}

//TT - class to represent flight paths as coordinates for plotting
class FlightPath
{
    float originX, originY, destX, destY;
  
    FlightPath(float oX, float oY, float dX, float dY)
    {
        originX = oX;
        originY = oY;
        destX = dX;
        destY = dY;
    }
}
