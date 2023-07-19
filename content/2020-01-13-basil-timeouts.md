---
title:  "Slow bots on Basil"
categories: basil
---


If you haven't yet, check out [BASIL]. It's a 24/7 Starcraft league, but for bots!
It usually runs fine nowadays. But sometimes an external hiccup occurs. One of those is the problem of detecting who to blame if a game times out.
It works fine if the game ends with the in-game timeout of 60min, since the [Tournament Module](https://github.com/basil-ladder/sc-tm) BASIL uses
will make both bots leave and select the winner based on the score (That might be unfair, but that's a topic for another post).

But if a game gets killed because it took to long (wall-clock time), what then? There are no scores, no replays - nothing essentially.
Besides a bot just hanging, most bots just take their time. So I wanted to penalize the slower bot in that case. This looked like a good idea back
in the beginning. For `dll` bots this works fine, but for `client` bots, it didn't work up until [BWAPI 4.4](https://github.com/bwapi/bwapi/commit/4a984290cf6aa6f05ebcbdcd4a094ffceb57f6e9).

As of today that means that games timing out in that fashion will not be counted. One could abuse this by timing out intentionally for imminent losses. 
I don't expect this to happen, the bot community is generally competitive, but also friendly and fair. (Totally unrelated: I can actually disable bots permanently)

[BASIL]: https://basil.bytekeeper.org/
