# Ultimate ERS Server · [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repo contains the code to the multiplayer server of the [Ultimate-ERS](https://github.com/kudoichika/Ultimate-ERS-Server) game

### Features
- Support CRUD of user accounts and stores their game history
- Supports upto 2 players per game room (rooms are basically unlimited until the server runs out of memory)
- Supports realtime action between client devices (as ERS is a realtime game - gotta get those slaps fast)

### Technical
- The classic JavaScript Node-Express-MongoDB stack for the backend framework
- Uses Socket.IO (with websockets/no pooling) to maintain realtime connection and updates
- Passport.js to simplify authentication
- Other libraries for cookie storage and MongoDB interfacing
- Chalk for some cool colored game/server logs

### License
This project is copyrighted under the [Apache 2.0 License](https://github.com/kudoichika/Ultimate-ERS-Server/blob/master/LICENSE).
