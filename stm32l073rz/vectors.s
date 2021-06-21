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

	.include "../common/vectors-common.s"

	@ Special interrupt handlers for this particular chip:

	.word irq_vector_wwdg+1			@  0
	.word irq_vector_pvd+1			@  1
	.word irq_vector_rtc+1			@  2
	.word irq_vector_flash+1		@  3
	.word irq_vector_rcc_crs+1		@  4
	.word irq_vector_exti0_1+1		@  5
	.word irq_vector_exti2_3+1		@  6
	.word irq_vector_exti4_15+1		@  7
	.word irq_vector_touch+1		@  8
	.word irq_vector_dma1+1			@  9
	.word irq_vector_dma2_3+1		@ 10
	.word irq_vector_dma4_7+1		@ 11
	.word irq_vector_adc+1			@ 12
	.word irq_vector_lptim1+1		@ 13
	.word irq_vector_usart4_usart5+1	@ 14
	.word irq_vector_tim2+1			@ 15
	.word irq_vector_tim3+1			@ 16
	.word irq_vector_tim6_dac+1		@ 17
	.word irq_vector_tim7+1			@ 18
	.word nullhandler+1			@ 19
	.word irq_vector_tim21+1		@ 20
	.word irq_vector_i2c3+1			@ 21
	.word irq_vector_tim22+1		@ 22
	.word irq_vector_i2c1+1			@ 23
	.word irq_vector_i2c2+1			@ 24
	.word irq_vector_spi1+1			@ 25
	.word irq_vector_spi2+1			@ 26
	.word irq_vector_usart1+1		@ 27
	.word irq_vector_usart2+1		@ 28
	.word irq_vector_rng+1			@ 29
	.word irq_vector_lcd+1			@ 30
	.word irq_vector_usb+1			@ 31
