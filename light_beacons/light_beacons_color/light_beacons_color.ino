#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            4
#define NUMPIXELS      12

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "Dollard_2.4GHz";
const char* password = "ik54j3s94rgq";

int buildinLed = 2;

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
    http.begin("http://192.168.178.47:1337");  //Specify request destination
    int httpCode = http.GET();                                                                  //Send the request

    if (httpCode > 0) { //Check the returning code
      String payloadBrightness = http.getString();   //Get the request response payload
      setBright(payloadBrightness);
    }
    http.end();   //Close connection
  }
  delay(1000);    //Send a request every 3 seconds
}

void setBright(String inString) {
  int brightness = 0;
  float value = inString.toFloat();
  value = value * 1000;
  //Serial.println(value);
  brightness = map(value, 0, 1000, 0, 255);
  //Serial.println(brightness);

  pixels.setBrightness(brightness);
  pixels.show();
}

void setColor(String inString) {
  int hue = 0;
  float value = inString.toFloat();
  hue = value * 65536;
  for (int i = 0; i < NUMPIXELS; i++) {
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(i, pixels.ColorHSV(hue); // Moderately bright green color.
                         pixels.show(); // This sends the updated pixel color to the hardware.
  }
}

void setColorStart() {
  for (int i = 0; i < NUMPIXELS; i++) {
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(i, pixels.Color(0, 255, 0); // Moderately bright green color.
                         pixels.show(); // This sends the updated pixel color to the hardware.
  }
}

