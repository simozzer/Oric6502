This is very much a work in progress!!

The basic idea is to create a split screen scrolling maze game 
using 6502 Assembly code on for the Oric 1 and Oric Atmos.

I first coded the routines to do this back in 1983 (before any other 
games were using split-screen scrolling). Unfortunately the tapes I recorded
from my Oric have long since disappeared (As has my memory of 6502 Assembly).

I seem to remember I'd got as far as having the split screen scrolling working, with some basic keyboard processing, randomly moving 'monsters', and some interupt driven music.

I'm just starting to re-learn the stuff I knew back then.  I'll continue to update this repo with my work (stuff that isn't yet working will be uploaded, just for me to keep track of where I'm at, but won't be called from 'main').

The main idea is to keep the 'maze' stored as a block/array of bytes, with each BIT used to denote if there is a maze wall or not. At runtime the routine for drawing the maze will process the maze data and plot the current state of the maze on the screen for the current top-left position.

I'll repeat - this is very much a work in progress
