# SPVideoPlayer
Sample demo how to use AVVideoPlayer and add custom media tool bar. Project is in progress. 

Customer wanted a custom tool bar for video player. Not the built in player controller. So here we are.
This demo shows how to work with AVPlayer in swift.
I've looked through the Apple official demo written in objC and got upset about absence of swift example.
The more i write code in Swift the more i like it. So, take a look at this demo if you're looking for examples of how to create custom players.

This code includes:
* custom tool bar;
* transition from landscape to portrait and back;
* list of videos to play in a row and ability to easily switch from one video to another;

P.S. I gave standard apple test videos, so try something else. This code is working with one of the projects i've taken part in, so it should be working.
Feel free to contact me if you find any mistake or you have some thoughts about how to make it better. 
P.P.S. I don't use storyboards because:

required init?(coder aDecoder: NSCoder) {
	fatalError("storyboards are incompatible with truth and beauty")
}

(c) Async Kit developers team


