# First Flight
Tommy Scheper
tdscheper@gmail.com

My final project for Harvard's edX CS50G course is a remake of the iOS game, Tiny Wings. 

Note: This project was completed in August of 2020. I first uploaded it publicly to my personal GitHub in May of 2021. It runs on LOVE2D version 0.10.2 (because that's what the class required).

Tiny Wings was created by Andreas Illiger and made its debut on the App Store in 2011. It surged to the top of the App Store charts when Apple featured the app in one of its Keynotes. In the game, the user controls a bird's flight, which is determined by how well the user utilizes the hills to launch the bird into the air. The game is a race against time, as it ends when the sun sets in the game.

First Flight is a penguin/winter themed remake of Tiny Wings. When the user boots up the game, they are taken to the start screen where they are greeted by a waving penguin. The penguin is standing on a snowy hill, with snow falling in the background from the clouds above. Two buttons also appear: a play button, and a high scores button. If the user presses on the high scores button, they are taken to a screen with up to 15 of the device's highest scores. They can then press the back button on this screen to go back to the start screen. When the user hits the play button, the penguin gets into his sliding position. It is ready to fly for the first time. It is the user's job to control the penguin so that it can optimally "fly." They effectively apply a downward (and slightly rightward) force on the penguin. If the user applies this force and has the penguin slide down the right end of a hill and then lets go as it makes its way up the left side of the next hill, the penguin naturally (from BOX2D) gains speed and altitude. The penguin always advances through the terrain; it never slides backwards down a hill. This is done by giving it a minimum velocity. As time goes by, the sky gets darker. Some daylight can be recovered, however, by getting the penguin to reach the altitude of the clouds or completing the level. Each level is its own new terrain, or island. When the penguin flies past the last hill, it flies to the next level. Eventually, the night will come and the game will end. The user's score is shown, as well as the duration of the game and how many times the penguin touched the clouds. The user may then return to the start screen by pressing the back button.

Listed are some of the key features of First Flight:
* Four game states: a start state, the play state, a game over state, and a high score state. The penguin (bird) also has three states of its own: a sliding state, waving state, and sitting state.
* Cohesive start-to-finish experience for the user: the user gets booted into the start screen of the game, where they can then opt to play the game or view high scores. If they choose the high scores option, they can return to the start screen by hitting the back button (GUI feature). If they choose to play the game, once it's over, they can return to the start screen again. Also, at any time, they can hit escape to quit the game, or close it like anything else on their device.
* There is definitive scoring in the game. The game ends when the night comes, which is when the game timer hits zero. Scoring is determined by how many hills the user passes, how many times the user completes a level, the duration of the game, and how many times the penguin touches the clouds.
* The utilization of BOX2D.
   * The hilly terrain. This was not easy, as each hill is made up if tiny line segments to depict smooth curves.
* Procedural generation. The game consists of levels with terrains of different sizes, depending on the level. Each hill in each terrain has its shape randomly chosen.
* The utilization of a shader, used primarily to turn the background sky from light to dark blue, to simulate day and night.
* Somewhat-complex GUI features.
   * Horizontal and vertical alignment, most significantly used in displaying the high scores.
   * Buttons, used to navigate through game states.
   * A unique bar showing how much daylight is left in the game.
* Keyboard, mouse, and touch screen functionality.
* Clean code.

For now, I'm pleased with the game I made. I may implement more features on my own time in the future.

Thank you Harvard for giving me this opportunity to learn about game development and make my own game. It was a lot of fun and it kept me busy throughout quarantine!
