# Frontline

![Godot](https://img.shields.io/badge/Godot-4.x-478cbf?logo=godot-engine&logoColor=white)
![GDScript](https://img.shields.io/badge/Language-GDScript-355570)
![License](https://img.shields.io/badge/License-See%20LICENSE-lightgrey)

A simple and intuitive 2D tower defense game built around surviving increasingly difficult enemy waves through strategic tower placement and resource management.

## About the game

In *Frontline* your objective is to defend your base against waves of enemies by placing towers around the map.

The game features:
- 20 progressively harder waves
- Multiple tower types
- Enemy resistances
- Economy management
- A final boss fight
- Simple and beginner-friendly gameplay

After surviving all 20 waves you must defeat the final boss with *50,000 HP* to complete the game.

## Features

- Classic 2D tower defense gameplay
- Easy to learn gameplay
- Different enemy types
- Multiple tower types with unique strengths
- Wave-based progression system
- Boss fight after completing all waves

## Screenshots

### Main menu

<img width="960" height="540" alt="image" src="https://github.com/user-attachments/assets/2c27673e-c8b5-4def-aa7a-b2a57cb0ae2b" />

### Gameplay

<img width="960" height="540" alt="image" src="https://github.com/user-attachments/assets/54409eb1-b860-456e-b6b4-b57e7ae6ead4" />

### Shop menu

<img width="201" height="866" alt="image" src="https://github.com/user-attachments/assets/11436020-3fdd-4b98-a552-4ffea5110c43" />

## Gameplay overview

### Waves

The game contains 20 waves.

Each wave increases in difficulty and introduces stronger enemy pressure.

After wave 20 the boss fight begins.

### Towers

You can purchase towers through the shop menu and place them around the map.

Some important towers:
- *Tower* — cheap and reliable basic defense tower
- *Sniper Tower* — high damage long-range tower
- *Money factory* — generates additional income

### Enemy resistances

Some enemies resist certain towers:
- *Strong (Tractor)* receives only 50% damage from the *Tower*
- *Weak (Pig)* receives only 50% damage from the *Sniper Tower*

## Controls

| Action | Input |
|---|---|
| Place tower | Left click |
| Cancel placement | Right click |
| Open shop | Right side menu |
| Pause game | Settings icon |

## Strategies

Some beginner tips:
- Start with multiple *Tower* towers
- Build *Money factories* when low on coins
- Fill the map with towers to maximize damage output
- Prepare heavily before wave 20

You can read more in the wiki:
- Gameplay Strategies
- Intro to the Game

## Getting Started

### Requirements

- Godot Engine 4.x

### Play in Godot

1. Download or clone this repository.
2. Open Godot Engine 4.x.
3. Import the project by selecting the `project.godot` file in the repository root.
4. Wait for the initial asset import to finish.
5. Press Play to run the game.

### Export a standalone build

1. Open the project in Godot.
2. Install the export templates if Godot asks for them.
3. Open the Export menu and add a preset for your target platform.
4. Export the project to create a standalone executable.

> Note: there is no published binary release yet, so players need to run the game through Godot or export their own build.

## Wiki

The project wiki contains:
- Intro to the Game
- Gameplay Strategies
- Tower Information
- Enemy Information

## Current limitations

> NOTE: The game currently does not support cloud saves or permanent local save files.

## Contributing

Contributions, suggestions and feedback are welcome.

If you find bugs or want to suggest improvements feel free to open an issue or create a pull request.

### Steps to follow

1. Clone the repository
2. Create a branch
3. Create a pull request

### Project Structure

- `assets/` - Art, audio, and data assets
- `scenes/` - Godot scenes
- `scripts/` - GDScript logic

## Credits

Contributors:

- Domas Baliūnas
- Dovydas Ruželė
- Tautvydas Tiškus
- Nojus Plekavičius

## License

See [LICENSE](LICENSE) for details.

[Back to top](#top)
