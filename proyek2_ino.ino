#include <SoftwareSerial.h>
  
  // motor A
int enA = 11;
int in1 = 13;    //////////
int in2 = 12;
  // motor B
int enB = 10;
int in3 = 9;
int in4 = 8;

int motorSpeed=200;
  
  // led
int led[]={5,3,4,7}; //////////////

int data = 0;
int val;

SoftwareSerial mySerial(A0, A1); // RX, TX

void setup() {
  // Open serial communications and wait for port to open
  // set the data rate for the SoftwareSerial port
  //  mySerial.begin(9600);             // Untuk Serial Bluetooth
  Serial.begin(9600);                 // Untuk Serial Biasa
  for(int i=0; i<4; i++){
    pinMode(led[i], OUTPUT);
  }
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
}

//  #################### FUNGSI INDIKATOR LED #####################
void ledMaju(){
  digitalWrite(led[0], 1);
  digitalWrite(led[1], 0);
  digitalWrite(led[2], 0);
  digitalWrite(led[3], 0);
}
void ledKanan(){
  digitalWrite(led[0], 0);
  digitalWrite(led[1], 0);
  digitalWrite(led[2], 1);
  digitalWrite(led[3], 0);
}
void ledKiri(){
  digitalWrite(led[0], 0);
  digitalWrite(led[1], 1);
  digitalWrite(led[2], 0);
  digitalWrite(led[3], 0);
}
void ledMundur(){
  digitalWrite(led[0], 0);
  digitalWrite(led[1], 0);
  digitalWrite(led[2], 0);
  digitalWrite(led[3], 1);
}
void ledMati(){
  digitalWrite(led[0], 0);
  digitalWrite(led[1], 0);
  digitalWrite(led[2], 0);
  digitalWrite(led[3], 0);
}

//  ####################################################################
//  #################### FUNGSI AKTIVITAS MOTOR DC #####################
void maju(){
    // Menyalakan motor A & B(maju)
    digitalWrite(in1, LOW);
    digitalWrite(in2, HIGH);
    digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
    // set kecepatan
    analogWrite(enA, motorSpeed);
    analogWrite(enB, motorSpeed);   
    ledMaju();
}

void kanan(){
    // Menyalakan motor A
    digitalWrite(in1, LOW);
    digitalWrite(in2, HIGH);
    // Mematikan motor B
    digitalWrite(in3, LOW);
    digitalWrite(in4, LOW);  
    // set speed motor dc
    analogWrite(enB, motorSpeed);
    ledKiri();
}

void kiri(){
    // Mematikan motor A
    digitalWrite(in1, LOW);
    digitalWrite(in2, LOW);  
    // Menyalakan motor B
    digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
    // set speed motor dc
    analogWrite(enA, motorSpeed);
    ledKanan();
}

void mundur(){
    // Menyalakan motor A & B (mundur)
    digitalWrite(in1, HIGH);
    digitalWrite(in2, LOW);
    digitalWrite(in3, LOW);
    digitalWrite(in4, HIGH);
    // set kecepatan
    analogWrite(enA, motorSpeed);
    analogWrite(enB, motorSpeed);
    ledMundur();
}

void berhenti(){
  // Mematikan A & motor B
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);
  ledMati();
}


void loop()
{
  // PERHATIKAN DATA YANG DIKIRIM DARI MANA? 
  // PAKAI "Serial" JIKA DARI ARDUINO BIASA
  // PAKAI "mySerial" JIKA DARI BLUETOOTH
  if (Serial.available() > 0) 
  {
    int data = Serial.read(); // MEMBACA DATA YANG DIKIRIM, DALAM HAL INI DARI PROCESSING
    if (data == 'W') {        // MAJU
      motorSpeed += 1;
      maju();      
      val = 1;
    }
    
    if (data == 'D') {        // KANAN
      motorSpeed += 1;
      kanan();      
      val = 2;
    }
    
    if (data == 'A') {        // KIRI
      motorSpeed += 1;
      kiri();      
      val = 3;
    }
    
   if (data == 'S') {         // MUNDUR
      motorSpeed += 1;
      mundur();      
      val = 4;
    }
    
   if (data == 'X') {         //STOP
      motorSpeed = 0;
      berhenti();
   }
   
// #####################  UNTUK MENGURANGI KECEPATAN MOTOR
   if (data == 'Z') {     //Mengurangi Nilai Kecepatan
      if(val == 1){
        motorSpeed -= 1;
        maju();
      }
      if(val == 2){
        motorSpeed -= 1;
        kanan();
      }
      if(val == 3){
        motorSpeed -= 1;
        kiri();
      }
      if(val == 4){
        motorSpeed -= 1;
        mundur();
      }
    }
    
   if (data == 'Q') {   
      motorSpeed -= 1;
    }
  }
}


