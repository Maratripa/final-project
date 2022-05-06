# Maze solving algorithms preview
### Video Demo:  
https://youtu.be/4Tp-MHemH_c
### Description:
The project is written in ```lua```, using the ```Löve 2D``` framework. It is a simulation of two maze solving algorithms, and a maze generating algorithm.

To generate the maze, the program uses ```Prim's``` algorithm, and to solve it there are two implemented algorithms: ```A*``` and ```Breadth-first serach (BFS)```.

### Usage:
To launch the program you need to have ```Löve 2D``` installed and in the main menu you'll have to select the algorithm to solve the maze. If you hit ```ESC``` while one algorithm is running you are going to return to the main menu, where you can select the same or the other algorithm.

### Files and directories:
1. ```main.lua``` : This file connects all parts of the code with the ```Löve 2D``` framework.
2. ```menu.lua``` : Handles the main menu: Text and buttons.
3. ```timer.lua``` : File that handles the timer of the top-left part of the screen
4. ```settings.lua``` : File to save settings and state of the program.
5. ```utils.lua``` : File that contains functions used throughout various parts.

#### entities/
1. ```cell.lua``` : This file contains the blueprint for the basic cell of the maze.
2. ```maze.lua``` : This file is in charge of generating the maze.

#### algs/
1. ```astar.lua``` : This file handles solving the maze with the ```A*``` algorithm.
2. ```bfs.lua``` : This file handles solving the maze with the ```BFS``` algorithm.
