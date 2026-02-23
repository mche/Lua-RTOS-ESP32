<?lua
    local mylib = require "/mylib/pwm16"
    mylib.pwm16()
    print("The PWM pin 16 is starting!")
    

-- os.remove('/www/do/pwm16.lua')
-- os.remove('/www/do/pwm16.luap')
-- $ ./wcc -p /dev/ttyUSB0 -d -up www/do/pwm16.lua /www/do/pwm16.lua

?>
