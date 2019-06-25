#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            4
#define NUMPIXELS      12

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "interwebs";
const char* password = "Wachtwoord";

//const char* ssid = "Dollard_2.4GHz";
//const char* password = "ik54j3s94rgq";

int buildinLed = 2;

int lightIndex = 1;

int heartRate = 1;
int heartMax = 254;
int heartMin = 50;

int hue = 49152;
int saturation = 255;
int brightness = 255;

int currentHue = 49152;
int currentSaturation = 255;
int currentBrightness = 255;

int flash = 65536;

String payload;

bool up = false;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 5;

void setup () {
  pinMode(buildinLed, OUTPUT);
  Serial.begin(115200);
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
}

void loop() {

  if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status
    HTTPClient http;  //Declare an object of class HTTPClient
    http.begin("http://192.168.43.67:3000/lights/" + String(lightIndex));
    int httpCode = http.GET();

    if (httpCode > 0) {
      payload = http.getString();
    }
    http.end();
  }
  setColor(payload);
  updatePixels();
  heartBeat();
  delay(100);
}

//    Sets the color of the pixels
void setColor(String inString) {
  int temp = inString.toFloat() * 1000;
  hue = map(temp, 0, 1000, 49152, 65536);

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
  //  Serial.println(currentBrightness);

  currentHue = currentHue + (checkPos(currentHue, hue) * 128);
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
  currentMillis = millis();  //get the current "time" (actually the number of milliseconds since the program started)
  if (currentMillis - startMillis >= period)  //test whether the period has elapsed
  {
    if (up == false) {
      currentBrightness --;
    }
    if (up == true) {
      currentBrightness ++;
    }
    if (currentBrightness == heartMin) {
      up = true;
    }
    if (currentBrightness == heartMax) {
      up = false;
    }
    startMillis = currentMillis;  //IMPORTANT to save the start time of the current LED state.
  }
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


