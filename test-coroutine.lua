-- A simple cooperative timer/scheduler in pure Lua
local function sleep(seconds)
    -- Calculate the end time
    local endTime = os.time() + seconds
    print("coroutine.yield", seconds)
    coroutine.yield(endTime - os.time())
    
    -- Keep yielding until the current time reaches the end time
    while os.time() < endTime do
        -- Yield control back to the main loop, optionally passing the remaining time
        print("After coroutine.yield", seconds)
        coroutine.yield(endTime - os.time())

    end
    -- The coroutine function will finish here when time is up
end

-- The task we want to run with a delay
local function delayed_task()
    print("Task started")
    -- print("Waiting for 3 seconds...")
    -- -- 'Call' the sleep function within the coroutine
    -- sleep(3)
    -- print("3 seconds passed. Task resumed.")
    
    print("Waiting for 1 second...")
    sleep(1)
    print("1 second passed. Task finished.")
end

-- Create the coroutine
local co = coroutine.create(sleep)
-- local co = coroutine.create(sleep)
if coroutine.status(co) ~= "dead" then
    local status, remaining_time = coroutine.resume(co, 3)
    print("coroutine status", status, remaining_time)
    coroutine.resume(co, 0)
end

-- The main loop acts as the scheduler
print("Main loop running...")
while false do -- coroutine.status(co) ~= "dead"
    -- Resume the coroutine
    local status, remaining_time = coroutine.resume(co)
    print("coroutine status", status, remaining_time)
    
    if coroutine.status(co) ~= "dead" then
        -- If the coroutine yielded (is suspended), the main loop can do other work
        -- In a real application (e.g., a game engine), you would process other events here.
        -- For this example, we use a blocking sleep (e.g., from LuaSocket or an OS call) 
        -- to simulate the passage of time without a game loop.
        -- In a game loop, you'd track deltatime instead of using os.time/socket.sleep.
        
        -- We'll use a small sleep to prevent a busy loop if the yield condition isn't met immediately.
        -- This part depends on having a function that can actually pause the main thread.
        -- If running in an environment with an event loop, this would just be the end of the frame.
        if remaining_time then
            print(string.format("Coroutine suspended, approx. %d seconds remaining. Main loop continues...", remaining_time))
            -- In a real scheduler, you'd add this coroutine to a queue sorted by wakeup time.
            -- This example just uses an immediate small sleep for demonstration purposes.
            -- (We can't use `sleep` here as it would block the main loop)
            -- If we have a system function for sleep:
            -- socket.sleep(math.min(remaining_time or 1, 0.1)) 
            -- We simulate work and wait by just running the loop again
        end
    end
end
print("Main loop finished.")
