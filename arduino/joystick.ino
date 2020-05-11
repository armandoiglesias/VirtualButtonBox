#include <Joystick.h>
#include <SoftwareSerial.h>

SoftwareSerial hc06(8,9);

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

Joystick_ Joystick;

void setup() {
  // Initialize Joystick Library
  Joystick.begin();
  hc06.begin(9600);

  Serial.begin(9600);
  //Serial1.begin(9600);

  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  

  pinMode( 12, INPUT_PULLUP );
  pinMode( 11, INPUT_PULLUP );
  pinMode( 10, INPUT_PULLUP );
  //pinMode(  9, INPUT_PULLUP );
  //pinMode(  8, INPUT_PULLUP );


}

void loop() {
  // Read pin values
  /*
    int currentButtonState = !digitalRead(pinToButtonMap);
    if (currentButtonState != lastButtonState)
    {
    Joystick.setButton(0, currentButtonState);
    lastButtonState = currentButtonState;
    }
  */

  int lectura = analogRead(A0);
  if (lectura < 612 & lectura > 412  ) {
    Joystick.setHatSwitch(0, -1);
  } else {
    if (lectura >= 612) {
      if (lectura < 818) {
        Joystick.setHatSwitch(0, 45);
      } else {
        Joystick.setHatSwitch(0, 0);
      }
    } else if (lectura <= 412) {
      if (lectura > 206) {
        Joystick.setHatSwitch(0, 135);
      } else {
        Joystick.setHatSwitch(0, 180);
      }
    }
  }

  // LUCES PARKING
  if ( !parking &&  digitalRead(parkingLPort) == LOW ) {
    parking = true;
    press('L');
  }

  if ( parking &&  digitalRead(parkingLPort) == HIGH ) {
    parking = false;
    for (int i = 0; i < 2; i++ )
    {
      press('L');
    }
  }
  // **************

  // LUCES BAJAS
  if (  !encendidas && parking && digitalRead(ligthPort) == LOW   ) {
    encendidas = true;
    for (int i = 0; i < 2; i++ )
    {
      press('L');
    }
  }

  if (  encendidas && digitalRead(ligthPort) == HIGH   ) {
    encendidas = false;
    press('L');
  }
  //

  // LUCES ALTAS ***********************************************************
  /*if ( !altas && encendidas &&  digitalRead(HLPort) == LOW ) {
    altas = true;
    press('H');
  }*/
/*
  if ( altas && digitalRead(HLPort) == HIGH ) {
    altas = false;
    press('H');
  }*/
  // ************************************************************************

  //Direccionales
  if ( !izquierda && digitalRead(LLPort) == LOW ) {
    izquierda = true;
    press('<');
  }

  if ( izquierda && digitalRead(LLPort) == HIGH ) {
    izquierda = false;
    press('<');
  }
/*
  if ( !derecha &&  digitalRead(RLPort) == LOW ) {
    derecha = true;
    press('>');
  }*/

/*
  if ( derecha && digitalRead(RLPort) == HIGH ) {
    derecha = false;
    press('>');
  }*/

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
  int button = 10;
  switch (cadena) {
    case 'L':
      Serial.println("Luz Click");
      button = 0;
      break;
    case 'H':
      Serial.println("Luz Alta");
      button = 1;
      break;
    case '>':
      Serial.println("Derecha");
      button = 2;
      break;
    case '<':
      Serial.println("Izquierda");
      button = 3;
      break;
    default:
      Serial.println("default");
      Serial.println(cadena);
      break;

  }
  //Keyboard.press(cadena);
  Joystick.pressButton(button);
  delay(50);
  Joystick.releaseButton(button);
  //Keyboard.releaseAll();


}

// https://www.aranacorp.com/es/comunicacion-con-arduino-y-el-modulo-hc-06/

