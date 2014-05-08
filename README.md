COREMA
======
This app is built for an apple iPad, below I have described the structure, Usage and API used.

Structure
	
The app has two major screens and three functionalities. The two screens are handled by two viewcontrollers, namely FistViewController and SecondViewController. The three functionalities of this app are,
	1.	Remote utility: This is responsible to firstly contact the dropbox server to download the relevant questionnaire file and also responsible for sending the JSON object to the central database. This module is handled inside FirstViewController.
	2.	Local Utility: This is responsible to save the user’s settings namely the id and mealtimes in the user defaults so that it can be fetched whenever needed. This is handled inside SecondViewController.
	3.	Core Logic: This is responsible for Checking the timing of the day and setting which file to be downloaded. This is also responsible to parse the file and display the questionnaires on the screen. This module also makes sure that all the questions are answered completely. This functionality is also handled by FIrstViewController.

Apart from the two viewControllers there is one more class called QnA, which stores a basic structure of a question, saving the question, options and category of the question.
	
Usage:
clone the repository to your local drive and run the project file using Xcode. This project was built using Xcode 5.1 targeting iOS 7.

You can either wish to run the application on the simulator or a any iOS 7 iPad.

Once executed, go to the settings tab and save your settings.

Since this was a custom app, you would need a valid patient ID to make this app work properly

once the settings are saved, based on the timing of the day, questionnaires will be displayed.

API

We have used AFNetworking library for our REST services
https://github.com/AFNetworking/AFNetworking

Contact: 
Vijith Venkatesh
Vij2288@gmail.com
vvankate@andrew.cmu.edu
