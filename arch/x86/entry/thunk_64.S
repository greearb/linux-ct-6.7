/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * Save registers before calling assembly functions. This avoids
 * disturbance of register allocation in some inline assembly constructs.
 * Copyright 2001,2002 by Andi Kleen, SuSE Labs.
 */
#include <linux/export.h>
#include <linux/linkage.h>
#include "calling.h"
#include <asm/asm.h>

	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
	.macro THUNK name, func
SYM_FUNC_START(\name)
	pushq %rbp
	movq %rsp, %rbp

	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %rax
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11

	call \func

	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rax
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	popq %rbp
	RET
SYM_FUNC_END(\name)
	_ASM_NOKPROBE(\name)
	.endm

THUNK preempt_schedule_thunk, preempt_schedule
THUNK preempt_schedule_notrace_thunk, preempt_schedule_notrace
EXPORT_SYMBOL(preempt_schedule_thunk)
EXPORT_SYMBOL(preempt_schedule_notrace_thunk)
