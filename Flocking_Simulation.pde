
Slider slider1, slider2, slider3, slider4, slider5;

static ArrayList<Boid> boids =  new ArrayList<>();;
static ArrayList<Boundary> obstacles = new ArrayList<>();;
final int BOIDS_POP = 1000;
final int OBSTACLE_NUMBER = 0;


public void settings() {
//        size(640, 360);
    fullScreen();
}

public void setup() {
    slider1 = new Slider(width / 2 - 100, 100, 200, -1, 1, "Alignment Force");
    slider2 = new Slider(width / 2 - 100, 140, 200, -1, 1, "Cohesion Force");
    slider3 = new Slider(width / 2 - 100, 180, 200, -1, 1, "Separation Force");
    slider4 = new Slider(width / 2 - 100, 220, 200, 0, 500, "Perception Radius");
    slider5 = new Slider(width / 2 - 100, 260, 200, 0, 10, "Force Multiplier");
    slider5.setValue(1);
    slider4.setValue(100);
    noStroke();
    for (int i = 0; i < BOIDS_POP; i++) {
        boids.add(new Boid());
    }

    for (int i = 0; i < OBSTACLE_NUMBER; i++) {
        Boundary b = new Boundary(new PVector(random(width), random(height)), new PVector(random(width), random(height)));
        obstacles.add(b);
    }
}

public void draw() {
    background(51);
    runSystem();
    slider1.update();
    slider2.update();
    slider3.update();
    slider4.update();
    slider5.update();


}

void runSystem() {
    boids.forEach(b -> {
        b.control(slider1.getValue(), slider2.getValue(), slider3.getValue(), slider4.getValue(), slider5.getValue());
        b.flock(boids, obstacles);
        b.update();
        b.show();
    });

    for (Boundary b : obstacles) {
        b.draw();
    }

}
