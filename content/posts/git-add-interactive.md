+++
date = '2024-02-06T20:13:52-06:00'
draft = false
title = 'If not git add ., then what?'
+++

Countless times you have been told to **never** use `git add .` when staging files. You've been to conferences where git experts say you shouldn't use it. Tech people of Twitter also say it. Again and again, you hear **never** use `git add .` to stage your files. 

### Habits
I get it. I don't want to accidentally stage a file, then commit it. Muscle memory is often times the culprit here. I don't even realize I'm typing `git add .` until I hit enter. If you are like me, you have a `git undo` alias mapped to `reset --soft HEAD^`. I can't count the times I have accidentally staged a file, then rapid fire commit with some message. I have done it enough times to justify a git alias.

I try to do as much work as possible in the terminal. On occasion when I need to do a highly selective commit, I will often jump to an IDE and use that to do selective adds. It's not part of my natural workflow, so it feels clunky.

### Then What?
If we should **never** use `git add .`, then what should we use?

On Twitter a few weeks ago, I saw @systemdesign42 post [his top 4 git commands](https://twitter.com/systemdesign42/status/1745433212589936659). In there was `git add -i`. Stage files interactively. 

### git add -i
I have been using git for 7 years and have never seen the interactive form of git add. I tried it immediately and found it incredibly intuitive. I can add edited files, untracked files, and undo the mistakes.

I have been deliberately using the interactive mode in an effort to break old habits. Now that I use it daily, I find the selective staging forces me to look at each edited file before staging a commit, in fact I don't think I've had to use my `git undo` alias since.

Maybe I'm late to the game on this, but if you find yourself in the same position, try putting `git add -i` into your daily workflow.

ref:
https://git-scm.com/book/en/v2/Git-Tools-Interactive-Staging
