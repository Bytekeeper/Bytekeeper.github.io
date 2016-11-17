---
layout: post
title: Don't do Getters and Setters!
category: java
---
Two thirds of each *POJO* classes are bloat-code. Martin Fowler called it [AnemDomainModel](http://martinfowler.com/bliki/AnemicDomainModel.html), describing it as *horror of anti-pattern*. I couldn't agree more.

Lets start off using a simple example:

{% highlight java %}
public class Person {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
{% endhighlight %}

Be honest to yourself
---------------------
That is not an object. It's a `struct`, `record` or whatever you want to call it in a procedural language of your choice. You can also call it [pseudo or quasi class](http://www.idinews.com/quasiClass.pdf).
Some even consider to [never have [get/set] near your code](http://www.yegor256.com/2014/09/16/getters-and-setters-are-evil.html), Yegor Bugayenko, for example.

But - if you have to do that - please leave the boilerplate and make it:
!
{% highlight java %}
public class Person {
    public String name;
}
{% endhighlight %}

### But what about encapsulation?
Getters and setters actually [break encapsulation](http://typicalprogrammer.com/doing-it-wrong-getters-and-setters/)!

You want to protect `name` from modification? Use `public final String name;`!

You want to protect `name` from being read? Remove the field, obviously you didn't need it!

### Information hiding
Please try to change the type of the field without changing the getters and setters. Or try the experiment the other way around. If you were careful, this might actually work.
I bet you were not. So changing the type of a field or even the name of the field will usually cascade through your code - so much for hiding anything.

### Debugging?
Unless you use some esoteric IDE, just add a variable break point - just like you would in the getter and setter.

### Overriding?
You're most likely violating the [Liskov substitution principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle) just by asking this.

### Concurrency?
Add `volatile` (unless you're using a reaaaly old JVM). Accessor methods won't protect you from synchronization issues:
{% highlight java %}
person.setAge(person.getAge() + 1);
{% endhighlight %}
will fail equally horrible as
{% highlight java %}
person.age += 1;
{% endhighlight %}
in a concurrent scenario.

Persistence
-----------
If you start taking persistence frameworks into account, things get far worse. You might have written getterns and setters for JPA (or hibernate).
Take a look at [this stackoverflow answer](http://stackoverflow.com/a/757330):

{% highlight java %}
@Entity
public class Person {

  @Column("nickName")
  public String getNickName(){
     if(this.name != null) return generateFunnyNick(this.name);
     else return "John Doe";
  }
}
{% endhighlight %}

Assume the following implementation of the `generateFunnyNick()` method:
{% highlight java %}
public static String generateFunnyNick(String name) {
    if (random.nextFloat() < 0.5f) {
        return name + " (wildhog)";
    }
    return name + " (hotshot)";
}
{% endhighlight %}

Every time you load that in a session, you have a 50% chance that the value of `nickName` has changed. Unintentionally, when the session is closed, this might result in an `update` of the corresponding database row.
You'll get a similar result if you do "logic" in `setNickName(...)`.

If you're using persistence, you must not modify the field value in neither the *getter* nor the *setter*, essentially breaking information hiding.

Abomination Classes
-------------------
If your setters are not just boilerplate, you might still have created an `abomination class`. That is, you can tell an object what is should do then *rip* (get) the result out of it.


### Observers?
This makes getters obsolete, since you can follow up with the [tell don't ask](http://martinfowler.com/bliki/TellDontAsk.html) principle.

(Join the club of [Getter Eradicators](http://martinfowler.com/bliki/GetterEradicator.html))

### Validation?
As soon as you use any framework depending on `accessor` methods, you can only do technical validation. If you check invariants, they might fail if the order of `setter` calls is not known.

For example:
{% highlight java %}
public void setOwnsDriversLicense(boolean ownsDriversLicense) {
    if (getAge() < 18) {
        throw new IllegalStateException();
    }
    this.ownsDriversLicense = ownsDriversLicense;
}
{% endhighlight %}
That is not possible, if `setOwnsDriversLicense` is called before `setAge`! You're also forced to call `getAge()` in there as somebody could just inherit the class and change `getAge()`.

So it boils down to:
{% highlight java %}
public void setName(String name) {
    if (name == null) {
        throw new IllegalStateException("Name mustn't be null!");
    }
    ...
}
{% endhighlight %}
But then again, you could also add a technical method to check invariants (Hibernates `Validatable` or @NotNull or @Column(nullable=false), ...), which can be checked by the framework.

It's also pretty likely that you cannot decide if an invariant is met, before all properties are set. In that case you have to add even more validation methods. What about invariants depending on the `service` that takes the object? 
Is it really prudent to place all this validation code in the class itself. What if someone creates a new `service`? He'll have to add validation code elsewhere anyways...

Conclusion
----------
This article, as well as other articles on the topic will most likely not persuade you or your colleagues to change their trained pattern. It's sad that we have to write all this boilerplate code to satisfy some other human being.

Yes, that's right. There's only a small amount of libraries that require the use of getters and setters. But there are a lot of developers using this pattern for almost 20 years, without any added benefit - but they're used to do it this way.

Maybe in your next POC - try not using any getters and setters and check what the code looks like without them. 



Refs
----

* <http://www.javaworld.com/article/2073723/core-java/why-getter-and-setter-methods-are-evil.html>
* <http://stackoverflow.com/questions/594597/hibernate-annotations-which-is-better-field-or-property-access>
* <http://www.yegor256.com/2014/09/16/getters-and-setters-are-evil.html>
* <http://typicalprogrammer.com/doing-it-wrong-getters-and-setters/>