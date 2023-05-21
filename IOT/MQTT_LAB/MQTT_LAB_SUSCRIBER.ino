#include <WiFiNINA.h>
#include <ArduinoMqttClient.h>
#include "arduino_secrets.h"

char ssid[] = SECRET_SSID;         // Your network SSID (name)
char pass[] = SECRET_PASS;         // Your network password (use for WPA, or use as key for WEP)

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "test.mosquitto.org";
int port = 1883;
const char topic[] = "real_unique_topic";

#define TEMPERATURE_THRESHOLD 21
#define OUTPUT_PIN 3

void setup() {
  // Initialize serial and wait for the port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for the serial port to connect. Needed for native USB port only
  }

  pinMode(OUTPUT_PIN, OUTPUT);

  // Attempt to connect to the WiFi network:
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // Failed, retry
    Serial.print(".");
    delay(5000);
  }

  Serial.println("You're connected to the network");
  Serial.println();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);

  if (!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());
    while (1);
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();

  mqttClient.onMessage(messageReceived);
  mqttClient.subscribe(topic);
}

void loop() {
  mqttClient.poll();
  // Add your other code here if needed
}

void messageReceived(int messageSize) {
  Serial.println("Received a message!");

  while (mqttClient.available()) {
    String message = mqttClient.readString();
    Serial.print("Received message: ");
    Serial.println(message);

    // Extract temperature value from the message
    if (message.startsWith("Temperature:")) {
      String temperatureString = message.substring(message.indexOf(":") + 2, message.indexOf(" °C"));
      float temperature = temperatureString.toFloat();

      // Check if temperature is greater than the threshold
      if (temperature > TEMPERATURE_THRESHOLD) {
        Serial.println("Temperature is greater than 21°C. Setting output pin HIGH.");
        digitalWrite(OUTPUT_PIN, HIGH);
      } else {
        Serial.println("Temperature is not greater than 21°C.");
        digitalWrite(OUTPUT_PIN, LOW);
      }

      // Wait for data processing to complete before reading new data
      delay(100);
    }
    // Continue processing other sensor values as needed
  }
}
