
from pynput.keyboard import Key, Controller
import time

a = Controller ()
b = 0
c = 1.6

time.sleep (5)

while b != 3600:
    time.sleep (c)
    a.press    (Key.enter)
    a.release  (Key.enter)
    b += c
