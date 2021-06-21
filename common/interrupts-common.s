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

@ Common interrupt helpers

@ -----------------------------------------------------------------------------
	defword Flag_visible, "eint?" @ ( -- ) Are Interrupts enabled ?

	pushdatos
	mrs tos, PRIMASK
	subs tos, #1
	sbcs tos, tos
	bx lr

@ -----------------------------------------------------------------------------
	defword Flag_inline, "eint" @ ( -- ) Enables Interrupts

	cpsie i @ Interrupt-Handler
	bx lr

@ -----------------------------------------------------------------------------
	defword Flag_inline, "dint" @ ( -- ) Disables Interrupts

	cpsid i @ Interrupt-Handler
	bx lr

@ -----------------------------------------------------------------------------
	defword Flag_inline, "ipsr" @ ( -- int ) Read IPSR by Mark Schweizer

	pushdatos
	mrs tos, ipsr
	bx lr

@ -----------------------------------------------------------------------------
	defword Flag_visible, "nop" @ ( -- )	Handler for unused hooks

nop_vector:
	bx lr

@ -----------------------------------------------------------------------------
	defword Flag_visible, "unhandled"	@ Message for wild interrupts
						@ and handler for unused interrupts
unhandled:
	push {lr}
	@ writeln "Unhandled Interrupt !"
	write "Unhandled Interrupt "
	pushdatos
	mrs tos, ipsr
	bl hexdot
	writeln "!"
	pop {pc}

@ -----------------------------------------------------------------------------
	defword Flag_visible, "reset" @ ( -- ) Hardware level reset

restart:
	ldr r0, =0xE000ED0C
	ldr r1, =0x5FA0004
	str r1, [r0]

@ -----------------------------------------------------------------------------
@ Interrupt handler trampoline macro

	.macro interrupt Name

	defword Flag_visible|Flag_variable, "irq-\Name" @ ( -- addr )
	CoreVariable irq_hook_\Name

	pushdatos
	ldr tos, =irq_hook_\Name
	bx lr
	.word unhandled				@ Start value for unused interrupts

irq_vector_\Name:
	.ifdef m0core
	ldr r0, =irq_hook_\Name
	.else
	movw r0, #:lower16:irq_hook_\Name
	movt r0, #:upper16:irq_hook_\Name
	.endif

	ldr r0, [r0]	@ Cannot ldr to PC directly, as this would require bit 0 to be set accordingly.
	mov pc, r0	@ No need to make bit[0] uneven as 16-bit Thumb "mov" to PC ignores bit 0.
			@ Code returns itself

	@ 3.6.1 ARM-Thumb interworking
	@       Thumb interworking uses bit[0] on a write to the PC to determine the CPSR T bit. For 16-bit instructions,
	@       interworking behavior is as follows:
	@       *     ADD (4) and MOV (3) branch within Thumb state ignoring bit[0].
	@       For 32-bit instructions, interworking behavior is as follows:
	@       *     LDM and LDR support interworking using the value written to the PC.

	.endm
@------------------------------------------------------------------------------
	.macro initinterrupt Name, Asmname, Routine

	defword Flag_visible|Flag_variable, "irq-\Name" @ ( -- addr )
	CoreVariable irq_hook_\Name

	pushdatos
	ldr tos, =irq_hook_\Name
	bx lr
	.word \Routine				@ Start value for unused interrupts

\Asmname:
	.ifdef m0core
	ldr r0, =irq_hook_\Name
	.else
	movw r0, #:lower16:irq_hook_\Name
	movt r0, #:upper16:irq_hook_\Name
	.endif

	ldr r0, [r0]		@ Cannot ldr to PC directly, as this would require bit 0 to be set accordingly.
	mov pc, r0		@ No need to make bit[0] uneven as 16-bit Thumb "mov" to PC ignores bit 0.
				@ Code returns itself
	.endm
@ -----------------------------------------------------------------------------
@ Common interrupt handlers for all targets

	interrupt systick
	initinterrupt fault, faulthandler, unhandled
	initinterrupt collection, nullhandler, unhandled

@ -----------------------------------------------------------------------------
@ Register map for reference purposes

@  Register map and interrupt entry push sequence:
@  r0  Saved by IRQ entry
@  r1  Saved by IRQ entry
@  r2  Saved by IRQ entry
@  r3  Saved by IRQ entry
@
@  r4  Is saved by code for every usage
@  r5  Is saved by code for every usage
@  r6  No need to save TOS
@  r7  No need to save PSP
@
@  r8  Unused
@  r9  Unused
@  r10 Unused
@  r11 Unused
@  r12 Unused, but saved by IRQ entry
@
@  r13 = sp
@  r14 = lr
@  r15 = pc
