+++
date = '2024-03-01T20:14:42-06:00'
draft = false
title = 'One Billion Row Challenge: way more than I thought'
+++

I found it like many other on January 1st, 2024. The [One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/). I was immediately hooked on the idea of doing this. I was coming off a disappointing non-finish of the Advent of Code and looking to redeem my incomplete effort. This was also the perfect opportunity to write some Go code and do my best to make it fast, like let's break some rules and make bad decisions. This is not intended to be about Go, it is just the language I used for the challenge. The Go terms and concepts used here apply to many languages.

## The Challenge
If you haven't heard of the challenge, visit the site linked above 👆 and check it out. The quick and dirty version of it is, given a file with one billion rows of weather station data, find the min, max and average from each weather station. Each row looks something like this `City Name;23.9` or `City Name;-15.6`. Use the standard library in your language of choice, no third-party packages. Simple enough in concept, right?

## How It Started
My approach seemed to naturally go to creating a `map[string[]float64]]`, read the data from the file into the map, then do the calculations. I'd use this as my starting point and iterate from there.

I went for it and started coding. Read a line from the file with a `bufio.Scanner`, parse the line, put it in a map, after reading the file, use math on all the results, and output it into a formatted string. Easy. I didn't want to wait for all 1 billion lines for my early tests, since I would be iterating over this. I used a 1 million line file to make the testing fast. Less than **two seconds** for a million rows. Not bad. 

I created the billion row file and ran against the big file. I waited for **minutes** ⏳. This was obviously not very good. I was hoping for under 30 seconds, and I have no idea where I came up with that math.

I had a place to start and compare.


![One Billion](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vxna6y44rblzanzz3qet.png)


## What Did I Learn from One Billion
Stating the obvious here, one billion is a lot. Things changed on me when I went to 100 million rows. One billion was yet another significant leap. What was fast and easy soon was slow and inefficient at one billion. I learned that even the smallest change can have a profound impact when the scale is large enough. Which operations did I touch that had a large impact at a scale of one billion?
- **Parsing numbers from a string**. It turns out there are many ways to do this. Not all are similar. My final solution scanned bytes from input to return an integer instead of a float.
- **Splitting strings with a delimiter**. My solution here? Again, scanning bytes to split a byte slice.
- **Reading data from a file**. Line by line, multiple lines, chunked bytes? I landed on reading chunks of a byte slice using the `bufio.Reader.Read` function. I played with the buffer size and had similar results in the 4 - 32 MB buffer size. Anything outside that range caused slower reads.
- **Map lookups**. Not as fast as I thought. Can I do better with hashing. I achieved faster map lookup times when I hashed the weather station name, at the cost of additional complexity. I backed out the change and hope to revisit it.
- **Division**. Yeah, the math one, do it a billion times or just a couple hundred? I didn't catch this until I read other solutions and blog posts. I was calculating the average for a weather station each time I added a new measurement. This involved float division and I found this to be slow enough to be noticeable. 
- **Concurrency**. Of course. One goroutine to produce chunks from the file, and a set of worker goroutines to process the chunks.
- **Allocations**. Is this operation causing a heap allocation or is it on the stack? I know you are supposed to let the Go compiler determine where data is stored, however I made every attempt to limit heap allocations.

## How It Ended
I wanted to do a deep dive of the code and the steps I took. I'm not doing that. You can see my [code](https://github.com/dave-smith/1brc-go) on GitHub if you are interested. There are some really good posts detailing the iterations to get faster and faster, this one by [Shraddha Agrawal](https://www.bytesizego.com/blog/one-billion-row-challenge-go) is fantastic and worth your time to read. I chose to end this after getting it to about 80 seconds. I stopped working on it because I had learned a significant amount of Go and how to make it fast. I came for the challenge and walked away with more knowledge than I planned.

## Deep Thoughts
How the heck do databases do stuff like this? Seriously. I was only doing a min, max and average on a simple dataset, large but simple. How do database engines do this for an arbitrary table. I have a new appreciation for databases now. I'd like to learn how database queries do this.

Honestly, I can get away with writing some real crappy code and still process a million rows fast. Maybe not that crappy but starting simple is often fast enough. Especially with Go.

I can do a lot of stuff with only the Go standard library. I never even thought of reaching for a third-party library. Concurrency is built-in along with everything else needed for this problem.

This is the perfect challenge for anyone learning a new language, or looking to do a deep dive on performance or dig one level deeper. Some of the thoughts and questions in the list above forced me to look at the implementation of the function in the standard library. I found many instances where the function in the standard library was not the fastest. String splitting, parsing numbers from strings and a few others. They are probably the best for general purpose use if you aren't processing one billion rows. Regardless, I now know how strings are split with a delimiter in the Go standard library.

## Closing
What did I learn? Start simple and measure everything. Get good at profiling and tracing tools. Question everything. I made too many assumptions just using prior experience as my guide. I never thought to question floating point number math. I should have. Learn the implementation of your language and its standard library. Learn one level deeper than where you work, there are so many amazing things just beneath the surface. Finally, sometimes the simplest solution is good enough most days.
