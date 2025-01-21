+++
date = '2025-01-20T11:13:30-06:00'
draft = false
title = 'Building a Battlesnake - How I Let Claude Do All the Hissing'
+++

This year was my second time building a [Battlesnake](https://play.battlesnake.com). With the experience from a couple of years ago, I wanted to do something different. Last time I used the experience to learn a new language - Go (Go is great btw). I planned on using the same language and I definitely planned on using AI to help with writing the code this time around. Then the idea hit me.

I didn't write any of the code. Huh? I used [Claude AI](https://claude.ai) to **generate all the code**. Well, kinda - I wrote the http server part to route a request to a function. If you were curious why I named my snake Claudia, well thats why.

>What the heck is a Battlesnake? You've played the snake game, right? Same thing, except your code decides the next move. Host your code as an API that accepts a POST request and respond with your next move. If you are curious what my code looks like, see for yourself - https://github.com/Dave-Smith/Battlesnake-go-2025.

I'm not talking about using Copilot autocomplete. I gave Claude an example http request body, described the rules of the game and asked it to generate the necessary in Go to move a battlesnake. A quick ctrl-c, ctrl-v later and the generated code was hooked up to an http endpoint. I ran the code and it worked!

My early success was limited to wandering and not running into walls. That's great and all, but I'm not winning games like that. I gave Claude more specific instructions. Don't prioritize eating food until health is running low. Evaluate dead-ends to avoid tunnels. Don't be the smallest snake on the board. Anticipate intent of other snakes. Apply higher penalty for deadly moves. Avoid head to head collisions. Explain the code you just wrote. Allow my snake to move to a space currently occupied to a snake tail.

I saw better results after each instruction.

> Getting real specific with Claude. I also included a json gamestate file for context and further analysis.
```
this works very well against a good player and another instance of the same snake. one test showed a questionable choice to move into a dead end instead of moving into the coordinate currently occupied by the tail of another snake. see the last 3 moves of of this test game. the snake with name Claudia turned right, into a dead end tunnel instead of left which was occupied by Cal's tail and would have been an open space to move into. Can you adjust for this scenario
```

After each prompt, I copied the new code to the app. Reviewed changes, and tested by running against other snakes. I tested each iteration in a simulated game at least 20 times, looking for better ways to play the game. I spent only a few minutes between each modification and testing cycle. I found this testing feedback loop fast and effective.

> Speaking of testing, there is an official testing CLI that lets you run games locally requiring just the terminal. The game below plays 4 snakes and shows each move on the board. I found this essential in testing. See the Battlesnake CLI below for info.
``` bash
./battlesnake play -W 13 -H 13 --name 'claudia' --url http://localhost:8080/claudia --name 'claude' --url http://localhost:8081/claudia --name 'cal' --url http://localhost:8080/claudia --name 'cow' --url http://localhost:8081/coward --viewmap --delay 200 --output './gamestate'
```

I continued this loop until I ran out of tokens for a single conversation with Claude. I decided to end the experiment with what I had. It was far from a championship Battlesnake, but worked well in many scenarios. I put the entire Claude conversation in the GitHub repo [`chat.json`](https://github.com/Dave-Smith/Battlesnake-go-2025/blob/main/chat.json) for the curious minded.

Why do this? I have used a few online apps that use LLM prompts to build and host fully functioning apps. That gave me the inspiration to have an LLM write all the code. I wanted to see how far I could take this using only english language prompts.

> Side Note: [Val Townie](https://www.val.town) was an inspiration for this experiment. They take everything a step further by hosting the app that is generated. I have used Val for a few websites and found it both fun and useful. I didn't use Val for Battlesnakes, but it would be fun to try.

Is this cheating, is this programming? I don't know, maybe, maybe not. I reviewed every line of code, many times. I tested this more than I have ever tested something, well I had tons of time to test because I wasn't writing the code or debugging out of range errors. I still had to ask Claude very specific questions giving examples with data and expected results. Review, test, refine, rinse repeat. Kinda sounds like programming, right?

Is it safe to trust AI with writing all the code? In this case, 90% yes. I mean, its just a game. I will use different judgement based on the nature of an app, game, marketing website, bash script, single purpose serverless apps, legacy code supporting a critical business process. The last example, I wouldn't ask AI to generate all the code. Too risky given its status as legacy code and criticality. Would I use AI for autocomplete, asking for a summary, explanation, or asking advice? **Heck yeah**. Each situation has its own context and requires good judgement by the programmer.

A big reason for doing this is to learn something. Battlesnakes are fun to play, but if I didn't learn something new, it would have been a big time spend and not much else. Last time I learned a different programming language. This time I learned how far you can take an LLM to write an app.

How about you? What's your stance on AI in the realm of software development?

Tools used
- Development ([Go](https://go.dev),  [Air](https://github.com/air-verse/air), [HTTP server in the Go standard library](https://pkg.go.dev/net/http@go1.23.5), [Zed for the IDE](https://zed.dev))
- AI and Testing ([Claude AI](https://claude.ai), [Battlesnake CLI](https://github.com/BattlesnakeOfficial/rules/tree/main/cli))
- Version Control & Hosting ([GitHub](https://github.com/Dave-Smith/Battlesnake-go-2025), [Fly.io](https://fly.io))
- Game Platform ([Battlesnakes website](https://play.battlesnake.com))
- Essential Tools ([Ctrl-C Ctrl-V](https://www.amazon.com/BTXETUEL-Keyboard-Shortcut-Mechanical-Programmable/dp/B0BBW89CRY?th=1))
