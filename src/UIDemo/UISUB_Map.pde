class MapWidget extends Widget {
    PImage mapImage;
    float originalAspectRatio;
    float displayWidth, displayHeight;
    ArrayList<FlightPath> paths = new ArrayList<FlightPath>();
    MapWidget(int x, int y, int w, int h, String mapImagePath) {

        super(x, y, w, h, new StaticColor(#FAF9F6));
        mapImage = loadImage(mapImagePath);
        originalAspectRatio = (float)mapImage.width / (float)mapImage.height;
        
        calculateDisplayDimensions();
    }
    
    void calculateDisplayDimensions() {
        float widgetAspectRatio = (float)w / (float)h;
        
        if (originalAspectRatio > widgetAspectRatio) {
            displayWidth = w;
            displayHeight = w / originalAspectRatio;
        } else {
            displayHeight = h;
            displayWidth = h * originalAspectRatio;
        }
    }
    
    void addPath(float originX, float originY, float destX, float destY) {
        paths.add(new FlightPath(originX, originY, destX, destY));
    }

    @Override
    void draw() {
    
        image(mapImage, x, y, displayWidth, displayHeight);
        for (FlightPath path : paths) {
            line(x+path.originX*displayWidth, y+path.originY*displayHeight, x+path.destX*displayWidth, y+path.destY*displayHeight);
        }
      
    }

}


class FlightPath {
  float originX, originY, destX, destY;
  
  FlightPath(float oX, float oY, float dX, float dY) {
    originX = oX;
    originY = oY;
    destX = dX;
    destY = dY;
  }
  
  void display(float widgetWidth, float widgetHeight) {
    float realOriginX = originX * widgetWidth;
    float realOriginY = originY * widgetHeight;
    float realDestX = destX * widgetWidth;
    float realDestY = destY * widgetHeight;
    line(realOriginX, realOriginY, realDestX, realDestY);
  }
}
