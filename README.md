# Hobby Farm

A small, charming farm simulation game written in the Janet programming language.

![Hobby Farm Screenshot](https://wmealing.github.io/images/hobby-farm.png)

## Overview

Hobby Farm is a personal project exploring game development with [Janet](https://janet-lang.org/) and [Jaylib](https://github.com/janet-lang/jaylib) (Janet bindings for Raylib). The project features a player-controlled character navigating a farm environment, interacting with various entities, and managing a game state.

## Status

**This project is currently unfinished.** It is a work in progress, and development will continue as more time becomes available.

## Technologies

- **Language:** [Janet](https://janet-lang.org/)
- **Graphics & Input:** [Jaylib](https://github.com/janet-lang/jaylib) (Raylib bindings)
- **Utilities:** [Spork](https://github.com/janet-lang/spork), [Pat](https://github.com/ianthehenry/pat)
- **Testing:** [Testament](https://github.com/pyrmont/testament)

## Prerequisites

To build and run this project, you will need:

1.  **Janet:** The Janet programming language.
2.  **jpm:** The Janet Project Manager.
3.  **Raylib:** Required by Jaylib (often handled by `jpm` during dependency installation).

## How to Build and Run

### Installing Dependencies

First, install the required dependencies using `jpm`:

```bash
jpm install-deps
```

### Building

You can build the project using the provided `Makefile`:

```bash
make build
```

Or directly with `jpm`:

```bash
jpm build
```

To build a local version of the executable:

```bash
make build-app
```

### Running

To run the game during development:

```bash
make run
```

Alternatively, you can run the entry point directly with Janet:

```bash
janet main.janet
```

## Project Structure

- `main.janet`: The entry point and main game loop.
- `game-state.janet`: Management of the global game state.
- `player.janet`: Player movement and interaction logic.
- `sprite-manager.janet`: Handling of game sprites and animations.
- `assets/`: Resource files including images and tilemaps.
- `resources/`: Audio, fonts, and additional image assets.
