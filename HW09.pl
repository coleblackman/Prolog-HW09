/* 
Playthrough 1:
This is an adventure game. Legal actions are left, right, forward, unlock, 
pickup, or drop. End each move with a period. You are in a pleasant valley, with
a trail ahead.
You see a stick. Next move --
forward.
-----forward----- You are on a path, with ravines on both sides.
Next move --
forward.
-----forward----- You are at a fork in the path.
Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You see a sword. Next move --
pickup.
Pick up what?
sword.
You pick up the sword. You are in a maze of twisty trails, all alike.
You are holding a sword. Next move --
right.
-----right----- You are in a maze of twisty trails, all alike.
You are holding a sword. You meet a very angry ogre. You take out your trusty 
sword and slay the ogre! Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You are holding a sword. Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You see a key. You are holding a sword. Next move --
drop.
Drop what?
sword.
You drop the sword. You are in a maze of twisty trails, all alike.
You see a key. Next move --
pickup.
Pick up what?
key.
You pick up the key. You are in a maze of twisty trails, all alike.
You see a sword. You are holding a key. Next move --
right.
-----right----- You are in a maze of twisty trails, all alike.
You are holding a key. Next move --
left.
-----left----- You are at a fork in the path.
You are holding a key. Next move --
right.
-----right----- You are at a locked gate.
You are holding a key. Next move --
unlock.
You have unlocked the gate!. Next move --
forward.
-----forward----- You are on the mountaintop.
There is a treasure here. Congratulations, you win! Thanks for playing.

Playthrough 2:
This is an adventure game. Legal actions are left, right, forward, unlock, 
pickup, or drop. End each move with a period. You are in a pleasant valley, with
a trail ahead.
You see a stick. Next move --
forward.
-----forward----- You are on a path, with ravines on both sides.
Next move --
forward.
-----forward----- You are at a fork in the path.
Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You see a sword. Next move --
right.
-----right----- You are in a maze of twisty trails, all alike.
You meet a very angry ogre. There is no escape for you. Ahhh! Thanks for playing.

Playthrough 3:
This is an adventure game. Legal actions are left, right, forward, unlock, 
pickup, or drop. End each move with a period. You are in a pleasant valley, with 
a trail ahead.
You see a stick. Next move --
forward.
-----forward----- You are on a path, with ravines on both sides.
Next move --
forward.
-----forward----- You are at a fork in the path.
Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You see a sword. Next move --
left.
-----left----- You are in a maze of twisty trails, all alike.
You see a key. Next move --
pickup.
Pick up what?
key.
You pick up the key. You are in a maze of twisty trails, all alike.
You are holding a key. Next move --
right.
-----right----- You are in a maze of twisty trails, all alike.
You are holding a key. Next move --
left.
-----left----- You are at a fork in the path.
You are holding a key. Next move --
right.
-----right----- You are at a locked gate.
You are holding a key. Next move --
forward.
-----forward----- You attempted to go through the locked gate! Lightning erupts 
from the sky and smites you down. You have dared to test the old gods. That is 
not a legal action. You are holding a key. Thanks for playing.
*/

/*Added feature: there is a sword at the start of the maze. 
If the player picks it up and sees the ogre, they kill the ogre.
*/

/* HW09

  In class on Monday (4/15) we did a walkthrough of a simple text-based
  adventure game in Prolog. This file contains a version similar to the one
  built in class.

  Your assignment is to add the following features to this prolog program:
    1.) Create a gate between the fork in the path and the mountaintop.
        The gate is a separate location; that is, the player must move
        from at(you,fork) to at(you,gate) and then to at(you,mountaintop).

    2.) To move forward through the gate the player must first unlock it
        with a key.

    3.) The key is somewhere in the maze. The player must find it and
        explicitly pick it up.

    4.) If the player tries to pass through the gate while still holding the
        key, he or she is killed by lightning. (To get the treasure, the
        player must first open the gate, then put down the key, and then
        pass through.)

    5.) Part of your implementation should be a general way for the player
        to pick things up, carry them, and put them down. Design your
        solution so that it would be easy to add additional objects for
        the player to pick up and put down.

    6.) Everytime report() is called, also print out what items the player
        is currently carrying. (or print out that they are carrying no items)

    7.) Add at least one more feature to the game not already specified above.
        It can be anything that you want, large or small. Describe what you
        added in your comments at the top of the file.

    8.) At the top of your file, include in your comments at least 2
        different complete interactions with your game (play it though a
        couple of different ways and copy and paste the results).
 */


/*
  Introduction to the game -
  This is a little adventure game.  There are three
  entities: you, a treasure, and an ogre.  There are 
  six places: a valley, a path, a cliff, a fork, a maze, 
  and a mountaintop.  Your goal is to get the treasure
  without being killed first.
*/

/* Allow asserts and retracts for the predicate -at- */
:- dynamic at/2.
:- dynamic holding/1.

/*
  First, text descriptions of all the places in 
  the game.
*/
description(valley,
  'You are in a pleasant valley, with a trail ahead.').
description(path,
  'You are on a path, with ravines on both sides.').
description(cliff,
  'You are teetering on the edge of a cliff.').
description(fork,
  'You are at a fork in the path.').
description(maze(_),
  'You are in a maze of twisty trails, all alike.').
description(mountaintop,
  'You are on the mountaintop.').
description(gate_locked,
  'You are at a locked gate.').
/*
  report prints the description of your current
  location.
*/
report :-
  at(you,Loc),
  description(Loc,Y),
  write(Y), nl,
  !,
  report_items,
  report_held_items.

report_items :-
    at(you, Loc),
    at(Item, Loc), 
    item(Item),
    write("You see a "), write(Item), write(".\n").

report_items.

report_held_items :-
    holding(Item),
    write("You are holding a "), write(Item), write(".\n").

report_held_items.

/*
  These connect predicates establish the map.
  The meaning of connect(X,Dir,Y) is that if you
  are at X and you move in direction Dir, you
  get to Y.  Recognized directions are
  forward, right, and left.
*/
connect(valley,forward,path).
connect(path,right,cliff).
connect(path,left,cliff).
connect(path,forward,fork).
connect(fork,left,maze(0)).
connect(fork,right,gate_locked).
connect(gate_locked, forward, gate_unlocked).
connect(gate_unlocked,forward,mountaintop).
connect(maze(0),left,maze(1)).
connect(maze(0),right,maze(3)).
connect(maze(1),left,maze(0)).
connect(maze(1),right,maze(2)).
connect(maze(2),left,fork).
connect(maze(2),right,maze(0)).
connect(maze(3),left,maze(0)).
connect(maze(3),right,maze(3)).



lightning_enforcement(Loc,Dir) :-
    /*holding(key),*/
    Loc == gate_locked,
    Dir == forward,
    write('You attempted to go through the locked gate! Lightning erupts from the sky and smites you down. You have dared to test the old gods.\n'),
    retract(at(you,_)),
    assert(at(you,done)),
    !.

lightning_enforcement(_,_).

/*
  Pickup and drop.
*/
/*
  move(Dir) moves you in direction Dir, then
  prints the description of your new location.
*/
do(Dir) :-
  direction(Dir),
  write('-----'),write(Dir),write('-----\n'),
  at(you,Loc),
  connect(Loc,Dir,Next),
  lightning_enforcement(Loc,Dir),
  retract(at(you,Loc)),
  assert(at(you,Next)),
  
  report,
  !.

do(pickup) :-
    write('Pick up what?\n'),
    read(Item),
    item(key),
    at(you, L),
    at(Item, L),
    assert(holding(Item)),
    retract(at(Item, L)),
    write("You pick up the "), write(Item), write(".\n"),
    report,
    !.

do(drop) :-
    write('Drop what?\n'),
    read(Item),
    holding(Item),
    at(you, L),
    assert(at(Item, L)),
    retract(holding(Item)),
    write("You drop the "), write(Item), write(".\n"),
    report,
    !.

do(unlock) :-
    holding(key),
    write("You have unlocked the gate!"), write(".\n"),
  	retract(at(you,gate_locked)),
  	assert(at(you,gate_unlocked)),
    !.
/*
  But if the argument was not a legal direction,
  print an error message and don't move.
*/
do(_) :-
  write('That is not a legal action.\n'),
  report.

/* Items */

item(key).
item(stick).
item(sword).
/*
  Move commands. The player can move left, right,
  or forward.
*/

direction(forward).
direction(left).
direction(right).

/*
  If you and the ogre are at the same place, and you have the sword, then you 
  kill the ogre.
*/
ogre :-
  at(ogre,Loc),
  at(you,Loc),
  holding(sword),
  write('You meet a very angry ogre.\n'),
  write('You take out your trusty sword and slay the ogre!\n'),
  retract(at(ogre,Loc)),
  /* ogre is dead, but for simplicity move to valley since you can't get back to
  the valley once you leave
  */
  assert(at(ogre,valley)),
  !.
/*
  If you and the ogre are at the same place (and you do not have the sword), it 
  kills you.
*/
ogre :-
  at(ogre,Loc),
  at(you,Loc),
  write('You meet a very angry ogre.\n'),
  write('There is no escape for you. Ahhh!\n'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.
/*
  But if you and the ogre are not in the same place,
  nothing happens.
*/
ogre.

/*
  If you and the treasure are at the same place, you
  win.
*/
treasure :-
  at(treasure,Loc),
  at(you,Loc),
  write('There is a treasure here.\n'),
  write('Congratulations, you win!\n'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.
/*
  But if you and the treasure are not in the same
  place, nothing happens.
*/
treasure.

/*
  If you are at the cliff, you fall off and die.
*/
cliff :-
  at(you,cliff),
  write('You fall off and die.\n'),
  retract(at(you,cliff)),
  assert(at(you,done)),
  !.
/*
  But if you are not at the cliff nothing happens.
*/
cliff.


/*
  Main loop.  Stop if player won or lost.
*/
main :- 
  at(you,done),
  write('Thanks for playing.\n'),
  !.
/*
  Main loop.  Not done, so get a move from the user
  and make it.  Then run all our special behaviors.  
  Then repeat.
*/
main :-
  write('\n\nNext move -- '),
  read(Action),
  call(do(Action)),
  ogre,
  treasure,
  cliff,
  main.

/*
  This is the starting point for the game.  We
  assert the initial conditions, print an initial
  report, then start the main loop.
*/
    
go :-
  retractall(at(_, _)), % cleanup from previous runs
  retractall(holding(_)),
  assert(at(you,valley)),
  assert(at(ogre,maze(3))),
  assert(at(treasure,mountaintop)),
  assert(at(stick, valley)),
  assert(at(key, maze(1))),
  assert(at(sword,maze(0))),  
  write('This is an adventure game. \n'),
  write('Legal actions are left, right, forward, unlock, pickup, or drop.\n'),
  write('End each move with a period.\n\n'),
  report,
  main.

/*
 * To get started, use the query:
 * go. 
 */