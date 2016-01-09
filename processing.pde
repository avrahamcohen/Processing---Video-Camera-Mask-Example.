/*
	Simple processing program.
	This program is listening to a serial port opened by Arduino Uno.

	-----Setup-----
	-We load a background image.
	-We load a movie.
	-We start a camera connection.
	-We start a serial port connection.

	Arduino Uno has a button, every time a button pressed we will do the following:

	-----Flow-----
	Random number is picked.
	-Every time a button is being pressed we save it.
	-If the number of the button has pressed is equal to the random number
	we will start a movie.
	-Else we will show the background image.
	On the bg image you will find an ellipse with the camera input.

	You have here an example how to mask a video and camera.
	Enjoy :)

*/


import processing.serial.*;
import processing.video.*;

// Graphical Variables.
Capture cam;  
PImage img, bg_img;  
PGraphics mask;
Movie movie;

// Settings
int photo_taken = 0;
int ran_num = (int)random(3,10);  

// Timer
int time;

// Serial Port.
Serial myPort;  // Create Object From Serial Class.
int val;  // Data Received From The Serial Port.

void setup() {
	fullScreen();

	// Open serial port.
	myPort = new Serial(this, Serial.list()[2], 9600);

	// Loading background image.
	bg_img = loadImage("data/cloud.jpg");
	bg_img.resize(width, height);

	// Loading movie.
	movie = new Movie(this, "open.mp4"); 
	movie.read();
	movie.frameRate(30);  

	// Camera is ready to capture.
	if (Capture.list().length == 0) {
		println("There are no cameras available for capture.");
	exit();
}

	// Preparing mask for camera i.e ellipse.
	img = createImage(width, height, RGB);
	mask = createGraphics(width, height, JAVA2D);

	// Initialize camera.
	cam = new Capture(this, width, height, 30);
	cam.start(); // In Processing 2.0, you need to start the capture device
}

// This function is being called in loop.
// We had to use if statements to keep it going as we wish.
void draw() {

	if (cam.available() == true) {
	cam.read();
	}      

	if (myPort.available() > 0 ) {
	val = myPort.read();
	}

	// Add a mask to get the camera to show as in a circle.
	mask.beginDraw();
	mask.noStroke();
	mask.ellipseMode(CENTER);
	mask.ellipse(width/2, height/2, width*0.38, height*0.6);
	mask.endDraw();

	// If movie stopped, reset state.
	if (movie.time() == movie.duration()) {
		photo_taken = 0;
		movie.stop();
	}

	// If a number of photo had taken we will start a movie.
	if (photo_taken == ran_num) {
		PImage mov = movie.get(0, 0 ,width, height);
		// For maskig the movie.
		//mov.mask(mask);
		movie.play();
		image(mov, 0, 0, width, height); 
	}  
	// As long as the above didn't happened show background + masked camera.
	else if (photo_taken < ran_num) {
		background(bg_img);
		img.copy(cam, 0, 0, width, height, 0, 0, width, height);
		img.mask(mask);
		image(img, 0 ,0);
	}

	// Sec the timer to the current time.
	time = millis();

	// If button clicked, take a screen shot.
	if (val == 1) {
	int wait = 1000;
	val = 0;

	// Stop the frame for one second, that is we can indentify a photo has taken.
	while (millis() - time < wait);
	if (val == 0) takePhoto();
	}
}

void movieEvent(Movie m) {
m.read();
}

// Saving frame to the current folder.
void takePhoto() {
	photo_taken = photo_taken + 1;

	if(cam.available()) {
		cam.read();
	}
	saveFrame("line-######.png");
}
