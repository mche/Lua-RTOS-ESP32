# Доброго времени и места

Залить прошивку
```
./wcc
смотри подсказку
```

Пример заливки файла (папку создавать внутри picocom)

```
guest@calculate ~/Lua-RTOS-ESP32 $ ./wcc -p /dev/ttyUSB0 -d -up mylib/pwm16.lua  /mylib/pwm16.lua

```


```
picocom --baud 115200 /dev/ttyUSB0
/ > mylib = require "/mylib/pwm16"
/ > mylib.loop16(39)
/ > mylib.loop16(79)
/ > mylib.loop16(85)

```