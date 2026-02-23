local myPwm = {}
local lock = {}
-- таймеры нужно сохранять
local myTmr = {}

local pwm16 = function ()
    -- print("before coroutine.yield")
    -- coroutine.yield(os.time())
    -- print("after coroutine.yield")
    for d = 0, 0.3, 0.02 do
        myPwm["16"]:setduty(d)
        tmr.sleepms(500)
    end

    -- tmr.sleepms(1000)

    for d = 1, 0.7, -0.02 do
        myPwm["16"]:setduty(d)
        tmr.sleepms(500)
    end
    -- myPwm["16"]:stop()
    -- myPwm["16"]:detach()

end
-- co_pwm16 = coroutine.create(f2)
-- print("coroutine.create")



-- lock["2"] = false
-- lock["16"] = false

--  function
local bg = function(func, lk)
    if lock[lk] then
        return false
    end
    lock[lk] = true
    print("bg start working...", myTmr[lk])
    func()
    myTmr[lk]:stop()
    -- tm:detach()
    lock[lk] = false
    print("bg done works", myTmr[lk])
    return true
end



return {
    blink2 = function ()
        if lock["2"] then
            print("locked already")
            return false
        end
        -- Configure the GPIO where the led is attached
        pio.pin.setdir(pio.OUTPUT, pio.GPIO2)
        pio.pin.sethigh(pio.GPIO2)
        local f = function ()
            for d = 0, 3, 0.5 do
                pio.pin.inv(pio.GPIO2)
                tmr.sleepms(500)
            end
        end
        -- local tm
        if myTmr["2"] == nil then
            myTmr["2"] = tmr.attach(1, function() bg(f, "2") end) -- tmr.TMR0,
            print("tmr.attach", myTmr["2"])
        end
        myTmr["2"]:stop()
        myTmr["2"]:start()
        return true
    end,
    pwm16 = function ()
        if lock["16"] then
            print("locked already")
            return false
        end
        if myPwm["16"] == nil then
            myPwm["16"] = pwm.attach(pio.GPIO16, 10, 0)
        end
        myPwm["16"]:stop()
        -- Set frequency to Hz
        myPwm["16"]:setfreq(100)
        myPwm["16"]:setduty(0)
        -- Start the PWM generation
        myPwm["16"]:start()



        -- local tm
        if myTmr["16"] == nil then
            local f = function ()
                pwm16()
            end
            myTmr["16"] = tmr.attach(1, function() bg(f, "16") end) -- tmr.TMR0,
            print("tmr.attach", myTmr["16"])
        end
        
        myTmr["16"]:stop()
        myTmr["16"]:start()
        return true

    end,
    loop16 = function (frq)
        -- mylib = require "/mylib/pwm16"

        -- mylib.loop16(77)
        -- mylib.loop16(79)
        -- mylib.loop16(85) неплохо
        -- mylib.loop16(19)
        -- mylib.loop16(39)
        -- mylib.loop16(44)
        if myPwm["16"] == nil then
            myPwm["16"] = pwm.attach(pio.GPIO16, 10, 0)
        end

        myPwm["16"]:stop()
        -- Set frequency to Hz
        myPwm["16"]:setfreq(frq)
        myPwm["16"]:setduty(0)
        -- Start the PWM generation
        myPwm["16"]:start()

        -- for d = 0, 1, 0.01 do
        --     myPwm["16"]:setduty(d)
        --     tmr.sleepms(2000)
        -- end


        for d = 1, 0, -0.01 do
            myPwm["16"]:setduty(d)
            tmr.sleepms(3000)
        end

        myPwm["16"]:stop()

    end

}

-- os.mkdir('/mylib')
-- $ ./wcc -p /dev/ttyUSB0 -d -up mylib/pwm16.lua /mylib/pwm16.lua
-- $ picocom --baud 115200 /dev/ttyUSB0
-- / > mylib = require "/mylib/pwm16"
-- mylib.blink()
-- / > mylib.pwm16.do2()


