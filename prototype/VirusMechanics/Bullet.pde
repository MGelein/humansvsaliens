BulletManager bulletManager = new BulletManager();
class BulletManager {
  ManagedList<Bullet> bullets = new ManagedList<Bullet>();

  void update() {
    bullets.update();
    for (Bullet b : bullets.list) {
      b.update();
    }
  }

  void render() {
    for (Bullet b : bullets.list) {
      b.render();
    }
  }
}

class Bullet {
  final float virusThreshold = 0.1;
  final color bulletColor = color(0, 125, 255);
  PVector pos;
  float power = 0;
  final PVector shootForce = new PVector(-30, 0);

  Bullet(Ship s, float str) {
    power = str;
    pos = new PVector(width - s.buffer, s.y);
  }

  void update() {
    pos.add(shootForce);
    //Do any collision after this
    float val = samplePos(pos);
    if (val > virusThreshold) {
      explode();
    }

    //If we go out of screen, die anyway, without exploding
    if (pos.x < 0) {
      bulletManager.bullets.rem(this);
    }
  }

  void explode() {
    addExplosion(pos, (int) power);
    //Remove me now
    bulletManager.bullets.rem(this);
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(bulletColor);
    stroke(255);
    strokeWeight(RESOLUTION);
    circle(0, 0, power);
    popMatrix();
  }
}
