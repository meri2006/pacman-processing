class Fantome {
  PVector position;
  int cellX, cellY;
  int startCellX, startCellY;
  int direction;  // 0=haut 1=droite 2=bas 3=gauche
  color couleur;
  Board board;
  boolean dansLaMaison;
  boolean peur;
  float vitesse;
  float vitesseNormale;
  float vitesseLente;
  int delaiSortie;
  boolean peutSortir;
  
  Fantome(Board b, int startCellX, int startCellY, color c, int delai) {
    this.board = b;
    this.cellX = startCellX;
    this.cellY = startCellY;
    this.startCellX = startCellX;
    this.startCellY = startCellY;
    this.couleur = c;
    this.vitesseNormale = 1.5;
    this.vitesseLente = 0.7;
    this.vitesse = vitesseNormale;
    this.dansLaMaison = true;
    this.peur = false;
    this.direction = 0;
    this.delaiSortie = delai;
    this.peutSortir = (delai <= 0);
    
    // position en pixels calculee a partir de la cellule
    this.position = new PVector(
      board._position.x + cellX * board._cellSize + board._cellSize/2,
      board._position.y + cellY * board._cellSize + board._cellSize/2
    );
  }
  
  void update() {
    // attend son tour pour sortir
    if (!peutSortir) {
      delaiSortie--;
      if (delaiSortie <= 0) { 
        peutSortir = true; 
      }
      return;
    }
    
    if (dansLaMaison) { 
      sortirMaison(); 
    } else { 
      deplacer(); 
    }
  }
  
  // animation de sortie de la maison des fantomes
  void sortirMaison() {
    // le centre de la porte c'est colonne 11
    float centreX = board._position.x + 11 * board._cellSize + board._cellSize/2;
    float sortieY = board._position.y + 7 * board._cellSize + board._cellSize/2;
    
    // d'abord on se centre horizontalement
    if (abs(position.x - centreX) > 2) {
      if (position.x < centreX) position.x += vitesse;
      else position.x -= vitesse;
    }
    // puis on monte
    else if (position.y > sortieY) {
      position.x = centreX;
      position.y -= vitesse;
    }
    // on est sorti!
    else {
      dansLaMaison = false;
      cellX = 11;
      cellY = 7;
      position.x = centreX;
      position.y = sortieY;
      
      // on part a gauche ou a droite au hasard
      if (random(1) > 0.5) {
        direction = 1;
      } else {
        direction = 3;
      }
    }
  }
  
  void deplacer() {
    // calcul de la prochaine case
    int nextX = cellX;
    int nextY = cellY;
    switch(direction) {
      case 0: nextY--; break;
      case 1: nextX++; break;
      case 2: nextY++; break;
      case 3: nextX--; break;
    }
    
    // si on peut pas aller par la on change de direction
    if (nextX < 0 || nextX >= board._nbCellsX || nextY < 0 || nextY >= board._nbCellsY || board._cells[nextY][nextX] == WALL) {
      choisirDirectionAleatoire();
      return;
    }
    
    // on avance
    switch(direction) {
      case 0: position.y -= vitesse; break;
      case 1: position.x += vitesse; break;
      case 2: position.y += vitesse; break;
      case 3: position.x -= vitesse; break;
    }
    
    mettreAJourCellule();
  }
  
  // choisi une nouvelle direction quand on est bloque
  void choisirDirectionAleatoire() {
    int[] directions = new int[4];
    int nbDir = 0;
    int opposee = (direction + 2) % 4;  // on evite de faire demi tour
    
    for (int d = 0; d < 4; d++) {
      if (d == opposee) continue;
      
      int testX = cellX;
      int testY = cellY;
      switch(d) {
        case 0: testY--; break;
        case 1: testX++; break;
        case 2: testY++; break;
        case 3: testX--; break;
      }
      
      // verifie que la case est valide
      if (testX >= 0 && testX < board._nbCellsX && testY >= 0 && testY < board._nbCellsY) {
        int cellType = board._cells[testY][testX];
        // on peut aller sur les gommes mais pas dans les murs ni dans la maison (EMPTY)
        if (cellType != WALL && cellType != EMPTY) {
          directions[nbDir] = d;
          nbDir++;
        }
      }
    }
    
    // choix aleatoire parmi les directions possibles
    if (nbDir > 0) {
      direction = directions[int(random(nbDir))];
    } else {
      // si vraiment bloque on fait demi tour
      direction = opposee;
    }
  }
  
  void activerPeur() { 
    // seulement si le fantome est dehors
    if (!dansLaMaison) {
      peur = true; 
      vitesse = 0.8;  // il ralentit quand il a peur
    }
  }

  void desactiverPeur() { 
    peur = false; 
    vitesse = vitesseNormale; 
  }
  
  // quand pacman mange le fantome
  void retournerMaison() {
    cellX = 11;
    cellY = 10;
    position.x = board._position.x + cellX * board._cellSize + board._cellSize/2;
    position.y = board._position.y + cellY * board._cellSize + board._cellSize/2;
    dansLaMaison = true;
    peur = false;
    vitesse = vitesseNormale;
    peutSortir = false;
    delaiSortie = 120;  // 2 sec avant de ressortir
  }
  
  // met a jour la cellule en fonction de la position pixel
  void mettreAJourCellule() {
    cellX = int((position.x - board._position.x) / board._cellSize);
    cellY = int((position.y - board._position.y) / board._cellSize);
    cellX = constrain(cellX, 0, board._nbCellsX - 1);
    cellY = constrain(cellY, 0, board._nbCellsY - 1);
  }
  
  void drawIt() {
    // bleu quand il a peur sinon sa couleur normale
    if (peur) { fill(0, 0, 255); } else { fill(couleur); }
    noStroke();
    
    float x = position.x;
    float y = position.y;
    float taille = board._cellSize - 12;
    
    // dessin du fantome: demi cercle + rectangle + yeux
    arc(x, y - taille/6, taille, taille, PI, TWO_PI);
    rect(x - taille/2, y - taille/6, taille, taille/2);
    
    // yeux blancs
    fill(255);
    ellipse(x - taille/5, y - taille/4, taille/3, taille/3);
    ellipse(x + taille/5, y - taille/4, taille/3, taille/3);
    
    // pupilles
    if (peur) { fill(255); } else { fill(0, 0, 255); }
    ellipse(x - taille/5, y - taille/4, taille/6, taille/6);
    ellipse(x + taille/5, y - taille/4, taille/6, taille/6);
  }
}
