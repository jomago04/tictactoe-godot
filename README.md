# TicTacToe

## Overview
Lightweight tictactoe project built in godot 4.7 to learn the engine before we start work on our POC.

## Requirements
- Godot 4.7

## How to Run
1. Install Godot 4.7 and ensure 'godot' is on your PATH.
1. From the project root, run 'godot --path .'

## What I Added
- Built a 3x3 matrix board that is built on run with 'GridContainer', 'CenterContainer', and 'VBoxContainer', which stays centered when the window is resized.
- Board state tracked as a 9 element 'Array[String]' with turn switching between X and O (player 1 and player 2).
- Win detection against the 8 win conditions.
- Draw detection when the board is full with no winner.
- Status label that shows whose turn it is or game result.
- A restart button that resets the board without reloading the scene.