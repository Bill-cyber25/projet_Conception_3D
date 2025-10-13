/*

tout ce qui concerne l'affichage du labyrinthe

*/


//______________________________________

// AFFICHAGE LABYRINTHE


// dégradé couleur des murs, plus utilisé
void fill(int i, int j) {
  fill(i/float(labyrinthe.length)*255, j/float(labyrinthe[0].length)*255, 255);
}


// affiche tout les labyrinthes empilés les uns sur les autres
void afficheAllLab() {
  for (int la = 0; la < NB_LAB; la++) {
    boolean[][] vis = new boolean[tabLab[la].length][tabLab[la][0].length];
    if (la == level) vis = currentVision(labyrinthe);
    push();
    translate(boxSize*la, boxSize*la, boxSize*la);
    afficheLabyrinthe(boxSize, bs2, vis, la);
    pop();
  }
}

// si on est de l'extérieur, on affiche toutes les cases. sinon, on affiche seulement celles visibles par le joueur
void afficheLabyrinthe(int boxSize, int bs2, boolean[][] inView, int lvl) {
  char[][] lab = tabLab[lvl];
  noStroke();
  noTint();
  
  //porte d'entrée
  texture(mur);
  pushMatrix();
  translate(boxSize, boxSize);
  // mur gauche
  beginShape(QUADS);
  texture(mur);
  vertex(-bs2, bs2, 0, 1, 0);
  vertex(-bs2, bs2, boxSize, 1, 1);
  vertex(-bs2, -bs2, boxSize, 0, 1);
  vertex(-bs2, -bs2, 0, 0, 0);
  endShape();
  popMatrix();
  
  // si on veut que la lumière affecte tout le labyrinthe, il faut la mettre avant de faire le labyrinthe
  // affiche seulement la lumière si on est à l'étage correspondant et si on n'est pas à l'extérieur
  if (lvl == level && !isOutside) afficheAllLights(lab, inView, lvl);
  
  for (int i=0; i<lab.length; i++) {
    for (int j=0; j<lab[0].length; j++) {
      pushMatrix();
      translate(i*boxSize, j*boxSize);
      if (inView[i][j] || isOutside) afficheCase(bs2, boxSize, i, j, lab);
      popMatrix();
    }
  }
}

private void afficheAllLights(char[][] lab, boolean[][] inView, int lvl) {
  for (int i=0; i<lab.length; i++) {
    for (int j=0; j<lab[0].length; j++) {
      pushMatrix();
      translate(i*boxSize, j*boxSize);
      if (lab[i][j] == '#') afficheLights(i, j, tabSides[lvl], inView);
      popMatrix();
    }
  }
}

private void afficheLights(int i, int j, char[][][] sides, boolean[][] inView) {
  if (sides[i][j][1] == 1 && inView[i][j-1]) lightDeadEnd(boxSize, bs2, "haut");
  if (sides[i][j][0] == 1 && inView[i+1][j]) lightDeadEnd(boxSize, bs2, "droit");
  if (sides[i][j][2] == 1 && inView[i][j+1]) lightDeadEnd(boxSize, bs2, "bas");
  if (sides[i][j][3] == 1 && inView[i-1][j]) lightDeadEnd(boxSize, bs2, "gauche");
}



private void afficheCase(int bs2, int boxSize, int i, int j, char[][] lab) {
  texture(mur);
  //boolean isEntrance = posX == 0 && posY == 1;
  //fill(i, j);
  if (lab[i][j] == '#') {  // si c'est un mur
    // mur haut
    if (j==0 || lab[i][j-1]!='#') {
      beginShape(QUADS);
      texture(mur);
      vertex(-bs2, -bs2, 0, 0, 0);
      vertex(-bs2, -bs2, boxSize, 0, 1);
      vertex(bs2, -bs2, boxSize, 1, 1);
      vertex(bs2, -bs2, 0, 1, 0);
      endShape();
    }

    // mur droit
    if (i == lab.length-1 || lab[i+1][j]!='#') {
      beginShape(QUADS);
      texture(mur);
      vertex(bs2, -bs2, 0, 0, 0);
      vertex(bs2, -bs2, boxSize, 0, 1);
      vertex(bs2, bs2, boxSize, 1, 1);
      vertex(bs2, bs2, 0, 1, 0);
      endShape();
    }
    
    // mur bas
    if (j==lab.length-1 || lab[i][j+1]!='#') {
      beginShape(QUADS);
      texture(mur);
      vertex(bs2, bs2, 0, 1, 0);
      vertex(bs2, bs2, boxSize, 1, 1);
      vertex(-bs2, bs2, boxSize, 0, 1);
      vertex(-bs2, bs2, 0, 0, 0);
      endShape();
    }
    
    // mur gauche
    if (i==0 || lab[i-1][j]!='#') {
      beginShape(QUADS);
      texture(mur);
      vertex(-bs2, bs2, 0, 1, 0);
      vertex(-bs2, bs2, boxSize, 1, 1);
      vertex(-bs2, -bs2, boxSize, 0, 1);
      vertex(-bs2, -bs2, 0, 0, 0);
      endShape();
    }

  } else {
    fill(0);
    // sol
    beginShape(QUADS);
    vertex(-bs2, -bs2, 0);
    vertex(bs2, -bs2, 0);
    vertex(bs2, bs2, 0);
    vertex(-bs2, bs2, 0);
    endShape();
    
    if (!cameraShift) {
      // plafond (disparait pour débug)
      beginShape(QUADS);
      vertex(-bs2,  bs2, boxSize);
      vertex( bs2,  bs2, boxSize);
      vertex( bs2, -bs2, boxSize);
      vertex(-bs2, -bs2, boxSize);
      endShape();
    }
  }
}


void lightDeadEnd(int boxSize, int bs2, String dir) {
  int r, g, b;
  int x = 0, y = 0;
  switch (dir) {
    case "haut":   r = 255; g = 0;   b = 0;   y = -1; break; 
    case "gauche": r = 0;   g = 255;   b = 255; x = -1; break;
    case "bas":    r = 0;   g = 255; b = 0;   y = 1;  break;
    case "droit":  r = 255; g = 255; b = 0;   x = 1;  break;
    default: throw new RuntimeException("direction invalide");
  }
  
  pushMatrix();
  translate(bs2*x, bs2*y, boxSize);
  spotLight(r, g, b, bs2*x, bs2*y, 0, 0, 0, -1, PI/4.0, 1);
  popMatrix();
  
  pushMatrix();
  translate(bs2*x, bs2*y, boxSize*9/10); // pour que ça passe pas à travers le plafond
  sphereDetail(8);
  scale(1, 1, 2/3.0);  // pour que la sphere corresponde à la perspective
  fill(r, g, b);
  sphere(bs2/5.0);
  popMatrix();
  
}



// un affichage texte pour vous aider a visualiser le labyrinthe en 2D
// (copie du code dans setup() )
void printLab(char[][] labyrinthe) {
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      print(labyrinthe[j][i]);
    }
    println("");
  }
}


//_____________________________________

// AFFICHAGE MINIMAP

void afficheMiniMap(float xj, float yj) {
  noLights();
  stroke(0);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), 
         width/2.0, height/2.0, 0, 
         0, 1, 0);
  perspective(PI/3.0, width/height, (height/2.0) / tan(PI*30.0 / 180.0)/10.0, (height/2.0) / tan(PI*30.0 / 180.0)*10.0);
  boxLabyrinthe(int(bs2/2.0), hasSeen);

  // position du joueur
  affichePosJoueur(xj, yj);

  // position de la momie
  affichePosMomie();
  
  afficheLevel();
}


void boxLabyrinthe(int boxSize, boolean[][] affiche) {
  fill(120);
  translate(0, 0, boxSize/2.0);
  for (int i=0; i<labyrinthe.length; i++) {
    for (int j=0; j<labyrinthe[0].length; j++) {
      pushMatrix();
      translate(i*boxSize, j*boxSize);
      //fill(i, j);
      fill(120);
      if (affiche[i][j]) {
        if (labyrinthe[i][j] != '#') {  // sol noir en dessous 
          fill(0);
          translate(0, 0, -boxSize);
        }
        box(boxSize);
      }
      popMatrix();
    }
  }
}

void affichePosJoueur(float x, float y) {
  pushMatrix();
  translate(x/4.0, y/4.0, 0);
  fill(0, 255, 0);
  noStroke();
  sphereDetail(8);
  sphere(bs2/4.0);
  popMatrix();
}
void affichePosMomie() {
  pushMatrix();
  translate(momX*boxSize/4.0, momY*boxSize/4.0, 0);
  fill(255, 0, 0);
  noStroke();
  sphereDetail(8);
  sphere(bs2/8.0);
  popMatrix();
}

//________________________________

// NIVEAU ACTUEL

void afficheLevel(){
  textSize(width/32);
  textAlign(RIGHT,TOP);
  fill(255,255,255);
  text("NIVEAU : "+ (level+1), width-10,0);
}
