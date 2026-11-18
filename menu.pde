class Menu {
  boolean actif;
  int selection;
  String[] options;
  
  Menu() {
    this.actif = false;
    this.selection = 0;
    this.options = new String[] {
      "Reprendre",
      "Recommencer",
      "Sauvegarder",
      "Charger",
      "Meilleurs scores",
      "Quitter"
    };
  }
  
  void ouvrir() {
    actif = true;
    selection = 0;
  }
  
  void fermer() {
    actif = false;
  }
  
  void monter() {
    selection--;
    if (selection < 0) {
      selection = options.length - 1;  // revient en bas
    }
  }
  
  void descendre() {
    selection++;
    if (selection >= options.length) {
      selection = 0;  // revient en haut
    }
  }
  
  int valider() {
    return selection;
  }
  
  void drawIt() {
    if (!actif) return;
    
    // fond sombre
    fill(0, 180);
    rect(0, 0, width, height);
    
    // le cadre du menu
    float menuW = 400;
    float menuH = 420;
    float menuX = width/2 - menuW/2;
    float menuY = height/2 - menuH/2;
    
    fill(20, 20, 50);
    stroke(255, 255, 0);
    strokeWeight(3);
    rect(menuX, menuY, menuW, menuH, 15);
    
    // titre
    fill(255, 255, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("PAUSE", width/2, menuY + 50);
    
    // les options
    textSize(25);
    for (int i = 0; i < options.length; i++) {
      float optionY = menuY + 120 + i * 45;
      
      // surlignage de l'option selectionnee
      if (i == selection) {
        fill(255, 255, 0);
        noStroke();
        rect(menuX + 50, optionY - 15, menuW - 100, 35, 5);
        fill(0);
      } else {
        fill(255);
      }
      
      text(options[i], width/2, optionY);
    }
    
    // aide en bas
    fill(150);
    textSize(14);
    text("Z/S pour naviguer | ENTER pour valider", width/2, menuY + menuH - 30);
    
    textAlign(LEFT, BASELINE);
  }
}
