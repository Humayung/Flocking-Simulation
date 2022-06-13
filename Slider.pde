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


    Slider(float x, float y, float w, float lBound, float uBound, String caption) {
        this.caption = caption;
        this.x = x;
        this.y = y;
        this.w = w;
        this.tValue = lerp(lBound, uBound, 0.5f);
        this.lBound = lBound;
        this.uBound = uBound;
        this.disabledColor = color(200);
        this.baseColor = 150;
        this.neutralColor = 150;
    }

    float getValue(){
        return value;
    }

    void display() {
        fill(255);
        textSize(13);
        textAlign(CENTER);
        text(caption, x + w/2, y - 10);
        stroke(baseColor);
        strokeWeight(2);
        line(x, y, x + w, y);

        tweakX = map(value, lBound, uBound, x, x+w);
        fill(baseColor);
        noStroke();
        if (!triggered) {
            ellipse(tweakX, y, 13, 13);
        } else {
            ellipse(tweakX, y, 19, 19);
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
        value = lerp(value, tValue, 0.4f);
    }

    boolean hover() {
        if (dist(mouseX, mouseY, tweakX, y) < 19) {
            triggered = true;
            textSize(12);
            text(value, tweakX, y + 20);
            return true;
        }
        triggered = false;
        return false;
    }

    void setValue(float val) {
        tValue = val;
    }

    boolean clicked() {
        if (mousePressed) {
            if (mouseX > x && mouseX < x + w && mouseY > y-10 && mouseY < y + 10) {
                tValue = map(constrain(mouseX, x, x+w), x, x+w, lBound, uBound);
            }
            if (hover()) {
                tValue = map(constrain(mouseX, x, x+w), x, x+w, lBound, uBound);
                return true;
            }
        }
        return false;
    }
}
