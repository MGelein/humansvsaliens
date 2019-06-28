#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            4
#define NUMPIXELS      12

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "Analog vs Digital";
const char* password = "kaasstengels";

//const char* ssid = "Dollard_2.4GHz";
//const char* password = "ik54j3s94rgq";

int buildinLed = 2;

int lightIndex = 1;

int hue = 65536;
int saturation = 255;

int currentHue = 65536;
int currentSaturation = 255;
int currentBrightness = 255;

int flash = 49152;
bool overtaken = false;

String payload;

bool up = false;

//    Request Timer
unsigned long reqStartMillis;
unsigned long reqCurrentMillis;
const unsigned long reqPeriod = 500;

//    Flash Timer
unsigned long flashStartMillis;
unsigned long flashCurrentMillis;
const unsigned long flashPeriod = 5;
HTTPClient http;  //Declare an object of class HTTPClient

//Amount of failed responses
byte tries = 0;
      


void setup () {
  pinMode(buildinLed, OUTPUT);
  Serial.begin(9600);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting..");
    digitalWrite(buildinLed, HIGH);
  }
  Serial.println("Connected!!");
  digitalWrite(buildinLed, LOW);

  pixels.begin(); // This initializes the NeoPixel library.
  setColorStart();
  http.setTimeout(500);

}

void loop() {
  if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status
    reqCurrentMillis = millis();
    if (reqCurrentMillis - reqStartMillis >= reqPeriod) {
      Serial.print("OPening connection... response: ");
      http.begin("192.168.0.200", 3000, "/lights/" + String(lightIndex) + "/");
      //http.begin("http://192.168.0.200:3000/lights/" + String(lightIndex) + "/");
      int httpCode = http.GET();
      Serial.print(String(httpCode));
      if (httpCode > 0 && httpCode < 300) {
        payload = http.getString();
        tries = 0;//We go a succesfull response
      }else{
        tries++;
        if(tries > 4) ESP.restart();
      }
      http.end();
      Serial.println(".... closing");
      //If the http request took long to process, be sure to set the timestamp to right now, because otherwise it will try to do multiple request in the time that passed
      reqStartMillis = millis();

    }
    setColor(payload);

    if (overtaken == true && currentHue != flash) {
      overtaken = false;
    }
  }

  updatePixels();
  overtakeFlash();
  heartBeat();

  delay(10);
}


//    Sets the color of the pixels
void setColor(String inString) {
  int temp = inString.toFloat() * 1000;
  hue = map(temp, 0, 1000,  65536, 49152);

  //  Serial.print(payload);
  //  Serial.print("\t");
  //  Serial.print(temp);
  //  Serial.print("\t");
  //  Serial.print(currentHue);
  //  Serial.print("\t");
  //  Serial.print(hue);
  //  Serial.print("\t");
  //  Serial.print(checkPos(currentHue, hue));
  //  Serial.print("\t");
//  Serial.print(currentBrightness);
//  Serial.print("\t");
//  Serial.print(currentSaturation);
//  Serial.print("\t");
//  Serial.print(saturation);
//  Serial.print("\t");
//  Serial.print(checkPos(currentSaturation, saturation));
//  Serial.print("\t");
//  Serial.println(overtaken);

  currentHue = currentHue + (checkPos(currentHue, hue) * 32);
}

//    Start color of the pixels
void setColorStart() {
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(0, 0, 255));
    pixels.show();
  }
}

//    Production of the heartbeat (pulsing effect)
void heartBeat() {
  currentBrightness = (sin(millis() / 600.0) * 0.5 + 0.5) * 205 + 50;
}



//    Checking the position in which the
int checkPos(int current, int target) {
  if (current < target) {
    return 1;
  }
  else if (current > target) {
    return -1;
  }
  else {
    return 0;
  }
}

//    Update the pixels with current values
void updatePixels() {
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.ColorHSV(currentHue, currentSaturation, currentBrightness));
    pixels.show();
  }
}

void overtakeFlash() {
  if (currentHue == flash && overtaken == false) {
    Serial.println("FLASH!!!");
    currentBrightness = 255;
    currentSaturation = 0;
    saturation = 0;
    overtaken = true;
  }
  else {
    saturation = 255;
  }
  flashCurrentMillis = millis();
  if (flashCurrentMillis - flashStartMillis >= flashPeriod) {
    currentSaturation = currentSaturation + (checkPos(currentSaturation, saturation));
    flashStartMillis = flashCurrentMillis;
  }
}
