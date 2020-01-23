---
layout: post
title:  "Comments for static pages? - Part 1"
categories: jekyll
---

[This](/) is actually a static page hosted by [GitHub](https://www.github.com/), powered by [Jekyll](https://jekyllrb.com/). 
But how to get a comment section?

# Give Me Comments

Weeeelll....
You could use a service like Disqus.

Or, you use the idea from [damieng](https://damieng.com/blog/2018/05/28/wordpress-to-jekyll-comments).

Jekyll has a neat feature: you can place data files under `_data` and access in Liquid templates.

And that's more or less the starting point. Add comments as data and render them via Jekyll (utilizing Liquid).

Using the folder `_data/comments/{slug}/` to place comment files in. (`slug` being the "slugified" post name.)
The actual files can be in a few formats, but I used yaml.
Here is an example comment:
{% highlight yaml%}
---
id: 1579711318_617889634
ref: basil-timeouts
message: Testing comments
name: Bytekeeper
url: ""
date: 1579711318
{% endhighlight %}


`id` is the id of the comment *and* the base name of the file: `1579711318_617889634.yml`.
`ref` is a reference for what the comment was for. Ie. a slug or the id of another comment (not yet working here).
`message` is too complicated to explain... really. So is `name`. `url` is the website a user gave and will be used to render the commenter's name as a link to the site.
`date` a simple timestamp and, as you might have noticed, part of the `id`.

But having the comments stored as data will not be enough, unless I can convince people to check out the GitHub repo for comments.

# Render Me Comments

This one will be quick.
I use a modified version of [damieng's _includes](https://github.com/damieng/jekyll-blog-comments/tree/master/jekyll/_includes).
Since I modified the structure a bit I had to adapt it. I also changed the layout bit, the final version can be seen down here (unless it does not work in which case: bummer).

For now they look ok but will certainly need more fine-tuning, especially once it's possible to reply to individual comments as well.

Storage place for comments &#10003;

Rendering comments &#10003;

Adding comments: &#10060;

# Add Me Commentse

This could be as simple as people wanting to comment grabbing a fork of my repository and adding a comment file in data and creating a PR for it.
I'm pretty sure this avoids all comment spamming bots and requires almost no moderation.

You don't want to fork? Ok, I'll give you commit r... waaait.

So basically, using damieng's idea:
* I want a PR for each comment
* I want branch and PR to be automatically created
* Once I merge it, GitHub will automatically update and voilà

## Step 1: Create a service that accepts comments
This could be any form of (micro) web service. Damieng used Azure Functions. But Amazon Lambda or Google Functions would be fine too.
But I'm oldschool... I already have a VPS, so I use [CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface)!

I'm also a experienced Java developer, so I used [Kotlin](https://kotlinlang.org/). J/K of course I used [Rust](https://www.rust-lang.org/).

I learn Rust as I go (I already tried that once but the burrow checker tried to murder me in my sleep), so take everything here with a grain of salt.

So, let's start with some Rust code. There is this really nice library called [serde](https://serde.rs/) which has a ton of serializers and deserializers for various formats.
Like `urlencoded` which is what a simple form post will send.

Now let's write the code to process a `POST`ed comment:

{% highlight Rust %}
#[derive(Deserialize)]
struct Post {
    r#ref: String,
    message: String,
    name: String,
    url: String,
    redirect: String,
}
{% endhighlight %}
For those who have never seen C, a `struct` is like a `class`: A container for fields.

That's it! The `derive` attribute with the `Deserialize` argument will create the code to dump in a `urlendcoded` string and get out an instance of `Post`:
{% highlight Rust %}
let post: Post = serde_urlencoded::from_bytes(body.as_slice()).unwrap();
{% endhighlight %}

I omitted the boilerplate code to read the data from `stdin` - which is how you get data with `CGI`. The full code can be seen in my [GitHub repo](https://github.com/Bytekeeper/github_comment_rs/blob/master/src/main.rs).

## Step 2: Create a branch and PR automatically
Creating a branch and pushing it should be fairly simply with `GIT`'s CLI. But for the PR, the GitHub API will have to be used.

It can also be used to create a branch and (!) even create a file in there. So I just have to use a GitHub API Rust implementation to solve this. 
Actually, there are a few - but they are mostly unmaintained.
They also don't allow the shenanigans I need.

_To be continued_