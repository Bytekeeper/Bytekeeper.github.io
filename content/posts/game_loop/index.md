+++
title = "4X Game Loop"
date = 2022-08-05
tags = ["gamedev"]
+++

I think I don't really need to explain what a 4X game is, maybe not even what the 4X stand for.
But, I'll do it anyway - the gameplay loop of a typical 4X game is:
![Image](4x_game.dot.png", alt="The 4 Xs", caption="A loop of loops - that is 4X)
* eXplore
* eXpand
* eXploit
* eXterminate

Much of the fun of this simple formula comes from the fact that none of those factors stands on its own.
You usually cannot expand without exploring first. Sometimes to expand by exterminating an enemy at a location first.
What is there to exploit, if you did not expand before?
And how will you exterminate, if you lack the resources you ought to have exploited first.

Let's dive deeper into the ~~abyss~~ parts of such a game:

## Exploration
The most basic approach is sending out scouts. An alternative would be spying.
Maybe diplomacy uncovers some secrets as well.

Keywords:
* Scouts
* Diplomacy
* Special events
* Spies
* Racial abilities
* Tech abilities

## Expansion
Again, there's the direct way of sending a colony ship (settler). Alternatively you can take over an enemy colony.
A random encounter could grant you a new colony.

Keywords:
* Colony ships
* Outposts
* Diplomacy

## Exploitation
Pumping up the population. Building factories. Gather food. There could be a lot of resources to be gathered.
Also things like research are part of this.
There are also hidden resources. A large army could incline neighbours for that large tribute.

Keywords:
* Research
* Mining
* Taxation
* Diplomacy
* Spies
* Production

## Extermination
Send your force and crush your foes. Or let your spies sabotage the heck out of them. Or let some allies or vassals handle it.

Keywords:
* Battle ships
* Planetary defense
* Spies
* Diplomacy

# Design for my Game
I planned on covering all topics above, but that is basically to large for a single post.
In the last post I covered a few basics of research. 
I will try a breadth-first approach in design and switch to another topic.

Let's tackle...

## Exploration
The basis for almost all games here is using some sort of scout.
It would not make sense to change that, it is pretty much what players expect to find.

But, what is a scout? A special ship (surveyor anyone)? A player designed ship?
Pre-designed units have a large benefit: They can be balanced pretty well.
The player chooses which ship to build, but not what it is composed of.

Player designed ships are way more interesting in concept.
In practice, it boils down to a few ships with a specific purpose (like scouting). 
Remnants of the Precursors for example allows only a few designs, which emphasizes that.

### Ship Design
I do think, limiting the number of designs is good idea.
But for the actual design of a ship I have another idea. As usual, ships are composed of different modules.
Each module modifies some attributes of a ship:

| Attribute                  | Effect                                                                                   |
| ----                       | ----                                                                                     |
| Cost                       | Makes your ship more expensive (but shiny and pretty as well)                            |
| Space                      | Most modules take up some precious space on a ship, but some can extend it               |
| Range Bonus                | Increases/Decreases the range a ship can distance itself to the nearest colony           |
| Interstellar Speed Bonus   | Increases/Decreases speed for long range travel                                          |
| Interstellar Stealth Bonus | Makes ships more/less detectable while in flight                                         |
| Hit point Bonus            | Increases/Decreases the hull of a ship to take more of a punch                           |
| Shield Bonus               | Similar to hit points, but weak against energy weapons - strong against physical weapons |
| Combat Speed Bonus         | Increases/Decreases speed for combat                                                     |
| Combat Repair              | Repairs ships by a small amount each combat turn                                         |
| Particle Damage            | Adds particle beams with some strength as combat and point defense weapons               |
| Projectile Damage          | Adds projectile weapons with some strength as combat weapon                              |
| Missile Damage             | Adds missiles with some strength as combat weapons                                       |
| Combat Stealth             | Makes ships harder to hit or easier to hit in combat                                     |
| Colonists                  | This allows a ship to colonize an empty planet                                           |

A ship, by itself is just a hull. The collection of modules selected will determine its purpose.
But, there's no free lunch. All modules will be balanced, one way or another.

For example, a missile launcher weapon will most likely take up a lot of space and will not be cheap.
A particle beam weapon on the other hand could be smaller and cheaper.
But at the cost of reduced combat stealth, and a weakness in damaging the hull of enemy ships.

Once again this reminds of RPG attributes on items:
![Simple Weapon](Simple%20Weapon.png "Impressive")

That is intentional.

I really want to enforce that ships are good at some things and bad at others.
Otherwise you will end up with the typical "high tech jack of all trades" ships.
Also, the number of designs should be limited, as with [ROTP](https://rayfowler.itch.io/remnants-of-the-precursors).
I would like the player to see each design as a "character". Although with some serious multiple personality disorder.

So modifying a design should be possible. What happens with the existing ships?
They could keep their original design. But then, the game could just have unlimited designs.
They could be scrapped. They could be retrofitted. Or something in-between.

No code was ~~harmed~~ written for this post. As mentioned before, I already have a small code base. 
But exploring (no pun intended) the design space is more of an issue for now.
So next time we take a look at *Expanding*.
