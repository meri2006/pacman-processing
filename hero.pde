class Hero {
  PVector _position;
  int _cellX, _cellY;
  int _startX, _startY;
  float _size;
  int direction;
  int nextDirection;
  float vitesse;
  Board board;
  float boucheAngle;
  float boucheDirection;
  
  Hero(Board b, int startX, int startY) {
    this.board = b;
    this._cellX = startX;
    this._cellY = startY;
    this._startX = startX;
    this._startY = startY;
    this.vitesse = 2;
    this.direction = -1;  // -1 = immobile
    this.nextDirection = -1;
    this._size = board._cellSize - 10; 
    this._position = new PVector(
      board._position.x + _cellX * board._cellSize + board._cellSize/2,
      board._position.y + _cellY * board._cellSize + board._cellSize/2
    );
    // pour l'animation de la bouche
    this.boucheAngle = 0.3;
    this.boucheDirection = 0.05;
  }
  
  void update() {
    // animation bouche qui s'ouvre et se ferme
    boucheAngle += boucheDirection;
    if (boucheAngle > 0.5 || boucheAngle < 0.05) { 
      boucheDirection *= -1; 
    }
    
    // si le joueur a demande une direction et qu'on peut y aller
    if (nextDirection != -1 && peutAller(nextDirection)) {
      direction = nextDirection;
    }
    
    if (direction == -1 || !peutAller(direction)) {
      return;
    }
    
    int prochaineX = _cellX;
    int prochaineY = _cellY;
    switch(direction) {
      case 0: prochaineY--; break;
      case 1: prochaineX++; break;
      case 2: prochaineY++; break;
      case 3: prochaineX--; break;
    }
    
    // teleportation quand on sort de l'ecran (tunnel)
    if (prochaineX < 0) { 
      _position.x = board._position.x + (board._nbCellsX - 1) * board._cellSize + board._cellSize/2; 
      mettreAJourCellule(); 
      return; 
    }
    if (prochaineX >= board._nbCellsX) { 
      _position.x = board._position.x + board._cellSize/2; 
      mettreAJourCellule(); 
      return; 
    }
    if (prochaineY < 0) { 
      _position.y = board._position.y + (board._nbCellsY - 1) * board._cellSize + board._cellSize/2; 
      mettreAJourCellule(); 
      return; 
    }
    if (prochaineY >= board._nbCellsY) { 
      _position.y = board._position.y + board._cellSize/2; 
      mettreAJourCellule(); 
      return; 
    }
    
    // deplacement normal
    if (board._cells[prochaineY][prochaineX] != WALL) {
      switch(direction) {
        case 0: _position.y -= vitesse; break;
        case 1: _position.x += vitesse; break;
        case 2: _position.y += vitesse; break;
        case 3: _position.x -= vitesse; break;
      }
      mettreAJourCellule();
    }
  }
  
  // verifie si on peut aller dans une direction
  boolean peutAller(int dir) {
    if (dir == -1) return false;
    
    int testX = _cellX;
    int testY = _cellY;
    switch(dir) {
      case 0: testY--; break;
      case 1: testX++; break;
      case 2: testY++; break;
      case 3: testX--; break;
    }
    
    // on peut sortir de l'ecran (pour les tunnels)
    if (testX < 0 || testX >= board._nbCellsX || testY < 0 || testY >= board._nbCellsY) { 
      return true; 
    }
    
    return board._cells[testY][testX] != WALL;
  }
  
  void mettreAJourCellule() {
    _cellX = int((_position.x - board._position.x) / board._cellSize);
    _cellY = int((_position.y - board._position.y) / board._cellSize);
    _cellX = constrain(_cellX, 0, board._nbCellsX - 1);
    _cellY = constrain(_cellY, 0, board._nbCellsY - 1);
  }
  
  // remet pacman au debut quand il meurt
  void resetPosition() {
    _cellX = _startX;
    _cellY = _startY;
    _position.x = board._position.x + _cellX * board._cellSize + board._cellSize/2;
    _position.y = board._position.y + _cellY * board._cellSize + board._cellSize/2;
    direction = -1;
    nextDirection = -1;
  }
  
  void drawIt() {
    fill(255, 255, 0);
    noStroke();
    float x = _position.x;
    float y = _position.y;
    
    // si immobile on dessine juste un cercle
    if (direction == -1) {
      ellipse(x, y, _size, _size);
      return;
    }
    
    // rotation selon la direction
    float rotation = 0;
    switch(direction) {
      case 0: rotation = -HALF_PI; break;  // haut
      case 1: rotation = 0; break;          // droite
      case 2: rotation = HALF_PI; break;    // bas
      case 3: rotation = PI; break;         // gauche
    }
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    arc(0, 0, _size, _size, boucheAngle, TWO_PI - boucheAngle, PIE);
    popMatrix();
  }
}
