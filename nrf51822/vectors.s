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

@ -----------------------------------------------------------------------------
@ Interruptvektortabelle
@ -----------------------------------------------------------------------------

.include "../common/vectors-common.s"

@ Special interrupt handlers for this particular chip:

.word irq_vector_power+1 	/*  0 POWER_CLOCK */
.word irq_vector_radio+1 	/*  1 RADIO */
.word irq_vector_uart+1		/*  2 UART0 */
.word irq_vector_spi0+1		/*  3 SPI0_TWI0 */
.word irq_vector_spi1+1		/*  4 SPI1_TWI1 */
.word 0				/*  5 Reserved */
.word irq_vector_gpiote+1	/*  6 GPIOTE */
.word irq_vector_adc+1  	/*  7 ADC */
.word irq_vector_tim0+1  	/*  8 TIMER0 */
.word irq_vector_tim1+1		/*  9 TIMER1 */
.word irq_vector_tim2+1 	/* 10 TIMER2 */
.word irq_vector_rtc0+1		/* 11 RTC0 */
.word irq_vector_temp+1  	/* 12 TEMP */
.word irq_vector_rng+1  	/* 13 RNG */
.word irq_vector_ecb+1  	/* 14 ECB */
.word irq_vector_ccm_aar+1  	/* 15 CCM_AAR */
.word irq_vector_wdt+1  	/* 16 WDT */
.word irq_vector_rtc1+1  	/* 17 RTC1 */
.word irq_vector_qdec+1  	/* 18 QDEC */
.word irq_vector_lpcomp+1  	/* 19 LPCOMP */
.word irq_vector_swi0+1		/* 20 SWI0 */
.word irq_vector_swi1+1		/* 21 SWI1 */
.word irq_vector_swi2+1		/* 22 SWI2 */
.word irq_vector_swi3+1		/* 23 SWI3 */
.word irq_vector_swi4+1		/* 24 SWI4 */
.word irq_vector_swi5+1		/* 25 SWI5 */
.word 0				/* 26 Reserved */
.word 0				/* 27 Reserved */
.word 0				/* 28 Reserved */
.word 0				/* 29 Reserved */
.word 0				/* 30 Reserved */
.word 0				/* 31 Reserved */
