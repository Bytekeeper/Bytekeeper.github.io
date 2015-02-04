---
layout: post
title: "Arduino Madness or The Quest for PS2014 lamp"
category: hardware
comments: true
---
If you haven't seen it yet, check out David Bliss' blog on the IKEA PS2014 - or his modification of it: [Transforming Sphere Lamp](http://davidbliss.com/2014/11/18/transforming-sphere-lamp/).

When friends from work and I saw this, we immediately wanted to have one of these. As a small bonus, I finally found a project to start some Arduino magic.

The Task
========
Create a computer controlled PS2014 that can open and close itself and produce some decend lighting. We initially didn't look at David's description on how he did it, but we did later on. Nevertheless, we wanted to do it without cheating, so what to do...

We got the lamp, and checked it's mechanics. The friction of the sliding part seemed quite high. As it turned out, it's not really - it's just squeezed by a spring. The spring in turn is used as a break "device" for the string attached, preventing the lamp from closing as soon as you stop pulling.

The Hardware
------------
Arduino Nanos will be used to control the lamp. The lighting will be some high power LEDs. The motor opening and closing the lamp will be a servo.

The servo part is quite interesting as it differs much from David's design with a threaded rod. The LEDs will be driven by some constant current power supplies and some simple resistors. A large problem will be the cooling of the LEDs, which can get quite hot.

Next time: Open and closing the lamp with a small servo arm, how to drive the LEDs, ...
