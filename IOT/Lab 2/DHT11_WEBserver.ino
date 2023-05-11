#include <WiFiNINA.h>
#include "DHT.h"

char ssid[] = "iPhone";
char pass[] = "62148723";
int keyIndex = 0;
int status = WL_IDLE_STATUS;
WiFiServer server(80);
WiFiClient client = server.available();

int ledPin = 13;

#define DHTPIN 2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  while (!Serial);

  enable_WiFi();
  connect_WiFi();

  server.begin();
  printWifiStatus();

  dht.begin();
}

void loop() {
  client = server.available();

  if (client) {
    printWEB();
  }
}

void printWifiStatus() {
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI): ");
  Serial.print(rssi);
  Serial.println(" dBm");

  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}

void enable_WiFi() {
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0") {
    Serial.println("Please upgrade the firmware");
  }
}

void connect_WiFi() {
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid, pass);
    delay(10000);
  }
}

void printWEB() {
  if (client) {
    Serial.println("new client");
    String currentLine = "";
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (c == '\n') {
          if (currentLine.length() == 0) {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            float temperature = dht.readTemperature();
            float humidity = dht.readHumidity();

            client.print("Temperature: ");
            client.print(temperature);
            client.println(" °C<br>");
            client.print("Humidity: ");
            client.print(humidity);
            client.println(" %<br>");

            client.println();
            break;
          } else {
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;
        }

        if (currentLine.endsWith("GET /H")) {
          digitalWrite(ledPin, HIGH);
        }
        if (currentLine.endsWith("GET /L")) {
          digitalWrite(ledPin, LOW);
        }
      }
    }
    client.stop();
    Serial.println("client disconnected");
  }
}
