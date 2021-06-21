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

@ Terminal code and initialisations.

@ choose which USART you want to use for the Forth interactive terminal
@ default: USART2 (pins PA2 TX and PA3 RX), access thru the ST-Link /dev/ttyACMx terminal
@ option:  USART1 (pins PA9 TX and PA10 RX), connect your own 3.3V serial line here

	.equ use_usart_1, 1 @ set this to 1 if you want to use USART1, default 0 for USART2

	.equ FLASH_Base,    0x40022000		@ Flash control register base
	.equ FLASH_ACR,     FLASH_Base + 0x00	@ Flash Access Control Register

	.equ GPIOA_BASE,    0x50000000
	.equ GPIOA_MODER,   GPIOA_BASE + 0x00
	.equ GPIOA_OTYPER,  GPIOA_BASE + 0x04
	.equ GPIOA_OSPEEDR, GPIOA_BASE + 0x08
	.equ GPIOA_PUPDR,   GPIOA_BASE + 0x0C
	.equ GPIOA_IDR,     GPIOA_BASE + 0x10
	.equ GPIOA_ODR,     GPIOA_BASE + 0x14
	.equ GPIOA_BSRR,    GPIOA_BASE + 0x18
	.equ GPIOA_LCKR,    GPIOA_BASE + 0x1C
	.equ GPIOA_AFRL,    GPIOA_BASE + 0x20
	.equ GPIOA_AFRH,    GPIOA_BASE + 0x24
	.equ GPIOA_BRR,     GPIOA_BASE + 0x28

	.equ GPIOB_BASE,    0x50000400
	.equ GPIOB_MODER,   GPIOB_BASE + 0x00
	.equ GPIOB_OTYPER,  GPIOB_BASE + 0x04
	.equ GPIOB_OSPEEDR, GPIOB_BASE + 0x08
	.equ GPIOB_PUPDR,   GPIOB_BASE + 0x0C
	.equ GPIOB_IDR,     GPIOB_BASE + 0x10
	.equ GPIOB_ODR,     GPIOB_BASE + 0x14
	.equ GPIOB_BSRR,    GPIOB_BASE + 0x18
	.equ GPIOB_LCKR,    GPIOB_BASE + 0x1C
	.equ GPIOB_AFRL,    GPIOB_BASE + 0x20
	.equ GPIOB_AFRH,    GPIOB_BASE + 0x24
	.equ GPIOB_BRR,     GPIOB_BASE + 0x28

	.equ RCC_BASE,    0x40021000
	.equ RCC_CR,      RCC_BASE + 0x00
	.equ RCC_CFGR,    RCC_BASE + 0x0C
	.equ RCC_IOPENR,  RCC_BASE + 0x2C
	.equ RCC_AHBENR,  RCC_BASE + 0x30
	.equ RCC_APB2ENR, RCC_BASE + 0x34
	.equ RCC_APB1ENR, RCC_BASE + 0x38

	.equ PWR_BASE, 0x40007000
	.equ PWR_CR,   PWR_BASE + 0x00
	.equ PWR_CSR,  PWR_BASE + 0x04

	.if use_usart_1
	.equ Terminal_USART_Base,  0x40013800 @ USART1, pins PA9 TX and PA10 RX
	.else
	.equ Terminal_USART_Base,  0x40004400 @ USART2, ST-Link integrated terminal
	.endif
	.equ Terminal_USART_CR1,  Terminal_USART_Base + 0x00
	.equ Terminal_USART_CR2,  Terminal_USART_Base + 0x04
	.equ Terminal_USART_CR3,  Terminal_USART_Base + 0x08
	.equ Terminal_USART_BRR,  Terminal_USART_Base + 0x0C
	.equ Terminal_USART_GTPR, Terminal_USART_Base + 0x10
	.equ Terminal_USART_RTOR, Terminal_USART_Base + 0x14
	.equ Terminal_USART_RQR,  Terminal_USART_Base + 0x18
	.equ Terminal_USART_ISR,  Terminal_USART_Base + 0x1C
	.equ Terminal_USART_ICR,  Terminal_USART_Base + 0x20
	.equ Terminal_USART_RDR,  Terminal_USART_Base + 0x24
	.equ Terminal_USART_TDR,  Terminal_USART_Base + 0x28

	@ flags in the USART_ISR register
	.equ RXNE, BIT5
	.equ TC,   BIT6
	.equ TXE,  BIT7
@ -----------------------------------------------------------------------------
blink:
	ldr r1, =GPIOB_MODER
	ldr r0, =0x7fffffff
	str r0, [r1]
	ldr r1, =GPIOB_BSRR
	ldr r2, =0x00008000
	ldr r3, =0x80000000
loop:	str r2, [r1]
	nop
	nop
	nop
	str r3, [r1]
	nop
	nop
	b loop

uart_init: @ ( -- )
	@ Turn on the clocks for all GPIOs.
	ldr r1, =RCC_IOPENR
	ldr r0, =BIT0 + BIT1 + BIT2 + BIT3 + BIT4 + BIT7 @ IOPAEN IOPBEN IOPCEN IOPDEN IOPEEN IOPHEN
	str r0, [r1]

	b blink

	@ Switch internal voltage regulator to high-performance "Range 1"
	ldr r1, =PWR_CR
	ldr r0, =BIT11
	str r0, [r1]

	ldr r1, =FLASH_ACR
	ldr r0, =0x00000001	@ 1 wait state
	str r0, [r1]

	@ Configure PLL
	ldr r1, =RCC_CFGR
	ldr r0, =0x44450000	@ MCO = SYSCLK/16; PLLCLK = 16 MHz * 4 / 2
	str r0, [r1]

	@ Turn on HSE and PLL
	ldr r1, =RCC_CR
	ldr r0, =0x00010000	@ HSE on
	str r0, [r1]
	ldr r2, =0x00020000
1:	ldr r0, [r1]      	@ Check HSERDY flag
	ands r0, r2
	beq 1b
	ldr r0, =0x01010000	@ PLL on, HSE on
	str r0, [r1]
	ldr r2, =0x02000000
1:	ldr r0, [r1]		@ Check PLLRDY flag
	ands r0, r2
	beq 1b

	@ Set system clock to PLL
	ldr r1, =RCC_CFGR
	ldr r0, [r1]
	movs r2, #0x03
	orrs r0, r2
	str r0, [r1]
	ldr r2, =0x0000000c
1:	ldr r0, [r1]
	ands r0, r2
	cmp r0, r2
	bne 1b

	.if use_usart_1
	@ Turn on the clock for USART1.
	ldr r1, =RCC_APB2ENR
	ldr r0, =BIT14		@ USART1EN
	str r0, [r1]
	@ Set PORTA pins 9 and 10 in alternate function mode
	ldr r1, =GPIOA_MODER
	ldr r0, =0xEBEBFCFF	@ EBFF FCFF is reset value for Port A
	str r0, [r1]
	@ Set alternate function 4 to enable USART1 pins on Port A
	ldr r1, =GPIOA_AFRH
	ldr r0, =0x440		@ PA9 TX and PA10 RX
	str r0, [r1]
	.else
	@ Turn on the clock for USART2.
	ldr r1, =RCC_APB1ENR
	ldr r0, =BIT17		@ USART2EN
	str r0, [r1]
	@ Set PORTA pins 2 and 3 to alternate function mode, Nucleo connects them to ST-LINK terminal
	ldr r1, =GPIOA_MODER
	ldr r0, =0xEBEBFCAF	@ EBFF FCFF is reset value for Port A
	str r0, [r1]
	@ Set alternate function 4 to enable USART2 pins on Port A
	ldr r1, =GPIOA_AFRL
	ldr r0, =0x4400		@ PA2 TX and PA3 RX
	str r0, [r1]
	.endif

	@ Configure BRR by deviding the bus clock with the baud rate
	ldr r1, =Terminal_USART_BRR
	ldr r0, =0x116		@ 115200 bps at 32 MHz
	str r0, [r1]

	@ Enable the USART, TX, and RX circuit
	ldr r1, =Terminal_USART_CR1
	ldr r0, =BIT3 + BIT2 + BIT0 @ USART_CR1_UE | USART_CR1_TE | USART_CR1_RE
	str r0, [r1]

	ldr r1, =GPIOA_MODER
	ldr r0, [r1]
	ldr r2, =0x00020000
	ldr r3, =~0x00030000
	ands r0, r3
	orrs r0, r2
	str r0, [r1]

	bx lr

	.include "../common/terminalhooks.s"
@ -----------------------------------------------------------------------------
	defword Flag_visible, "serial-emit"
serial_emit: @ ( c -- ) Emit one character
	push {lr}

1:	bl serial_qemit
	cmp tos, #0
	drop
	beq 1b

	ldr r2, =Terminal_USART_TDR
	strb tos, [r2]         @ Output the character
	drop

	pop {pc}
@ -----------------------------------------------------------------------------
	defword Flag_visible, "serial-key"
serial_key: @ ( -- c ) Receive one character
	push {lr}

1:	bl serial_qkey
	cmp tos, #0
	drop
	beq 1b

	pushdatos
	ldr r2, =Terminal_USART_RDR
	ldrb tos, [r2]         @ Fetch the character

	pop {pc}
@ -----------------------------------------------------------------------------
	defword Flag_visible, "serial-emit?"
serial_qemit:  @ ( -- ? ) Ready to send a character ?
	push {lr}
	bl pause

	pushdaconst 0  @ False Flag
	ldr r0, =Terminal_USART_ISR
	ldr r1, [r0]     @ Fetch status
	movs r0, #TXE
	ands r1, r0
	beq 1f
	mvns tos, tos @ True Flag
1:	pop {pc}
@ -----------------------------------------------------------------------------
	defword Flag_visible, "serial-key?"
serial_qkey:  @ ( -- ? ) Is there a key press ?
	push {lr}
	bl pause

	pushdaconst 0  @ False Flag
	ldr r0, =Terminal_USART_ISR
	ldr r1, [r0]     @ Fetch status
	movs r0, #RXNE
	ands r1, r0
	beq 1f
	mvns tos, tos @ True Flag
1:	pop {pc}

	.ltorg @ Hier werden viele spezielle Hardwarestellenkonstanten gebraucht, schreibe sie gleich !
