class Game {
  Board _board;
  Hero _hero;
  Fantome[] _fantomes;
  Menu _menu;
  int _score;
  int _vies;
  boolean _modePeur;
  int _timerPeur;
  int _fantomeManges;
  boolean _gameOver;
  boolean _victoire;
  boolean _pause;
  boolean _afficherScores;
  int[] _meilleursScores;
  String[] _meilleursNoms;
  
  float boutonW, boutonH;
  boolean boutonSurvole;
  boolean boutonMenuSurvole;
  
  // pour gerer quand le joueur tape son nom
  boolean _saisieNom;
  String _nomJoueur;
  boolean _scoreEnregistre;
  boolean _bonusVieDonne;  // la vie bonus n'est donnee qu'une fois
  
  Game() {
    _board = new Board(new PVector(20, 40), 27, "levels/level1.txt");
    _hero = new Hero(_board, _board._heroStartX, _board._heroStartY);
    _menu = new Menu();
    _score = 0;
    _vies = 2;  // 3 vies au total avec celle de base
    _modePeur = false;
    _timerPeur = 0;
    _fantomeManges = 0;
    _gameOver = false;
    _victoire = false;
    _pause = false;
    _afficherScores = false;
    boutonSurvole = false;
    boutonMenuSurvole = false;
    
    _saisieNom = false;
    _nomJoueur = "";
    _scoreEnregistre = false;
    _bonusVieDonne = false;
    
    // taille du bouton recommencer
    boutonW = 350;
    boutonH = 50;
    
    // creation des 4 fantomes avec leurs couleurs
    // le dernier parametre c'est le delai avant qu'ils sortent
    _fantomes = new Fantome[4];
    _fantomes[0] = new Fantome(_board, 9, 10, color(255, 0, 0), 0);      // rouge sort direct
    _fantomes[1] = new Fantome(_board, 10, 10, color(255, 184, 255), 120); // rose
    _fantomes[2] = new Fantome(_board, 12, 10, color(0, 255, 255), 240);   // cyan
    _fantomes[3] = new Fantome(_board, 13, 10, color(255, 184, 82), 360);  // orange

    chargerScores();
  }
  
  void handleMouse(int mx, int my) {
    // clic sur bouton menu en haut a droite
    if (mx >= width - 80 && mx <= width - 10 && my >= 5 && my <= 35) {
      if (!_gameOver && !_victoire && !_saisieNom && !_menu.actif) {
        _menu.ouvrir();
        _pause = true;
        return;
      }
    }
    
    // on bloque les clics si le joueur est en train de taper son nom
    if (_saisieNom) return;
    
    if (_gameOver || _victoire) {
      float bX = width/2 - boutonW/2;
      float bY = height/2 + 60;
      
      // verif si on clique sur le bouton
      if (mx >= bX && mx <= bX + boutonW && my >= bY && my <= bY + boutonH) {
        recommencer();
      }
    }
  }
  
  void chargerScores() {
    // init du tableau des scores
    _meilleursScores = new int[5];
    _meilleursNoms = new String[5];
    for (int i = 0; i < 5; i++) {
      _meilleursNoms[i] = "---";
      _meilleursScores[i] = 0;
    }
    
    // on essaie de lire le fichier, si il existe pas c'est pas grave
    try {
      String[] lignes = loadStrings("data/scores.txt");
      if (lignes != null) {
        for (int i = 0; i < min(5, lignes.length); i++) {
          String[] parts = split(lignes[i], ";");
          if (parts.length >= 2) {
            _meilleursNoms[i] = parts[0];
            _meilleursScores[i] = int(parts[1]);
          }
        }
      }
    } catch (Exception e) {
      println("Pas de fichier scores, c'est normal au premier lancement");
    }
  }
  
  void sauvegarderScores() {
    String[] lignes = new String[5];
    for (int i = 0; i < 5; i++) {
      lignes[i] = _meilleursNoms[i] + ";" + _meilleursScores[i];
    }
    saveStrings("data/scores.txt", lignes);
  }
  
  void sauvegarderPartie() {
    // je sauvegarde juste les infos essentielles
    String[] lignes = new String[5];
    lignes[0] = str(_score);
    lignes[1] = str(_vies);
    lignes[2] = str(_hero._cellX);
    lignes[3] = str(_hero._cellY);
    lignes[4] = str(_hero.direction);
    saveStrings("data/sauvegarde.txt", lignes);
    println("ok partie sauvegardee");
  }
  
  void chargerPartie() {
    try {
      String[] lignes = loadStrings("data/sauvegarde.txt");
      if (lignes != null && lignes.length >= 5) {
        _score = int(lignes[0]);
        _vies = int(lignes[1]);
        _hero._cellX = int(lignes[2]);
        _hero._cellY = int(lignes[3]);
        _hero.direction = int(lignes[4]);
        // faut recalculer la position en pixels
        _hero._position.x = _board._position.x + _hero._cellX * _board._cellSize + _board._cellSize/2;
        _hero._position.y = _board._position.y + _hero._cellY * _board._cellSize + _board._cellSize/2;
        _gameOver = false;
        _victoire = false;
        println("ok partie chargee");
      }
    } catch (Exception e) {
      println("erreur chargement, fichier introuvable?");
    }
  }
  
  void recommencer() {
    // on reinit tout
    _board = new Board(new PVector(20, 40), 27, "levels/level1.txt");
    _hero = new Hero(_board, _board._heroStartX, _board._heroStartY);
    _score = 0;
    _vies = 2;
    _modePeur = false;
    _timerPeur = 0;
    _fantomeManges = 0;
    _gameOver = false;
    _victoire = false;
    _pause = false;
    _menu.fermer();
    
    _saisieNom = false;
    _nomJoueur = "";
    _scoreEnregistre = false;
    _bonusVieDonne = false;
    
    // on remet les fantomes a leur place
    _fantomes[0] = new Fantome(_board, 9, 10, color(255, 0, 0), 0);
    _fantomes[1] = new Fantome(_board, 10, 10, color(255, 184, 255), 120);
    _fantomes[2] = new Fantome(_board, 12, 10, color(0, 255, 255), 240);
    _fantomes[3] = new Fantome(_board, 13, 10, color(255, 184, 82), 360);
  }
  
  void gererMenu(int choix) {
    switch(choix) {
      case 0:  // reprendre
        _menu.fermer();
        _pause = false;
        break;
      case 1:  // recommencer
        recommencer();
        break;
      case 2:  // sauvegarder
        sauvegarderPartie();
        break;
      case 3:  // charger
        chargerPartie();
        _menu.fermer();
        _pause = false;
        break;
      case 4:  // scores
        _afficherScores = true;
        _menu.fermer();        
        _pause = false;        
        break;
      case 5:  // quitter
        exit();
        break;
    }
  }
  
  // check si le score merite d'etre dans le top 5
  boolean estDansTop5() {
    for (int i = 0; i < 5; i++) {
      if (_score > _meilleursScores[i]) {
        return true;
      }
    }
    return false;
  }
  
  // ajoute le score au bon endroit dans le classement
  void insererScore() {
    for (int i = 0; i < 5; i++) {
      if (_score > _meilleursScores[i]) {
        // decale tous les scores en dessous
        for (int j = 4; j > i; j--) {
          _meilleursScores[j] = _meilleursScores[j-1];
          _meilleursNoms[j] = _meilleursNoms[j-1];
        }
        _meilleursScores[i] = _score;
        _meilleursNoms[i] = _nomJoueur;
        break;
      }
    }
    sauvegarderScores();
    _scoreEnregistre = true;
  }
  
  void handleKey(char k, int code) {
    // si on est en train de taper le nom
    if (_saisieNom) {
      if (code == 10 || code == ENTER || code == RETURN) {
        // valide que si y'a au moins 1 caractere
        if (_nomJoueur.length() > 0) {
          insererScore();
          _saisieNom = false;
        }
      } else if (code == 8) {  // backspace
        if (_nomJoueur.length() > 0) {
          _nomJoueur = _nomJoueur.substring(0, _nomJoueur.length() - 1);
        }
      } else if (_nomJoueur.length() < 10 && k >= ' ' && k <= 'z') {
        // max 10 caracteres pour le nom
        _nomJoueur += k;
      }
      return;
    }
    
    // ferme l'ecran des scores
    if (_afficherScores) {
      _afficherScores = false;
      return;
    }
    
    // navigation dans le menu
    if (_menu.actif) {
      if (code == 38 || k == 'z' || k == 'Z') {
        _menu.monter();
      } else if (code == 40 || k == 's' || k == 'S') {
        _menu.descendre();
      } else if (code == 10 || k == ENTER || k == RETURN) {
        gererMenu(_menu.valider());
      } else if (code == 27) {  // echap
        _menu.fermer();
        _pause = false;
      }
      return;
    }
    
    // ouvre le menu avec echap ou P
    if (code == 27 || k == 'p' || k == 'P') {
      if (!_gameOver && !_victoire) {
        _menu.ouvrir();
        _pause = true;
      }
      return;
    }
    
    // controles du pacman - zqsd ou fleches
    if (!_gameOver && !_victoire && !_pause) {
      if (code == 38 || k == 'z' || k == 'Z') {
        _hero.nextDirection = 0;  // haut
      } else if (code == 39 || k == 'd' || k == 'D') {
        _hero.nextDirection = 1;  // droite
      } else if (code == 40 || k == 's' || k == 'S') {
        _hero.nextDirection = 2;  // bas
      } else if (code == 37 || k == 'q' || k == 'Q') {
        _hero.nextDirection = 3;  // gauche
      }
    }
  }
  
  void update() {
    float bX = width/2 - boutonW/2;
    float bY = height/2 + 60;
    
    // effet hover sur le bouton recommencer
    if (_gameOver || _victoire) {
      boutonSurvole = (mouseX >= bX && mouseX <= bX + boutonW &&
                       mouseY >= bY && mouseY <= bY + boutonH);
    }
    
    // effet hover sur le bouton menu
    boutonMenuSurvole = (mouseX >= width - 80 && mouseX <= width - 10 &&
                         mouseY >= 5 && mouseY <= 35);
    
    // on update rien si pause ou partie finie
    if (_pause || _gameOver || _victoire) {
      return;
    }
    
    _hero.update();
    
    // gestion du mode peur (quand pacman mange une grosse gomme)
    if (_modePeur) { 
      _timerPeur--; 
      if (_timerPeur <= 0) { 
        desactiverModePeur(); 
      } 
    }
    
    // update de chaque fantome
    for (int i = 0; i < _fantomes.length; i++) { 
      _fantomes[i].update(); 
    }
    
    verifierCollisions();
    verifierGommes();
    verifierVictoire();
    
    // bonus vie a 10000 points (comme dans le vrai pacman)
    if (_score >= 10000 && !_bonusVieDonne) { 
      _vies++; 
      _bonusVieDonne = true;
    }
  }
  
  void verifierGommes() {
    int cellX = _hero._cellX;
    int cellY = _hero._cellY;
    
    if (_board._cells[cellY][cellX] == DOT) { 
      _board._cells[cellY][cellX] = EMPTY; 
      _score += 10; 
    }
    else if (_board._cells[cellY][cellX] == SUPER_DOT) { 
      _board._cells[cellY][cellX] = EMPTY; 
      _score += 50; 
      activerModePeur(); 
    }
  }
  
  // verifie si toutes les gommes sont mangees
  void verifierVictoire() {
    for (int i = 0; i < _board._nbCellsY; i++) {
      for (int j = 0; j < _board._nbCellsX; j++) {
        if (_board._cells[i][j] == DOT || _board._cells[i][j] == SUPER_DOT) {
          return;  // il reste des gommes
        }
      }
    }
    _victoire = true;
  }
  
  void activerModePeur() {
    _modePeur = true;
    _timerPeur = 300;  // environ 5 secondes a 60fps
    _fantomeManges = 0;
    for (int i = 0; i < _fantomes.length; i++) { 
      _fantomes[i].activerPeur(); 
    }
  }
  
  void desactiverModePeur() {
    _modePeur = false;
    for (int i = 0; i < _fantomes.length; i++) { 
      _fantomes[i].desactiverPeur(); 
    }
  }
  
  void verifierCollisions() {
    for (int i = 0; i < _fantomes.length; i++) {
      float d = dist(_hero._position.x, _hero._position.y, _fantomes[i].position.x, _fantomes[i].position.y);
      
      // collision detectee
      if (d < _board._cellSize * 0.7) {
        if (_modePeur && _fantomes[i].peur) {
          // on mange le fantome
          _fantomes[i].retournerMaison();
          _fantomeManges++;
          // les points doublent a chaque fantome mange: 200, 400, 800, 1600
          _score += 200 * (int)pow(2, _fantomeManges - 1);
        }
        else if (!_fantomes[i].dansLaMaison && !_fantomes[i].peur) {
          // le fantome nous tue
          perdreVie();
          return; 
        }
      }
    }
  }
  
  void perdreVie() {
    _vies--;
    if (_vies <= 0) { 
      _gameOver = true;
    } else {
      _hero.resetPosition();
      
      // on remet les fantomes dans leur maison
      _fantomes[0] = new Fantome(_board, 9, 10, color(255, 0, 0), 0);
      _fantomes[1] = new Fantome(_board, 10, 10, color(255, 184, 255), 120);
      _fantomes[2] = new Fantome(_board, 12, 10, color(0, 255, 255), 240);
      _fantomes[3] = new Fantome(_board, 13, 10, color(255, 184, 82), 360);
      
      _modePeur = false;
      _timerPeur = 0;
    }
  }
  
  void drawIt() {
    // fond violet quand mode peur sinon noir
    if (_modePeur) {
      background(20, 0, 40);
    } else {
      background(0);
    }
    
    _board.drawIt(_modePeur);
    _hero.drawIt();
    
    for (int i = 0; i < _fantomes.length; i++) { 
      _fantomes[i].drawIt(); 
    }
    
    // affichage du score en haut
    textAlign(CENTER, TOP);
    
    fill(255);
    textSize(16);
    text("1UP", 80, 5);
    text(nf(_score, 2), 80, 22);
    
    // high score au milieu
    fill(255);
    text("HIGH SCORE", width/2, 5);
    int highScore = max(_score, _meilleursScores[0]);
    text(nf(highScore, 2), width/2, 22);
    
    // bouton menu en haut a droite
    if (boutonMenuSurvole && !_gameOver && !_victoire && !_menu.actif) {
      fill(255, 255, 0);
      cursor(HAND);
    } else {
      fill(50, 50, 150);
      cursor(ARROW);
    }
    stroke(255, 255, 0);
    strokeWeight(2);
    rect(width - 80, 5, 70, 30, 5);
    
    if (boutonMenuSurvole && !_gameOver && !_victoire && !_menu.actif) {
      fill(0);
    } else {
      fill(255);
    }
    textSize(14);
    textAlign(CENTER, CENTER);
    text("MENU", width - 45, 20);
    
    // petits pacmans pour les vies en bas a gauche
    noStroke();
    for (int i = 0; i < _vies; i++) {
      fill(255, 255, 0);
      float vieX = 30 + i * 25;
      float vieY = height - 20;
      arc(vieX, vieY, 18, 18, 0.3, TWO_PI - 0.3, PIE);
    }
    
    textAlign(LEFT, BASELINE);
    
    if (_gameOver) {
      dessinerFin("GAME OVER", color(255, 0, 0));
    }
    
    if (_victoire) {
      dessinerFin("VICTOIRE!", color(0, 255, 0));
    }
    
    if (_afficherScores) {
      dessinerScores();
    }
    
    if (_saisieNom) {
      dessinerSaisieNom();
    }
    
    _menu.drawIt();
  }
  
  void dessinerFin(String titre, color c) {
    // si nouveau record on demande le nom d'abord
    if (!_scoreEnregistre && estDansTop5()) {
      _saisieNom = true;
      return;
    }
    
    // fond semi transparent
    fill(0, 180);
    rect(0, 0, width, height);
    
    fill(c);
    textSize(60);
    textAlign(CENTER, CENTER);
    text(titre, width/2, height/2 - 60);
    
    fill(255);
    textSize(35);
    text("Score: " + _score, width/2, height/2);
    
    // bouton recommencer
    float bX = width/2 - boutonW/2;
    float bY = height/2 + 60;
    
    if (boutonSurvole) {
      fill(255, 255, 0);
      stroke(255);
      cursor(HAND);
    } else {
      fill(50, 50, 150);
      stroke(255, 255, 0);
      cursor(ARROW);
    }
    strokeWeight(3);
    rect(bX, bY, boutonW, boutonH, 10);
    
    if (boutonSurvole) {
      fill(0);
    } else {
      fill(255);
    }
    textSize(22);
    text("Cliquez ici pour recommencer", width/2, bY + boutonH/2);
    
    textAlign(LEFT, BASELINE);
  }
  
  void dessinerSaisieNom() {
    fill(0, 200);
    rect(0, 0, width, height);
    
    fill(255, 255, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("NOUVEAU RECORD!", width/2, height/2 - 100);
    
    fill(255);
    textSize(25);
    text("Score: " + _score, width/2, height/2 - 50);
    
    text("Entrez votre nom:", width/2, height/2);
    
    // zone de texte
    fill(50);
    stroke(255, 255, 0);
    strokeWeight(2);
    rect(width/2 - 100, height/2 + 30, 200, 40, 5);
    
    // curseur qui clignote
    fill(255, 255, 0);
    textSize(30);
    String affichage = _nomJoueur;
    if (frameCount % 30 < 15) { affichage += "_"; }
    text(affichage, width/2, height/2 + 50);
    
    fill(150);
    textSize(15);
    text("Appuie ENTER pour valider", width/2, height/2 + 100);
    
    textAlign(LEFT, BASELINE);
  }
  
  void dessinerScores() {
    fill(0, 200);
    rect(0, 0, width, height);
    
    fill(255, 255, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("MEILLEURS SCORES", width/2, height/2 - 120);
    
    textSize(25);
    for (int i = 0; i < 5; i++) {
      fill(255);
      text((i+1) + ". " + _meilleursNoms[i] + " - " + _meilleursScores[i], width/2, height/2 - 50 + i * 40);
    }
    
    fill(150);
    textSize(15);
    text("Appuie une touche pour fermer", width/2, height/2 + 160);
    textAlign(LEFT, BASELINE);
  }
}
