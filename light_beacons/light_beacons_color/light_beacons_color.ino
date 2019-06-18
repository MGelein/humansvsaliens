#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            4
#define NUMPIXELS      8

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "interwebs";
const char* password = "Wachtwoord";

//const char* ssid = "Dollard_2.4GHz";
//const char* password = "ik54j3s94rgq";

int buildinLed = 2;

int hue = 65536;
int saturation = 255;
int brightness = 255;

int currentHue = 65536;
int currentSaturation = 255;
int currentBrightness = 255;

float data[2];

String payload1, payload2, payload3;

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
    HTTPClient http1, http2, http3;  //Declare an object of class HTTPClient
    http1.begin("http://192.168.43.67:1001");
    http2.begin("http://192.168.43.67:1002");
    http3.begin("http://192.168.43.67:1003");
    int httpCode1 = http1.GET();
    int httpCode2 = http2.GET();
    int httpCode3 = http3.GET();
    if (httpCode1 > 0) {
      payload1 = http1.getString();
    }
    if (httpCode2 > 0) {
      payload2 = http2.getString();
    }
    if (httpCode3 > 0) {
      payload3 = http3.getString();
    }
    http1.end();
    http2.end();
    http3.end();
  }
  setColor(payload1, payload2, payload3);
  delay(10);
}

void setColor(String inString1, String inString2, String inString3) {
  //  char charBuffer[100];
  //  inString.toCharArray(charBuffer, 100);
  //  char* comma;
  //  comma = strtok(charBuffer, ",");
  //
  //  while (comma != NULL) {
  //    int i = 0;
  //    comma = strtok(NULL, ",");
  //    data[i] = atof(comma);
  //    i++;
  //  }

  //    Serial.print(data[0]);
  //    Serial.print("\t");
  //    Serial.print(data[1]);
  //    Serial.print("\t");
  //    Serial.println(data[2]);


  hue = inString1.toFloat() * 65536;
  saturation = inString2.toFloat() * 255;
  brightness = inString3.toFloat() * 255;
  //  hue = inHue * 65536;
  //  saturation = inSaturation * 255;
  //  brightness = inBrightness * 255;

  //    Serial.print(hue);
  //    Serial.print("\t");
  //    Serial.print(saturation);
  //    Serial.print("\t");
  //    Serial.println(brightness);

  Serial.print(payload1);
  Serial.print("\t");
  Serial.print(payload2);
  Serial.print("\t");
  Serial.print(payload3);
  Serial.print("\t");

  Serial.print(currentHue);
  Serial.print("\t");
  Serial.print(hue);
  Serial.print("\t");
  Serial.print(checkPos(currentHue, hue));
  Serial.print("\t");

  Serial.print(currentSaturation);
  Serial.print("\t");
  Serial.print(saturation);
  Serial.print("\t");
  Serial.print(checkPos(currentSaturation, saturation));
  Serial.print("\t");

  Serial.print(currentBrightness);
  Serial.print("\t");
  Serial.print(brightness);
  Serial.print("\t");
  Serial.print(checkPos(currentBrightness, brightness));
  Serial.println("\t");


  currentHue = currentHue + (checkPos(currentHue, hue) * 100);
  currentSaturation = currentSaturation + checkPos(currentSaturation, saturation);
  currentBrightness = currentBrightness + checkPos(currentBrightness, brightness);

  for (int i = 0; i < NUMPIXELS; i++) {
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(i, pixels.ColorHSV(currentHue, currentSaturation, currentBrightness)); // Moderately bright green color.
    pixels.show(); // This sends the updated pixel color to the hardware.
  }
}

void setColorStart() {
  for (int i = 0; i < NUMPIXELS; i++) {
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(i, pixels.Color(0, 0, 255)); // Moderately bright green color.
    pixels.show(); // This sends the updated pixel color to the hardware.
  }
}

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


