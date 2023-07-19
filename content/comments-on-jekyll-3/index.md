+++
title = "Comments for static pages? - Part 3"
+++

[Previously](@/2020-01-25-comments-part-2.md) I wrote a CGI service to allow adding comments by adding them as GitHub PRs. The basic idea is still sound, but CGI has some problems:
* It does not scale (not that I would ever need that)
* It requires some web server with CGI config (I can host my own, but I don't actually want to)
* 
