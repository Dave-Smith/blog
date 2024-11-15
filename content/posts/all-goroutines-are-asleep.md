+++
date = '2024-02-02T20:13:30-06:00'
draft = false
title = 'Exercises in Concurrency - All Goroutines are Asleep!'
+++

## How It Started

I saw the [One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) at the beginning of January and was immediately intrigued. This is not about the challenge (more on that later), but instead my side quest in troubleshooting concurrency. After I found a fasting way to read a large file I decided that concurrency will make everything better, ya know, make all the cores work :wink:. I fill a buffer, send it to a pool of workers to do slow string functions, then combine results. Easy, right? I write the code yada yada yada, *fatal error: all Goroutines are asleep - deadlock!* 

The error:

```
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [semacquire]:
sync.runtime_Semacquire(0xc00001e0c0?)

```

The code. Can you see my mistake before reading on?

```go
const workers int = 32
const chunkSize int = 8 * 1024 * 1024

func chunkedReadWithWorkerPool(filename string) {
	chunks := make(chan []byte, 100)
	res := make(chan int)
	wg := &sync.WaitGroup{}

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go worker(chunks, res, wg)
	}

	go readChunks(filename, chunks)

	length := 0
	length += <-res
	wg.Wait()
	close(res)
}

func worker(chunks <-chan []byte, res chan<- int, wg *sync.WaitGroup) {
	wg.Add(1)
	defer wg.Done()
	length := 0
	reads := 0
	for in := range chunks {
		length += len(in)
		reads++
	}
	log.Printf("read %d bytes, in %d reads\n", length, reads)
	res <- length
}

func readChunks(filename string, chunks chan []byte) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	newLine := byte('\n')
	r := bufio.NewReaderSize(file, chunkSize+64)
	for {
		buf := make([]byte, chunkSize)
		n, err := r.Read(buf)
		if n == 0 {
			if err == io.EOF {
				break
			}
			if err != nil {
				fmt.Printf(err.Error())
			}
		}
		b, err := r.ReadBytes(newLine)
		if err == nil || err == io.EOF {
			buf = append(buf, b...)
		} else {
			fmt.Printf(err.Error())
		}
		chunks <- buf
	}
	log.Println("finished reading file. Closing channel")
	close(chunks)
}
```

## Okaaaaaay

The google results for the error message all tell me that a channel is not getting closed. I attach the debugger and the debugger never goes past the `wg.Wait()` function. Thinking it is a problem with the `res` channel, I removed the results channel from the solution. Same error, but only one goroutine is throwing an error now. 

The internet recommended that the worker should be in a closure to make sure the it tells the WaitGroup it is done. 

Same error.
```go
go func() {
    defer wg.Done()
    worker(chunks, wg)
}
``` 


I decide o take a break from this and write about it in hopes of a mental breakthrough.

## Duh 

I feel dumb. I set this aside for a day and looked at it with fresh eyes. I added to the wait group inside the for loop and also in the worker function :grimacing:. The wait group is incremented by 2 for each worker, but done is called once per worker. The wait group will wait forever. What is amazing is Go can detect this at runtime and panic. I must admit, I don't know how that works.

```go
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go worker(chunks, res, wg)
	}
```

## Some Reflection

Go makes concurrency easier than other languages, but concurrency will always be more challenging that synchronous code.

Why I am writing this when this is clearly not my best effort? I could just never mention this and the results is the same. Working through a challenging problem over an extended timeframe, finding a resolution (usually an aha moment) and reflecting on it could possibly be the best learning method. If you are experienced in Go, you likely would not have even made the mistake, I hope I don't toil on this same error in the future. 
