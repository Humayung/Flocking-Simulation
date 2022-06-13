public class Boid {

    PVector position;
    PVector velocity;
    PVector acceleration;

    float maxForce;
    float maxSpeed = 5;

    float perceptionRadius;
    int index = 0;
    int color_;

    Ray ray;

    private float alignMultiplier;
    private float separationMultiplier;
    private float cohesionMultiplier;
    private float maxSeeAhead = 100;

    Boid() {

        position = new PVector(random(width), random(height));
        velocity = PVector.random2D().mult(0);
        acceleration = new PVector();
        ray = new Ray(position, velocity.heading());
        perceptionRadius = 100;
        color_ = color(100, map(perceptionRadius, 10, 150, 0, 255), 255);
        maxForce = 0.2f;
    }

    void show() {
        noStroke();
        fill(color_, 100);

        final float cx = 1.5f / 3;
        final float cy = 1.5f / 3;
        float size = 10;
        pushMatrix();
        {
            translate(position.x, position.y);
            rotate(velocity.heading());
            scale(size);
            beginShape();
            {
                // Triangle
                vertex(0 - cx, 0 - cy);
                vertex(0 - cx, 1 - cy);
                vertex(1.5f - cx, 0.5f - cy);
            }
            endShape();
        }
        popMatrix();
    }

    PVector alignmentForce(ArrayList<Boid> boids) {
        int total = 0;
        PVector steering = new PVector();
        for (Boid other : boids) {
            float distance = position.dist(other.position);
            if (other != this && distance < perceptionRadius) {
                steering.add(other.velocity);
                total++;

            }
        }
        if (total > 0) {
            steering.div(total);
            steering.setMag(maxSpeed);
            steering.sub(velocity);
            steering.limit(maxForce);
        }
        return steering;
    }

    PVector cohesionForce(ArrayList<Boid> boids) {
        int total = 0;
        PVector steering = new PVector();
        for (Boid other : boids) {
            float distance = position.dist(other.position);
            if (other != this && distance < perceptionRadius) {
                steering.add(other.position);
                total++;
            }
        }
        if (total > 0) {
            steering.div(total);
            steering.sub(position);
            steering.setMag(maxSpeed);
            steering.sub(velocity);
            steering.limit(maxForce);
        }
        return steering;
    }

    PVector separationForce(ArrayList<Boid> boids) {
        int total = 0;
        PVector steering = new PVector();
        for (Boid other : boids) {
            float distance = position.dist(other.position);
            if (other != this && distance < perceptionRadius) {
                PVector different = PVector.sub(position, other.position);
                different.div(distance);
                steering.add(different);
                total++;
            }
        }
        if (total > 0) {
            steering.div(total);
            steering.setMag(maxSpeed);
            steering.sub(velocity);
            steering.limit(maxForce);
        }
        return steering;
    }

    PVector avoidanceForce(ArrayList<Boundary> obstacles) {
        PVector avoidanceForce = new PVector();
        Boundary closestObstacle = look(obstacles);

        if (closestObstacle != null) {
            float obstacleDistance = closestObstacle.intersectionPoint.dist(position);
            if (obstacleDistance < maxSeeAhead) {
//                avoidanceForce = PVector.sub(closestObstacle.different, position);
                avoidanceForce = closestObstacle.different;
                avoidanceForce.setMag(maxForce);
                avoidanceForce.add(PVector.mult(velocity, -0.05f));

                stroke(255);
                line(position.x, position.y, avoidanceForce.x * 100 + position.x, avoidanceForce.y * 100 + position.y);
            }
        }
        return avoidanceForce;
    }

    Boundary look(ArrayList<Boundary> boundaries) {
        PVector closest = null;
        Boundary closestBoundary = null;
        float record = Float.POSITIVE_INFINITY;
        for (Boundary b : boundaries) {
            final PVector pt = ray.cast(b);
            if (pt != null) {
                final float d = PVector.dist(position, pt);
                if (d < record) {
                    record = d;
                    closest = pt;
                    closestBoundary = b;
                }
            }
        }
        if(closest != null){
            closestBoundary.intersectionPoint = closest;
        }
        return closestBoundary;
    }


    void wrapEdges() {
        position.x = position.x > width
                ? 0
                : position.x < 0
                ? width
                : position.x;
        position.y = position.y > height
                ? 0
                : position.y < 0
                ? height
                : position.y;
    }

    void control(float alignMultplier, float cohesionMultiplier, float separationMultiplier, float perceptionRadius, float multiplier) {
        this.perceptionRadius = perceptionRadius;
        this.alignMultiplier = alignMultplier * multiplier;
        this.cohesionMultiplier = cohesionMultiplier * multiplier;
        this.separationMultiplier = separationMultiplier * multiplier;
    }

    void flock(ArrayList<Boid> boids, ArrayList<Boundary> obstacles) {

        PVector avoidanceForce = avoidanceForce(obstacles);
        acceleration.add(avoidanceForce);
        acceleration.add(alignmentForce(boids).mult(alignMultiplier));
        acceleration.add(cohesionForce(boids).mult(cohesionMultiplier));
        acceleration.add(separationForce(boids).mult(separationMultiplier));
    }

    void update() {
        ray.rotate(velocity.heading());
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        position.add(velocity);
        acceleration.mult(0);
        wrapEdges();
    }
}
