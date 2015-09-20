---
title: OSX Keep SSH Session Alive
date: 2015-09-19 22:43 MDT
tags: ssh
---

For keeping the connection alive, you can check in `/etc/ssh_config` the line where
it says `ServerAliveInterval`, that tells you how often (in seconds) your computer
is gonna send a null packet to keep the connection alive. If you have a 0 in there
that indicates that your computer is not trying to keep the connection alive
(it is disabled), otherwise it tells you how often (in seconds) it is sending
the aforementioned packet. Try putting 120 or 240, if it is still killing your
connection, you can go lower, maybe to 5, if with that number it doesn't happen,
maybe it is your router who is dumping the connection to free memory.

Reference: http://apple.stackexchange.com/questions/36690/how-can-i-prevent-an-ssh-session-from-hanging-in-os-x-terminal
