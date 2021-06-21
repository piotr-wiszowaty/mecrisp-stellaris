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

@ Common startup code for all implementations

@ Einige der Kernvariablen müssen hier unbedingt frisch gesetzt werden, damit quit nicht nach dem Init-Einsprung nochmal tätig werden muss.

	ldr r0, =konstantenfaltungszeiger
	movs r1, #0    			@ Clear constant folding pointer
	str r1, [r0]

	.ifdef registerallocator
	bl init_register_allocator
	.endif

	@ Search for current init definition in dictionary:
	pushdatos
	ldr tos, =init_name
	pushdaconst 4
	bl find
	drop				@ No need for flags
	cmp tos, #0
	beq 1f
	@ Found!
	bl execute
	ldr r0, =quit_intern
	mov pc, r0
1:	drop				@ Drop 0-address of find to keep magic TOS value intact.
	ldr r0, =quit
	mov pc, r0

init_name:
	.byte 105, 110, 105, 116	@ "init"

	.ltorg				@ Ein letztes Mal Konstanten schreiben
