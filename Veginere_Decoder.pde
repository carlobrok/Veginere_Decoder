/*

MIT License

Copyright (c) 2021 Carlo Brokering

-> For more detail view license file.

*/

String verschluesselt = "";                  // Verschlüsselter text wird hier gespeichert
String fileName = "verschluesselt.txt";      // Vigenere-Text z.B. von hier: https://gc.de/gc/vigenere/

int minLen = 5;
int maxLen = 20;
int displayKeyLen = minLen;

int verteilung[][][] = new int[maxLen-minLen+1][maxLen][26];


void readFile() {
  // Open the file from the createWriter() example
  BufferedReader reader = createReader(fileName);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      verschluesselt += line.replaceAll("[^a-zA-Z]", "");        // alle Zeichen bis auf Buchstaben löschen
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  } 
  verschluesselt = verschluesselt.toLowerCase();      // alle Buchstaben in Kleinbuchstaben, dadurch nur ascii 97 - 122(dec)
} 

void verteilungBerechnen() {
  for(int l = minLen; l <= maxLen; l++) {                        // alle Schlüssellängen von minLen bis maxLen durchgehen
    for(int k = 0; k < verschluesselt.length() / l; k++ ) {      // alle hintereinander stehenden Schlüssel durchgehen
      for(int n = 0; n < l; n++) {                               // die Positionen 0 bis 5 durchgene
        
        // bei l = 5; k = 1; n = 0; -> index 5
        // bei l = 11; k = 1; n = 0; -> index 11
        // bei l = 5; k = 1; n = 3; -> index 8
        
        // k*l + n = index
        
        int charIndex = -97 + (int)verschluesselt.charAt(k*l + n);    // ascii 97 - 122 -> index 0-25
        verteilung[ l-minLen ][n][charIndex]++;
      }
    }
  }
}

void auswertenPlotten() {
  for(int c = 0; c < 26; c++) {
    char x = (char)(c + 97);
    text(x, 52 + 20*c, 50);
  }
  text("Schlüssel", 572, 50);
  
  for(int n = 0; n < displayKeyLen; n++) {      // alle Positionen der Schlüssellänge durchgehen
    int maxPos = 0;
    int maxVal = 0;
    int max2Val = 0;
    int sum = 0;
    
    // Maximum finden
    for(int c = 0; c < 26; c++) {             // die Buchstaben a-z / 0-26 durchgehen
      int value = verteilung[displayKeyLen-minLen][n][c];
      sum += value;
      if(value > maxVal) {
        maxPos = c;
        max2Val = maxVal;
        maxVal = value;
      }
    }
    
    // Plotten
    for(int c = 0; c < 26; c++) {             // die Buchstaben a-z / 0-26 durchgehen
      int value = verteilung[displayKeyLen-minLen][n][c];
      color intensity = color(255,0,0, (float)value/maxVal * 255);
      fill(intensity);                        
      rect(50 + 20*c, 60+20*n, 18, 18);
    }
    
    // bei korrekter Verteilung: 
    // e = 17,40 % 
    // n = 9,78 % 
    
    float maxPerc = (float)maxVal/sum;
    float max2Perc = (float)max2Val/sum; 
    
    // Auswerten
    /*print("  ");
    print(maxPerc);
    print("  ");
    print(max2Perc);*/
    
    if(maxPerc > 0.13 && max2Perc < 0.1 || ( maxPerc > 0.1 && maxPerc - max2Perc > 0.03 )) {
      char offset = char(97 + (26*2 + maxPos - 4) % 26);
      
      color c_confidence = color(0,0,0);
      if(maxPerc > 0.17)
        c_confidence = color(0,255,0);
      else if(maxPerc > 0.15)
        c_confidence = color(50,255,0);
      else if(maxPerc > 0.13)
        c_confidence = color(200,255,0);
      else if(maxPerc > 0.11)
        c_confidence = color(255,255,0);
      else if(maxPerc > 0.1)
        c_confidence = color(255,200,0);
       
      fill(c_confidence);
      text(offset, 572,  75+20*n);
       
        
      //print(" key=" + offset);
    }
    //println();
    
  }
  //println();
}


void setup() {  
  size(1000,500);
  
  textSize(20);
  readFile();
  verteilungBerechnen();
  
}

void draw() {
  clear();
  background(150);
  fill(10);
  text("Graph for key length " + String.valueOf(displayKeyLen) + "  (arrows UP/DOWN)", 10, 20);
  auswertenPlotten();
}

void keyPressed() {
  if(key == CODED) {
    if (keyCode == UP && displayKeyLen < maxLen) {
      displayKeyLen++;
    } else if (keyCode == DOWN && displayKeyLen > minLen) {
      displayKeyLen--;
    } 
  }
}
