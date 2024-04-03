import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.geo.*;

class MapWidget extends Widget {
    UnfoldingMap map;
    PApplet parent; 

    MapWidget(PApplet parent, int x, int y, int w, int h) {
        super(x, y, w, h);
        this.parent = parent; // Store the reference
        initMap();
    }

    void initMap() {
        map = new UnfoldingMap(parent, x - w/2, y - h/2, w, h, new de.fhpotsdam.unfolding.providers.Microsoft.AerialProvider());
        MapUtils.createDefaultEventDispatcher(parent, map);

        map.zoomToLevel(2);
        map.panTo(new de.fhpotsdam.unfolding.geo.Location(0, 0));
    }

    @Override
    void draw() {
        map.draw(); 
    }

}
