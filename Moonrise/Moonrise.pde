// Moonrise variables
float moonY;
float moonRadius = 60;
float moonSpeed = 0.3;

// Star variables
int numStars = 200;
float[] starX, starY;
float[] starTwinkle;
float[] starSpeedX, starSpeedY; // Star movement speeds

// Shooting star variables
int numShootingStars = 3;
float[] shootingStarX, shootingStarY;
float[] shootingStarSpeedX, shootingStarSpeedY;
boolean[] shootingStarActive;

// Cloud variables
int numClouds = 3;
float[] cloudX, cloudY;
float[] cloudSpeed;

// Mountain variables
PVector[] mountainPeaks;

void setup() {
  size(800, 600);
  moonY = height + 50;

  // Initialize stars
  starX = new float[numStars];
  starY = new float[numStars];
  starTwinkle = new float[numStars];
  starSpeedX = new float[numStars];
  starSpeedY = new float[numStars];
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width);
    starY[i] = random(height / 2);
    starTwinkle[i] = random(100, 255);
    starSpeedX[i] = random(-0.15, 0.15); // Horizontal speed
    starSpeedY[i] = random(-0.05, 0.05); // Vertical speed
  }

  // Initialize shooting stars
  shootingStarX = new float[numShootingStars];
  shootingStarY = new float[numShootingStars];
  shootingStarSpeedX = new float[numShootingStars];
  shootingStarSpeedY = new float[numShootingStars];
  shootingStarActive = new boolean[numShootingStars];
  for (int i = 0; i < numShootingStars; i++) {
    resetShootingStar(i);
  }

  // Initialize clouds
  cloudX = new float[numClouds];
  cloudY = new float[numClouds];
  cloudSpeed = new float[numClouds];
  for (int i = 0; i < numClouds; i++) {
    cloudX[i] = random(width);
    cloudY[i] = random(100, 200);
    cloudSpeed[i] = random(0.3, 0.6);
  }

  // Define mountain peaks
  mountainPeaks = new PVector[5];
  mountainPeaks[0] = new PVector(0, height * 0.75);
  mountainPeaks[1] = new PVector(width * 0.25, height * 0.55);
  mountainPeaks[2] = new PVector(width * 0.5, height * 0.65);
  mountainPeaks[3] = new PVector(width * 0.75, height * 0.6);
  mountainPeaks[4] = new PVector(width, height * 0.75);
}

void draw() {
  drawSky();
  drawMoon();
  drawStars();
  drawShootingStars();
  drawClouds();
  drawMountains();
}

// Draws the sky with a smooth gradient from blue-purple to deep night blue as the moon rises
void drawSky() {
  float skyProgress = map(moonY, height * 0.75, height * 0.25, 0, 1);

  for (int y = 0; y < height; y++) {
    float lerpVal = map(y, 0, height, 0, 1);

    // Transition from blue-purple to dark blue, getting darker as the moon rises
    int startColor = color(80, 60, 150);   // Blue-purple at horizon
    int midColor = color(30, 40, 100);     // Middle dark blue
    int endColor = color(10, 10, 30);      // Very dark blue at the top

    int skyColor = lerpColor(
      lerpColor(startColor, midColor, lerpVal), 
      lerpColor(midColor, endColor, lerpVal), 
      skyProgress * 0.7 + lerpVal * 0.3
    );

    stroke(skyColor);
    line(0, y, width, y);
  }
}

// Draws a realistic, solid moon with shading and craters
void drawMoon() {
  float moonProgress = map(moonY, height, height * 0.25, 0, 1);
  int moonBaseColor = color(240, 240, 255); // Base moon color
  int shadowColor = color(180, 180, 200);   // Slightly darker for shadow effect

  // Draw the base of the moon with shading on one side
  for (float i = 0; i <= moonRadius; i++) {
    float shadeFactor = map(i, 0, moonRadius, 0, 1); // Gradual shading effect
    fill(lerpColor(moonBaseColor, shadowColor, shadeFactor));
    noStroke();
    ellipse(width * 0.5 - i / 2, moonY, moonRadius * 2 - i, moonRadius * 2 - i);
  }

  // Draw moon craters for texture
  fill(200, 200, 220); // Light gray for craters
  ellipse(width * 0.5 - 10, moonY - 15, 8, 8); // Main crater
  ellipse(width * 0.5 + 15, moonY + 10, 6, 6); // Small crater
  ellipse(width * 0.5 + 20, moonY - 20, 5, 5); // Tiny crater
  ellipse(width * 0.5 - 15, moonY + 5, 7, 7);  // Another crater
  ellipse(width * 0.5, moonY - 10, 4, 4);      // Small crater at center

  // Moon rises slowly
  if (moonY > height * 0.25) {
    moonY -= moonSpeed;
  }
}

// Draws stars that twinkle and move slightly
void drawStars() {
  for (int i = 0; i < numStars; i++) {
    starTwinkle[i] += random(-5, 5);
    starTwinkle[i] = constrain(starTwinkle[i], 100, 255);

    fill(255, 255, 255, starTwinkle[i]);
    noStroke();
    ellipse(starX[i], starY[i], 3, 3);

    // Move stars more noticeably for dynamic effect
    starX[i] += starSpeedX[i];
    starY[i] += starSpeedY[i];

    // Wrap stars around edges if they move off screen
    if (starX[i] < 0) starX[i] = width;
    if (starX[i] > width) starX[i] = 0;
    if (starY[i] < 0) starY[i] = height / 2;
    if (starY[i] > height / 2) starY[i] = 0;
  }
}

// Draws multiple shooting stars at random intervals
void drawShootingStars() {
  for (int i = 0; i < numShootingStars; i++) {
    if (shootingStarActive[i]) {
      stroke(255, 255, 200);
      strokeWeight(3);
      line(shootingStarX[i], shootingStarY[i], shootingStarX[i] - 10, shootingStarY[i] - 5);

      shootingStarX[i] += shootingStarSpeedX[i];
      shootingStarY[i] += shootingStarSpeedY[i];

      if (shootingStarX[i] > width || shootingStarY[i] > height) {
        resetShootingStar(i);
      }
    } else if (random(500) < 1) { // Random chance to activate a shooting star
      shootingStarActive[i] = true;
    }
  }
}

// Resets a shooting star's position and speed
void resetShootingStar(int i) {
  shootingStarX[i] = random(width);
  shootingStarY[i] = random(height / 2);
  shootingStarSpeedX[i] = random(3, 7);
  shootingStarSpeedY[i] = random(1, 3);
  shootingStarActive[i] = false;
}

// Draws clouds that drift across the sky
void drawClouds() {
  fill(255, 255, 255, 150);
  noStroke();

  for (int i = 0; i < numClouds; i++) {
    float cloudOpacity = map(cloudY[i], 100, 200, 100, 200);
    fill(255, 255, 255, cloudOpacity);

    ellipse(cloudX[i], cloudY[i], 100, 30);
    ellipse(cloudX[i] + 30, cloudY[i] + 10, 80, 25);
    ellipse(cloudX[i] - 30, cloudY[i] + 10, 80, 25);

    cloudX[i] += cloudSpeed[i];

    if (cloudX[i] > width + 50) {
      cloudX[i] = -50;
      cloudY[i] = random(100, 200);
    }
  }
}

// Draws mountains with subtle moonlight reflection
void drawMountains() {
  float reflectionProgress = map(moonY, height, height * 0.25, 0, 1);
  int mountainColor = lerpColor(color(20, 30, 40), color(50, 50, 70), reflectionProgress);

  fill(mountainColor);
  noStroke();
  
  beginShape();
  for (PVector peak : mountainPeaks) {
    vertex(peak.x, peak.y);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}
