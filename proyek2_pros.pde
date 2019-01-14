import processing.serial.*; //Import Serial library
import controlP5.*;

Serial myPort;
ControlP5 cp5;
controlP5.Button b;
bouncyWordJudul judul_;
PFont fontJudul;
        
        // INISIALISASI UNTUK SPEEDOMETER
PImage jarum, background, speedo, judul;
PImage UP_, RIGHT_, LEFT_, DOWN_, setUP, setRIGHT, setLEFT, setDOWN, pens;
int rec_x=355, rec_y=640, rec_height=10, z1=200;  
        
        // INISIALISASI LAIN
int w, indikator;
int buttonValue = 1;
float angle;
boolean isOpen;
        
        // INISIALISASI UNTUK WAKTU
String[] dayName = 
{
  "MIN", "SEN", "SEL", "RAB", "KAM", "JUM", "SAB" 
};

String[] monthName = 
{ 
  "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", 
  "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
};

int hari = day();
int bulan = month();
int tahun = year();

void setup() {
//  PASTIKAN COM SERIAL TERBACA DAN TERHUBUNG DULU
//  RUN TANPA TERHUBUNG PORT SERIAL AKAN ERROR
  myPort = new Serial(this, "COM3", 9600); 
  size(1300, 720);
  stroke(255);
  smooth();
          //******** MEMBUKA SEMUA DATA FOTO DARI FILE ********//
  background = loadImage("background.png");
  jarum = loadImage("JARUM.png");
  speedo = loadImage("speedo.png");
  UP_ = loadImage("_atas.png");
  RIGHT_ = loadImage("_kanan.png");
  LEFT_ = loadImage("_kiri.png");
  DOWN_ = loadImage("_bawah.png");
  setUP = loadImage("up.png");
  setRIGHT = loadImage("right.png");
  setLEFT = loadImage("left.png");
  setDOWN = loadImage("down.png");
  pens = loadImage("pens.png");

          //  BUTTON UNTUK OPEN/HIDE PHOTO
  cp5 = new ControlP5(this);
  cp5.addButton("button")
    .setPosition(width-100, 20)
      .setSize(60, 20)
        ;

  b = cp5.addButton("buttonValue")
    .setPosition(0, 400)
      .setImages(loadImage("foto.png"), loadImage("foto.png"), loadImage("foto.png"))      // FOTO BARENG
//      .setImages(loadImage("fot.png"), loadImage("fot.png"), loadImage("fot.png"))      // FOTOKU
        ;
  cp5.getController("button")
    .getCaptionLabel()
      .setSize(20)
        ;
  b.getCaptionLabel()
    .toUpperCase(false)
      ;
      
        //  LOAD FONT UNTUK JUDUL
  fontJudul = loadFont("Blanka-Regular-46.vlw");
  textFont(fontJudul);
  judul_ = new bouncyWordJudul("", -3, 300, 50);
}

void draw() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  judul_.draw();
  
  image(loadImage("up_.png"), 1030, 420, 135, 64);
  image(loadImage("right_.png"), 1165, 485, 64, 135);
  image(loadImage("left_.png"), 965, 485, 64, 135);
  image(loadImage("down_.png"), 1030, 620, 135, 64);
  image(speedo, 220, 55, 865, 655);
  
  // CLOCK FUNCTION
  int s = second();   
  int m = minute();  
  int h = hour(); 
  fill(250, 250, 250);
  textFont(loadFont("Digital-7Italic-48.vlw"));
  textSize(52);
  textAlign(LEFT);
  text(h + ":" + m + ":" + s, 290, 250);
  textAlign(CENTER);
  textSize(40);
  text(dayName[3],  905, 225);          // Pengaturan Hari Manual
  textSize(32);
  text(monthName[bulan-1],  970, 175);  // CETAK BULAN
  textSize(40);
  text(tahun,  970, 260);                // CETAK TAHUN
  textSize(74);
  text(hari,  970, 230);                // CETAK HARI

  // TO SHOW/HIDE PHOTO
  float x = b.x(b.getPosition());
  x += ((isOpen==true ? 0:-380) - x) * 0.5;
  ;
  float y = b.y(b.getPosition());
  b.setPosition(x, y);

  //  INDIKATOR ARAH MOTOR
  if (indikator==1) {
    ellipse(1100, 550,100,100);
    image(UP_, 1030, 485, 134, 134);
  }
  if (indikator==2) {
    ellipse(1100, 550,100,100);
    image(RIGHT_, 1030, 485, 134, 134);
  }
  if (indikator==3) {
    ellipse(1100, 550,100,100);
    image(LEFT_, 1030, 485, 134, 134);
  }
  if (indikator==4) {
    ellipse(1100, 550,100,100);
    image(DOWN_, 1030, 485, 134, 134);
  }
  if (indikator==5) {
    image(pens, 1030, 485, 134, 134);
  }

  speedo();
}

//******************  KONTROL ARAH DAN KECEPATAN MOTOR  ****************//
void keyPressed() {
  imageMode(CORNER);
  if (key == CODED) {
    if (keyCode == UP) {   
      image(setUP, 1030, 420, 135, 64);
      println("MAJU");      
      indikator=1;
      if (z1>=0 && z1<=254) {
        z1++;      
        myPort.write('W');
      } else if (z1==255) {
        z1 = 254;  
        myPort.write('Q');
      }
    }
    
    if (keyCode == RIGHT) {  
      image(setRIGHT, 1165, 485, 64, 135);
      println("KANAN");      
      indikator=2;
      if (z1>=0 && z1<=254) {
        z1++;      
        myPort.write('D');
      } else if (z1==255) {
        z1 = 254;  
        myPort.write('Q');
      }
    }
    
    if (keyCode == LEFT) { 
      image(setLEFT, 965, 485, 64, 135);
      println("KIRI");      
      indikator=3;
      if (z1>=0 && z1<=254) {
        z1++;      
        myPort.write('A');
      } else if (z1==255) {
        z1 = 254;  
        myPort.write('Q');
      }
    }
    
    
    if (keyCode == DOWN) {
      image(setDOWN, 1030, 620, 135, 64);
      println("MUNDUR");      
      indikator=4;
      if (z1>=0 && z1<=254) {
        z1++;      
        myPort.write('S');
      } else if (z1==255) {
        z1 = 254;  
        myPort.write('Q');
      }
    }
  }
  
  if (key == 'z') {
    println("REM.....");
    if (z1>0 && z1<=256) {
      z1--;      
      myPort.write('Z');
    }
    if (0==z1) {
      z1 = 0;
    }
  }

  if (key == 'x') {  
    println("STOP");       
    indikator=5;
    z1 = 0;      
    myPort.write('X');
  }
}

//*********************** MENGATUR PERPUTARAN JARUM SPEEDO  ***********************//
void speedo() { 
  imageMode(CENTER);  
  textAlign(CENTER);
  pushMatrix();
  translate(667, 435);
  angle = map(z1, 0, 255, 39.5, 79);
  rotate(angle*0.1);
  tint(255, 0, 0); 
  image(jarum, 0, 0, 555, 555);
  noTint();
  popMatrix();
  textSize(68);
  fill(255, 255, 255);
  text(z1, 750, 540);
}

// Show Hide Photo
public void button(float theValue) {
  isOpen = !isOpen;
  cp5.getController("button").setCaptionLabel((isOpen==true) ? "hide":"show");
}

// d = Hari dalam sebulan (Senin ..... Minggu)
// m = Bulan (January = 1 : December = 12)
// y = 4 digit Tahun
// Returns 0 = Minggu .. 6 = Sabtu
public int date(int d, int m, int y) {
  if (m < 3) {
    m += 12;
    y--;
  }
  return (d + int((m+1)*2.6) +  y + int(y/4) + 6*int(y/100) + int(y/400) + 6) % 7;
}

// RUNNING TEXT JUDUL
class bouncyWordJudul {
  float px, py, vx, vy, ypos;
  bouncyWordJudul(String theWord, float ivx, float ipx, float ipy) {
    py=ipy;
    vy=0;
    vx=ivx;
    px=ipx;
    frameRate(300);
    smooth();
  }
  void draw() {
    px+=vx;
    py+=vy;
    if (px<550) {
      px=550;
      vx=-vx;
    }
    if (px>700) {
      px=700;
      vx=-vx;
    }
  textFont(fontJudul);
  text("Microprocessor & Interface 2 Project", px, py);
  }
}
