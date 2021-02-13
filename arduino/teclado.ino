#include <Keyboard.h>

#include <SoftwareSerial.h>
SoftwareSerial hc06(8, 9);

#define START_CMD_CHAR '*'
#define END_CMD_CHAR '#'
#define DIV_CMD_CHAR '|'
#define CMD_DIGITALWRITE 10
#define CMD_ANALOGWRITE 11
#define CMD_TEXT 32
#define CMD_READ_ARDUDROID 13
#define MAX_COMMAND 20  // max command number code. used for error checking.
#define MIN_COMMAND 10  // minimum command number code. used for error checking. 
#define IN_STRING_LENGHT 40
#define MAX_ANALOGWRITE 255

String inText;

char ctrlKey = KEY_LEFT_CTRL;
char altKey = KEY_LEFT_ALT;
char shiftKey = KEY_LEFT_SHIFT;

bool izquierda = false;
bool derecha = false;
bool encendidas = false;
bool parking = false;
bool altas = false;

int parkingLPort  = 12; 
int ligthPort  = 11;
int LLPort  = 10;
//int RLPort  = 9;
//int HLPort  = 8;

//Joystick_ Joystick;

void setup() {
  // Initialize Joystick Library
  //Joystick.begin();
  Keyboard.begin();
  
  hc06.begin(9600);

  Serial.begin(9600);
  //Serial1.begin(9600);

  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


}

void loop() {
  char ard_command = ' ';
  int pin_num = 0;
  int pin_value = 0;

  String cmd = "";

  if (hc06.available() > 4 ){

    char c = hc06.read();
    if( c != START_CMD_CHAR  ){
      return;
    }

    //Serial.println(c);

    ard_command = hc06.read(); // Leemos la orden
    hc06.read();     // Leemos el pin
    hc06.read();   // Leemos valor
    
    Serial.println(ard_command);
    if( ard_command == ' ' ){
      c = hc06.read();
      while ( c != END_CMD_CHAR )            //Hasta que el caracter sea END_CMD_CHAR
      {
        cmd += c;
        c = hc06.read();  
        //Serial.println(c);
      }
      delay(25);
      //Serial.println(cmd);

      if(cmd == "")
        return;

      press(cmd.charAt(0));
  
    }    
  }
    
}

void press(char cadena ) {

  Keyboard.press(ctrlKey);
  Keyboard.press(altKey);
  Keyboard.press(shiftKey);
  Keyboard.press(cadena);
  delay(100);
  Keyboard.releaseAll();

}


