@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ Routinen für die Interrupthandler, die zur Laufzeit neu gesetzt werden können.
@ Code for interrupt handlers that are exchangeable on the fly

@------------------------------------------------------------------------------
@ Alle Interrupthandler funktionieren gleich und werden komfortabel mit einem Makro erzeugt:
@ All interrupt handlers work the same way and are generated with a macro:
@------------------------------------------------------------------------------

interrupt rtc
interrupt exti0
interrupt exti1
interrupt exti2
interrupt exti3
interrupt exti4
interrupt adc
interrupt usb_hp_can_tx
interrupt usb_lp_can_rx0
interrupt exti5
interrupt tim1brk
interrupt tim1up
interrupt tim1trg
interrupt tim1cc
interrupt tim2
interrupt tim3
interrupt tim4
interrupt i2c1ev
interrupt i2c1er
interrupt i2c2ev
interrupt i2c2er
interrupt spi1
interrupt spi2
interrupt usart1
interrupt usart2
interrupt usart3
interrupt exti10
interrupt rtcalarm
interrupt usbwkup

interrupt tim5
interrupt spi3
interrupt uart4
interrupt uart5
interrupt tim6
interrupt tim7
interrupt usbfs

@------------------------------------------------------------------------------
