/**

toutes les fonctions utilisées pour initialiser les labyrinthes

*/

// MISC

boolean outOfBounds(char[][] lab, int i, int j) {
  return i < 0 || j < 0 || i >= lab.length || j >= lab[0].length;
}



// créé et renvoie un tableau de NB_LAB labyrinthes
char[][][] initTabLab() {
  char[][][] tabL = new char[NB_LAB][][];
  for (int k = 0; k < NB_LAB; k++) {
    int size = LAB_SIZE +10 - k*2;
    tabL[k] = createLab(size);
  }
  return tabL;
}


// créé et renvoie un nouveau labyrinthe de taille k généré aléatoirement
// (copie du code dans setup() )
private char [][] createLab(int k) {
  char labyrinthe [][] = new char[k][k];
  int todig = 0;
  for (int j=0; j<k; j++) {
    for (int i=0; i<k; i++) {
      if (j%2==1 && i%2==1) {
        labyrinthe[j][i] = '.';
        todig ++;
      } else
        labyrinthe[j][i] = '#';
    }
  }
  int gx = 1;
  int gy = 1;
  while (todig>0 ) {
    int oldgx = gx;
    int oldgy = gy;
    int alea = floor(random(0, 4)); // selon un tirage aleatoire
    if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
    else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
    else if (alea==2 && gx<k-2) gx += 2; // .. va a droite
    else if (alea==3 && gy<k-2) gy += 2; // .. va en bas

    if (labyrinthe[gy][gx] == '.') {
      todig--;
      labyrinthe[gy][gx] = ' ';
      labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
    }
  }

  labyrinthe[0][1]     = ' '; // entree
  labyrinthe[k-2][k-1] = ' '; // sortie

  return labyrinthe;
}


// créé et renvoie un tableau des sides correspondant à tabLab
// (copie du code dans setup() )
char[][][][] initSides(char[][][] tabL) {
  char[][][][] tabS = new char[NB_LAB][][][];
  
  for (int nbL = 0; nbL<NB_LAB; nbL++) {
    char[][] lab = tabL[nbL];
    char[][][] side= new char[lab.length][lab[0].length][4];
  
    for (int j=1; j < lab.length-1; j++) {
      for (int i=1; i < lab.length-1; i++) {
        if (lab[j][i]==' ') {
          if (lab[j-1][i]=='#' && lab[j+1][i]==' ' && lab[j][i-1]=='#' && lab[j][i+1]=='#')
            side[j-1][i][0] = 1;// c'est un bout de couloir vers le haut
          if (lab[j-1][i]==' ' && lab[j+1][i]=='#' && lab[j][i-1]=='#' && lab[j][i+1]=='#')
            side[j+1][i][3] = 1;// c'est un bout de couloir vers le bas
          if (lab[j-1][i]=='#' && lab[j+1][i]=='#' && lab[j][i-1]==' ' && lab[j][i+1]=='#')
            side[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
          if (lab[j-1][i]=='#' && lab[j+1][i]=='#' && lab[j][i-1]=='#' && lab[j][i+1]==' ')
            side[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
        }
      }
    }
    
    tabS[nbL] = side; 
  }
  return tabS;
  
}
