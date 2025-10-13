/**
Contient tout ce qui concerne les variables et conditions propres au Joueur
*/


//_______________________________________

// MOUVEMENT

int posX=1, posY=1, dirX=1, dirY=0;

void resetJoueurPos(char[][] lab) {
  posX = 1;
  posY = 1;
  dirX = 1; dirY = 0;
  // pour qu'on regarde pas un mur au début
  if (lab[posX+dirX][posY+dirY] == '#') {dirX = 0; dirY = 1;}
}

boolean isAtExit() {
  return posX == labyrinthe.length-2 && posY == labyrinthe.length-1;
}
boolean isAtEntrance() {
  return posX == 0 && posY == 1;
}


private int anim=0;
private final int tmpAnim = 10;
private int dirXA, dirYA;  // direction précédente, pour pouvoir tourner en avançant

private void avance() {
  anim = tmpAnim;
  dirXA = dirX;
  dirYA = dirY;
  posX = posX+dirX;
  posY = posY+dirY;
}

private boolean peutAvancer() {
  int fx = posX + dirX;
  int fy = posY + dirY;
  return !(outOfBounds(labyrinthe, fx, fy) || labyrinthe[fx][fy] == '#');
}


void keyPressed() {
  if (transitionNiveau) return;
  if (keyCode == UP) {
    if (noClip || peutAvancer() || isAtExit())
      avance();
    if (isAtExit()) transitionNiveau = true;
  }
  if (keyCode == LEFT) {
    int tmp = dirX;
    dirX = dirY;
    dirY = -tmp;
  }
  if (keyCode == RIGHT) {
    int tmp = dirX;
    dirX = -dirY;
    dirY = tmp;
  }
  if (keyCode == SHIFT) {
    cameraShift = !cameraShift;
  }
  if (keyCode == ENTER) {
    ecranTitre = false;
    isOutside = !isOutside;
  }
}


//______________________________________

// VISION DU JOUEUR

boolean[][] hasSeen;
boolean[][] hasBeen;

void resetHasSeenHasBeen(char[][] l) {
  hasSeen = new boolean[l.length][l[0].length];
  hasBeen = new boolean[l.length][l[0].length];
}

void updateHasSeen(boolean[][] current) {
  if (!hasBeen[posX][posY])
    for (int i=0; i<current.length; i++)
      for (int j=0; j<current[0].length; j++)
        if (current[i][j]) hasSeen[i][j] = true;
  updateHasBeen();
}

void updateHasBeen() {
  hasBeen[posX][posY] = true;
}


boolean[][] currentVision(char[][] lab) {
  boolean[][] voit = new boolean[lab.length][lab.length];
  
  // en haut et en bas
  for (int i = posX; i < lab.length; i++) {
    updateVision(i, posY, voit, true);
    if (outOfBounds(lab, i, posY) || lab[i][posY] == '#') break;
  }
  for (int i = posX; i >= 0; i--) {
    updateVision(i, posY, voit, true);
    if (outOfBounds(lab, i, posY) || lab[i][posY] == '#') break;
  }
  // à droite et à gauche
  for (int j = posY; j < lab[0].length; j++) {
    updateVision(posX, j, voit, false);
    if (outOfBounds(lab, posX, j) || lab[posX][j] == '#') break;
  }
  for (int j = posY; j >= 0; j--) {
    updateVision(posX, j, voit, false);
    if (outOfBounds(lab, posX, j) || lab[posX][j] == '#') break;
  }
  return voit;
}

private void updateVision(int i, int j, boolean[][] voit, boolean vertical) {
  if (vertical) {
    voit[i][j] = true; 
    if (j+1 < voit[0].length) voit[i][j+1] = true; 
    if (j-1 >= 0) voit[i][j-1] = true;
  }
  else {
    voit[i][j] = true; 
    if (i+1 < voit.length) voit[i+1][j] = true; 
    if (i-1 >= 0) voit[i-1][j] = true;
  }
}
