This is very much a work in progress!!

The basic idea is to create a split screen scrolling maze game 
using 6502 Assembly code on for the Oric 1 and Oric Atmos.

I first coded the routines to do this back in 1983 (before any other 
games were using split-screen scrolling). Unfortunately the tapes I recorded
from my Oric have long since disappeared (As has my memory of 6502 Assembly).

I seem to remember I'd got as far as having the split screen scrolling working, with some basic keyboard processing, randomly moving 'monsters', and some interupt driven music.

I'm just starting to re-learn the stuff I knew back then.  I'll continue to update this repo with my work (stuff that isn't yet working will be uploaded, just for me to keep track of where I'm at, but won't be called from 'main').

The main idea is to keep the 'maze' stored as a block/array of bytes, with each BIT used to denote if there is a maze wall or not. At runtime the routine for drawing the maze will process the maze data and plot the current state of the maze on the screen for the current top-left position.

I'm not intending on pixel level scrolling. Ideally the scrolling will be performed on a character level - but the maze will be 'magnified'. So 1 bit set in the maze data will be a 2 * 2 character in the maze,  and this will be scrolled 1 char at a time.


I'll repeat - this is very much a work in progress.

TODO (in approximate order):
- ~~fix routines in maze_procs for finding which bits represent a wall.~~
- Optimise the above routine
- ~~create routine to plot maze on screen for top-left coordinates.~~
- Use the above routine to parse maze bitmasks into an off screen buffer and create a new routine to render from that (should be faster)
- test.
- adjust routines to handle split screen (both vertical and horizontal).
- implement fast keyboard handling to scroll each view of the maze (and disable ROM interupt for these).
- test again.
- create 'tracker' for creating music.
- play music in background.
- implement 'player', with keyboard handling and detection with maze walls.
- implement 'chararacter designer', to allow creation of custom chars.
- think of a playable game using the code.
- implement it.
- test
- compress maze data (possibly using an external compression routine lz77)
- decompress maze data (lz77?)
- apply decompression to sprites, maze and sound.


The aim of this bit of coding is to provide a scrolling area which is much bigger than the Oric screen
![The aim](scrollArea.png)


