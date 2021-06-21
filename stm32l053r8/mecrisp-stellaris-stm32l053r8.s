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

	.syntax unified
	.cpu cortex-m0
	.thumb

	@ Swiches for capabilities of this chip

	.equ m0core, 1
	.equ erasedflashcontainszero, 1
	.equ emulated16bitflashwrites, 1
	@ Not available: .equ charkommaavailable, 1

	@ Start with some essential macro definitions

	.include "../common/datastackandmacros.s"

	@ Memory map for Flash and RAM

	.equ RAM_START, 0x20000000 @ Start of RAM
	.equ RAM_END,   0x20002000 @ End   of RAM. 20 kb

	@ Konstanten für die Größe und Aufteilung des Flash-Speichers

	.equ Kernschutzadresse,      0x00004000 @ Mecrisp core never writes flash below this address.
	.equ FLASH_DICTIONARY_START, 0x00004000 @ 16k Flash reserved for core.
	.equ FLASH_DICTIONARY_END,   0x00010000 @ 192k total Flash. Porting: Change this !
	.equ Backlinkgrenze,         RAM_START  @ Ab dem Ram-Start.

	@ Flash start - Vector table has to be placed here

	.text    @ Hier beginnt das Vergnügen mit der Stackadresse und der Einsprungadresse
	.include "vectors.s" @ You have to change vectors for Porting !

	@ Include the Forth core of Mecrisp-Stellaris

	.include "../common/forth-core.s"

Reset: @ Einsprung zu Beginn
	@ Initialisations for Terminal hardware, without Datastack.
	bl uart_init

	@ Catch the pointers for Flash dictionary
	.include "../common/catchflashpointers.s"

	welcome " with M0 core for STM32L053R8 by Matthias Koch"

	@ Ready to fly !
	.include "../common/boot.s"
