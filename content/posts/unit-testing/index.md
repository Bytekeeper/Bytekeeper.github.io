+++
title = "Unit Testing: Test Coverage"
date = 2025-02-02
[taxonomies]
tags = ["design & architecture", "testing"]
+++

# Testing != Proofing
It's pretty simple: 

A proven piece of code will need no tests at all. A tested piece of code almost always is not guaranteed to work.


# No One Size Fits All
Zero unit test coverage surely is wrong! Wait, are you sure?

Did you write a unit test for all those pesky shell and PowerShell scripts? Why not? 

I see, your build server executes them all the time? So they're integration tested.

No? You run them on your local machine? So you actually execute them in "production" without test.
"They're an exception" I hear you say? I say "the exception is the rule".

## Why Do We Test
Before we try to estimate how and what we want to test, we need to establish *why* we want to.

The sage programmer would not need tests. All code they write is perfect, adding tests would slow them down. 

#### Code Coverage
So you have to get a Code Coverage of 80 percent (or 70, or 90, ..)? And it's the same for all of your code?

What a stupid question you ask? Let me try to answer, why in might no be:
Programming languages differ. Dynamically typed languages for example, require a lot more tests that statically typed languages. There's a huge amount of things that can't be determined by the compiler/VM before executing the code. To name a few:
* Are the accessed methods present?
* Are the accessed fields present?
* Is the variable being passed of the expected type?

Statically typed languages will be able to answer some of these questions. There are still problems: 
* Is the reference/pointer valid? (null, anyone?)
* Do we use-after-free some data structure?


### For Whom Do We Write Tests
A large portion of our daily work revolves around writing tests. If you're a Test Driven Design (TDD) proponent, this will be quite a lot more.

But *why* do we write them in the first place? Or better, who requires us to do so?


## Why Don't We Write Tests

### Tests Help Learning the API
This is something, some well known developers repeat often to support test-driven design.

Tests *could* help other people learn how to use the API. That would be a by-product, and **not** the responsibility of a test.

I agree that developers rarely read the documentation. But it's not the tests you taking a first glance at.
It's the examples! Either by some other Blogger, or those provided by the "vendor".

Examples *should* be present in any library. Examples *should* compile. Examples *needn't* **test** anything, it is expected to execute them and observe as a human.
