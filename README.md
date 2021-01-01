# Ultimate ERS · [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
A realtime iOS game of ERS!

ERS stands for Egpytian Rat Slap (or Rat Screw/other names) and is a pretty fun and challenging card game (if you have really tough opponents, like I did in high school). I built this game as a way to play with friends over quarantine and as a way to hone my skills so they don't grow numb.

The supported multiplayer server is located in the [Ultimate-ERS-Server](https://github.com/kudoichika/Ultimate-ERS-Server) repo.

### Features
- Single player game with 2-4 "AI" opponents that can have a chosen difficulty ranging from 1-5
- Multiplayer 2-player game with realtime competition support using the custom built game server
- Customizable with 13 different kinds of slap pattern rules (Adding some popular home rules)

### GamePlay
- Demo vid in the repo. Will be converted to gif and put here later.
<div align="center">
	<video width="30%" src="https://github.com/kudoichika/Ultimate-ERS/blob/master/ers-demo.mov?raw=true" alt="ERS Demo" autoplay>
</div>

### Technical
- Uses Swift and Apple SpriteKit & UIKit to control gameplay/graphics
- Uses Socket.IO-Swift to communicate with the multiplayer server backend
- Requests to perform basic CRUD and retrieve game history

### License
This project is copyrighted under the [Apache 2.0 License](https://github.com/kudoichika/Ultimate-ERS/blob/master/LICENSE).
