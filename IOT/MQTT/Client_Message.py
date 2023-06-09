import time
import paho.mqtt.client as mqtt

# Global variable to store the received messages
received_messages = []

# Callback function when client receives a message
def on_message(client, userdata, msg):
    global received_messages
    received_messages.append(msg.payload.decode())  # Append the received message to the list

# Create a MQTT client
client = mqtt.Client()

# Set the callback function for message reception
client.on_message = on_message

# Connect to the MQTT broker
broker_address = "localhost"
client.connect(broker_address)

# Subscribe to the topic
topic = "test"
client.subscribe(topic)

# Start the network loop to handle incoming messages
client.loop_start()

# Keep the script running
while True:
    if received_messages:
        print(' '.join(received_messages), end=' ')  # Print the received messages in a single line
        received_messages = []  # Clear the received messages list
        time.sleep(1)  # Delay for one second
    else:
        continue

# Disconnect the client and stop the network loop
client.disconnect()
client.loop_stop()
