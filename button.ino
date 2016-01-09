// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
	// Led is in W mode.
	pinMode(ledPin, OUTPUT);
	// Led is not turn off.
	digitalWrite(ledPin, HIGH);

	// Button is in RW mode.
	pinMode(buttonPin, INPUT);
	// Button is released.
	digitalWrite(buttonPin, HIGH);

	// Start serial connection.
	Serial.begin(9600);
	// Flushing the serial port.
	Serial.flush();
}

void loop() {
	// Read button state.
	buttonState = digitalRead(buttonPin);

	// While button is pressed !!!
	if (buttonState == LOW) {
	// Turn led off.
	digitalWrite(ledPin, LOW);
	// Write '1' to serial port.
	// We will listening in another process.
	Serial.write((char)1);
	// Create delay to not to flood the port.
	delay(100);
	}
	// Led is on.
	digitalWrite(ledPin, HIGH);
}
