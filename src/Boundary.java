import processing.core.PApplet;
import processing.core.PVector;

public class Boundary {
    PVector intersectionPoint;
    PVector[] endPoint;
    PVector center;
    PVector different;
    static PApplet t;
    Boundary(PApplet target, PVector endPoint1, PVector endPoint2){
        endPoint = new PVector[]{endPoint1, endPoint2};
        center = PVector.lerp(endPoint[0], endPoint[1], 0.5f);
        different = PVector.sub(endPoint[0], endPoint[1]);
        if(t == null) t = target;
    }

    void draw(){
        t.stroke(255);
        t.line(endPoint[0].x, endPoint[0].y, endPoint[1].x, endPoint[1].y);
    }
}
