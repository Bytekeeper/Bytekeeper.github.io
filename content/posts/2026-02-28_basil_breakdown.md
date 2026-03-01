+++
date = 2026-02-28
title = "BASIL broke"
tags = ["basil"]
+++

So, in the almost 8 years (insane!) it was running, BASIL had few hiccups. Recently it failed hard and was down for a few days. First: It's back up again, but the rabbit whole was deep.

# The Game Server
The first few years the machine running the games had issues with the network drivers (Linux). It first started loosing the connection then either hang or Kernel-panicking. A workaround was to restart it regularly. Mind you: this strategy is used by professional business software as well --- I'm in good company.

After a few years the issue suddenly was fixed. I can only assume some Kernel dev had the same issue an was motivated enough to fix it --- THANK YOU for that.

## Basic Setup of BASIL

The "game" machine was kind of running fine after that point --- without any scheduled restarts. The file serving machine started to get problems soon after. It's a VPS and has limited disk space. And it started to fill up. It serves replays, game logs and all sorts of aggregated JSON data. Everything is pretty small, but multiplied by a few thousand it gets large very quickly.

Using two machines has several benefits:
  * A VPS running games would be very expensive (good CPU, a lot of memory)
  * Hosting a web-server at home, even with Cloudflare "buffer" might get hammered
  * Using one machine for both:
    * Could be abused to influence the games being played
    * My internet being down would mean: no more public data

## Woes of Producing a lot of Data

The fix here was simple. Archive all old files and sync only recent ones. That way the VPS should never be filled beyond capacity. This worked fine for a few years. I will eventually have to manually move the archives to another place as disk slowly fills up.

Now let's head back to more recent days. On Feb. 19th - Dan destroyed BASIL with his custom CherryPi build. Okay, maybe it just made me check the machine and restart after installing security fixes. After that I did the usual check: Did the service start, are games being played. BUT: I did not check if games were actually running successfully.

Unfortunately, they did not. I tried some quick fixes but to no avail.

# Down the Rabbit Hole
So the journey began:

I suspected a security update broke something. I found it had upgraded from Ubuntu 24.4.3 to 24.4.4. There was nothing extremely suspicious about that. So I started a headful game. I suspected a crash. But it ran. The other bot just did not join. Observing that one I saw why: No hosted games were listed.

## Why You Not Join Game
Why though? Either the host did not "send" its game or the client did not receive it. So I fired up `tcpdump` inside the docker network used by `sc-docker`. I did not remember the UDP port so a quick internet search revealed 6112. Nothing showed up when I tried to start a game. So I (falsely) assumed that nothing was being sent. I tried `WINEDEBUG` - figuring out the potential params with some ChatGPT help. It did not help much. So I decided to add `strace` to the sc-docker image and ran wine with strace (only the network related calls). It did call `sendto()` --- which is the Linux syscall for sending on a socket.

So it *was* sending. But why was it not receiving anything. I decided to `tcpdump` on the network bridge of docker. Thankfully, without port range. Because DAMN YOU internet, it announced games on port 6111 and **not** 6112.

## UDP Broadcasting
So I ran `tcpdump` inside a docker container, and lo and behold... wait, again - nothing!

So I tried to manually broadcast UDP packets on 6111. And they got received. What the actual ... But there *was* a difference compared to my broadcast. It did use the subnet's broadcast address. Starcraft uses 255.255.255.255. This in itself should not be a problem, and it worked before.

At this point I tried all kinds of shenanigans, checking netfilter, and iptables. All looked fine. At some point I decided to want to see "more" data about UDP packets being sent by Starcraft. With some more help ChatGPT figuring out the obscure and cryptic arguments of tcpdump, I finally got more info. In case you want to try: `tcpdump -i br-<yourbride> -nnve udp port 6111`.

## It's Not Only the IP
While packets were sent to 255.255.255.255, they were *not* sent to the MAC address FF:FF:..:FF. But to a concrete one. Whereas my manually sent packets *were* sent to that MAC address.

So some new code started to decide to route differently. I suspect a kernel "fix". Figuring out the 255...255 address it might have decided that `lo` was a good choice - but I don't know. I did not check. Whatever the cause is, packets were not broadcast - because it's not a broadcast address.

## Fixing the Problem
Because, in that case the fix might have meant to remove `lo` --- nah. Another option would have been to patch Starcraft. Kind of overkill.

A "good" solution might be to write a tool that captures those packets and re-broadcasts them properly.

So, nobody would actually try an ugly hack like rewriting UDP packets via netfilter. Or would they? Hint: Yes.
My netfilter foo is pretty bad, so ChatGPT helped once again - the basic idea being pretty simple: Create a priority prerouting rule that captures packets targeting 6111 and set the target MAC address to ff:...:ff. Like this:

```
table inet filter {
	chain input {
		type filter hook input priority filter;
	}
	chain forward {
		type filter hook forward priority filter;
	}
	chain output {
		type filter hook output priority filter;
	}
}

table bridge starcraft_fix {
    chain prerouting {
        type filter hook prerouting priority -200;
        udp dport 6111 ether daddr set ff:ff:ff:ff:ff:ff
    }
}
```

## Conclusion
Making a 28-year-old game run reliably on a OS (Linux) that is wasn't meant to run on, in a setting (headless) it was not meant to run on, with hooks (BWAPI) it was not supposed to have --- is a challenge.

Most bot authors use Windows or macOS - so neither this problem nor the solution might apply. But if you sc-docker games suddenly stop working it "might" be this issue. If you're not on Linux - the fix might be different, but maybe I saved you a few hours finding the problem.

(PS: I used enough em dashes to trigger an LLM "alarm". I let ChatGPT proof-read but all the text is mine.)
