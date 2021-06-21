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

@ Code for interrupt handlers that are exchangeable on the fly

@ All interrupt handlers work the same way and are generated with a macro:

	interrupt wwdg
	interrupt pvd
	interrupt rtc_tamp
	interrupt flash
	interrupt rcc
	interrupt exti0_1
	interrupt exti2_3
	interrupt exti4_15
	interrupt ucpd1_ucpd2
	interrupt dma_channel1
	interrupt dma_channel2_3
	interrupt dma_channel4_5_6_7_dmamux
	interrupt adc
	interrupt tim1_up
	interrupt tim1_cc

	.ltorg

	interrupt tim2
	interrupt tim3
	interrupt tim6_dac_lptim1
	interrupt tim7_lptim2
	interrupt tim14
	interrupt tim15
	interrupt tim16
	interrupt tim17
	interrupt i2c1
	interrupt i2c2
	interrupt spi1
	interrupt spi2
	interrupt usart1
	interrupt usart2
	interrupt usart3_usart4_lpuart1
	interrupt cec
	interrupt aes_rng
