
// DEPLACEMENT

int momX=1, momY=1; private int dirMX=0, dirMY=1;


// place la momie
public void setPositionMomie(int x, int y) {
  momX = x;
  momY = y;
}
/* place la momie sur une case vide sélectionnée, ou une de ses voisines sinon */
public void setPositionMomie(char[][] l, int x, int y) {
  if (!outOfBounds(l, x, y) || l[x][y] != '#') {
    setPositionMomie(x, y);
    return; 
  }
  for (int i=-1; i<=1 && x+i < l.length && x+i >= 0; i++) { 
    if (!outOfBounds(l, x+i, y) || l[x+i][y] != '#') {
      setPositionMomie(x+i, y);
      return; 
    }
  }
  for (int i=-1; i<=1 && y+i < l[0].length && y+i >= 0; i++) { 
    if (!outOfBounds(l, x, y+i) || l[x][y+i] != '#') {
      setPositionMomie(x, y+i);
      return; 
    }
  }
  throw new RuntimeException("pas de case disponible pour la momie");
}



// TIMER

// se déplace toutes les X frames
private int timerMove = 0, maxTimerMove = 40, baseMaxTimerMove = 40;

// set la vitesse à laquelle la momie se déplace (à appeler au début du programme)
public void setMaxTimerMoveMomie(int nb) {
  maxTimerMove = nb;
  baseMaxTimerMove = nb;
}

void quickTimer() { maxTimerMove = int(baseMaxTimerMove/4.0); } 
void slowTimer()  { maxTimerMove = int(baseMaxTimerMove); } 



// DEPLACEMENT

private boolean vaDansUnMur(char[][] laby) {
  return vaDansUnMur(laby, dirMX, dirMY);
}
private boolean vaDansUnMur(char[][] laby, String dir) {
  if (dir == "gauche") return vaDansUnMur(laby, dirMY, -dirMX);
  else if (dir == "droite") return vaDansUnMur(laby, -dirMY, dirMX);
  else throw new RuntimeException("Direction invalide");
}
private boolean vaDansUnMur(char[][] laby, int dirx, int diry) {
  int fx = momX+dirx, fy = momY+diry;
  return outOfBounds(laby, fx, fy) || laby[fx][fy] == '#';
}


public void deplaceMomie(char[][] laby, int xJoueur, int yJoueur) {
  boolean voieJoueur = checkVueJoueur(laby, xJoueur, yJoueur);
  if (voieJoueur) {
    tournerVersJoueur(xJoueur, yJoueur);
    quickTimer();
  } else slowTimer();
  timerMove++;
  if (timerMove < maxTimerMove) return;  // si c'est pas le moment de bouger 
  timerMove = 0;
  if (!voieJoueur) tourner(laby);
  if (!vaDansUnMur(laby)) momieAvance();
}

/*
// pas utile puisque déjà inclus dans tourner()
//s'il y a de l'espace à droite et à gauche
private boolean peutTourner(char[][] l) {
  return !vaDansUnMur(l, "droite") || !vaDansUnMur(l, "gauche");
}
*/

private void momieAvance() {
  momX += dirMX;
  momY += dirMY;
}

private void tourner(char[][] laby) {
  int dir = int(random(6));  // 0 rien, 1 gauche, 2 droite
  int tmp = dirMX;
  
  if (vaDansUnMur(laby)) {
    dir = dir%2 +1; // si tu vas dans un mur, faut tourner
    // si tu peux seulement tourner à droite, tu tournes à doite (et vice versa)
    if (dir == 1 && vaDansUnMur(laby, "gauche")) dir = 2;
    else if (dir == 2 && vaDansUnMur(laby, "droite")) dir = 1;
  }
  else { 
    dir = dir%3; 
    // si on cherche à tourner vers un mur, on tourne pas
    if ((dir == 1 && vaDansUnMur(laby, "gauche")) || 
        (dir == 2 && vaDansUnMur(laby, "droite"))) dir = 0;
  }
  
  if (dir == 1) {
    dirMX = dirMY;
    dirMY = -tmp;
  }
  else if (dir == 2) {
    dirMX = -dirMY;
    dirMY = tmp;
  }
}


 /* pour les tests
void keyPressed() {
  if (keyCode == UP) {
    momieAvance();
  }
  if (keyCode == LEFT) {
    int tmp = dirMX;
    dirMX = dirMY;
    dirMY = -tmp;
  }
  if (keyCode == RIGHT) {
    int tmp = dirMX;
    dirMX = -dirMY;
    dirMY = tmp;
  }
}
// */


// VISION DU JOUEUR

/* x, y la position du joueur */
private void tournerVersJoueur(int x, int y) {
  int nx = x - momX;
  int ny = y - momY;
  if (nx != 0) {
    dirMX = nx/abs(nx);
    dirMY = 0;
  }
  else if (ny != 0) {
    dirMY = ny/abs(ny);
    dirMX = 0;
  }
}

// peut voir le joueur s'il est dans un couloir devant, à droite ou à gauche 
private boolean checkVueJoueur(char [][] laby, int xj, int yj) {
  if (xj == momX) {
    if (dirMY != -1) for (int ym = momY; ym < laby[momX].length; ym++) {
        if (outOfBounds(laby, momX, ym) || laby[momX][ym] == '#') break;
        if (momX == xj && ym == yj) return true; 
    }
    if (dirMY != 1) for (int ym = momY; ym < laby[momX].length; ym--) {
        if (outOfBounds(laby, momX, ym) || laby[momX][ym] == '#') break;
        if (momX == xj && ym == yj) return true; 
    }
  }
  if (yj == momY) {
    if (dirMX != -1) for (int xm = momX; xm < laby.length; xm++) {
        if (outOfBounds(laby, xm, momY) || laby[xm][momY] == '#') break;
        if (xm == xj && momY == yj) return true; 
    }
    if (dirMX != 1) for (int xm = momX; xm < laby.length; xm--) {
        if (outOfBounds(laby, xm, momY) || laby[xm][momY] == '#') break;
        if (xm == xj && momY == yj) return true; 
    }
  }
  return false;
}



// _________________________________

// AFFICHAGE

public void afficheMomie(int boxSize) {
  PShape momShape = momie(180, 80);
  momShape.scale(boxSize/180.0);
  pushMatrix();
  
  translate(momX*boxSize, momY*boxSize, 0);
  
  float angle; // direction vers laquelle la momie regarde
  if (dirMX == 0) angle = PI/2.0 + dirMY*PI/2.0;
  else angle = dirMX*PI/2.0;
  rotateZ(angle);
  
  shape(momShape);
  popMatrix();

}

int idle = 0, maxIdle = 100;

// tailleH la taille totale, largeur la largeur de la momie (r*2)
private PShape momie(int tailleH, int largeur) {
  PShape mom = createShape(GROUP);
  PShape corps, tête, bras1, bras2;
  mom.noStroke();
  float r = largeur/2.0;
  int nbc1 = 32;  // nb de niveaux pour le corps
  int nbc2 = 42;  // nb total de niveaux (corps + tête)
  int h = int(tailleH/(float)nbc2); // la hauteur d'une bandelette
  
  corps = cylindreMomie(r, h, nbc1);
  mom.addChild(corps);
  
  //tête
  pushMatrix();
  tête = cylindreMomie(r*2/3.0, h, nbc2 - nbc1);
  tête.translate(0, 0, nbc1*h);
  mom.addChild(tête);
  popMatrix();
  
  
  float xBras = r*0.8;
  float yBras = r*0.2;
  float hBras = nbc1*h*0.9;
  int nbTours = int((nbc2 - nbc1)*2);
  
  float idleA = cos(idle/float(maxIdle)*2*PI); 
  // pour que idleA et idleB soient légèrement décalés
  float idleB = cos((idle2(idle))/float(maxIdle)*2*PI);
  float angleI = PI/8.0;
  
  //bras 1
  pushMatrix();
  bras1 = cylindreMomie(r/3.0, h, nbTours);
  bras1.rotateX(PI/2.0 + angleI*idleA);
  bras1.translate(xBras, yBras, hBras);
  mom.addChild(bras1);
  popMatrix();
  
  //bras 2
  pushMatrix();
  bras2 = cylindreMomie(r/3.0, h, nbTours);
  bras2.rotateX(PI/2.0 + angleI*idleB);
  bras2.translate(-xBras, yBras, hBras);
  mom.addChild(bras2);
  popMatrix();
  
  idle++;
  if (idle >= maxIdle) idle = 0;
  
  PShape yeux = createShape();
  float hauteurYeux = h*((nbc2-nbc1)*2/3.0 + nbc1);
  yeux = yeuxMomie(int(r*2/4.0), int(hauteurYeux), int(r/3.0));
  mom.addChild(yeux);
  
  return mom;
}


private PShape yeuxMomie(int y, int z, int largeur) {
  PShape yeux = createShape(GROUP);
  PShape o1 = oeil(largeur), o2 = oeil(largeur);
  o1.translate(largeur, 0, 0);
  o2.translate(-largeur, 0, 0);
  
  yeux.fill(255, 0, 0);
  yeux.translate(0, -y, z);
  yeux.addChild(o1);
  yeux.addChild(o2);
  
  return yeux;
}

private PShape oeil(int largeur) {
  sphereDetail(6);
  noStroke();
  PShape o = createShape(SPHERE, largeur/2.0);
  o.setFill(color(255, 255, 255));
  o.scale(1, 1, 2/3.0);
  return o;
}

// pour le 2e bras
private int idle2(int idleA) {
  for (int i=0; i<maxIdle/6.0; i++) {
    idleA++;
    if (idleA >= maxIdle) idleA = 0;
  }
  return idleA;
}

// r le rayon maximum de la momie, h la hauteur d'une bandelette
// nbTours le nombre de cercles en hauteur
private PShape cylindreMomie(float r, int h, int nbTours) {
  PShape momie = createShape();
  float MAXJ = 8.0;  // le nb de quads pour 1 bandelette
  float hMargin = h/2.0;
  
  momie.beginShape(QUAD_STRIP);
  momie.noStroke();
  for (int i=0; i<nbTours; i++) {
    float ai = (i)/(float)(nbTours)*PI;  // 1/50e du cylindre, 2/50e du cylindre...
    float multXY = min(1, sin(ai)+0.2);  // plus fin en haut et en bas
    for (int j=0; j<MAXJ; j++) {
      couleurMomie(i, j, momie);
      float aj = j/MAXJ * 2*PI + noise(i, j);
      float hVar = noise(i, j)*h/2.0;
      momie.vertex(cos(aj)*r*multXY, sin(aj)*r*multXY, (i+(j/MAXJ))*h + hVar - hMargin);
      aj = j/MAXJ * 2*PI + noise(i+1/2.0, j);
      momie.vertex(cos(aj)*r*multXY, sin(aj)*r*multXY, (i+(j/MAXJ)+1)*h + hVar + hMargin);
    }
  }
  momie.endShape();
  return momie;
}



private void couleurMomie(int i, int j, PShape momie) {
  float n = noise(i*64 + j);
  momie.fill(160 + n*60, 150 + n*20, 50 + n*10);
}
