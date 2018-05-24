
from pynput.keyboard import Key, Controller
import time

a = Controller ()
b = 0
c = 1.6

time.sleep (3)

while b <= 7200:
    time.sleep (c)
    a.press    (Key.enter)
    a.release  (Key.enter)
    b += c
