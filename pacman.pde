Game game;

void setup() {
    size(710, 680);
    game = new Game();
}

void draw() {
  game.update();
  game.drawIt();
}

void keyPressed() {
  if (key == ESC) {
    key = 0;
  }
  game.handleKey(key, keyCode);
}

void mousePressed() {
  game.handleMouse(mouseX, mouseY);
}
