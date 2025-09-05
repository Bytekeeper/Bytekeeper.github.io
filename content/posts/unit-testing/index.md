+++
title = "Unit Testing: Test Coverage"
date = 2025-07-05
tags = ["design", "architecture", "testing"]
draft = true
+++

A small rant about unit testing and test coverage in general. There are rather extreme opinions out there on this topic.
But these opinions often don't take the context into account, like - at all.

# Testing != Proofing
Let's start with what testing is. Or rather, what it certainly is not:

**A proof.**


If you proof that your code works, you don't need tests.

If you test your code, it proofs it will work for the specific test you made.

# No One Size Fits All
Zero unit test coverage surely is wrong! Wait, are you sure?

Did you write a unit test for all those pesky shell and PowerShell scripts? Why not? 

I see, your build server executes them all the time? So they're integration tested.

No? You run them on your local machine? So you actually execute them in "production" without test.
"They're an exception" I hear you say? Sure...

## Why Do We Test
Before we try to estimate how and what we want to test, we need to establish *why* we want to.

The sage programmer would not need tests. All code they write is perfect, adding tests would slow them down. 

### Code Coverage
So you have to get a Code Coverage of 80 percent (or 70, or 90, ..)? And it's the same for all of your code?

But why?

Programming languages differ. Dynamically typed languages for example, require a lot more tests that statically typed languages. There's a huge amount of things that can't be determined by the compiler/VM before executing the code. To name a few:
* Are the accessed methods present?
* Are the accessed fields present?
* Is the variable being passed of the expected type?
* Is the return type correct? For all returned types in your function?

Statically typed languages will be able to answer some of these questions. There are still problems: 
* Is the reference/pointer valid? (null, anyone?)
* Are your indices in-bounds?
* Do we use-after-free some data structure?

### What Will it Drive
A shell scripts searching for old files. You might run it multiple times. But do you need a test? Most likely not. There are exceptions, as always, but even SQL scripts are often tested against a TEST-environment - no test automation.

A plane or spacecraft? Better proof as much as you can! People could die, it's usually a good idea to do whatever we can to prevent that. Note that even a proof does not provide 100% certainty that nothing happens. Reality is - kind of probabilistic. 

A CRM? Now we're right in the middle. People are usually not physically hurt (if they are, WHAT kind of CRM are you even creating?). But by proxy, they could. Imagine a CRM for a pharmacy - and your bug preventing important drugs from being delivered.

### What Do We Actually want
Generally - we want to avoid harming people.
We want software that has no bugs and performs well, all while being easy to maintain and develop new features for. 

We know that is impossible.


### For Whom Do We Write Tests
A large portion of our daily work revolves around writing tests. If you're a Test Driven Design (TDD) proponent, this will be quite a lot more.

But *why* do we write them in the first place? Or better, who requires us to do so?


## Why Don't We Write Tests

### Tests Help Learning the API
This is something, some well known developers repeat often to support test-driven design.

Tests *could* help other people learn how to use the API. That would be a by-product, and **not** the responsibility of a test.

I agree that developers rarely read the documentation. But it's not the tests you're taking a first glance at.
It's the examples! Either by some other Blogger, or those provided by the "vendor".

Examples *should* be present in any library. Examples *should* compile. Examples *needn't* **test** anything, it is expected to execute them and observe as a human.
