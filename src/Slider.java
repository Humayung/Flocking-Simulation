import processing.core.PApplet;

public class Slider {
    float x, y, w;
    float value;
    float lBound, uBound;
    float tweakX;
    float tValue;
    boolean triggered;
    boolean hide = false;
    boolean enabled = true;

    int disabledColor;
    int baseColor;
    int neutralColor;

    String caption;

    PApplet t;

    Slider(PApplet target, float x, float y, float w, float lBound, float uBound, String caption) {
        this.caption = caption;
        t = target;
        this.x = x;
        this.y = y;
        this.w = w;
        this.tValue = t.lerp(lBound, uBound, 0.5f);
        this.lBound = lBound;
        this.uBound = uBound;
        this.disabledColor = t.color(200);
        this.baseColor = 150;
        this.neutralColor = 150;
    }

    float getValue(){
        return value;
    }

    void display() {
        t.fill(255);
        t.textSize(13);
        t.textAlign(t.CENTER);
        t.text(caption, x + w/2, y - 10);
        t.stroke(baseColor);
        t.strokeWeight(2);
        t.line(x, y, x + w, y);

        tweakX = t.map(value, lBound, uBound, x, x+w);
        t.fill(baseColor);
        t.noStroke();
        if (!triggered) {
            t.ellipse(tweakX, y, 13, 13);
        } else {
            t.ellipse(tweakX, y, 19, 19);
        }
    }

    void disable(){
        enabled = false;
        baseColor = disabledColor;
    }

    void enable(){
        enabled = true;
        baseColor = neutralColor;
    }

    void hide(){
        hide = true;
    }

    void show(){
        hide = false;
    }

    void update() {
        if (!hide) {
            display();
            if (enabled) {
                hover();
                clicked();
            }
        }
        value = t.lerp(value, tValue, 0.4f);
    }

    boolean hover() {
        if (t.dist(t.mouseX, t.mouseY, tweakX, y) < 19) {
            triggered = true;
            t.textSize(12);
            t.text(value, tweakX, y + 20);
            return true;
        }
        triggered = false;
        return false;
    }

    void setValue(float val) {
        tValue = val;
    }

    boolean clicked() {
        if (t.mousePressed) {
            if (t.mouseX > x && t.mouseX < x + w && t.mouseY > y-10 && t.mouseY < y + 10) {
                tValue = t.map(t.constrain(t.mouseX, x, x+w), x, x+w, lBound, uBound);
            }
            if (hover()) {
                tValue = t.map(t.constrain(t.mouseX, x, x+w), x, x+w, lBound, uBound);
                return true;
            }
        }
        return false;
    }
}