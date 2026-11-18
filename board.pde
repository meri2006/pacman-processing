class Board {
  int _cells[][];
  PVector _position;
  int _nbCellsX, _nbCellsY, _cellSize;
  int _heroStartX, _heroStartY;

  Board(PVector position, int cellSize, String fichier) {
    this._position = position;
    this._cellSize = cellSize;
    chargerNiveau(fichier);
  }
  
  Board(PVector position, int nbCellsX, int nbCellsY, int cellSize) {
    this._position = position;
    this._nbCellsX = nbCellsX;
    this._nbCellsY = nbCellsY;
    this._cellSize = cellSize;
    this._cells = new int[_nbCellsY][_nbCellsX];
    
    // on remplit tout de vide d'abord
    for (int i = 0; i < _nbCellsY; i++) {
      for (int j = 0; j < _nbCellsX; j++) {
        _cells[i][j] = EMPTY;
      }
    }
    
    // murs autour
    for (int j = 0; j < _nbCellsX; j++) {
      _cells[0][j] = WALL;
      _cells[_nbCellsY-1][j] = WALL;
    }
    for (int i = 0; i < _nbCellsY; i++) {
      _cells[i][0] = WALL;
      _cells[i][_nbCellsX-1] = WALL;
    }
 
    // trous pour les tunnels
    int milieuY = _nbCellsY / 2;
    int milieuX = _nbCellsX / 2;
    _cells[milieuY][0] = EMPTY;
    _cells[milieuY][_nbCellsX-1] = EMPTY;
    _cells[0][milieuX] = EMPTY;
    _cells[_nbCellsY-1][milieuX] = EMPTY;
    
    dessin();  
    placerGommes();
  }

  // murs interieurs dessines case par case
  void dessin() {
    for (int j = 2; j <= 12; j++) { _cells[3][j] = WALL; }
    for (int j = 17; j <= 27; j++) { _cells[3][j] = WALL; }
    for (int j = 2; j <= 8; j++) { _cells[7][j] = WALL; }
    for (int j = 22; j <= 27; j++) { _cells[7][j] = WALL; }
    for (int j = 2; j <= 8; j++) { _cells[12][j] = WALL; }
    for (int j = 20; j <= 27; j++) { _cells[12][j] = WALL; }
    for (int j = 3; j <= 9; j++) { _cells[16][j] = WALL; }
    for (int j = 17; j <= 20; j++) { _cells[16][j] = WALL; }
    for (int i = 2; i <= 8; i++) { _cells[i][7] = WALL; }
    for (int i = 11; i <= 17; i++) { _cells[i][7] = WALL; }
    for (int i = 2; i <= 8; i++) { _cells[i][22] = WALL; }
    for (int i = 11; i <= 17; i++) { _cells[i][22] = WALL; }
    for (int i = 2; i <= 5; i++) { _cells[i][14] = WALL; }
    for (int i = 14; i <= 17; i++) { _cells[i][14] = WALL; }
    
    // la maison des fantomes
    for (int j = 11; j <= 18; j++) { _cells[8][j] = WALL; }
    for (int j = 11; j <= 18; j++) { _cells[11][j] = WALL; }
    for (int i = 8; i <= 11; i++) { _cells[i][11] = WALL; }
    for (int i = 8; i <= 11; i++) { _cells[i][18] = WALL; }
    // la porte
    _cells[8][14] = EMPTY;
    _cells[8][15] = EMPTY;
  }

  void placerGommes() {
    for (int i = 0; i < _nbCellsY; i++) {
      for (int j = 0; j < _nbCellsX; j++) {
        if (_cells[i][j] == EMPTY) {
          // pas de gommes dans la maison des fantomes
          if (i >= 9 && i <= 10 && j >= 12 && j <= 17) { continue; }
          // pas de gommes dans les tunnels
          if ((i == _nbCellsY/2 && (j == 0 || j == _nbCellsX-1)) ||
              (j == _nbCellsX/2 && (i == 0 || i == _nbCellsY-1))) { continue; }
          _cells[i][j] = DOT;
        }
      }
    }
    // les 4 super gommes dans les coins
    _cells[2][2] = SUPER_DOT;
    _cells[2][_nbCellsX-3] = SUPER_DOT;
    _cells[_nbCellsY-3][2] = SUPER_DOT;
    _cells[_nbCellsY-3][_nbCellsX-3] = SUPER_DOT;
  }
    
  PVector getCellCenter(int i, int j) {
    return new PVector(_position.x + j * _cellSize + _cellSize/2, 
                       _position.y + i * _cellSize + _cellSize/2);
  }
  
  void drawIt(boolean modePeur) {
    // couleur des murs
    if (modePeur) {
      stroke(255, 100, 255);
    } else {
      stroke(33, 33, 255);
    }
    strokeWeight(3);
    noFill();
    
    // dessin des murs avec coins arrondis
    for (int i = 0; i < _nbCellsY; i++) {
      for (int j = 0; j < _nbCellsX; j++) {
        if (_cells[i][j] == WALL) {
          float x = _position.x + j * _cellSize;
          float y = _position.y + i * _cellSize;
          float mid = _cellSize / 2;
          float r = 6;
          
          // on regarde les voisins pour savoir comment dessiner
          boolean haut = (i > 0 && _cells[i-1][j] == WALL);
          boolean bas = (i < _nbCellsY-1 && _cells[i+1][j] == WALL);
          boolean gauche = (j > 0 && _cells[i][j-1] == WALL);
          boolean droite = (j < _nbCellsX-1 && _cells[i][j+1] == WALL);
          
          if (haut) line(x + mid, y, x + mid, y + mid);
          if (bas) line(x + mid, y + mid, x + mid, y + _cellSize);
          if (gauche) line(x, y + mid, x + mid, y + mid);
          if (droite) line(x + mid, y + mid, x + _cellSize, y + mid);
          
          // coins arrondis selon les murs voisins
          if (!haut && !gauche && (bas || droite)) {
            arc(x + mid + r, y + mid + r, r*2, r*2, PI, PI + HALF_PI);
          }
          if (!haut && !droite && (bas || gauche)) {
            arc(x + mid - r, y + mid + r, r*2, r*2, -HALF_PI, 0);
          }
          if (!bas && !gauche && (haut || droite)) {
            arc(x + mid + r, y + mid - r, r*2, r*2, HALF_PI, PI);
          }
          if (!bas && !droite && (haut || gauche)) {
            arc(x + mid - r, y + mid - r, r*2, r*2, 0, HALF_PI);
          }
        }
      }
    }
    
    // dessin des gommes
    noStroke();
    for (int i = 0; i < _nbCellsY; i++) {
      for (int j = 0; j < _nbCellsX; j++) {
        float x = _position.x + j * _cellSize + _cellSize/2;
        float y = _position.y + i * _cellSize + _cellSize/2;
        
        if (_cells[i][j] == DOT) {
          fill(255, 184, 174);
          ellipse(x, y, 5, 5);
        }
        else if (_cells[i][j] == SUPER_DOT) {
          // les grosses gommes clignotent
          if (frameCount % 20 < 10) {
            fill(255, 184, 174);
            ellipse(x, y, 14, 14);
          }
        }
      }
    }
  }
  
  // charge un niveau depuis un fichier txt
  void chargerNiveau(String fichier) {
    String[] lignes = loadStrings(fichier);
    
    if (lignes == null) {
      println("erreur fichier pas trouve: " + fichier);
      return;
    }
    
    _nbCellsY = lignes.length - 1;
    _nbCellsX = lignes[1].length();
    _cells = new int[_nbCellsY][_nbCellsX];
    
    for (int i = 0; i < _nbCellsY; i++) {
      String ligne = lignes[i + 1];
      for (int j = 0; j < _nbCellsX; j++) {
        if (j < ligne.length()) {
          char c = ligne.charAt(j);
          switch(c) {
            case 'x': _cells[i][j] = WALL; break;
            case 'o': _cells[i][j] = DOT; break;
            case 'O': _cells[i][j] = SUPER_DOT; break;
            case 'P': _cells[i][j] = EMPTY; _heroStartX = j; _heroStartY = i; break;
            default: _cells[i][j] = EMPTY; break;
          }
        }
      }
    }
    println("niveau charge ok");
  }
  
  void drawIt() {
    drawIt(false);
  }
}
