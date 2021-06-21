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
	.include "../include/stm32g0x1.inc"
@ ------
@ USART2_CTS	PA0	AF1
@ USART2_RTS	PA1	AF1
@ USART2_TX	PA2	AF1
@ USART2_RX	PA3	AF1
uart_init:
	@ Turn on GPIO clock(s)
	ldr r1, =RCC_IOPENR
	ldr r0, =RCC_IOPENR_GPIOAEN | RCC_IOPENR_GPIOBEN | RCC_IOPENR_GPIOCEN
	str r0, [r1]

	@ Set flash access latency: 2 cycles
	ldr r1, =FLASH_ACR
	ldr r0, [r1]
	ldr r2, =0x02
	orrs r0, r2
	str r0, [r1]

	@ Set PLLRCLK to 64 MHz
	ldr r1, =RCC_PLLCFGR
	ldr r0, =0x30001012
	str r0, [r1]
	ldr r1, =RCC_PLLCR
	ldr r0, [r1]
	ldr r2, =0x01000000
	orrs r0, r2
	str r0, [r1]
	ldr r2, =0x02000000
1:	ldr r0, [r1]
	tst r0, r2
	beq 1b

	@ Switch system clock to PLLRCLK, PCLK = HCLK/4
	ldr r1, =RCC_CFGR
	ldr r0, [r1]
	ldr r2, =0x07
	bics r0, r2
	ldr r2, =0x5002
	orrs r0, r2
	str r0, [r1]
	ldr r2, =0x38
	ldr r3, =0x10
1:	ldr r0, [r1]
	ands r0, r2
	cmp r0, #0x10
	bne 1b

	@ Turn on USART2 clock
	ldr r1, =RCC_APBENR1
	ldr r0, =RCC_APBENR1_USART2EN
	str r0, [r1]

	@ Set PORTA pins: 2, 3 to alternate function
	@ldr r1, =GPIOA_MODER
	@ldr r0, =0xEAFFFFAF
	@str r0, [r1]
	@ldr r1, =GPIOA_AFRL
	@ldr r0, =0x00001100
	@str r0, [r1]

	@ Set PORTA pins: 0, 1, 2, 3 to alternate function
	ldr r1, =GPIOA_MODER
	ldr r0, =0xEAFFFFAA
	str r0, [r1]
	ldr r1, =GPIOA_AFRL
	ldr r0, =0x00001111
	str r0, [r1]

	@ Set baud rate
	ldr r1, =USART2_BRR
	@ldr r0, =32		@ 16 MHz, 500 kbps
	ldr r0, =16		@ 16 MHz, 1 Mbps
	str r0, [r1]

	@ Overrun Disable
	ldr r1, =USART2_CR3
	ldr r0, =USART_CR3_OVRDIS
	str r0, [r1]

	@ Enable USART TX & RX
	ldr r1, =USART2_CR1
	ldr r0, =USART_CR1_UE | USART_CR1_TE | USART_CR1_RE
	str r0, [r1]
	@ Enable USART CTS/RTS
	ldr r1, =USART2_CR3
	ldr r0, =USART_CR3_RTSE | USART_CR3_CTSE
	str r0, [r1]

	bx lr

	.include "../common/terminalhooks.s"
@ ------
	defword Flag_visible, "serial-emit"
serial_emit: @ ( c -- ) Emit one character
	push {lr}

1:	bl serial_qemit
	cmp tos, #0
	drop
	beq 1b

	ldr r2, =USART2_TDR
	strb tos, [r2]         @ Output the character
	drop

	pop {pc}
@ ------
	defword Flag_visible, "serial-key"
serial_key: @ ( -- c ) Receive one character
	push {lr}

1:	bl serial_qkey
	cmp tos, #0
	drop
	beq 1b

	pushdatos
	ldr r2, =USART2_RDR
	ldrb tos, [r2]         @ Fetch the character

	pop {pc}
@ ------
	defword Flag_visible, "serial-emit?"
serial_qemit:  @ ( -- ? ) Ready to send a character ?
	push {lr}
	bl pause
	movs r2, #USART_ISR_TXE
	b.n serial_qkey_intern
@ ------
	defword Flag_visible, "serial-key?"
serial_qkey:  @ ( -- ? ) Is there a key press ?
	push {lr}
	bl pause
	movs r2, #USART_ISR_RXNE

serial_qkey_intern:
	pushdaconst 0  @ False Flag
	ldr r0, =USART2_ISR
	ldr r1, [r0]     @ Fetch status
	ands r1, r2
	beq 1f
	mvns tos, tos @ True Flag
1:	pop {pc}

	.ltorg @ Hier werden viele spezielle Hardwarestellenkonstanten gebraucht, schreibe sie gleich !
