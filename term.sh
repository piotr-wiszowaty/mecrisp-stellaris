#!/bin/sh
picocom -b 500000 /dev/ttyUSB0 --imap lfcrlf,crcrlf --omap delbs,crlf --flow n --send-cmd "./xfr.py -c -e -s -I $HOME/include/ARM/STM32F05x"
