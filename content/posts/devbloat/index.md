+++
title = "A Rant on Software Development Bloat"
date = 2025-09-05
tags = ["design & architecture"]
+++

In my opinion, software development has become rather bloated. If that is not the case for you, feel free to skip - or continue and enjoy some schadenfreude. This is just me ranting, don't mind me. Much of this I experienced at some points in my career. Some of it I heard from friends. Some of it from social media.

*Disclaimer*: As with most ~developers~ people, I am in a bubble.

We got pretty good at pushing out MVPs. A reasonably good-looking UI, some backend scaffolding - that is done in days instead of months. How did we get there? Frameworks! We got so many, the start is basically plug-and-play. In some areas we got so many frameworks, it is overwhelming. JavaScript frameworks anyone?

Frameworks are nice. But many frameworks start to create an ecosystem after a while. You get more tools, but also more restrictions. This can be good and bad. On the one hand, working with the framework becomes more productive. On the other hand, learning the framework gets harder - so is integration with other libraries/frameworks.

# Dependencies
Adding a new library or framework to your project? Are you thinking about the implications as well?
Your co-workers will also use them. **You** will use them. There should be a cost-benefit analysis for adding dependencies --- every time.

We mostly see the benefits while developing. Yes, we don't have to write code. Yes, someone else might have solved it better than you could. And yes, if there's a community --- you don't have to support the code (as much).

What it costs us?
* Google might suddenly drop the project, and you're left with a huge chunk of software --- heavily intertwined with a framework that is no longer maintained.
* Complexity of your software increases, because you opted for the "common" solution --- instead of the simple one.
* You add bugs and security holes, which you probably cannot fix quickly --- other than asking someone else to do it, most likely a volunteer in an open-source project.
* You don't fully understand the framework, so your misuse adds more bugs. Thankfully, you can fix those yourself.
* Updating a dependency can lead to conflicts if transitive dependencies don't line up.

# Dependencies Part 2
Actually, there's a hidden gem. Tool dependencies are often overlooked. They're quite useful, until they're not.

## Your IDE
Dev Containers, pre-configured IDEs, IDE setup guides? All useful. But again, nothing is free. For smaller projects, this part is usually not problematic. But for long-running products and projects...

As with all software, IDEs get updated, abandoned, and have bugs. You can enforce specific IDE setups to prevent this, but you will also make enemies among your co-workers on the way. Most of us customize their IDE experience. If you enforce your specific setup, you're just evil. If you enforce the common ground it's fair, but everyone will be unhappy. 

## Enforced Formatting
Yes, it's nice once your team agrees on formatting. And that can be pretty unpleasant. But is your formatting enforced? Git pre-commit hooks? IDE integration? What happens if the formatter fails? It happens more often than you would expect. Or the IDE plugin differs from the plugin in the build tool, or the CLI tool you use.

You use more than one tool? That can happen if one tool only handles a part of what you want. But what happens if both tools have overlapping responsibilities. And they disagree? (Oh yes, they will.). 

## Build Tool
Depending on the programming language, the number of build tools is ... enormous. They can be configured to death and bring all sorts of *joy*.

Oh, your software is polyglot? Multiple build tools? Sounds like fun. Works fine on your continuous integration (CI), but building it on your machine is a chore? Scripted steps on your CI, manual steps locally --- nice!

## Automated Testing
Unit tests take a second each, and there are 8,000 of them? Integration tests (for brevity's sake, I'll only distinguish between unit and integration tests here) are so slow you extracted them into separate build steps. Even your CI won't run them unless you ask it to, if you know how to ask. And if the CI is even on same system and not split across multiple systems.

## Continuous Integration
I mentioned it above, but CI is not something that magically appears. It has its own scripts and systems. It *can* be documented quite well, but often is not. It *can* be on one platform, but can be spread across platforms. Since your build and tests run in up to four hours there might be a slight problem if multiple developers are doing builds. It crashes, it fails randomly, it costs a ton of money. And you got one person who knows the configuration, two if you are lucky.

I mean, at least you have got CI and are not building the latest release on an individual developer's machine.

# Verdict
You will manage. If you can influence things, try to keep the environment simple --- not only the code (bloated architectures and design are topics for another time). If it's out of your control, don't get infuriated. You cannot change it, so accept it. Either way, it's always a good time to learn the good and the bad stuff here.

Don't get angry at your co-workers; most of them want to do what they think is right. They might be wrong, you might be wrong. Especially on that point, reflect on your opinions. If they seem wrong, change them. If not, help the other person if possible --- otherwise, don't.

A few suggestions that might help:
* Require a short cost‑benefit note for new dependencies.
* Add automated dependency update tests in CI.
* Enforce one authoritative formatter.
* Make builds reproducible locally (container or script).
* Refactor tests to run fast.
* Try to make builds as fast as possible locally.
* Assign and rotate CI/dependency owners.

