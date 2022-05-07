# Maze solving algorithms preview
### Video Demo:  
https://youtu.be/4Tp-MHemH_c
### Description:
The project is written in ```lua```, using the ```Löve 2D``` framework. It is a simulation of two maze solving algorithms, and a maze generating algorithm.

To generate the maze, the program uses ```Prim's``` algorithm, and to solve it there are two implemented algorithms: ```A*``` and ```Breadth-first serach (BFS)```.

When you choose an algorithm, it immediately starts to solve the generated maze. On the top-left part of the screen you are going to see a timer counting how much time the algorithm takes to solve the maze. This is important because if you go back and choose the other algorithm, it is going to start solving the same maze, so you can compare the two algorithms with the same settings.

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

## How it works
### Prim's algorithm
This algoritm takes a grid of cell previously generated. From there it takes this steps:
1. Pick the starting cell and add it to the ```maze``` list, then add its neighbors to the ```frontier``` list.
2. Enter a loop until the ```frontier``` list is empty.
    1. Choose a random cell from the ```frontier``` list, let's call it current.
    2. Connect current to the closest cell that is in the ```maze``` list.
    3. Add current's neighbors to the ```frontier``` list.

### A* algorithm
This algorithm work by minimizing the ```f``` score of the path. ```f = g + h```, where ```g``` is the distance traveled and ```h``` is a heuristics function.
We'll have two sets, ```openset``` and ```closedset```.
1. Do while ```openset``` is not empty
    1. Select the cell from ``openset``` with the lowest ```f``` score, call it current.
    2. If current is the goal cell, we are done.
    3. Remove the current cell from the ```openset```.
    4. For each neighbor of current that is not on the ```closedset```:
        1. Give a tentative ```g``` score to the neighbor, which is current's ```g``` score + the distance between current and it's neighbor.
        2. If the neighbor is in the ```openset``` calculate if the tentative ```g``` score is less than the ```g``` score of the neighbor.
            1. If it is less than, update the neighbor's ```g``` score and set current as the neighbors's "previous" cell.
        3. If it is not on the ```openset```, set the neighbor's ```g``` score to the tentative one, set current as the previous cell of neighbor, and add the neighbor to the ```openset```.
        4. If neighbor's previous cell was updated, set it's ```f``` score accordingly.
2. If ```openset``` is empty and the algorithm has not found a solution, there is no solution.

When you finish, the path is given by following the goal cell's previous cell and so on.

### BFS algorithm
This algorithm works by calculating every possible path of the maze.
You start with two sets, ```explored``` and ```queue```.
1. Do while ```queue``` is not empty.
    1. Pop the first element in the queue and call it current.
    2. If current is the goal cell, we are done.
    3. For each neighbor:
        1. If the neighbor is not in ```explored```.
            1. Add the neighbor to ```explored```.
            2. Set current as the neighbor's previous cell.
            3. Add the neighbor to the ```queue```.

When you finish, the path is given by following the goal cell's previous cell and so on.
