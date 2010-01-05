	.section __DWARF,__debug_frame,regular,debug
Lsection__debug_frame:
	.section __DWARF,__debug_info,regular,debug
Lsection__debug_info:
	.section __DWARF,__debug_abbrev,regular,debug
Lsection__debug_abbrev:
	.section __DWARF,__debug_aranges,regular,debug
Lsection__debug_aranges:
	.section __DWARF,__debug_macinfo,regular,debug
Lsection__debug_macinfo:
	.section __DWARF,__debug_line,regular,debug
Lsection__debug_line:
	.section __DWARF,__debug_loc,regular,debug
Lsection__debug_loc:
	.section __DWARF,__debug_pubnames,regular,debug
Lsection__debug_pubnames:
	.section __DWARF,__debug_pubtypes,regular,debug
Lsection__debug_pubtypes:
	.section __DWARF,__debug_inlined,regular,debug
Lsection__debug_inlined:
	.section __DWARF,__debug_str,regular,debug
Lsection__debug_str:
	.section __DWARF,__debug_ranges,regular,debug
Lsection__debug_ranges:
	.section __DWARF,__debug_abbrev,regular,debug
Ldebug_abbrev0:
	.section __DWARF,__debug_info,regular,debug
Ldebug_info0:
	.section __DWARF,__debug_line,regular,debug
Ldebug_line0:
	.text
Ltext0:
	.literal4
	.align 2
_NUMBER_OF_CHANNELS:
	.long	4
	.align 2
_DISPLAY_IMAGE_WIDTH:
	.long	320
	.align 2
_DISPLAY_IMAGE_HEIGHT:
	.long	256
	.align 2
_SLICES_PER_ROW:
	.long	5
	.align 2
_SLICES_PER_COL:
	.long	4
	.align 2
_SLICE_DIMENSION:
	.long	64
	.cstring
LC0:
	.ascii "MessageName\0"
	.section __DATA, __cfstring
	.align 3
LC1:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC0
	.quad	11
	.text
"-[BAAnalyzerGLM init]":
LFB680:
	.file 1 "/Users/user/Development/BARTProcedure/BARTApplication/BAAnalyzerGLM.m"
	.loc 1 48 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI0:
	movq	%rsp, %rbp
LCFI1:
	pushq	%rbx
LCFI2:
	subq	$24, %rsp
LCFI3:
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	.loc 1 49 0
	movq	-24(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.gui@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	%rax, %rbx
	movq	L_OBJC_CLASSLIST_REFERENCES_$_0(%rip), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_0(%rip), %rsi
	call	_objc_msgSend
	movq	%rax, (%rbx)
	.loc 1 50 0
	movq	L_OBJC_CLASSLIST_REFERENCES_$_1(%rip), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_1(%rip), %rsi
	call	_objc_msgSend
	movq	%rax, %rdi
	leaq	LC1(%rip), %rax
	movq	L_OBJC_SELECTOR_REFERENCES_2(%rip), %rcx
	movq	-24(%rbp), %rdx
	movq	L_OBJC_SELECTOR_REFERENCES_3(%rip), %rsi
	movl	$0, %r9d
	movq	%rax, %r8
	call	_objc_msgSend
	.loc 1 51 0
	movq	-24(%rbp), %rax
	.loc 1 52 0
	addq	$24, %rsp
	popq	%rbx
	leave
	ret
LFE680:
"-[BAAnalyzerGLM anaylzeTheData:withDesign:]":
LFB681:
	.loc 1 56 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI4:
	movq	%rsp, %rbp
LCFI5:
	subq	$48, %rsp
LCFI6:
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%rcx, -48(%rbp)
	.loc 1 59 0
	movq	-24(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rax, (%rdx)
	.loc 1 60 0
	movq	-24(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rax, (%rdx)
	.loc 1 64 0
	movq	-24(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_4(%rip), %rsi
	call	_objc_msgSend
	.loc 1 66 0
	movl	$0, -4(%rbp)
	.loc 1 67 0
	jmp	L4
L5:
	.loc 1 68 0
	movq	-24(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_5(%rip), %rsi
	movl	$4, %r8d
	movl	$4, %ecx
	movl	$2000, %edx
	call	_objc_msgSend
	.loc 1 69 0
	movq	-24(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_6(%rip), %rsi
	call	_objc_msgSend
	.loc 1 70 0
	movq	-24(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.gui@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rdx
	movq	L_OBJC_SELECTOR_REFERENCES_7(%rip), %rsi
	call	_objc_msgSend
	.loc 1 71 0
	incl	-4(%rbp)
L4:
	.loc 1 67 0
	cmpl	$0, -4(%rbp)
	jle	L5
	.loc 1 81 0
	leave
	ret
LFE681:
"-[BAAnalyzerGLM dealloc]":
LFB682:
	.loc 1 84 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI7:
	movq	%rsp, %rbp
LCFI8:
	subq	$32, %rsp
LCFI9:
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	.loc 1 85 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	l_objc_msgSend_fixup_release@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	l_objc_msgSend_fixup_release@GOTPCREL(%rip), %rsi
	call	*%rax
	.loc 1 86 0
	movq	-24(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	L_OBJC_CLASSLIST_SUP_REFS_$_2(%rip), %rax
	movq	%rax, -8(%rbp)
	leaq	-16(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_8(%rip), %rsi
	call	_objc_msgSendSuper2
	.loc 1 87 0
	leave
	ret
LFE682:
"-[BAAnalyzerGLM OnNewData]":
LFB683:
	.loc 1 90 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI10:
	movq	%rsp, %rbp
LCFI11:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	.loc 1 92 0
	leave
	ret
LFE683:
	.cstring
LC2:
	.ascii "AnalyzeGLMFinished\0"
	.section __DATA, __cfstring
	.align 3
LC3:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC2
	.quad	18
	.text
"-[BAAnalyzerGLM sendFinishNotification]":
LFB684:
	.loc 1 95 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI12:
	movq	%rsp, %rbp
LCFI13:
	subq	$16, %rsp
LCFI14:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	.loc 1 96 0
	movq	L_OBJC_CLASSLIST_REFERENCES_$_1(%rip), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_1(%rip), %rsi
	call	_objc_msgSend
	movq	%rax, %rdi
	movq	-8(%rbp), %rcx
	leaq	LC3(%rip), %rdx
	movq	L_OBJC_SELECTOR_REFERENCES_9(%rip), %rsi
	call	_objc_msgSend
	.loc 1 97 0
	leave
	ret
LFE684:
	.data
	.align 5
___block_descriptor_tmp_1.108:
	.quad	0
	.quad	96
	.quad	___copy_helper_block_2
	.quad	___destroy_helper_block_2
	.align 5
___block_descriptor_tmp_2.110:
	.quad	0
	.quad	104
	.quad	___copy_helper_block_1
	.quad	___destroy_helper_block_1
	.cstring
	.align 3
LC5:
	.ascii " ntimesteps=%d,   num covariates=%d\12\0"
	.align 3
LC6:
	.ascii " too many covariates (%d), max is %d\0"
	.section __DATA, __cfstring
	.align 3
LC7:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC6
	.quad	36
	.cstring
	.align 3
LC8:
	.ascii " design dimension inconsistency: %d %d\0"
	.section __DATA, __cfstring
	.align 3
LC9:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC8
	.quad	38
	.cstring
LC11:
	.ascii " df= %.3f\12\0"
LC12:
	.ascii " slice: %3d\15\0"
	.align 3
LC13:
	.ascii " no voxels above threshold %d found\0"
	.section __DATA, __cfstring
	.align 3
LC14:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC13
	.quad	35
	.text
"-[BAAnalyzerGLM Regression:::]":
LFB685:
	.loc 1 102 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI15:
	movq	%rsp, %rbp
LCFI16:
	pushq	%rbx
LCFI17:
	subq	$360, %rsp
LCFI18:
	movq	%rdi, -328(%rbp)
	movq	%rsi, -336(%rbp)
	movl	%ecx, -344(%rbp)
	movl	%r8d, -348(%rbp)
	movw	%dx, -340(%rbp)
	.loc 1 106 0
	movl	$0, -20(%rbp)
	.loc 1 107 0
	movl	$0, -24(%rbp)
	.loc 1 108 0
	movl	$0, -28(%rbp)
	.loc 1 109 0
	movl	$0, -32(%rbp)
	.loc 1 123 0
	movl	$0, -68(%rbp)
	.loc 1 125 0
	movq	$0, -208(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, -200(%rbp)
	movl	$0, -192(%rbp)
	movl	$32, -188(%rbp)
	movl	$0, -184(%rbp)
	.loc 1 127 0
	movl	$0x00000000, %eax
	movl	%eax, -76(%rbp)
	.loc 1 128 0
	movl	$0x00000000, %eax
	movl	%eax, -80(%rbp)
	.loc 1 138 0
	movq	$0, -104(%rbp)
	.loc 1 139 0
	movq	$0, -112(%rbp)
	.loc 1 140 0
	movq	$0, -120(%rbp)
	.loc 1 144 0
	movq	$0, -136(%rbp)
	.loc 1 145 0
	movq	$0, -144(%rbp)
	.loc 1 147 0
	movq	$0, -152(%rbp)
	.loc 1 150 0
	movq	$0, -160(%rbp)
	.loc 1 151 0
	movq	$0, -168(%rbp)
	.loc 1 153 0
	movl	$0, %esi
	movl	$2, %edi
	call	_dispatch_get_global_queue
	movq	%rax, -176(%rbp)
	.loc 1 155 0
	call	_gsl_set_error_handler_off
	.loc 1 162 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_18(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -64(%rbp)
	.loc 1 164 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_18(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -24(%rbp)
	.loc 1 165 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_19(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -40(%rbp)
	.loc 1 166 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_19(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -28(%rbp)
	.loc 1 167 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_20(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -44(%rbp)
	.loc 1 168 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_20(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -32(%rbp)
	.loc 1 169 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_21(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -72(%rbp)
	.loc 1 172 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_21(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -20(%rbp)
	.loc 1 173 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_21(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -68(%rbp)
	.loc 1 174 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_22(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, -64(%rbp)
	.loc 1 175 0
	movl	-64(%rbp), %edx
	movl	-68(%rbp), %esi
	leaq	LC5(%rip), %rdi
	movl	$0, %eax
	call	_printf
	.loc 1 177 0
	cmpl	$63, -64(%rbp)
	jle	L15
	.loc 1 178 0
	leaq	LC7(%rip), %rdi
	movl	-64(%rbp), %esi
	movl	$64, %edx
	movl	$0, %eax
	call	_NSLog
L15:
	.loc 1 180 0
	movl	-68(%rbp), %eax
	cmpl	-20(%rbp), %eax
	je	L17
	.loc 1 181 0
	leaq	LC9(%rip), %rdi
	movl	-20(%rbp), %edx
	movl	-68(%rbp), %esi
	movl	$0, %eax
	call	_NSLog
L17:
	.loc 1 187 0
	movl	-64(%rbp), %eax
	movslq	%eax,%rsi
	movl	-68(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_matrix_float_alloc
	movq	%rax, -104(%rbp)
	.loc 1 188 0
	movl	$0, -56(%rbp)
	jmp	L19
L20:
	.loc 1 189 0
	movl	$0, -60(%rbp)
	jmp	L21
L22:
	.loc 1 190 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_10(%rip), %rsi
	movl	-56(%rbp), %ecx
	movl	-60(%rbp), %edx
	call	_objc_msgSend
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_11(%rip), %rsi
	call	_objc_msgSend
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	.loc 1 192 0
	cvtsd2ss	-96(%rbp), %xmm0
	movl	-60(%rbp), %eax
	movslq	%eax,%rdx
	movl	-56(%rbp), %eax
	movslq	%eax,%rsi
	movq	-104(%rbp), %rdi
	call	_gsl_matrix_float_set
	.loc 1 189 0
	incl	-60(%rbp)
L21:
	movl	-60(%rbp), %eax
	cmpl	-64(%rbp), %eax
	jl	L22
	.loc 1 188 0
	incl	-56(%rbp)
L19:
	movl	-56(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	L20
	.loc 1 202 0
	movl	$0x40800000, %eax
	movl	%eax, -84(%rbp)
	.loc 1 203 0
	movq	-328(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_12(%rip), %rsi
	movss	-84(%rbp), %xmm0
	call	_objc_msgSend
	movss	%xmm0, -88(%rbp)
	.loc 1 204 0
	movl	-68(%rbp), %eax
	movslq	%eax,%rsi
	movl	-68(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_matrix_float_alloc
	movq	%rax, -136(%rbp)
	.loc 1 205 0
	cvtss2sd	-88(%rbp), %xmm0
	movq	-136(%rbp), %rdi
	call	_GaussMatrix
	.loc 1 206 0
	movq	-136(%rbp), %rsi
	movq	-136(%rbp), %rdi
	movl	$0, %edx
	call	_fmat_x_matT
	movq	%rax, -144(%rbp)
	.loc 1 211 0
	movq	-104(%rbp), %rsi
	movq	-136(%rbp), %rdi
	movl	$0, %edx
	call	_fmat_x_mat
	movq	%rax, -120(%rbp)
	.loc 1 212 0
	movq	-120(%rbp), %rdi
	movl	$0, %esi
	call	_fmat_PseudoInv
	movq	%rax, -112(%rbp)
	.loc 1 233 0
	movl	-68(%rbp), %eax
	movslq	%eax,%rsi
	movl	-68(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_matrix_float_alloc
	movq	%rax, -160(%rbp)
	.loc 1 235 0
	movq	-152(%rbp), %rdx
	movq	-112(%rbp), %rsi
	movq	-120(%rbp), %rdi
	call	_fmat_x_mat
	movq	%rax, -152(%rbp)
	.loc 1 236 0
	movq	-160(%rbp), %rdi
	call	_gsl_matrix_float_set_identity
	.loc 1 237 0
	movq	-152(%rbp), %rsi
	movq	-160(%rbp), %rdi
	call	_gsl_matrix_float_sub
	.loc 1 239 0
	movq	-144(%rbp), %rsi
	movq	-160(%rbp), %rdi
	movl	$0, %edx
	call	_fmat_x_mat
	movq	%rax, -168(%rbp)
	.loc 1 241 0
	movl	$0, -52(%rbp)
	jmp	L25
L26:
	.loc 1 242 0
	movl	-52(%rbp), %eax
	movslq	%eax,%rdx
	movl	-52(%rbp), %eax
	movslq	%eax,%rsi
	movq	-168(%rbp), %rdi
	call	_gsl_matrix_float_get
	movaps	%xmm0, %xmm1
	movss	-76(%rbp), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -76(%rbp)
	.loc 1 241 0
	incl	-52(%rbp)
L25:
	movl	-52(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	L26
	.loc 1 245 0
	movq	-152(%rbp), %rdx
	movq	-168(%rbp), %rsi
	movq	-168(%rbp), %rdi
	call	_fmat_x_mat
	movq	%rax, -152(%rbp)
	.loc 1 247 0
	movl	$0, -52(%rbp)
	jmp	L28
L29:
	.loc 1 248 0
	movl	-52(%rbp), %eax
	movslq	%eax,%rdx
	movl	-52(%rbp), %eax
	movslq	%eax,%rsi
	movq	-152(%rbp), %rdi
	call	_gsl_matrix_float_get
	movaps	%xmm0, %xmm1
	movss	-80(%rbp), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -80(%rbp)
	.loc 1 247 0
	incl	-52(%rbp)
L28:
	movl	-52(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	L29
	.loc 1 251 0
	movss	-76(%rbp), %xmm0
	mulss	-76(%rbp), %xmm0
	divss	-80(%rbp), %xmm0
	movss	%xmm0, -48(%rbp)
	.loc 1 252 0
	cvtss2sd	-48(%rbp), %xmm0
	leaq	LC11(%rip), %rdi
	movl	$1, %eax
	call	_printf
	.loc 1 254 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	L_OBJC_CLASSLIST_REFERENCES_$_3(%rip), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_13(%rip), %rsi
	movss	-48(%rbp), %xmm0
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$2, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 264 0
	cvtss2sd	-88(%rbp), %xmm0
	call	_GaussKernel
	movq	%rax, -128(%rbp)
	.loc 1 269 0
	movq	-200(%rbp), %rax
	movl	$0, 24(%rax)
	.loc 1 272 0
	movl	-344(%rbp), %eax
	cmpl	-348(%rbp), %eax
	jg	L31
	.loc 1 273 0
	movl	$0, -36(%rbp)
	jmp	L33
L34:
	.loc 1 274 0
	movl	-36(%rbp), %ecx
	movl	$1717986919, -356(%rbp)
	movl	-356(%rbp), %eax
	imull	%ecx
	sarl	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	movl	%edx, %ebx
	subl	%eax, %ebx
	movl	%ebx, -352(%rbp)
	movl	-352(%rbp), %eax
	sall	$2, %eax
	addl	-352(%rbp), %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%edx, -352(%rbp)
	cmpl	$0, -352(%rbp)
	jne	L35
	.loc 1 275 0
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movl	-36(%rbp), %edx
	leaq	LC12(%rip), %rsi
	movl	$0, %eax
	call	_fprintf
L35:
	.loc 1 278 0
	movq	-328(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_15(%rip), %rsi
	movl	-36(%rbp), %edx
	call	_objc_msgSend
	cmpb	$1, %al
	jne	L37
LBB2:
	.loc 1 341 0
	movq	-200(%rbp), %rdx
	movq	__NSConcreteStackBlock@GOTPCREL(%rip), %rax
	movq	%rax, -320(%rbp)
	movl	$570425344, -312(%rbp)
	movl	$0, -308(%rbp)
	movq	"___-[BAAnalyzerGLM Regression:::]_block_invoke_1"@GOTPCREL(%rip), %rax
	movq	%rax, -304(%rbp)
	movq	___block_descriptor_tmp_2.110@GOTPCREL(%rip), %rax
	movq	%rax, -296(%rbp)
	movq	-112(%rbp), %rax
	movq	%rax, -288(%rbp)
	movl	-64(%rbp), %eax
	movl	%eax, -280(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, -272(%rbp)
	movl	-348(%rbp), %eax
	movl	%eax, -264(%rbp)
	movl	-344(%rbp), %eax
	movl	%eax, -260(%rbp)
	movzwl	-340(%rbp), %eax
	movw	%ax, -256(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -252(%rbp)
	movq	-328(%rbp), %rax
	movq	%rax, -248(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -240(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -232(%rbp)
	movq	%rdx, -224(%rbp)
	.loc 1 280 0
	leaq	-320(%rbp), %rdx
	movl	-28(%rbp), %eax
	movslq	%eax,%rdi
	movq	-176(%rbp), %rsi
	call	_dispatch_apply
L37:
LBE2:
	.loc 1 273 0
	incl	-36(%rbp)
L33:
	movl	-36(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	L34
L31:
	.loc 1 346 0
	movq	-200(%rbp), %rax
	movl	24(%rax), %eax
	testl	%eax, %eax
	jne	L39
	.loc 1 347 0
	movswl	-340(%rbp),%esi
	leaq	LC14(%rip), %rdi
	movl	$0, %eax
	call	_NSLog
L39:
	.loc 1 349 0
	movq	L_OBJC_CLASSLIST_REFERENCES_$_0(%rip), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_0(%rip), %rsi
	call	_objc_msgSend
	movq	%rax, %rdi
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rdx
	movq	L_OBJC_SELECTOR_REFERENCES_7(%rip), %rsi
	call	_objc_msgSend
	.loc 1 125 0
	movq	-200(%rbp), %rdi
	movl	$8, %esi
	call	__Block_object_dispose
	.loc 1 352 0
	addq	$360, %rsp
	popq	%rbx
	leave
	ret
LFE685:
___destroy_helper_block_1:
LFB691:
	.loc 1 341 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI19:
	movq	%rsp, %rbp
LCFI20:
	subq	$16, %rsp
LCFI21:
	movq	%rdi, -8(%rbp)
	.loc 1 341 0
	movq	-8(%rbp), %rax
	movq	72(%rax), %rdi
	movl	$3, %esi
	call	__Block_object_dispose
	movq	-8(%rbp), %rax
	movq	96(%rax), %rdi
	movl	$8, %esi
	call	__Block_object_dispose
	leave
	ret
LFE691:
___copy_helper_block_1:
LFB690:
	.loc 1 341 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI22:
	movq	%rsp, %rbp
LCFI23:
	subq	$16, %rsp
LCFI24:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	.loc 1 341 0
	movq	-16(%rbp), %rax
	movq	72(%rax), %rsi
	movq	-8(%rbp), %rdi
	addq	$72, %rdi
	movl	$3, %edx
	call	__Block_object_assign
	movq	-16(%rbp), %rax
	movq	96(%rax), %rsi
	movq	-8(%rbp), %rdi
	addq	$96, %rdi
	movl	$8, %edx
	call	__Block_object_assign
	leave
	ret
LFE690:
"___-[BAAnalyzerGLM Regression:::]_block_invoke_1":
LFB686:
	.loc 1 280 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI25:
	movq	%rsp, %rbp
LCFI26:
	subq	$176, %rsp
LCFI27:
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	movq	-168(%rbp), %rax
	movq	96(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-168(%rbp), %rax
	movl	88(%rax), %eax
	movl	%eax, -8(%rbp)
	movq	-168(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-168(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-168(%rbp), %rax
	movl	68(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-168(%rbp), %rax
	movzwl	64(%rax), %eax
	movw	%ax, -2(%rbp)
	movq	-168(%rbp), %rax
	movl	60(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-168(%rbp), %rax
	movl	56(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-168(%rbp), %rax
	movq	48(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-168(%rbp), %rax
	movl	40(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-168(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, -64(%rbp)
	.loc 1 340 0
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movq	__NSConcreteStackBlock@GOTPCREL(%rip), %rax
	movq	%rax, -160(%rbp)
	movl	$570425344, -152(%rbp)
	movl	$0, -148(%rbp)
	movq	"___-[BAAnalyzerGLM Regression:::]_block_invoke_2"@GOTPCREL(%rip), %rax
	movq	%rax, -144(%rbp)
	movq	___block_descriptor_tmp_1.108@GOTPCREL(%rip), %rax
	movq	%rax, -136(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -128(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -120(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -112(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -104(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -100(%rbp)
	movzwl	-2(%rbp), %eax
	movw	%ax, -96(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -92(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	.loc 1 281 0
	leaq	-160(%rbp), %rdx
	movl	-8(%rbp), %eax
	movslq	%eax,%rdi
	movq	-32(%rbp), %rsi
	call	_dispatch_apply
	.loc 1 341 0
	leave
	ret
LFE686:
___destroy_helper_block_2:
LFB689:
	.loc 1 340 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI28:
	movq	%rsp, %rbp
LCFI29:
	subq	$16, %rsp
LCFI30:
	movq	%rdi, -8(%rbp)
	.loc 1 340 0
	movq	-8(%rbp), %rax
	movq	80(%rax), %rdi
	movl	$3, %esi
	call	__Block_object_dispose
	movq	-8(%rbp), %rax
	movq	88(%rax), %rdi
	movl	$8, %esi
	call	__Block_object_dispose
	leave
	ret
LFE689:
___copy_helper_block_2:
LFB688:
	.loc 1 340 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI31:
	movq	%rsp, %rbp
LCFI32:
	subq	$16, %rsp
LCFI33:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	.loc 1 340 0
	movq	-16(%rbp), %rax
	movq	80(%rax), %rsi
	movq	-8(%rbp), %rdi
	addq	$80, %rdi
	movl	$3, %edx
	call	__Block_object_assign
	movq	-16(%rbp), %rax
	movq	88(%rax), %rsi
	movq	-8(%rbp), %rdi
	addq	$88, %rdi
	movl	$8, %edx
	call	__Block_object_assign
	leave
	ret
LFE688:
	.cstring
LC19:
	.ascii "%.2f \0"
	.text
"___-[BAAnalyzerGLM Regression:::]_block_invoke_2":
LFB687:
	.loc 1 281 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI34:
	movq	%rsp, %rbp
LCFI35:
	subq	$160, %rsp
LCFI36:
	movq	%rdi, -136(%rbp)
	movq	%rsi, -144(%rbp)
	movq	-136(%rbp), %rax
	movq	88(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	-136(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-136(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-136(%rbp), %rax
	movl	68(%rax), %eax
	movl	%eax, -8(%rbp)
	movq	-136(%rbp), %rax
	movzwl	64(%rax), %eax
	movw	%ax, -2(%rbp)
	movq	-136(%rbp), %rax
	movl	60(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-136(%rbp), %rax
	movl	56(%rax), %eax
	movl	%eax, -36(%rbp)
	movq	-136(%rbp), %rax
	movq	48(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-136(%rbp), %rax
	movl	40(%rax), %eax
	movl	%eax, -48(%rbp)
	movq	-136(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, -120(%rbp)
	.loc 1 283 0
	movq	-56(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	-144(%rbp), %rax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	%eax, %edx
	movq	L_OBJC_SELECTOR_REFERENCES_16(%rip), %rsi
	movl	-8(%rbp), %eax
	movl	$0, %r9d
	movl	%eax, %r8d
	call	_objc_msgSend
	movswl	%ax,%edx
	movswl	-2(%rbp),%eax
	incl	%eax
	cmpl	%eax, %edx
	jl	L70
LBB3:
	.loc 1 287 0
	movq	-72(%rbp), %rax
	movq	8(%rax), %rdx
	movl	24(%rdx), %eax
	incl	%eax
	movl	%eax, 24(%rdx)
	.loc 1 288 0
	movl	$0x00000000, %eax
	movl	%eax, -12(%rbp)
	.loc 1 289 0
	movl	$0x00000000, %eax
	movl	%eax, -16(%rbp)
	.loc 1 290 0
	movl	$0x00000000, %eax
	movl	%eax, -20(%rbp)
	.loc 1 291 0
	movl	-24(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_vector_float_alloc
	movq	%rax, -80(%rbp)
	.loc 1 292 0
	movq	-80(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -88(%rbp)
	.loc 1 296 0
	movl	-24(%rbp), %edx
	movl	-36(%rbp), %eax
	subl	%edx, %eax
	movl	%eax, -28(%rbp)
	jmp	L55
L56:
	.loc 1 299 0
	movq	-56(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-144(%rbp), %rax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	%eax, %esi
	movq	L_OBJC_SELECTOR_REFERENCES_16(%rip), %rdi
	movl	-28(%rbp), %eax
	movl	-8(%rbp), %edx
	movl	%eax, %r9d
	movl	%edx, %r8d
	movl	%esi, %edx
	movq	%rdi, %rsi
	movq	%r10, %rdi
	call	_objc_msgSend
	cwtl
	cvtsi2ss	%eax, %xmm0
	movss	%xmm0, -32(%rbp)
	.loc 1 300 0
	movq	-88(%rbp), %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)
	addq	$4, -88(%rbp)
	.loc 1 301 0
	movss	-12(%rbp), %xmm0
	addss	-32(%rbp), %xmm0
	movss	%xmm0, -12(%rbp)
	.loc 1 302 0
	movss	-32(%rbp), %xmm0
	movaps	%xmm0, %xmm1
	mulss	-32(%rbp), %xmm1
	movss	-16(%rbp), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -16(%rbp)
	.loc 1 303 0
	movss	-20(%rbp), %xmm1
	movss	LC15(%rip), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -20(%rbp)
	.loc 1 296 0
	incl	-28(%rbp)
L55:
	movl	-28(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	L56
	.loc 1 306 0
	movss	-12(%rbp), %xmm0
	divss	-20(%rbp), %xmm0
	movss	%xmm0, -40(%rbp)
	.loc 1 307 0
	movss	-20(%rbp), %xmm0
	mulss	-40(%rbp), %xmm0
	movaps	%xmm0, %xmm1
	mulss	-40(%rbp), %xmm1
	movss	-16(%rbp), %xmm0
	subss	%xmm1, %xmm0
	cvtss2sd	%xmm0, %xmm2
	cvtss2sd	-20(%rbp), %xmm1
	movsd	LC16(%rip), %xmm0
	movapd	%xmm1, %xmm3
	subsd	%xmm0, %xmm3
	movapd	%xmm3, %xmm0
	movapd	%xmm2, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	sqrtsd	%xmm0, %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, -44(%rbp)
	.loc 1 308 0
	cvtss2sd	-44(%rbp), %xmm0
	ucomisd	LC17(%rip), %xmm0
	jae	L60
	jmp	L58
L60:
LBB4:
	.loc 1 311 0
	movq	-80(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -88(%rbp)
	.loc 1 312 0
	movl	$0, -28(%rbp)
	jmp	L61
L62:
	.loc 1 313 0
	movq	-88(%rbp), %rax
	movss	(%rax), %xmm0
	subss	-40(%rbp), %xmm0
	divss	-44(%rbp), %xmm0
	movss	%xmm0, -32(%rbp)
	.loc 1 314 0
	movss	-32(%rbp), %xmm1
	movss	LC18(%rip), %xmm0
	addss	%xmm1, %xmm0
	movq	-88(%rbp), %rax
	movss	%xmm0, (%rax)
	addq	$4, -88(%rbp)
	.loc 1 312 0
	incl	-28(%rbp)
L61:
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	L62
	.loc 1 317 0
	movl	-24(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_vector_float_alloc
	movq	%rax, -96(%rbp)
	.loc 1 319 0
	movq	-104(%rbp), %rdx
	movq	-96(%rbp), %rsi
	movq	-80(%rbp), %rdi
	call	_VectorConvolve
	movq	%rax, -96(%rbp)
	.loc 1 321 0
	movl	-48(%rbp), %eax
	movslq	%eax,%rdi
	call	_gsl_vector_float_alloc
	movq	%rax, -112(%rbp)
	.loc 1 323 0
	movq	-112(%rbp), %rdx
	movq	-96(%rbp), %rsi
	movq	-120(%rbp), %rdi
	call	_fmat_x_vector
	.loc 1 326 0
	movq	-112(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -88(%rbp)
	.loc 1 327 0
	movl	$0, -28(%rbp)
	jmp	L64
L65:
LBB5:
	.loc 1 328 0
	movq	L_OBJC_CLASSLIST_REFERENCES_$_3(%rip), %rax
	movq	%rax, %rdi
	movq	-88(%rbp), %rax
	movss	(%rax), %xmm0
	movq	L_OBJC_SELECTOR_REFERENCES_13(%rip), %rsi
	call	_objc_msgSend
	movq	%rax, -128(%rbp)
	.loc 1 329 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-144(%rbp), %rax
	movl	%eax, %ecx
	movq	-64(%rbp), %rax
	movl	%eax, %esi
	movq	L_OBJC_SELECTOR_REFERENCES_17(%rip), %rdi
	movl	-28(%rbp), %edx
	movq	-128(%rbp), %r10
	movl	-8(%rbp), %eax
	movl	%eax, (%rsp)
	movl	%edx, %r9d
	movl	%ecx, %r8d
	movl	%esi, %ecx
	movq	%r10, %rdx
	movq	%rdi, %rsi
	movq	%r11, %rdi
	call	_objc_msgSend
	.loc 1 330 0
	cmpl	$4, -28(%rbp)
	jne	L66
	cmpq	$23, -64(%rbp)
	jne	L66
	.loc 1 331 0
	movq	-128(%rbp), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_11(%rip), %rsi
	call	_objc_msgSend
	cvtss2sd	%xmm0, %xmm0
	leaq	LC19(%rip), %rdi
	movl	$1, %eax
	call	_printf
L66:
	.loc 1 333 0
	addq	$4, -88(%rbp)
LBE5:
	.loc 1 327 0
	incl	-28(%rbp)
L64:
	movl	-28(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl	L65
	.loc 1 335 0
	movq	-112(%rbp), %rdi
	call	_gsl_vector_float_free
L58:
LBE4:
	.loc 1 337 0
	movq	-80(%rbp), %rdi
	call	_gsl_vector_float_free
L70:
LBE3:
	.loc 1 340 0
	leave
	ret
LFE687:
	.cstring
LC21:
	.ascii " TR: %.3f seconds\12\0"
	.align 3
LC24:
	.ascii " 'fwhm/sigma' too small (%.3f / %.3f), will be set to zero\0"
	.section __DATA, __cfstring
	.align 3
LC25:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC24
	.quad	58
	.text
"-[BAAnalyzerGLM CalcSigma:]":
LFB692:
	.loc 1 356 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI37:
	movq	%rsp, %rbp
LCFI38:
	subq	$64, %rsp
LCFI39:
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movss	%xmm0, -36(%rbp)
	.loc 1 357 0
	movl	$0x00000000, %eax
	movl	%eax, -4(%rbp)
	.loc 1 358 0
	movq	-24(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_23(%rip), %rsi
	call	_objc_msgSend
	cvtsi2ss	%eax, %xmm1
	movss	LC20(%rip), %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm2, %xmm0
	movss	%xmm0, -8(%rbp)
	.loc 1 360 0
	cvtss2sd	-8(%rbp), %xmm0
	ucomisd	LC17(%rip), %xmm0
	ja	L74
	jmp	L72
L74:
	cvtss2sd	-36(%rbp), %xmm0
	ucomisd	LC17(%rip), %xmm0
	ja	L76
	jmp	L72
L76:
	.loc 1 361 0
	cvtss2sd	-8(%rbp), %xmm0
	leaq	LC21(%rip), %rdi
	movl	$1, %eax
	call	_printf
	.loc 1 362 0
	cvtss2sd	-36(%rbp), %xmm1
	movsd	LC22(%rip), %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, -4(%rbp)
	.loc 1 363 0
	movss	-4(%rbp), %xmm0
	divss	-8(%rbp), %xmm0
	movss	%xmm0, -4(%rbp)
	.loc 1 364 0
	cvtss2sd	-4(%rbp), %xmm1
	movsd	LC23(%rip), %xmm0
	ucomisd	%xmm1, %xmm0
	ja	L78
	jmp	L72
L78:
	.loc 1 365 0
	cvtss2sd	-4(%rbp), %xmm0
	cvtss2sd	-36(%rbp), %xmm2
	leaq	LC25(%rip), %rdi
	movapd	%xmm0, %xmm1
	movapd	%xmm2, %xmm0
	movl	$2, %eax
	call	_NSLog
	.loc 1 366 0
	movl	$0x00000000, %eax
	movl	%eax, -4(%rbp)
L72:
	.loc 1 369 0
	movl	-4(%rbp), %eax
	movl	%eax, -52(%rbp)
	movss	-52(%rbp), %xmm0
	.loc 1 370 0
	leave
	ret
LFE692:
	.cstring
LC26:
	.ascii "BETA\0"
	.section __DATA, __cfstring
	.align 3
LC27:
	.quad	___CFConstantStringClassReference
	.long	1992
	.space 4
	.quad	LC26
	.quad	4
	.text
"-[BAAnalyzerGLM createOutputImages]":
LFB693:
	.loc 1 373 0
	nop
	nop
	nop
	nop
	nop
	nop
	pushq	%rbp
LCFI40:
	movq	%rsp, %rbp
LCFI41:
	pushq	%r14
LCFI42:
	pushq	%r13
LCFI43:
	pushq	%r12
LCFI44:
	pushq	%rbx
LCFI45:
	subq	$32, %rsp
LCFI46:
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	.loc 1 384 0
	movq	L_OBJC_CLASSLIST_REFERENCES_$_4(%rip), %rax
	movq	%rax, %rdi
	movq	l_objc_msgSend_fixup_alloc@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	l_objc_msgSend_fixup_alloc@GOTPCREL(%rip), %rsi
	call	*%rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_18(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, %r12d
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_22(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, %r13d
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_20(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, %r14d
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_19(%rip), %rsi
	call	_objc_msgSend
	movl	%eax, %ecx
	movq	L_OBJC_SELECTOR_REFERENCES_24(%rip), %rsi
	movl	%r12d, (%rsp)
	movl	%r13d, %r9d
	movl	%r14d, %r8d
	movl	$0, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	movq	%rax, %rdx
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	%rdx, (%rax)
	.loc 1 386 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$3, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$3, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 387 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$4, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$4, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 388 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	L_OBJC_CLASSLIST_REFERENCES_$_3(%rip), %rax
	movq	%rax, %r12
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_23(%rip), %rsi
	call	_objc_msgSend
	movslq	%eax,%rdx
	movq	L_OBJC_SELECTOR_REFERENCES_26(%rip), %rsi
	movq	%r12, %rdi
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$5, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 389 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$6, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$6, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 391 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$7, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$7, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 394 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$8, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$8, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 395 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$9, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$9, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 396 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$10, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$10, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 399 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	leaq	LC27(%rip), %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$0, %edx
	call	_objc_msgSend
	.loc 1 400 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	leaq	LC27(%rip), %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$1, %edx
	call	_objc_msgSend
	.loc 1 402 0
	movq	_mBetaOutput@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rbx
	movq	-40(%rbp), %rdx
	movq	_OBJC_IVAR_$_BAAnalyzerGLM.mData@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_25(%rip), %rsi
	movl	$4, %edx
	call	_objc_msgSend
	movq	%rax, %rcx
	movq	L_OBJC_SELECTOR_REFERENCES_14(%rip), %rsi
	movl	$4, %edx
	movq	%rbx, %rdi
	call	_objc_msgSend
	.loc 1 412 0
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	leave
	ret
LFE693:
	.cstring
L_OBJC_METH_VAR_NAME_0:
	.ascii "mDesign\0"
L_OBJC_METH_VAR_TYPE_0:
	.ascii "@\"BADesignElement\"\0"
L_OBJC_METH_VAR_NAME_1:
	.ascii "mData\0"
L_OBJC_METH_VAR_TYPE_1:
	.ascii "@\"BADataElement\"\0"
L_OBJC_METH_VAR_NAME_2:
	.ascii "gui\0"
L_OBJC_METH_VAR_TYPE_2:
	.ascii "@\"BAGUIPrototyp\"\0"
	.section __DATA, __objc_const
	.align 3
l_OBJC_$_INSTANCE_VARIABLES_BAAnalyzerGLM:
	.long	32
	.long	3
	.quad	_OBJC_IVAR_$_BAAnalyzerGLM.mDesign
	.quad	L_OBJC_METH_VAR_NAME_0
	.quad	L_OBJC_METH_VAR_TYPE_0
	.long	3
	.long	8
	.quad	_OBJC_IVAR_$_BAAnalyzerGLM.mData
	.quad	L_OBJC_METH_VAR_NAME_1
	.quad	L_OBJC_METH_VAR_TYPE_1
	.long	3
	.long	8
	.quad	_OBJC_IVAR_$_BAAnalyzerGLM.gui
	.quad	L_OBJC_METH_VAR_NAME_2
	.quad	L_OBJC_METH_VAR_TYPE_2
	.long	3
	.long	8
	.cstring
L_OBJC_METH_VAR_NAME_3:
	.ascii "createOutputImages\0"
L_OBJC_METH_VAR_TYPE_3:
	.ascii "v16@0:8\0"
L_OBJC_METH_VAR_NAME_4:
	.ascii "CalcSigma:\0"
L_OBJC_METH_VAR_TYPE_4:
	.ascii "f20@0:8f16\0"
L_OBJC_METH_VAR_NAME_5:
	.ascii "Regression:::\0"
L_OBJC_METH_VAR_TYPE_5:
	.ascii "v28@0:8s16i20i24\0"
L_OBJC_METH_VAR_NAME_6:
	.ascii "sendFinishNotification\0"
L_OBJC_METH_VAR_NAME_7:
	.ascii "OnNewData\0"
L_OBJC_METH_VAR_NAME_8:
	.ascii "dealloc\0"
L_OBJC_METH_VAR_NAME_9:
	.ascii "anaylzeTheData:withDesign:\0"
L_OBJC_METH_VAR_TYPE_6:
	.ascii "v32@0:8@16@24\0"
L_OBJC_METH_VAR_NAME_10:
	.ascii "init\0"
L_OBJC_METH_VAR_TYPE_7:
	.ascii "@16@0:8\0"
	.section __DATA, __objc_const
	.align 3
l_OBJC_$_INSTANCE_METHODS_BAAnalyzerGLM:
	.long	24
	.long	8
	.quad	L_OBJC_METH_VAR_NAME_3
	.quad	L_OBJC_METH_VAR_TYPE_3
	.quad	"-[BAAnalyzerGLM createOutputImages]"
	.quad	L_OBJC_METH_VAR_NAME_4
	.quad	L_OBJC_METH_VAR_TYPE_4
	.quad	"-[BAAnalyzerGLM CalcSigma:]"
	.quad	L_OBJC_METH_VAR_NAME_5
	.quad	L_OBJC_METH_VAR_TYPE_5
	.quad	"-[BAAnalyzerGLM Regression:::]"
	.quad	L_OBJC_METH_VAR_NAME_6
	.quad	L_OBJC_METH_VAR_TYPE_3
	.quad	"-[BAAnalyzerGLM sendFinishNotification]"
	.quad	L_OBJC_METH_VAR_NAME_7
	.quad	L_OBJC_METH_VAR_TYPE_3
	.quad	"-[BAAnalyzerGLM OnNewData]"
	.quad	L_OBJC_METH_VAR_NAME_8
	.quad	L_OBJC_METH_VAR_TYPE_3
	.quad	"-[BAAnalyzerGLM dealloc]"
	.quad	L_OBJC_METH_VAR_NAME_9
	.quad	L_OBJC_METH_VAR_TYPE_6
	.quad	"-[BAAnalyzerGLM anaylzeTheData:withDesign:]"
	.quad	L_OBJC_METH_VAR_NAME_10
	.quad	L_OBJC_METH_VAR_TYPE_7
	.quad	"-[BAAnalyzerGLM init]"
	.cstring
L_OBJC_CLASS_NAME_0:
	.ascii "BAAnalyzerGLM\0"
	.section __DATA, __objc_const
	.align 3
l_OBJC_METACLASS_RO_$_BAAnalyzerGLM:
	.long	1
	.long	40
	.long	40
	.long	0
	.quad	0
	.quad	L_OBJC_CLASS_NAME_0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
.globl _OBJC_METACLASS_$_BAAnalyzerGLM
	.section __DATA, __objc_data
	.align 3
_OBJC_METACLASS_$_BAAnalyzerGLM:
	.quad	_OBJC_METACLASS_$_NSObject
	.quad	_OBJC_METACLASS_$_BAAnalyzerElement
	.quad	__objc_empty_cache
	.quad	__objc_empty_vtable
	.quad	l_OBJC_METACLASS_RO_$_BAAnalyzerGLM
	.section __DATA, __objc_const
	.align 3
l_OBJC_CLASS_RO_$_BAAnalyzerGLM:
	.long	0
	.long	8
	.long	32
	.long	0
	.quad	0
	.quad	L_OBJC_CLASS_NAME_0
	.quad	l_OBJC_$_INSTANCE_METHODS_BAAnalyzerGLM
	.quad	0
	.quad	l_OBJC_$_INSTANCE_VARIABLES_BAAnalyzerGLM
	.quad	0
	.quad	0
.globl _OBJC_CLASS_$_BAAnalyzerGLM
	.section __DATA, __objc_data
	.align 3
_OBJC_CLASS_$_BAAnalyzerGLM:
	.quad	_OBJC_METACLASS_$_BAAnalyzerGLM
	.quad	_OBJC_CLASS_$_BAAnalyzerElement
	.quad	__objc_empty_cache
	.quad	__objc_empty_vtable
	.quad	l_OBJC_CLASS_RO_$_BAAnalyzerGLM
	.cstring
L_OBJC_METH_VAR_NAME_11:
	.ascii "numberWithLong:\0"
	.section __DATA, __objc_msgrefs, coalesced
	.section __DATA, __objc_data
	.section __DATA, __objc_const
	.section __DATA, __objc_classrefs, regular, no_dead_strip
	.section __DATA, __objc_classlist, regular, no_dead_strip
	.section __DATA, __objc_catlist, regular, no_dead_strip
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.section __DATA, __objc_nlclslist, regular, no_dead_strip
	.section __DATA, __objc_nlcatlist, regular, no_dead_strip
	.section __DATA, __objc_protolist, coalesced, no_dead_strip
	.section __DATA, __objc_protorefs, coalesced, no_dead_strip
	.section __DATA, __objc_superrefs, regular, no_dead_strip
	.section __DATA, __objc_imageinfo, regular, no_dead_strip
	.section __DATA, __objc_stringobj, regular, no_dead_strip
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_26:
	.quad	L_OBJC_METH_VAR_NAME_11
	.cstring
L_OBJC_METH_VAR_NAME_12:
	.ascii "getImageProperty:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_25:
	.quad	L_OBJC_METH_VAR_NAME_12
	.cstring
L_OBJC_METH_VAR_NAME_13:
	.ascii "initWithDataType:andRows:andCols:andSlices:andTimesteps:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_24:
	.quad	L_OBJC_METH_VAR_NAME_13
	.cstring
L_OBJC_METH_VAR_NAME_14:
	.ascii "repetitionTimeInMs\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_23:
	.quad	L_OBJC_METH_VAR_NAME_14
	.cstring
L_OBJC_METH_VAR_NAME_15:
	.ascii "numberCovariates\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_22:
	.quad	L_OBJC_METH_VAR_NAME_15
	.cstring
L_OBJC_METH_VAR_NAME_16:
	.ascii "numberTimesteps\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_21:
	.quad	L_OBJC_METH_VAR_NAME_16
	.cstring
L_OBJC_METH_VAR_NAME_17:
	.ascii "numberCols\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_20:
	.quad	L_OBJC_METH_VAR_NAME_17
	.cstring
L_OBJC_METH_VAR_NAME_18:
	.ascii "numberRows\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_19:
	.quad	L_OBJC_METH_VAR_NAME_18
	.cstring
L_OBJC_METH_VAR_NAME_19:
	.ascii "numberSlices\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_18:
	.quad	L_OBJC_METH_VAR_NAME_19
	.cstring
L_OBJC_METH_VAR_NAME_20:
	.ascii "setVoxelValue:atRow:col:slice:timestep:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_17:
	.quad	L_OBJC_METH_VAR_NAME_20
	.cstring
L_OBJC_METH_VAR_NAME_21:
	.ascii "getVoxelValueAtRow:col:slice:timestep:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_16:
	.quad	L_OBJC_METH_VAR_NAME_21
	.cstring
L_OBJC_METH_VAR_NAME_22:
	.ascii "sliceIsZero:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_15:
	.quad	L_OBJC_METH_VAR_NAME_22
	.cstring
L_OBJC_METH_VAR_NAME_23:
	.ascii "setImageProperty:withValue:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_14:
	.quad	L_OBJC_METH_VAR_NAME_23
	.cstring
L_OBJC_METH_VAR_NAME_24:
	.ascii "numberWithFloat:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_13:
	.quad	L_OBJC_METH_VAR_NAME_24
	.align 3
L_OBJC_SELECTOR_REFERENCES_12:
	.quad	L_OBJC_METH_VAR_NAME_4
	.cstring
L_OBJC_METH_VAR_NAME_25:
	.ascii "floatValue\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_11:
	.quad	L_OBJC_METH_VAR_NAME_25
	.cstring
L_OBJC_METH_VAR_NAME_26:
	.ascii "getValueFromCovariate:atTimestep:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_10:
	.quad	L_OBJC_METH_VAR_NAME_26
	.cstring
L_OBJC_METH_VAR_NAME_27:
	.ascii "postNotificationName:object:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_9:
	.quad	L_OBJC_METH_VAR_NAME_27
	.align 3
L_OBJC_SELECTOR_REFERENCES_8:
	.quad	L_OBJC_METH_VAR_NAME_8
	.cstring
L_OBJC_METH_VAR_NAME_28:
	.ascii "updateImage:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_7:
	.quad	L_OBJC_METH_VAR_NAME_28
	.align 3
L_OBJC_SELECTOR_REFERENCES_6:
	.quad	L_OBJC_METH_VAR_NAME_6
	.align 3
L_OBJC_SELECTOR_REFERENCES_5:
	.quad	L_OBJC_METH_VAR_NAME_5
	.align 3
L_OBJC_SELECTOR_REFERENCES_4:
	.quad	L_OBJC_METH_VAR_NAME_3
	.cstring
L_OBJC_METH_VAR_NAME_29:
	.ascii "addObserver:selector:name:object:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_3:
	.quad	L_OBJC_METH_VAR_NAME_29
	.cstring
L_OBJC_METH_VAR_NAME_30:
	.ascii "OnNewData:\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_2:
	.quad	L_OBJC_METH_VAR_NAME_30
	.cstring
L_OBJC_METH_VAR_NAME_31:
	.ascii "defaultCenter\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_1:
	.quad	L_OBJC_METH_VAR_NAME_31
	.cstring
L_OBJC_METH_VAR_NAME_32:
	.ascii "getGUI\0"
	.section __DATA, __objc_selrefs, literal_pointers, no_dead_strip
	.align 3
L_OBJC_SELECTOR_REFERENCES_0:
	.quad	L_OBJC_METH_VAR_NAME_32
	.cstring
L_OBJC_METH_VAR_NAME_33:
	.ascii "release\0"
	.private_extern l_objc_msgSend_fixup_release
.globl l_objc_msgSend_fixup_release
	.weak_definition l_objc_msgSend_fixup_release
	.section __DATA, __objc_msgrefs, coalesced
	.align 3
l_objc_msgSend_fixup_release:
	.quad	_objc_msgSend_fixup
	.quad	L_OBJC_METH_VAR_NAME_33
	.cstring
L_OBJC_METH_VAR_NAME_34:
	.ascii "alloc\0"
	.private_extern l_objc_msgSend_fixup_alloc
.globl l_objc_msgSend_fixup_alloc
	.weak_definition l_objc_msgSend_fixup_alloc
	.section __DATA, __objc_msgrefs, coalesced
	.align 3
l_objc_msgSend_fixup_alloc:
	.quad	_objc_msgSend_fixup
	.quad	L_OBJC_METH_VAR_NAME_34
	.section __DATA, __objc_classrefs, regular, no_dead_strip
	.align 3
L_OBJC_CLASSLIST_REFERENCES_$_0:
	.quad	_OBJC_CLASS_$_BAGUIPrototyp
	.align 3
L_OBJC_CLASSLIST_REFERENCES_$_1:
	.quad	_OBJC_CLASS_$_NSNotificationCenter
	.align 3
L_OBJC_CLASSLIST_REFERENCES_$_3:
	.quad	_OBJC_CLASS_$_NSNumber
	.align 3
L_OBJC_CLASSLIST_REFERENCES_$_4:
	.quad	_OBJC_CLASS_$_BADataElement
	.section __DATA, __objc_superrefs, regular, no_dead_strip
	.align 3
L_OBJC_CLASSLIST_SUP_REFS_$_2:
	.quad	_OBJC_CLASS_$_BAAnalyzerGLM
.globl _OBJC_IVAR_$_BAAnalyzerGLM.mDesign
	.section __DATA, __objc_const
	.align 3
_OBJC_IVAR_$_BAAnalyzerGLM.mDesign:
	.quad	8
.globl _OBJC_IVAR_$_BAAnalyzerGLM.mData
	.align 3
_OBJC_IVAR_$_BAAnalyzerGLM.mData:
	.quad	16
.globl _OBJC_IVAR_$_BAAnalyzerGLM.gui
	.align 3
_OBJC_IVAR_$_BAAnalyzerGLM.gui:
	.quad	24
	.section __DATA, __objc_classlist, regular, no_dead_strip
	.align 3
L_OBJC_LABEL_CLASS_$:
	.quad	_OBJC_CLASS_$_BAAnalyzerGLM
	.section __DATA, __objc_imageinfo, regular, no_dead_strip
	.align 2
L_OBJC_IMAGE_INFO:
	.long	0
	.long	16
	.objc_class_name_BAAnalyzerGLM=0
.globl .objc_class_name_BAAnalyzerGLM
.comm _mBetaOutput,8,3
	.literal4
	.align 2
LC15:
	.long	1065353216
	.literal8
	.align 3
LC16:
	.long	0
	.long	1072693248
	.align 3
LC17:
	.long	3539053052
	.long	1062232653
	.literal4
	.align 2
LC18:
	.long	1120403456
	.align 2
LC20:
	.long	1148846080
	.literal8
	.align 3
LC22:
	.long	3728718808
	.long	1073927851
	.align 3
LC23:
	.long	2576980378
	.long	1069128089
	.section __DWARF,__debug_frame,regular,debug
Lframe0:
	.set L$set$0,LECIE0-LSCIE0
	.long L$set$0
LSCIE0:
	.long	0xffffffff
	.byte	0x1
	.ascii "\0"
	.byte	0x1
	.byte	0x78
	.byte	0x10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.byte	0x90
	.byte	0x1
	.align 3
LECIE0:
LSFDE0:
	.set L$set$1,LEFDE0-LASFDE0
	.long L$set$1
LASFDE0:
	.set L$set$2,Lframe0-Lsection__debug_frame
	.long L$set$2
	.quad	LFB680
	.set L$set$3,LFE680-LFB680
	.quad L$set$3
	.byte	0x4
	.set L$set$4,LCFI0-LFB680
	.long L$set$4
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$5,LCFI1-LCFI0
	.long L$set$5
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$6,LCFI3-LCFI1
	.long L$set$6
	.byte	0x83
	.byte	0x3
	.align 3
LEFDE0:
LSFDE2:
	.set L$set$7,LEFDE2-LASFDE2
	.long L$set$7
LASFDE2:
	.set L$set$8,Lframe0-Lsection__debug_frame
	.long L$set$8
	.quad	LFB681
	.set L$set$9,LFE681-LFB681
	.quad L$set$9
	.byte	0x4
	.set L$set$10,LCFI4-LFB681
	.long L$set$10
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$11,LCFI5-LCFI4
	.long L$set$11
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE2:
LSFDE4:
	.set L$set$12,LEFDE4-LASFDE4
	.long L$set$12
LASFDE4:
	.set L$set$13,Lframe0-Lsection__debug_frame
	.long L$set$13
	.quad	LFB682
	.set L$set$14,LFE682-LFB682
	.quad L$set$14
	.byte	0x4
	.set L$set$15,LCFI7-LFB682
	.long L$set$15
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$16,LCFI8-LCFI7
	.long L$set$16
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE4:
LSFDE6:
	.set L$set$17,LEFDE6-LASFDE6
	.long L$set$17
LASFDE6:
	.set L$set$18,Lframe0-Lsection__debug_frame
	.long L$set$18
	.quad	LFB683
	.set L$set$19,LFE683-LFB683
	.quad L$set$19
	.byte	0x4
	.set L$set$20,LCFI10-LFB683
	.long L$set$20
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$21,LCFI11-LCFI10
	.long L$set$21
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE6:
LSFDE8:
	.set L$set$22,LEFDE8-LASFDE8
	.long L$set$22
LASFDE8:
	.set L$set$23,Lframe0-Lsection__debug_frame
	.long L$set$23
	.quad	LFB684
	.set L$set$24,LFE684-LFB684
	.quad L$set$24
	.byte	0x4
	.set L$set$25,LCFI12-LFB684
	.long L$set$25
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$26,LCFI13-LCFI12
	.long L$set$26
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE8:
LSFDE10:
	.set L$set$27,LEFDE10-LASFDE10
	.long L$set$27
LASFDE10:
	.set L$set$28,Lframe0-Lsection__debug_frame
	.long L$set$28
	.quad	LFB685
	.set L$set$29,LFE685-LFB685
	.quad L$set$29
	.byte	0x4
	.set L$set$30,LCFI15-LFB685
	.long L$set$30
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$31,LCFI16-LCFI15
	.long L$set$31
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$32,LCFI18-LCFI16
	.long L$set$32
	.byte	0x83
	.byte	0x3
	.align 3
LEFDE10:
LSFDE12:
	.set L$set$33,LEFDE12-LASFDE12
	.long L$set$33
LASFDE12:
	.set L$set$34,Lframe0-Lsection__debug_frame
	.long L$set$34
	.quad	LFB691
	.set L$set$35,LFE691-LFB691
	.quad L$set$35
	.byte	0x4
	.set L$set$36,LCFI19-LFB691
	.long L$set$36
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$37,LCFI20-LCFI19
	.long L$set$37
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE12:
LSFDE14:
	.set L$set$38,LEFDE14-LASFDE14
	.long L$set$38
LASFDE14:
	.set L$set$39,Lframe0-Lsection__debug_frame
	.long L$set$39
	.quad	LFB690
	.set L$set$40,LFE690-LFB690
	.quad L$set$40
	.byte	0x4
	.set L$set$41,LCFI22-LFB690
	.long L$set$41
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$42,LCFI23-LCFI22
	.long L$set$42
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE14:
LSFDE16:
	.set L$set$43,LEFDE16-LASFDE16
	.long L$set$43
LASFDE16:
	.set L$set$44,Lframe0-Lsection__debug_frame
	.long L$set$44
	.quad	LFB686
	.set L$set$45,LFE686-LFB686
	.quad L$set$45
	.byte	0x4
	.set L$set$46,LCFI25-LFB686
	.long L$set$46
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$47,LCFI26-LCFI25
	.long L$set$47
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE16:
LSFDE18:
	.set L$set$48,LEFDE18-LASFDE18
	.long L$set$48
LASFDE18:
	.set L$set$49,Lframe0-Lsection__debug_frame
	.long L$set$49
	.quad	LFB689
	.set L$set$50,LFE689-LFB689
	.quad L$set$50
	.byte	0x4
	.set L$set$51,LCFI28-LFB689
	.long L$set$51
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$52,LCFI29-LCFI28
	.long L$set$52
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE18:
LSFDE20:
	.set L$set$53,LEFDE20-LASFDE20
	.long L$set$53
LASFDE20:
	.set L$set$54,Lframe0-Lsection__debug_frame
	.long L$set$54
	.quad	LFB688
	.set L$set$55,LFE688-LFB688
	.quad L$set$55
	.byte	0x4
	.set L$set$56,LCFI31-LFB688
	.long L$set$56
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$57,LCFI32-LCFI31
	.long L$set$57
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE20:
LSFDE22:
	.set L$set$58,LEFDE22-LASFDE22
	.long L$set$58
LASFDE22:
	.set L$set$59,Lframe0-Lsection__debug_frame
	.long L$set$59
	.quad	LFB687
	.set L$set$60,LFE687-LFB687
	.quad L$set$60
	.byte	0x4
	.set L$set$61,LCFI34-LFB687
	.long L$set$61
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$62,LCFI35-LCFI34
	.long L$set$62
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE22:
LSFDE24:
	.set L$set$63,LEFDE24-LASFDE24
	.long L$set$63
LASFDE24:
	.set L$set$64,Lframe0-Lsection__debug_frame
	.long L$set$64
	.quad	LFB692
	.set L$set$65,LFE692-LFB692
	.quad L$set$65
	.byte	0x4
	.set L$set$66,LCFI37-LFB692
	.long L$set$66
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$67,LCFI38-LCFI37
	.long L$set$67
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE24:
LSFDE26:
	.set L$set$68,LEFDE26-LASFDE26
	.long L$set$68
LASFDE26:
	.set L$set$69,Lframe0-Lsection__debug_frame
	.long L$set$69
	.quad	LFB693
	.set L$set$70,LFE693-LFB693
	.quad L$set$70
	.byte	0x4
	.set L$set$71,LCFI40-LFB693
	.long L$set$71
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$72,LCFI41-LCFI40
	.long L$set$72
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$73,LCFI46-LCFI41
	.long L$set$73
	.byte	0x83
	.byte	0x6
	.byte	0x8c
	.byte	0x5
	.byte	0x8d
	.byte	0x4
	.byte	0x8e
	.byte	0x3
	.align 3
LEFDE26:
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$74,LECIE1-LSCIE1
	.long L$set$74
LSCIE1:
	.long	0x0
	.byte	0x1
	.ascii "zR\0"
	.byte	0x1
	.byte	0x78
	.byte	0x10
	.byte	0x1
	.byte	0x10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.byte	0x90
	.byte	0x1
	.align 3
LECIE1:
"-[BAAnalyzerGLM init].eh":
LSFDE1:
	.set L$set$75,LEFDE1-LASFDE1
	.long L$set$75
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB680-.
	.set L$set$76,LFE680-LFB680
	.quad L$set$76
	.byte	0x0
	.byte	0x4
	.set L$set$77,LCFI0-LFB680
	.long L$set$77
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$78,LCFI1-LCFI0
	.long L$set$78
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$79,LCFI3-LCFI1
	.long L$set$79
	.byte	0x83
	.byte	0x3
	.align 3
LEFDE1:
"-[BAAnalyzerGLM anaylzeTheData:withDesign:].eh":
LSFDE3:
	.set L$set$80,LEFDE3-LASFDE3
	.long L$set$80
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB681-.
	.set L$set$81,LFE681-LFB681
	.quad L$set$81
	.byte	0x0
	.byte	0x4
	.set L$set$82,LCFI4-LFB681
	.long L$set$82
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$83,LCFI5-LCFI4
	.long L$set$83
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE3:
"-[BAAnalyzerGLM dealloc].eh":
LSFDE5:
	.set L$set$84,LEFDE5-LASFDE5
	.long L$set$84
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB682-.
	.set L$set$85,LFE682-LFB682
	.quad L$set$85
	.byte	0x0
	.byte	0x4
	.set L$set$86,LCFI7-LFB682
	.long L$set$86
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$87,LCFI8-LCFI7
	.long L$set$87
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE5:
"-[BAAnalyzerGLM OnNewData].eh":
LSFDE7:
	.set L$set$88,LEFDE7-LASFDE7
	.long L$set$88
LASFDE7:
	.long	LASFDE7-EH_frame1
	.quad	LFB683-.
	.set L$set$89,LFE683-LFB683
	.quad L$set$89
	.byte	0x0
	.byte	0x4
	.set L$set$90,LCFI10-LFB683
	.long L$set$90
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$91,LCFI11-LCFI10
	.long L$set$91
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE7:
"-[BAAnalyzerGLM sendFinishNotification].eh":
LSFDE9:
	.set L$set$92,LEFDE9-LASFDE9
	.long L$set$92
LASFDE9:
	.long	LASFDE9-EH_frame1
	.quad	LFB684-.
	.set L$set$93,LFE684-LFB684
	.quad L$set$93
	.byte	0x0
	.byte	0x4
	.set L$set$94,LCFI12-LFB684
	.long L$set$94
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$95,LCFI13-LCFI12
	.long L$set$95
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE9:
"-[BAAnalyzerGLM Regression:::].eh":
LSFDE11:
	.set L$set$96,LEFDE11-LASFDE11
	.long L$set$96
LASFDE11:
	.long	LASFDE11-EH_frame1
	.quad	LFB685-.
	.set L$set$97,LFE685-LFB685
	.quad L$set$97
	.byte	0x0
	.byte	0x4
	.set L$set$98,LCFI15-LFB685
	.long L$set$98
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$99,LCFI16-LCFI15
	.long L$set$99
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$100,LCFI18-LCFI16
	.long L$set$100
	.byte	0x83
	.byte	0x3
	.align 3
LEFDE11:
___destroy_helper_block_1.eh:
LSFDE13:
	.set L$set$101,LEFDE13-LASFDE13
	.long L$set$101
LASFDE13:
	.long	LASFDE13-EH_frame1
	.quad	LFB691-.
	.set L$set$102,LFE691-LFB691
	.quad L$set$102
	.byte	0x0
	.byte	0x4
	.set L$set$103,LCFI19-LFB691
	.long L$set$103
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$104,LCFI20-LCFI19
	.long L$set$104
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE13:
___copy_helper_block_1.eh:
LSFDE15:
	.set L$set$105,LEFDE15-LASFDE15
	.long L$set$105
LASFDE15:
	.long	LASFDE15-EH_frame1
	.quad	LFB690-.
	.set L$set$106,LFE690-LFB690
	.quad L$set$106
	.byte	0x0
	.byte	0x4
	.set L$set$107,LCFI22-LFB690
	.long L$set$107
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$108,LCFI23-LCFI22
	.long L$set$108
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE15:
"___-[BAAnalyzerGLM Regression:::]_block_invoke_1.eh":
LSFDE17:
	.set L$set$109,LEFDE17-LASFDE17
	.long L$set$109
LASFDE17:
	.long	LASFDE17-EH_frame1
	.quad	LFB686-.
	.set L$set$110,LFE686-LFB686
	.quad L$set$110
	.byte	0x0
	.byte	0x4
	.set L$set$111,LCFI25-LFB686
	.long L$set$111
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$112,LCFI26-LCFI25
	.long L$set$112
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE17:
___destroy_helper_block_2.eh:
LSFDE19:
	.set L$set$113,LEFDE19-LASFDE19
	.long L$set$113
LASFDE19:
	.long	LASFDE19-EH_frame1
	.quad	LFB689-.
	.set L$set$114,LFE689-LFB689
	.quad L$set$114
	.byte	0x0
	.byte	0x4
	.set L$set$115,LCFI28-LFB689
	.long L$set$115
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$116,LCFI29-LCFI28
	.long L$set$116
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE19:
___copy_helper_block_2.eh:
LSFDE21:
	.set L$set$117,LEFDE21-LASFDE21
	.long L$set$117
LASFDE21:
	.long	LASFDE21-EH_frame1
	.quad	LFB688-.
	.set L$set$118,LFE688-LFB688
	.quad L$set$118
	.byte	0x0
	.byte	0x4
	.set L$set$119,LCFI31-LFB688
	.long L$set$119
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$120,LCFI32-LCFI31
	.long L$set$120
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE21:
"___-[BAAnalyzerGLM Regression:::]_block_invoke_2.eh":
LSFDE23:
	.set L$set$121,LEFDE23-LASFDE23
	.long L$set$121
LASFDE23:
	.long	LASFDE23-EH_frame1
	.quad	LFB687-.
	.set L$set$122,LFE687-LFB687
	.quad L$set$122
	.byte	0x0
	.byte	0x4
	.set L$set$123,LCFI34-LFB687
	.long L$set$123
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$124,LCFI35-LCFI34
	.long L$set$124
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE23:
"-[BAAnalyzerGLM CalcSigma:].eh":
LSFDE25:
	.set L$set$125,LEFDE25-LASFDE25
	.long L$set$125
LASFDE25:
	.long	LASFDE25-EH_frame1
	.quad	LFB692-.
	.set L$set$126,LFE692-LFB692
	.quad L$set$126
	.byte	0x0
	.byte	0x4
	.set L$set$127,LCFI37-LFB692
	.long L$set$127
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$128,LCFI38-LCFI37
	.long L$set$128
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE25:
"-[BAAnalyzerGLM createOutputImages].eh":
LSFDE27:
	.set L$set$129,LEFDE27-LASFDE27
	.long L$set$129
LASFDE27:
	.long	LASFDE27-EH_frame1
	.quad	LFB693-.
	.set L$set$130,LFE693-LFB693
	.quad L$set$130
	.byte	0x0
	.byte	0x4
	.set L$set$131,LCFI40-LFB693
	.long L$set$131
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$132,LCFI41-LCFI40
	.long L$set$132
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$133,LCFI46-LCFI41
	.long L$set$133
	.byte	0x83
	.byte	0x6
	.byte	0x8c
	.byte	0x5
	.byte	0x8d
	.byte	0x4
	.byte	0x8e
	.byte	0x3
	.align 3
LEFDE27:
	.text
Letext0:
	.section __DWARF,__debug_loc,regular,debug
Ldebug_loc0:
LLST0:
	.set L$set$134,LFB680-Ltext0
	.quad L$set$134
	.set L$set$135,LCFI0-Ltext0
	.quad L$set$135
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$136,LCFI0-Ltext0
	.quad L$set$136
	.set L$set$137,LCFI1-Ltext0
	.quad L$set$137
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$138,LCFI1-Ltext0
	.quad L$set$138
	.set L$set$139,LFE680-Ltext0
	.quad L$set$139
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST1:
	.set L$set$140,LFB681-Ltext0
	.quad L$set$140
	.set L$set$141,LCFI4-Ltext0
	.quad L$set$141
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$142,LCFI4-Ltext0
	.quad L$set$142
	.set L$set$143,LCFI5-Ltext0
	.quad L$set$143
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$144,LCFI5-Ltext0
	.quad L$set$144
	.set L$set$145,LFE681-Ltext0
	.quad L$set$145
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST2:
	.set L$set$146,LFB682-Ltext0
	.quad L$set$146
	.set L$set$147,LCFI7-Ltext0
	.quad L$set$147
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$148,LCFI7-Ltext0
	.quad L$set$148
	.set L$set$149,LCFI8-Ltext0
	.quad L$set$149
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$150,LCFI8-Ltext0
	.quad L$set$150
	.set L$set$151,LFE682-Ltext0
	.quad L$set$151
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST3:
	.set L$set$152,LFB683-Ltext0
	.quad L$set$152
	.set L$set$153,LCFI10-Ltext0
	.quad L$set$153
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$154,LCFI10-Ltext0
	.quad L$set$154
	.set L$set$155,LCFI11-Ltext0
	.quad L$set$155
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$156,LCFI11-Ltext0
	.quad L$set$156
	.set L$set$157,LFE683-Ltext0
	.quad L$set$157
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST4:
	.set L$set$158,LFB684-Ltext0
	.quad L$set$158
	.set L$set$159,LCFI12-Ltext0
	.quad L$set$159
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$160,LCFI12-Ltext0
	.quad L$set$160
	.set L$set$161,LCFI13-Ltext0
	.quad L$set$161
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$162,LCFI13-Ltext0
	.quad L$set$162
	.set L$set$163,LFE684-Ltext0
	.quad L$set$163
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST5:
	.set L$set$164,LFB685-Ltext0
	.quad L$set$164
	.set L$set$165,LCFI15-Ltext0
	.quad L$set$165
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$166,LCFI15-Ltext0
	.quad L$set$166
	.set L$set$167,LCFI16-Ltext0
	.quad L$set$167
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$168,LCFI16-Ltext0
	.quad L$set$168
	.set L$set$169,LFE685-Ltext0
	.quad L$set$169
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST8:
	.set L$set$170,LFB686-Ltext0
	.quad L$set$170
	.set L$set$171,LCFI25-Ltext0
	.quad L$set$171
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$172,LCFI25-Ltext0
	.quad L$set$172
	.set L$set$173,LCFI26-Ltext0
	.quad L$set$173
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$174,LCFI26-Ltext0
	.quad L$set$174
	.set L$set$175,LFE686-Ltext0
	.quad L$set$175
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST7:
	.set L$set$176,LFB690-Ltext0
	.quad L$set$176
	.set L$set$177,LCFI22-Ltext0
	.quad L$set$177
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$178,LCFI22-Ltext0
	.quad L$set$178
	.set L$set$179,LCFI23-Ltext0
	.quad L$set$179
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$180,LCFI23-Ltext0
	.quad L$set$180
	.set L$set$181,LFE690-Ltext0
	.quad L$set$181
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST6:
	.set L$set$182,LFB691-Ltext0
	.quad L$set$182
	.set L$set$183,LCFI19-Ltext0
	.quad L$set$183
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$184,LCFI19-Ltext0
	.quad L$set$184
	.set L$set$185,LCFI20-Ltext0
	.quad L$set$185
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$186,LCFI20-Ltext0
	.quad L$set$186
	.set L$set$187,LFE691-Ltext0
	.quad L$set$187
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST11:
	.set L$set$188,LFB687-Ltext0
	.quad L$set$188
	.set L$set$189,LCFI34-Ltext0
	.quad L$set$189
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$190,LCFI34-Ltext0
	.quad L$set$190
	.set L$set$191,LCFI35-Ltext0
	.quad L$set$191
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$192,LCFI35-Ltext0
	.quad L$set$192
	.set L$set$193,LFE687-Ltext0
	.quad L$set$193
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST10:
	.set L$set$194,LFB688-Ltext0
	.quad L$set$194
	.set L$set$195,LCFI31-Ltext0
	.quad L$set$195
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$196,LCFI31-Ltext0
	.quad L$set$196
	.set L$set$197,LCFI32-Ltext0
	.quad L$set$197
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$198,LCFI32-Ltext0
	.quad L$set$198
	.set L$set$199,LFE688-Ltext0
	.quad L$set$199
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST9:
	.set L$set$200,LFB689-Ltext0
	.quad L$set$200
	.set L$set$201,LCFI28-Ltext0
	.quad L$set$201
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$202,LCFI28-Ltext0
	.quad L$set$202
	.set L$set$203,LCFI29-Ltext0
	.quad L$set$203
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$204,LCFI29-Ltext0
	.quad L$set$204
	.set L$set$205,LFE689-Ltext0
	.quad L$set$205
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST12:
	.set L$set$206,LFB692-Ltext0
	.quad L$set$206
	.set L$set$207,LCFI37-Ltext0
	.quad L$set$207
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$208,LCFI37-Ltext0
	.quad L$set$208
	.set L$set$209,LCFI38-Ltext0
	.quad L$set$209
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$210,LCFI38-Ltext0
	.quad L$set$210
	.set L$set$211,LFE692-Ltext0
	.quad L$set$211
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
LLST13:
	.set L$set$212,LFB693-Ltext0
	.quad L$set$212
	.set L$set$213,LCFI40-Ltext0
	.quad L$set$213
	.word	0x2
	.byte	0x77
	.byte	0x8
	.set L$set$214,LCFI40-Ltext0
	.quad L$set$214
	.set L$set$215,LCFI41-Ltext0
	.quad L$set$215
	.word	0x2
	.byte	0x77
	.byte	0x10
	.set L$set$216,LCFI41-Ltext0
	.quad L$set$216
	.set L$set$217,LFE693-Ltext0
	.quad L$set$217
	.word	0x2
	.byte	0x76
	.byte	0x10
	.quad	0x0
	.quad	0x0
	.file 2 "/usr/include/i386/_types.h"
	.file 3 "/usr/include/sys/_types.h"
	.file 4 "/usr/include/sys/types.h"
	.file 5 "/usr/include/runetype.h"
	.file 6 "/usr/include/architecture/i386/math.h"
	.file 7 "/usr/include/stdio.h"
	.file 8 "/usr/include/dispatch/queue.h"
	.file 9 "<built-in>"
	.file 10 "/usr/include/objc/objc.h"
	.file 11 "/System/Library/Frameworks/Foundation.framework/Headers/NSObjCRuntime.h"
	.file 12 "/System/Library/Frameworks/Foundation.framework/Headers/NSObject.h"
	.file 13 "/System/Library/Frameworks/Foundation.framework/Headers/NSValue.h"
	.file 14 "/System/Library/Frameworks/Foundation.framework/Headers/NSArray.h"
	.file 15 "/System/Library/Frameworks/Foundation.framework/Headers/NSDictionary.h"
	.file 16 "/System/Library/Frameworks/Foundation.framework/Headers/NSSet.h"
	.file 17 "/System/Library/Frameworks/ApplicationServices.framework/Headers/../Frameworks/CoreGraphics.framework/Headers/CGBase.h"
	.file 18 "/System/Library/Frameworks/ApplicationServices.framework/Headers/../Frameworks/CoreGraphics.framework/Headers/CGGeometry.h"
	.file 19 "/System/Library/Frameworks/Foundation.framework/Headers/NSGeometry.h"
	.file 20 "/System/Library/Frameworks/Foundation.framework/Headers/NSNotification.h"
	.file 21 "/System/Library/Frameworks/Foundation.framework/Headers/NSURL.h"
	.file 22 "/System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework/Headers/CGColorSpace.h"
	.file 23 "/System/Library/Frameworks/AppKit.framework/Headers/NSResponder.h"
	.file 24 "/System/Library/Frameworks/AppKit.framework/Headers/NSView.h"
	.file 25 "/System/Library/Frameworks/AppKit.framework/Headers/NSGraphics.h"
	.file 26 "/System/Library/Frameworks/AppKit.framework/Headers/NSWindow.h"
	.file 27 "/System/Library/Frameworks/AppKit.framework/Headers/NSImage.h"
	.file 28 "/System/Library/Frameworks/QuartzCore.framework/Headers/CIImage.h"
	.file 29 "/System/Library/Frameworks/AppKit.framework/Headers/NSBitmapImageRep.h"
	.file 30 "/System/Library/Frameworks/OpenGL.framework/Headers/gl.h"
	.file 31 "/System/Library/Frameworks/AppKit.framework/Headers/NSOpenGL.h"
	.file 32 "/System/Library/Frameworks/AppKit.framework/Headers/NSOpenGLView.h"
	.file 33 "/Users/user/Development/BARTProcedure/BARTApplication/BAAnalyzerElement.h"
	.file 34 "/System/Library/Frameworks/AppKit.framework/Headers/NSGraphicsContext.h"
	.file 35 "/System/Library/Frameworks/QuartzCore.framework/Headers/CIContext.h"
	.file 36 "/System/Library/Frameworks/QuartzCore.framework/Headers/CIFilter.h"
	.file 37 "/Users/user/Development/BARTProcedure/BARTApplication/BAElement.h"
	.file 38 "/Users/user/Development/BARTProcedure/BARTApplication/BADataElement.h"
	.file 39 "/Users/user/Development/BARTProcedure/BARTApplication/BAGUIPrototyp.h"
	.file 40 "/Users/user/Development/BARTProcedure/BARTApplication/BAAnalyzerGLM.h"
	.file 41 "/Users/user/Development/BARTProcedure/BARTApplication/BADesignElement.h"
	.file 42 "/usr/local/include/gsl/gsl_block_double.h"
	.file 43 "/usr/local/include/gsl/gsl_vector_double.h"
	.file 44 "/usr/local/include/gsl/gsl_block_float.h"
	.file 45 "/usr/local/include/gsl/gsl_vector_float.h"
	.file 46 "/usr/local/include/gsl/gsl_matrix_float.h"
	.section __DWARF,__debug_info,regular,debug
	.long	0x37ec
	.word	0x2
	.set L$set$218,Ldebug_abbrev0-Lsection__debug_abbrev
	.long L$set$218
	.byte	0x8
	.byte	0x1
	.ascii "GNU Objective-C 4.2.1 (Apple Inc. build 5646)\0"
	.byte	0x10
	.ascii "/Users/user/Development/BARTProcedure/BARTApplication/BAAnalyzerGLM.m\0"
	.byte	0x2
	.quad	Ltext0
	.quad	Letext0
	.set L$set$219,Ldebug_line0-Lsection__debug_line
	.long L$set$219
	.byte	0x2
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.byte	0x2
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.byte	0x2
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.byte	0x2
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.byte	0x2
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.byte	0x3
	.ascii "__uint32_t\0"
	.byte	0x2
	.byte	0x2d
	.long	0xf2
	.byte	0x2
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.byte	0x3
	.ascii "__int64_t\0"
	.byte	0x2
	.byte	0x2e
	.long	0x113
	.byte	0x2
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.byte	0x2
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.byte	0x2
	.byte	0x8
	.byte	0x5
	.ascii "long int\0"
	.byte	0x4
	.byte	0x8
	.byte	0x7
	.byte	0x2
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.byte	0x3
	.ascii "__darwin_size_t\0"
	.byte	0x2
	.byte	0x5a
	.long	0x16c
	.byte	0x2
	.byte	0x8
	.byte	0x7
	.ascii "long unsigned int\0"
	.byte	0x5
	.byte	0x8
	.byte	0x3
	.ascii "__darwin_wchar_t\0"
	.byte	0x2
	.byte	0x66
	.long	0xd9
	.byte	0x3
	.ascii "__darwin_rune_t\0"
	.byte	0x2
	.byte	0x6b
	.long	0x183
	.byte	0x6
	.long	0x14d
	.long	0x1c2
	.byte	0x7
	.long	0x14a
	.byte	0x7
	.byte	0x0
	.byte	0x3
	.ascii "__darwin_off_t\0"
	.byte	0x3
	.byte	0x6e
	.long	0x102
	.byte	0x8
	.byte	0x8
	.long	0x14d
	.byte	0x3
	.ascii "size_t\0"
	.byte	0x4
	.byte	0xe6
	.long	0x155
	.byte	0x9
	.byte	0x18
	.byte	0x5
	.byte	0x51
	.long	0x237
	.byte	0xa
	.ascii "__min\0"
	.byte	0x5
	.byte	0x52
	.long	0x19b
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "__max\0"
	.byte	0x5
	.byte	0x53
	.long	0x19b
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0xa
	.ascii "__map\0"
	.byte	0x5
	.byte	0x54
	.long	0x19b
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "__types\0"
	.byte	0x5
	.byte	0x55
	.long	0x237
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0xe0
	.byte	0x3
	.ascii "_RuneEntry\0"
	.byte	0x5
	.byte	0x56
	.long	0x1ec
	.byte	0x9
	.byte	0x10
	.byte	0x5
	.byte	0x58
	.long	0x27f
	.byte	0xa
	.ascii "__nranges\0"
	.byte	0x5
	.byte	0x59
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "__ranges\0"
	.byte	0x5
	.byte	0x5a
	.long	0x27f
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x23d
	.byte	0x3
	.ascii "_RuneRange\0"
	.byte	0x5
	.byte	0x5b
	.long	0x24f
	.byte	0x9
	.byte	0x14
	.byte	0x5
	.byte	0x5d
	.long	0x2c2
	.byte	0xa
	.ascii "__name\0"
	.byte	0x5
	.byte	0x5e
	.long	0x2c2
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "__mask\0"
	.byte	0x5
	.byte	0x5f
	.long	0xe0
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x0
	.byte	0x6
	.long	0x14d
	.long	0x2d2
	.byte	0x7
	.long	0x14a
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.ascii "_RuneCharClass\0"
	.byte	0x5
	.byte	0x60
	.long	0x297
	.byte	0xb
	.word	0xc88
	.byte	0x5
	.byte	0x62
	.long	0x44e
	.byte	0xa
	.ascii "__magic\0"
	.byte	0x5
	.byte	0x63
	.long	0x1b2
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "__encoding\0"
	.byte	0x5
	.byte	0x64
	.long	0x44e
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "__sgetrune\0"
	.byte	0x5
	.byte	0x66
	.long	0x489
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0xa
	.ascii "__sputrune\0"
	.byte	0x5
	.byte	0x67
	.long	0x4b4
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0xa
	.ascii "__invalid_rune\0"
	.byte	0x5
	.byte	0x68
	.long	0x19b
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0xa
	.ascii "__runetype\0"
	.byte	0x5
	.byte	0x6a
	.long	0x4ba
	.byte	0x2
	.byte	0x23
	.byte	0x3c
	.byte	0xa
	.ascii "__maplower\0"
	.byte	0x5
	.byte	0x6b
	.long	0x4ca
	.byte	0x3
	.byte	0x23
	.byte	0xbc,0x8
	.byte	0xa
	.ascii "__mapupper\0"
	.byte	0x5
	.byte	0x6c
	.long	0x4ca
	.byte	0x3
	.byte	0x23
	.byte	0xbc,0x10
	.byte	0xa
	.ascii "__runetype_ext\0"
	.byte	0x5
	.byte	0x73
	.long	0x285
	.byte	0x3
	.byte	0x23
	.byte	0xc0,0x18
	.byte	0xa
	.ascii "__maplower_ext\0"
	.byte	0x5
	.byte	0x74
	.long	0x285
	.byte	0x3
	.byte	0x23
	.byte	0xd0,0x18
	.byte	0xa
	.ascii "__mapupper_ext\0"
	.byte	0x5
	.byte	0x75
	.long	0x285
	.byte	0x3
	.byte	0x23
	.byte	0xe0,0x18
	.byte	0xa
	.ascii "__variable\0"
	.byte	0x5
	.byte	0x77
	.long	0x181
	.byte	0x3
	.byte	0x23
	.byte	0xf0,0x18
	.byte	0xa
	.ascii "__variable_len\0"
	.byte	0x5
	.byte	0x78
	.long	0xd9
	.byte	0x3
	.byte	0x23
	.byte	0xf8,0x18
	.byte	0xa
	.ascii "__ncharclasses\0"
	.byte	0x5
	.byte	0x7d
	.long	0xd9
	.byte	0x3
	.byte	0x23
	.byte	0xfc,0x18
	.byte	0xa
	.ascii "__charclasses\0"
	.byte	0x5
	.byte	0x7e
	.long	0x4da
	.byte	0x3
	.byte	0x23
	.byte	0x80,0x19
	.byte	0x0
	.byte	0x6
	.long	0x14d
	.long	0x45e
	.byte	0x7
	.long	0x14a
	.byte	0x1f
	.byte	0x0
	.byte	0xc
	.byte	0x1
	.long	0x19b
	.long	0x478
	.byte	0xd
	.long	0x478
	.byte	0xd
	.long	0x155
	.byte	0xd
	.long	0x483
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x47e
	.byte	0xe
	.long	0x14d
	.byte	0x8
	.byte	0x8
	.long	0x478
	.byte	0x8
	.byte	0x8
	.long	0x45e
	.byte	0xc
	.byte	0x1
	.long	0xd9
	.long	0x4ae
	.byte	0xd
	.long	0x19b
	.byte	0xd
	.long	0x1d8
	.byte	0xd
	.long	0x155
	.byte	0xd
	.long	0x4ae
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1d8
	.byte	0x8
	.byte	0x8
	.long	0x48f
	.byte	0x6
	.long	0xe0
	.long	0x4ca
	.byte	0x7
	.long	0x14a
	.byte	0xff
	.byte	0x0
	.byte	0x6
	.long	0x19b
	.long	0x4da
	.byte	0x7
	.long	0x14a
	.byte	0xff
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2d2
	.byte	0x3
	.ascii "_RuneLocale\0"
	.byte	0x5
	.byte	0x7f
	.long	0x2e8
	.byte	0x3
	.ascii "float_t\0"
	.byte	0x6
	.byte	0x31
	.long	0x502
	.byte	0x2
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.byte	0x2
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.byte	0x3
	.ascii "fpos_t\0"
	.byte	0x7
	.byte	0x57
	.long	0x1c2
	.byte	0xf
	.ascii "__sbuf\0"
	.byte	0x10
	.byte	0x7
	.byte	0x62
	.long	0x553
	.byte	0xa
	.ascii "_base\0"
	.byte	0x7
	.byte	0x63
	.long	0x553
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "_size\0"
	.byte	0x7
	.byte	0x64
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0xa5
	.byte	0xf
	.ascii "__sFILE\0"
	.byte	0x98
	.byte	0x7
	.byte	0x84
	.long	0x6a9
	.byte	0xa
	.ascii "_p\0"
	.byte	0x7
	.byte	0x85
	.long	0x553
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "_r\0"
	.byte	0x7
	.byte	0x86
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "_w\0"
	.byte	0x7
	.byte	0x87
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0xa
	.ascii "_flags\0"
	.byte	0x7
	.byte	0x88
	.long	0xb6
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "_file\0"
	.byte	0x7
	.byte	0x89
	.long	0xb6
	.byte	0x2
	.byte	0x23
	.byte	0x12
	.byte	0xa
	.ascii "_bf\0"
	.byte	0x7
	.byte	0x8a
	.long	0x523
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0xa
	.ascii "_lbfsize\0"
	.byte	0x7
	.byte	0x8b
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0xa
	.ascii "_cookie\0"
	.byte	0x7
	.byte	0x8e
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0xa
	.ascii "_close\0"
	.byte	0x7
	.byte	0x8f
	.long	0x6b9
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0xa
	.ascii "_read\0"
	.byte	0x7
	.byte	0x90
	.long	0x6d9
	.byte	0x2
	.byte	0x23
	.byte	0x40
	.byte	0xa
	.ascii "_seek\0"
	.byte	0x7
	.byte	0x91
	.long	0x6f9
	.byte	0x2
	.byte	0x23
	.byte	0x48
	.byte	0xa
	.ascii "_write\0"
	.byte	0x7
	.byte	0x92
	.long	0x719
	.byte	0x2
	.byte	0x23
	.byte	0x50
	.byte	0xa
	.ascii "_ub\0"
	.byte	0x7
	.byte	0x95
	.long	0x523
	.byte	0x2
	.byte	0x23
	.byte	0x58
	.byte	0xa
	.ascii "_extra\0"
	.byte	0x7
	.byte	0x96
	.long	0x72a
	.byte	0x2
	.byte	0x23
	.byte	0x68
	.byte	0xa
	.ascii "_ur\0"
	.byte	0x7
	.byte	0x97
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x70
	.byte	0xa
	.ascii "_ubuf\0"
	.byte	0x7
	.byte	0x9a
	.long	0x730
	.byte	0x2
	.byte	0x23
	.byte	0x74
	.byte	0xa
	.ascii "_nbuf\0"
	.byte	0x7
	.byte	0x9b
	.long	0x740
	.byte	0x2
	.byte	0x23
	.byte	0x77
	.byte	0xa
	.ascii "_lb\0"
	.byte	0x7
	.byte	0x9e
	.long	0x523
	.byte	0x2
	.byte	0x23
	.byte	0x78
	.byte	0xa
	.ascii "_blksize\0"
	.byte	0x7
	.byte	0xa1
	.long	0xd9
	.byte	0x3
	.byte	0x23
	.byte	0x88,0x1
	.byte	0xa
	.ascii "_offset\0"
	.byte	0x7
	.byte	0xa2
	.long	0x515
	.byte	0x3
	.byte	0x23
	.byte	0x90,0x1
	.byte	0x0
	.byte	0xc
	.byte	0x1
	.long	0xd9
	.long	0x6b9
	.byte	0xd
	.long	0x181
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x6a9
	.byte	0xc
	.byte	0x1
	.long	0xd9
	.long	0x6d9
	.byte	0xd
	.long	0x181
	.byte	0xd
	.long	0x1d8
	.byte	0xd
	.long	0xd9
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x6bf
	.byte	0xc
	.byte	0x1
	.long	0x515
	.long	0x6f9
	.byte	0xd
	.long	0x181
	.byte	0xd
	.long	0x515
	.byte	0xd
	.long	0xd9
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x6df
	.byte	0xc
	.byte	0x1
	.long	0xd9
	.long	0x719
	.byte	0xd
	.long	0x181
	.byte	0xd
	.long	0x478
	.byte	0xd
	.long	0xd9
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x6ff
	.byte	0x10
	.ascii "__sFILEX\0"
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x71f
	.byte	0x6
	.long	0xa5
	.long	0x740
	.byte	0x7
	.long	0x14a
	.byte	0x2
	.byte	0x0
	.byte	0x6
	.long	0xa5
	.long	0x750
	.byte	0x7
	.long	0x14a
	.byte	0x0
	.byte	0x0
	.byte	0x3
	.ascii "FILE\0"
	.byte	0x7
	.byte	0xa3
	.long	0x559
	.byte	0x10
	.ascii "dispatch_queue_s\0"
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x75c
	.byte	0x3
	.ascii "dispatch_queue_t\0"
	.byte	0x8
	.byte	0x33
	.long	0x76f
	.byte	0x11
	.byte	0x4
	.byte	0x8
	.word	0x164
	.long	0x7f6
	.byte	0x12
	.ascii "DISPATCH_QUEUE_PRIORITY_HIGH\0"
	.byte	0x2
	.byte	0x12
	.ascii "DISPATCH_QUEUE_PRIORITY_DEFAULT\0"
	.byte	0x0
	.byte	0x12
	.ascii "DISPATCH_QUEUE_PRIORITY_LOW\0"
	.byte	0x7e
	.byte	0x0
	.byte	0x13
	.byte	0x8
	.ascii "Class\0"
	.long	0x802
	.byte	0x10
	.ascii "objc_class\0"
	.byte	0x1
	.byte	0x13
	.byte	0x8
	.ascii "id\0"
	.long	0x818
	.byte	0xf
	.ascii "objc_object\0"
	.byte	0x8
	.byte	0x9
	.byte	0x0
	.long	0x83b
	.byte	0xa
	.ascii "isa\0"
	.byte	0xa
	.byte	0x25
	.long	0x7f6
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x841
	.byte	0x10
	.ascii "objc_selector\0"
	.byte	0x1
	.byte	0x3
	.ascii "NSInteger\0"
	.byte	0xb
	.byte	0xa7
	.long	0x13e
	.byte	0x3
	.ascii "NSUInteger\0"
	.byte	0xb
	.byte	0xa8
	.long	0x16c
	.byte	0x14
	.ascii "NSObject\0"
	.byte	0x10
	.byte	0x8
	.byte	0xc
	.byte	0x43
	.long	0x896
	.byte	0x15
	.ascii "isa\0"
	.byte	0xc
	.byte	0x42
	.long	0x7f6
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x2
	.byte	0x0
	.byte	0x14
	.ascii "NSValue\0"
	.byte	0x10
	.byte	0x8
	.byte	0xd
	.byte	0xb
	.long	0x8b1
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "NSNumber\0"
	.byte	0x10
	.byte	0x8
	.byte	0xd
	.byte	0x26
	.long	0x8cd
	.byte	0x16
	.long	0x896
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "NSString\0"
	.byte	0x10
	.byte	0x8
	.byte	0xb
	.byte	0xb4
	.long	0x8e9
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "NSData\0"
	.byte	0x10
	.byte	0x8
	.byte	0xe
	.byte	0xa
	.long	0x903
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "NSDictionary\0"
	.byte	0x10
	.byte	0x8
	.byte	0xd
	.byte	0x7
	.long	0x923
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x8cd
	.byte	0x8
	.byte	0x8
	.long	0x903
	.byte	0x14
	.ascii "NSSet\0"
	.byte	0x10
	.byte	0x8
	.byte	0xf
	.byte	0x8
	.long	0x948
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "NSMutableSet\0"
	.byte	0x10
	.byte	0x8
	.byte	0x10
	.byte	0x45
	.long	0x968
	.byte	0x16
	.long	0x92f
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x3
	.ascii "CGFloat\0"
	.byte	0x11
	.byte	0x69
	.long	0x50b
	.byte	0xf
	.ascii "CGPoint\0"
	.byte	0x10
	.byte	0x12
	.byte	0xd
	.long	0x9a0
	.byte	0xa
	.ascii "x\0"
	.byte	0x12
	.byte	0xe
	.long	0x968
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "y\0"
	.byte	0x12
	.byte	0xf
	.long	0x968
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x3
	.ascii "CGPoint\0"
	.byte	0x12
	.byte	0x11
	.long	0x977
	.byte	0xf
	.ascii "CGSize\0"
	.byte	0x10
	.byte	0x12
	.byte	0x15
	.long	0x9e0
	.byte	0xa
	.ascii "width\0"
	.byte	0x12
	.byte	0x16
	.long	0x968
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "height\0"
	.byte	0x12
	.byte	0x17
	.long	0x968
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x3
	.ascii "CGSize\0"
	.byte	0x12
	.byte	0x19
	.long	0x9af
	.byte	0xf
	.ascii "CGRect\0"
	.byte	0x20
	.byte	0x12
	.byte	0x1d
	.long	0xa1e
	.byte	0xa
	.ascii "origin\0"
	.byte	0x12
	.byte	0x1e
	.long	0x9a0
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "size\0"
	.byte	0x12
	.byte	0x1f
	.long	0x9e0
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x0
	.byte	0x3
	.ascii "CGRect\0"
	.byte	0x12
	.byte	0x21
	.long	0x9ee
	.byte	0x3
	.ascii "NSSize\0"
	.byte	0x13
	.byte	0x1a
	.long	0x9e0
	.byte	0x8
	.byte	0x8
	.long	0xa2c
	.byte	0x3
	.ascii "NSRect\0"
	.byte	0x13
	.byte	0x1f
	.long	0xa1e
	.byte	0x14
	.ascii "NSNotificationCenter\0"
	.byte	0x10
	.byte	0x70
	.byte	0x14
	.byte	0x21
	.long	0xaaf
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0xa
	.ascii "_impl\0"
	.byte	0x14
	.byte	0x1e
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "_callback_block\0"
	.byte	0x14
	.byte	0x1f
	.long	0xaaf
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "_pad\0"
	.byte	0x14
	.byte	0x20
	.long	0xabf
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x0
	.byte	0x6
	.long	0x181
	.long	0xabf
	.byte	0x7
	.long	0x14a
	.byte	0x3
	.byte	0x0
	.byte	0x6
	.long	0x181
	.long	0xacf
	.byte	0x7
	.long	0x14a
	.byte	0x7
	.byte	0x0
	.byte	0x14
	.ascii "NSURL\0"
	.byte	0x10
	.byte	0x28
	.byte	0xe
	.byte	0xa
	.long	0xb3b
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_urlString\0"
	.byte	0x15
	.byte	0x27
	.long	0x923
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "_baseURL\0"
	.byte	0x15
	.byte	0x28
	.long	0xb3b
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x15
	.ascii "_clients\0"
	.byte	0x15
	.byte	0x29
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x2
	.byte	0x15
	.ascii "_reserved\0"
	.byte	0x15
	.byte	0x2a
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0xacf
	.byte	0x6
	.long	0xd9
	.long	0xb4c
	.byte	0x17
	.byte	0x0
	.byte	0x3
	.ascii "CGColorSpaceRef\0"
	.byte	0x16
	.byte	0x8
	.long	0xb63
	.byte	0x8
	.byte	0x8
	.long	0xb69
	.byte	0x10
	.ascii "CGColorSpace\0"
	.byte	0x1
	.byte	0x2
	.byte	0x1
	.byte	0x2
	.ascii "_Bool\0"
	.byte	0x8
	.byte	0x8
	.long	0x502
	.byte	0x8
	.byte	0x8
	.long	0x948
	.byte	0x14
	.ascii "NSResponder\0"
	.byte	0x10
	.byte	0x10
	.byte	0x17
	.byte	0x10
	.long	0xbc6
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_nextResponder\0"
	.byte	0x17
	.byte	0xf
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x0
	.byte	0xf
	.ascii "__VFlags\0"
	.byte	0x4
	.byte	0x18
	.byte	0x43
	.long	0xe8a
	.byte	0x18
	.ascii "aboutToResize\0"
	.byte	0x18
	.byte	0x5c
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "retainCountOverMax\0"
	.byte	0x18
	.byte	0x5d
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "retainCount\0"
	.byte	0x18
	.byte	0x5e
	.long	0xf2
	.byte	0x4
	.byte	0x6
	.byte	0x18
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "interfaceStyle1\0"
	.byte	0x18
	.byte	0x5f
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "specialArchiving\0"
	.byte	0x18
	.byte	0x60
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsDisplayForBounds\0"
	.byte	0x18
	.byte	0x61
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "interfaceStyle0\0"
	.byte	0x18
	.byte	0x62
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "removingWithoutInvalidation\0"
	.byte	0x18
	.byte	0x63
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x13
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsBoundsChangeNote\0"
	.byte	0x18
	.byte	0x64
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x12
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "boundsChangeNotesSuspended\0"
	.byte	0x18
	.byte	0x65
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x11
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "focusChangeNotesSuspended\0"
	.byte	0x18
	.byte	0x66
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x10
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsFrameChangeNote\0"
	.byte	0x18
	.byte	0x67
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xf
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "frameChangeNotesSuspended\0"
	.byte	0x18
	.byte	0x68
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xe
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "noVerticalAutosizing\0"
	.byte	0x18
	.byte	0x69
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xd
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "newGState\0"
	.byte	0x18
	.byte	0x6a
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xc
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "validGState\0"
	.byte	0x18
	.byte	0x6b
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xb
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsDisplay\0"
	.byte	0x18
	.byte	0x6c
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xa
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "wantsGState\0"
	.byte	0x18
	.byte	0x6d
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x9
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "autoresizeSubviews\0"
	.byte	0x18
	.byte	0x6e
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x8
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "autosizing\0"
	.byte	0x18
	.byte	0x6f
	.long	0xf2
	.byte	0x4
	.byte	0x6
	.byte	0x2
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "rotatedOrScaledFromBase\0"
	.byte	0x18
	.byte	0x70
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "rotatedFromBase\0"
	.byte	0x18
	.byte	0x71
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x0
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x0
	.byte	0x3
	.ascii "_VFlags\0"
	.byte	0x18
	.byte	0x73
	.long	0xbc6
	.byte	0xf
	.ascii "__VFlags2\0"
	.byte	0x4
	.byte	0x18
	.byte	0x8b
	.long	0xf5d
	.byte	0x18
	.ascii "nextKeyViewRefCount\0"
	.byte	0x18
	.byte	0x8c
	.long	0xf2
	.byte	0x4
	.byte	0xe
	.byte	0x12
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "previousKeyViewRefCount\0"
	.byte	0x18
	.byte	0x8d
	.long	0xf2
	.byte	0x4
	.byte	0xe
	.byte	0x4
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "isVisibleRect\0"
	.byte	0x18
	.byte	0x8e
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x3
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "hasToolTip\0"
	.byte	0x18
	.byte	0x8f
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x2
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsRealLockFocus\0"
	.byte	0x18
	.byte	0x90
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "menuWasSet\0"
	.byte	0x18
	.byte	0x91
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x0
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x0
	.byte	0x14
	.ascii "NSView\0"
	.byte	0x10
	.byte	0x98
	.byte	0x19
	.byte	0xb
	.long	0x1070
	.byte	0x16
	.long	0xb8d
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_frame\0"
	.byte	0x18
	.byte	0x80
	.long	0xa40
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x15
	.ascii "_bounds\0"
	.byte	0x18
	.byte	0x81
	.long	0xa40
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x2
	.byte	0x15
	.ascii "_superview\0"
	.byte	0x18
	.byte	0x82
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x50
	.byte	0x2
	.byte	0x15
	.ascii "_subviews\0"
	.byte	0x18
	.byte	0x83
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x58
	.byte	0x2
	.byte	0x15
	.ascii "_window\0"
	.byte	0x18
	.byte	0x84
	.long	0x1372
	.byte	0x2
	.byte	0x23
	.byte	0x60
	.byte	0x2
	.byte	0x15
	.ascii "_gState\0"
	.byte	0x18
	.byte	0x85
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x68
	.byte	0x2
	.byte	0x15
	.ascii "_frameMatrix\0"
	.byte	0x18
	.byte	0x86
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x70
	.byte	0x2
	.byte	0x15
	.ascii "_drawMatrix\0"
	.byte	0x18
	.byte	0x87
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x78
	.byte	0x2
	.byte	0x19
	.set L$set$220,LASF0-Lsection__debug_str
	.long L$set$220
	.byte	0x18
	.byte	0x88
	.long	0x80f
	.byte	0x3
	.byte	0x23
	.byte	0x80,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_viewAuxiliary\0"
	.byte	0x18
	.byte	0x89
	.long	0x138c
	.byte	0x3
	.byte	0x23
	.byte	0x88,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_vFlags\0"
	.byte	0x18
	.byte	0x8a
	.long	0xe8a
	.byte	0x3
	.byte	0x23
	.byte	0x90,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_vFlags2\0"
	.byte	0x18
	.byte	0x92
	.long	0xe99
	.byte	0x3
	.byte	0x23
	.byte	0x94,0x1
	.byte	0x2
	.byte	0x0
	.byte	0x1a
	.ascii "NSWindow\0"
	.byte	0x10
	.word	0x100
	.byte	0x22
	.byte	0xf
	.long	0x1372
	.byte	0x16
	.long	0xb8d
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_frame\0"
	.byte	0x1a
	.byte	0xa4
	.long	0xa40
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x15
	.ascii "_contentView\0"
	.byte	0x1a
	.byte	0xa5
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x2
	.byte	0x15
	.ascii "_delegate\0"
	.byte	0x1a
	.byte	0xa6
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0x2
	.byte	0x15
	.ascii "_firstResponder\0"
	.byte	0x1a
	.byte	0xa7
	.long	0x1b49
	.byte	0x2
	.byte	0x23
	.byte	0x40
	.byte	0x2
	.byte	0x15
	.ascii "_lastLeftHit\0"
	.byte	0x1a
	.byte	0xa8
	.long	0x1434
	.byte	0x2
	.byte	0x23
	.byte	0x48
	.byte	0x2
	.byte	0x15
	.ascii "_lastRightHit\0"
	.byte	0x1a
	.byte	0xa9
	.long	0x1434
	.byte	0x2
	.byte	0x23
	.byte	0x50
	.byte	0x2
	.byte	0x15
	.ascii "_counterpart\0"
	.byte	0x1a
	.byte	0xaa
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x58
	.byte	0x2
	.byte	0x15
	.ascii "_fieldEditor\0"
	.byte	0x1a
	.byte	0xab
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x60
	.byte	0x2
	.byte	0x15
	.ascii "_winEventMask\0"
	.byte	0x1a
	.byte	0xac
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x68
	.byte	0x2
	.byte	0x15
	.ascii "_windowNum\0"
	.byte	0x1a
	.byte	0xad
	.long	0x851
	.byte	0x2
	.byte	0x23
	.byte	0x70
	.byte	0x2
	.byte	0x15
	.ascii "_level\0"
	.byte	0x1a
	.byte	0xae
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x78
	.byte	0x2
	.byte	0x15
	.ascii "_backgroundColor\0"
	.byte	0x1a
	.byte	0xaf
	.long	0x142e
	.byte	0x3
	.byte	0x23
	.byte	0x80,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_borderView\0"
	.byte	0x1a
	.byte	0xb0
	.long	0x80f
	.byte	0x3
	.byte	0x23
	.byte	0x88,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_postingDisabled\0"
	.byte	0x1a
	.byte	0xb1
	.long	0xa5
	.byte	0x3
	.byte	0x23
	.byte	0x90,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_styleMask\0"
	.byte	0x1a
	.byte	0xb2
	.long	0xa5
	.byte	0x3
	.byte	0x23
	.byte	0x91,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_flushDisabled\0"
	.byte	0x1a
	.byte	0xb3
	.long	0xa5
	.byte	0x3
	.byte	0x23
	.byte	0x92,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_reservedWindow1\0"
	.byte	0x1a
	.byte	0xb4
	.long	0xa5
	.byte	0x3
	.byte	0x23
	.byte	0x93,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_cursorRects\0"
	.byte	0x1a
	.byte	0xb5
	.long	0x181
	.byte	0x3
	.byte	0x23
	.byte	0x98,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_trectTable\0"
	.byte	0x1a
	.byte	0xb6
	.long	0x181
	.byte	0x3
	.byte	0x23
	.byte	0xa0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_miniIcon\0"
	.byte	0x1a
	.byte	0xb7
	.long	0x140d
	.byte	0x3
	.byte	0x23
	.byte	0xa8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_unused\0"
	.byte	0x1a
	.byte	0xb8
	.long	0xd9
	.byte	0x3
	.byte	0x23
	.byte	0xb0,0x1
	.byte	0x2
	.byte	0x19
	.set L$set$221,LASF0-Lsection__debug_str
	.long L$set$221
	.byte	0x1a
	.byte	0xb9
	.long	0xb87
	.byte	0x3
	.byte	0x23
	.byte	0xb8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_representedURL\0"
	.byte	0x1a
	.byte	0xba
	.long	0xb3b
	.byte	0x3
	.byte	0x23
	.byte	0xc0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_sizeLimits\0"
	.byte	0x1a
	.byte	0xbb
	.long	0xa3a
	.byte	0x3
	.byte	0x23
	.byte	0xc8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_frameSaveName\0"
	.byte	0x1a
	.byte	0xbc
	.long	0x923
	.byte	0x3
	.byte	0x23
	.byte	0xd0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_regDragTypes\0"
	.byte	0x1a
	.byte	0xbd
	.long	0x1b4f
	.byte	0x3
	.byte	0x23
	.byte	0xd8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_wFlags\0"
	.byte	0x1a
	.byte	0xf8
	.long	0x143a
	.byte	0x3
	.byte	0x23
	.byte	0xe0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_defaultButtonCell\0"
	.byte	0x1a
	.byte	0xf9
	.long	0x80f
	.byte	0x3
	.byte	0x23
	.byte	0xe8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_initialFirstResponder\0"
	.byte	0x1a
	.byte	0xfa
	.long	0x1434
	.byte	0x3
	.byte	0x23
	.byte	0xf0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "_auxiliaryStorage\0"
	.byte	0x1a
	.byte	0xfb
	.long	0x1b6a
	.byte	0x3
	.byte	0x23
	.byte	0xf8,0x1
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1070
	.byte	0x1b
	.ascii "_NSViewAuxiliary\0"
	.byte	0x10
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x1378
	.byte	0x14
	.ascii "NSImage\0"
	.byte	0x10
	.byte	0x38
	.byte	0x18
	.byte	0xf
	.long	0x140d
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_name\0"
	.byte	0x1b
	.byte	0x32
	.long	0x923
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "_size\0"
	.byte	0x1b
	.byte	0x33
	.long	0xa2c
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x15
	.ascii "_flags\0"
	.byte	0x1b
	.byte	0x4a
	.long	0x1bcf
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x2
	.byte	0x15
	.ascii "_reps\0"
	.byte	0x1b
	.byte	0x4b
	.long	0x1b70
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x2
	.byte	0x15
	.ascii "_imageAuxiliary\0"
	.byte	0x1b
	.byte	0x4c
	.long	0x1e35
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1392
	.byte	0x14
	.ascii "NSColor\0"
	.byte	0x10
	.byte	0x8
	.byte	0x19
	.byte	0xb
	.long	0x142e
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1413
	.byte	0x8
	.byte	0x8
	.long	0xf5d
	.byte	0xf
	.ascii "__wFlags\0"
	.byte	0x8
	.byte	0x1a
	.byte	0xbe
	.long	0x1b49
	.byte	0x18
	.ascii "backing\0"
	.byte	0x1a
	.byte	0xbf
	.long	0xf2
	.byte	0x4
	.byte	0x2
	.byte	0x1e
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "visible\0"
	.byte	0x1a
	.byte	0xc0
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "isMainWindow\0"
	.byte	0x1a
	.byte	0xc1
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "isKeyWindow\0"
	.byte	0x1a
	.byte	0xc2
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "hidesOnDeactivate\0"
	.byte	0x1a
	.byte	0xc3
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "dontFreeWhenClosed\0"
	.byte	0x1a
	.byte	0xc4
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "oneShot\0"
	.byte	0x1a
	.byte	0xc5
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "deferred\0"
	.byte	0x1a
	.byte	0xc6
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "cursorRectsDisabled\0"
	.byte	0x1a
	.byte	0xc7
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "haveFreeCursorRects\0"
	.byte	0x1a
	.byte	0xc8
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "validCursorRects\0"
	.byte	0x1a
	.byte	0xc9
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "docEdited\0"
	.byte	0x1a
	.byte	0xca
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x13
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "dynamicDepthLimit\0"
	.byte	0x1a
	.byte	0xcb
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x12
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "worksWhenModal\0"
	.byte	0x1a
	.byte	0xcc
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x11
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "limitedBecomeKey\0"
	.byte	0x1a
	.byte	0xcd
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x10
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsFlush\0"
	.byte	0x1a
	.byte	0xce
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xf
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "viewsNeedDisplay\0"
	.byte	0x1a
	.byte	0xcf
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xe
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "ignoredFirstMouse\0"
	.byte	0x1a
	.byte	0xd0
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xd
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "repostedFirstMouse\0"
	.byte	0x1a
	.byte	0xd1
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xc
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "windowDying\0"
	.byte	0x1a
	.byte	0xd2
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xb
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "tempHidden\0"
	.byte	0x1a
	.byte	0xd3
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xa
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "floatingPanel\0"
	.byte	0x1a
	.byte	0xd4
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x9
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "wantsToBeOnMainScreen\0"
	.byte	0x1a
	.byte	0xd5
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x8
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "optimizedDrawingOk\0"
	.byte	0x1a
	.byte	0xd6
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x7
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "optimizeDrawing\0"
	.byte	0x1a
	.byte	0xd7
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x6
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "titleIsRepresentedFilename\0"
	.byte	0x1a
	.byte	0xd8
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x5
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "excludedFromWindowsMenu\0"
	.byte	0x1a
	.byte	0xd9
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x4
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "depthLimit\0"
	.byte	0x1a
	.byte	0xda
	.long	0xf2
	.byte	0x4
	.byte	0x4
	.byte	0x0
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "delegateReturnsValidRequestor\0"
	.byte	0x1a
	.byte	0xdb
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "lmouseupPending\0"
	.byte	0x1a
	.byte	0xdc
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "rmouseupPending\0"
	.byte	0x1a
	.byte	0xdd
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "wantsToDestroyRealWindow\0"
	.byte	0x1a
	.byte	0xde
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "wantsToRegDragTypes\0"
	.byte	0x1a
	.byte	0xdf
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "sentInvalidateCursorRectsMsg\0"
	.byte	0x1a
	.byte	0xe0
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "avoidsActivation\0"
	.byte	0x1a
	.byte	0xe1
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "frameSavedUsingTitle\0"
	.byte	0x1a
	.byte	0xe2
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "didRegDragTypes\0"
	.byte	0x1a
	.byte	0xe3
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "delayedOneShot\0"
	.byte	0x1a
	.byte	0xe4
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "postedNeedsDisplayNote\0"
	.byte	0x1a
	.byte	0xe5
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "postedInvalidCursorRectsNote\0"
	.byte	0x1a
	.byte	0xe6
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "initialFirstResponderTempSet\0"
	.byte	0x1a
	.byte	0xe7
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x13
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "autodisplay\0"
	.byte	0x1a
	.byte	0xe8
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x12
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "tossedFirstEvent\0"
	.byte	0x1a
	.byte	0xe9
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x11
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "isImageCache\0"
	.byte	0x1a
	.byte	0xea
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x10
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "interfaceStyle\0"
	.byte	0x1a
	.byte	0xeb
	.long	0xf2
	.byte	0x4
	.byte	0x3
	.byte	0xd
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "keyViewSelectionDirection\0"
	.byte	0x1a
	.byte	0xec
	.long	0xf2
	.byte	0x4
	.byte	0x2
	.byte	0xb
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "defaultButtonCellKETemporarilyDisabled\0"
	.byte	0x1a
	.byte	0xed
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xa
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "defaultButtonCellKEDisabled\0"
	.byte	0x1a
	.byte	0xee
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x9
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "menuHasBeenSet\0"
	.byte	0x1a
	.byte	0xef
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x8
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "wantsToBeModal\0"
	.byte	0x1a
	.byte	0xf0
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x7
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "showingModalFrame\0"
	.byte	0x1a
	.byte	0xf1
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x6
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "isTerminating\0"
	.byte	0x1a
	.byte	0xf2
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x5
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "win32MouseActivationInProgress\0"
	.byte	0x1a
	.byte	0xf3
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x4
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "makingFirstResponderForMouseDown\0"
	.byte	0x1a
	.byte	0xf4
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x3
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "needsZoom\0"
	.byte	0x1a
	.byte	0xf5
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x2
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "sentWindowNeedsDisplayMsg\0"
	.byte	0x1a
	.byte	0xf6
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x18
	.ascii "liveResizeActive\0"
	.byte	0x1a
	.byte	0xf7
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x0
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0xb8d
	.byte	0x8
	.byte	0x8
	.long	0x92f
	.byte	0x1b
	.ascii "NSWindowAuxiliary\0"
	.byte	0x10
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x1b55
	.byte	0x1c
	.long	0x80f
	.byte	0x8
	.byte	0x8
	.long	0x8e9
	.byte	0x3
	.ascii "CIFormat\0"
	.byte	0x1c
	.byte	0x1d
	.long	0xd9
	.byte	0x14
	.ascii "CIImage\0"
	.byte	0x10
	.byte	0x18
	.byte	0x1d
	.byte	0xb
	.long	0x1bc9
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_state\0"
	.byte	0x1c
	.byte	0x17
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "_priv\0"
	.byte	0x1c
	.byte	0x18
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1b8b
	.byte	0xf
	.ascii "__imageFlags\0"
	.byte	0x4
	.byte	0x1b
	.byte	0x34
	.long	0x1e20
	.byte	0x18
	.ascii "scalable\0"
	.byte	0x1b
	.byte	0x35
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "dataRetained\0"
	.byte	0x1b
	.byte	0x36
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "uniqueWindow\0"
	.byte	0x1b
	.byte	0x37
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "sizeWasExplicitlySet\0"
	.byte	0x1b
	.byte	0x38
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "builtIn\0"
	.byte	0x1b
	.byte	0x39
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "needsToExpand\0"
	.byte	0x1b
	.byte	0x3a
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "useEPSOnResolutionMismatch\0"
	.byte	0x1b
	.byte	0x3b
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "colorMatchPreferred\0"
	.byte	0x1b
	.byte	0x3c
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "multipleResolutionMatching\0"
	.byte	0x1b
	.byte	0x3d
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "focusedWhilePrinting\0"
	.byte	0x1b
	.byte	0x3e
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "archiveByName\0"
	.byte	0x1b
	.byte	0x3f
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "unboundedCacheDepth\0"
	.byte	0x1b
	.byte	0x40
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "flipped\0"
	.byte	0x1b
	.byte	0x41
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x13
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "aliased\0"
	.byte	0x1b
	.byte	0x42
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x12
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "dirtied\0"
	.byte	0x1b
	.byte	0x43
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x11
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "cacheMode\0"
	.byte	0x1b
	.byte	0x44
	.long	0xf2
	.byte	0x4
	.byte	0x2
	.byte	0xf
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "sampleMode\0"
	.byte	0x1b
	.byte	0x45
	.long	0xf2
	.byte	0x4
	.byte	0x3
	.byte	0xc
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "reserved2\0"
	.byte	0x1b
	.byte	0x46
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xb
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "isTemplate\0"
	.byte	0x1b
	.byte	0x47
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0xa
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "failedToExpand\0"
	.byte	0x1b
	.byte	0x48
	.long	0xf2
	.byte	0x4
	.byte	0x1
	.byte	0x9
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x18
	.ascii "reserved1\0"
	.byte	0x1b
	.byte	0x49
	.long	0xf2
	.byte	0x4
	.byte	0x9
	.byte	0x0
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x0
	.byte	0x1b
	.ascii "_NSImageAuxiliary\0"
	.byte	0x10
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x1e20
	.byte	0x3
	.ascii "GLuint\0"
	.byte	0x1e
	.byte	0x31
	.long	0xf2
	.byte	0x3
	.ascii "GLfloat\0"
	.byte	0x1e
	.byte	0x32
	.long	0x502
	.byte	0x3
	.ascii "NSOpenGLPixelFormatAuxiliary\0"
	.byte	0x1f
	.byte	0x62
	.long	0x1e7c
	.byte	0x10
	.ascii "_CGLPixelFormatObject\0"
	.byte	0x1
	.byte	0x14
	.ascii "NSOpenGLPixelFormat\0"
	.byte	0x10
	.byte	0x30
	.byte	0x1f
	.byte	0x6c
	.long	0x1f25
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_pixelFormatAuxiliary\0"
	.byte	0x1f
	.byte	0x67
	.long	0x1f25
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x3
	.byte	0x15
	.ascii "_pixelAttributes\0"
	.byte	0x1f
	.byte	0x68
	.long	0x1b75
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x3
	.byte	0x19
	.set L$set$222,LASF1-Lsection__debug_str
	.long L$set$222
	.byte	0x1f
	.byte	0x69
	.long	0x851
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x3
	.byte	0x19
	.set L$set$223,LASF2-Lsection__debug_str
	.long L$set$223
	.byte	0x1f
	.byte	0x6a
	.long	0x851
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x3
	.byte	0x19
	.set L$set$224,LASF3-Lsection__debug_str
	.long L$set$224
	.byte	0x1f
	.byte	0x6b
	.long	0x851
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x3
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1e58
	.byte	0x3
	.ascii "NSOpenGLContextAuxiliary\0"
	.byte	0x1f
	.byte	0xb6
	.long	0x1f4b
	.byte	0x10
	.ascii "_CGLContextObject\0"
	.byte	0x1
	.byte	0x14
	.ascii "NSOpenGLContext\0"
	.byte	0x10
	.byte	0x18
	.byte	0x1f
	.byte	0xbd
	.long	0x1fb0
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_view\0"
	.byte	0x1f
	.byte	0xbb
	.long	0x1434
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x3
	.byte	0x15
	.ascii "_contextAuxiliary\0"
	.byte	0x1f
	.byte	0xbc
	.long	0x1fb0
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x3
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x1f2b
	.byte	0x8
	.byte	0x8
	.long	0x1e94
	.byte	0x8
	.byte	0x8
	.long	0x1f5f
	.byte	0x14
	.ascii "NSOpenGLView\0"
	.byte	0x10
	.byte	0xc0
	.byte	0x20
	.byte	0x13
	.long	0x2046
	.byte	0x16
	.long	0xf5d
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_openGLContext\0"
	.byte	0x20
	.byte	0xe
	.long	0x1fbc
	.byte	0x3
	.byte	0x23
	.byte	0x98,0x1
	.byte	0x3
	.byte	0x15
	.ascii "_pixelFormat\0"
	.byte	0x20
	.byte	0xf
	.long	0x1fb6
	.byte	0x3
	.byte	0x23
	.byte	0xa0,0x1
	.byte	0x3
	.byte	0x19
	.set L$set$225,LASF1-Lsection__debug_str
	.long L$set$225
	.byte	0x20
	.byte	0x10
	.long	0x851
	.byte	0x3
	.byte	0x23
	.byte	0xa8,0x1
	.byte	0x3
	.byte	0x19
	.set L$set$226,LASF2-Lsection__debug_str
	.long L$set$226
	.byte	0x20
	.byte	0x11
	.long	0x851
	.byte	0x3
	.byte	0x23
	.byte	0xb0,0x1
	.byte	0x3
	.byte	0x19
	.set L$set$227,LASF3-Lsection__debug_str
	.long L$set$227
	.byte	0x20
	.byte	0x12
	.long	0x851
	.byte	0x3
	.byte	0x23
	.byte	0xb8,0x1
	.byte	0x3
	.byte	0x0
	.byte	0x14
	.ascii "BAAnalyzerElement\0"
	.byte	0x10
	.byte	0x8
	.byte	0x21
	.byte	0x18
	.long	0x206b
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "CIContext\0"
	.byte	0x10
	.byte	0x10
	.byte	0x22
	.byte	0x75
	.long	0x2099
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "_priv\0"
	.byte	0x23
	.byte	0x12
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x0
	.byte	0x14
	.ascii "CIFilter\0"
	.byte	0x10
	.byte	0x48
	.byte	0x18
	.byte	0x11
	.long	0x20c7
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x1d
	.ascii "_priv\0"
	.byte	0x24
	.word	0x105
	.long	0xabf
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x0
	.byte	0x1e
	.ascii "ImageDataType\0"
	.byte	0x4
	.byte	0x25
	.byte	0x13
	.long	0x2104
	.byte	0x12
	.ascii "IMAGE_DATA_FLOAT\0"
	.byte	0x0
	.byte	0x12
	.ascii "IMAGE_DATA_SHORT\0"
	.byte	0x1
	.byte	0x0
	.byte	0x1e
	.ascii "ImagePropertyID\0"
	.byte	0x4
	.byte	0x25
	.byte	0x18
	.long	0x21d5
	.byte	0x12
	.ascii "PROPID_NAME\0"
	.byte	0x0
	.byte	0x12
	.ascii "PROPID_MODALITY\0"
	.byte	0x1
	.byte	0x12
	.ascii "PROPID_DF\0"
	.byte	0x2
	.byte	0x12
	.ascii "PROPID_PATIENT\0"
	.byte	0x3
	.byte	0x12
	.ascii "PROPID_VOXEL\0"
	.byte	0x4
	.byte	0x12
	.ascii "PROPID_REPTIME\0"
	.byte	0x5
	.byte	0x12
	.ascii "PROPID_TALAIRACH\0"
	.byte	0x6
	.byte	0x12
	.ascii "PROPID_FIXPOINT\0"
	.byte	0x7
	.byte	0x12
	.ascii "PROPID_CA\0"
	.byte	0x8
	.byte	0x12
	.ascii "PROPID_CP\0"
	.byte	0x9
	.byte	0x12
	.ascii "PROPID_EXTENT\0"
	.byte	0xa
	.byte	0x12
	.ascii "PROPID_BETA\0"
	.byte	0xb
	.byte	0x0
	.byte	0x14
	.ascii "BAElement\0"
	.byte	0x10
	.byte	0x8
	.byte	0x21
	.byte	0xc
	.long	0x21f2
	.byte	0x16
	.long	0x874
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x0
	.byte	0x14
	.ascii "BADataElement\0"
	.byte	0x10
	.byte	0x28
	.byte	0x21
	.byte	0xe
	.long	0x22a2
	.byte	0x16
	.long	0x21d5
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "numberRows\0"
	.byte	0x26
	.byte	0x12
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "numberCols\0"
	.byte	0x26
	.byte	0x13
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0x2
	.byte	0x15
	.ascii "numberSlices\0"
	.byte	0x26
	.byte	0x14
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x19
	.set L$set$228,LASF4-Lsection__debug_str
	.long L$set$228
	.byte	0x26
	.byte	0x15
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x14
	.byte	0x2
	.byte	0x19
	.set L$set$229,LASF5-Lsection__debug_str
	.long L$set$229
	.byte	0x26
	.byte	0x17
	.long	0x20c7
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x2
	.byte	0x19
	.set L$set$230,LASF6-Lsection__debug_str
	.long L$set$230
	.byte	0x26
	.byte	0x19
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x1c
	.byte	0x2
	.byte	0x15
	.ascii "imagePropertiesMap\0"
	.byte	0x26
	.byte	0x1b
	.long	0x929
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x2
	.byte	0x0
	.byte	0x1f
	.ascii "BAGUIPrototyp\0"
	.byte	0x10
	.long	0x1e0178
	.byte	0x27
	.byte	0x43
	.long	0x2559
	.byte	0x16
	.long	0x1fc2
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "pixelFormat\0"
	.byte	0x27
	.byte	0x21
	.long	0x1fb6
	.byte	0x3
	.byte	0x23
	.byte	0xc0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "FBOid\0"
	.byte	0x27
	.byte	0x22
	.long	0x1e3b
	.byte	0x3
	.byte	0x23
	.byte	0xc8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "FBOTextureId\0"
	.byte	0x27
	.byte	0x23
	.long	0x1e3b
	.byte	0x3
	.byte	0x23
	.byte	0xcc,0x1
	.byte	0x2
	.byte	0x15
	.ascii "functionalAspectRatio\0"
	.byte	0x27
	.byte	0x24
	.long	0x1e49
	.byte	0x3
	.byte	0x23
	.byte	0xd0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "activationAspectRatio\0"
	.byte	0x27
	.byte	0x25
	.long	0x1e49
	.byte	0x3
	.byte	0x23
	.byte	0xd4,0x1
	.byte	0x2
	.byte	0x15
	.ascii "myCIcontext\0"
	.byte	0x27
	.byte	0x28
	.long	0x2559
	.byte	0x3
	.byte	0x23
	.byte	0xd8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "functionalCIImage\0"
	.byte	0x27
	.byte	0x29
	.long	0x1bc9
	.byte	0x3
	.byte	0x23
	.byte	0xe0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "activationCIImage\0"
	.byte	0x27
	.byte	0x2a
	.long	0x1bc9
	.byte	0x3
	.byte	0x23
	.byte	0xe8,0x1
	.byte	0x2
	.byte	0x15
	.ascii "functionalRect\0"
	.byte	0x27
	.byte	0x2b
	.long	0xa1e
	.byte	0x3
	.byte	0x23
	.byte	0xf0,0x1
	.byte	0x2
	.byte	0x15
	.ascii "sourceOverFilter\0"
	.byte	0x27
	.byte	0x2d
	.long	0x255f
	.byte	0x3
	.byte	0x23
	.byte	0x90,0x2
	.byte	0x2
	.byte	0x15
	.ascii "activationOverlayAlpha\0"
	.byte	0x27
	.byte	0x2e
	.long	0x502
	.byte	0x3
	.byte	0x23
	.byte	0x98,0x2
	.byte	0x2
	.byte	0x15
	.ascii "short_bytes_length\0"
	.byte	0x27
	.byte	0x31
	.long	0x862
	.byte	0x3
	.byte	0x23
	.byte	0xa0,0x2
	.byte	0x2
	.byte	0x15
	.ascii "float_bytes_length\0"
	.byte	0x27
	.byte	0x32
	.long	0x862
	.byte	0x3
	.byte	0x23
	.byte	0xa8,0x2
	.byte	0x2
	.byte	0x15
	.ascii "functionalImageRaw\0"
	.byte	0x27
	.byte	0x33
	.long	0x2565
	.byte	0x3
	.byte	0x23
	.byte	0xb0,0x2
	.byte	0x2
	.byte	0x15
	.ascii "activationImageRaw\0"
	.byte	0x27
	.byte	0x34
	.long	0x2578
	.byte	0x4
	.byte	0x23
	.byte	0xb0,0x82,0x28
	.byte	0x2
	.byte	0x15
	.ascii "bytes\0"
	.byte	0x27
	.byte	0x35
	.long	0x181
	.byte	0x4
	.byte	0x23
	.byte	0xb0,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "myData\0"
	.byte	0x27
	.byte	0x36
	.long	0x1b75
	.byte	0x4
	.byte	0x23
	.byte	0xb8,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "short_bytesPerRow\0"
	.byte	0x27
	.byte	0x37
	.long	0x1de
	.byte	0x4
	.byte	0x23
	.byte	0xc0,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "float_bytesPerRow\0"
	.byte	0x27
	.byte	0x38
	.long	0x1de
	.byte	0x4
	.byte	0x23
	.byte	0xc8,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "mySize\0"
	.byte	0x27
	.byte	0x39
	.long	0x9e0
	.byte	0x4
	.byte	0x23
	.byte	0xd0,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "shortFormat\0"
	.byte	0x27
	.byte	0x3a
	.long	0x1b7b
	.byte	0x4
	.byte	0x23
	.byte	0xe0,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "floatFormat\0"
	.byte	0x27
	.byte	0x3b
	.long	0x1b7b
	.byte	0x4
	.byte	0x23
	.byte	0xe4,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "colorSpace\0"
	.byte	0x27
	.byte	0x3c
	.long	0xb4c
	.byte	0x4
	.byte	0x23
	.byte	0xe8,0x82,0x78
	.byte	0x2
	.byte	0x15
	.ascii "functionalImage\0"
	.byte	0x27
	.byte	0x3f
	.long	0x258b
	.byte	0x4
	.byte	0x23
	.byte	0xf0,0x82,0x78
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x206b
	.byte	0x8
	.byte	0x8
	.long	0x2099
	.byte	0x6
	.long	0xb6
	.long	0x2578
	.byte	0x20
	.long	0x14a
	.long	0x4ffff
	.byte	0x0
	.byte	0x6
	.long	0x502
	.long	0x258b
	.byte	0x20
	.long	0x14a
	.long	0x4ffff
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x21f2
	.byte	0x14
	.ascii "BAAnalyzerGLM\0"
	.byte	0x10
	.byte	0x20
	.byte	0x28
	.byte	0x18
	.long	0x25e5
	.byte	0x16
	.long	0x2046
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x15
	.ascii "mDesign\0"
	.byte	0x28
	.byte	0x15
	.long	0x2651
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "mData\0"
	.byte	0x28
	.byte	0x16
	.long	0x258b
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x15
	.ascii "gui\0"
	.byte	0x28
	.byte	0x17
	.long	0x2657
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x2
	.byte	0x0
	.byte	0x14
	.ascii "BADesignElement\0"
	.byte	0x10
	.byte	0x18
	.byte	0x21
	.byte	0xd
	.long	0x2651
	.byte	0x16
	.long	0x21d5
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x1
	.byte	0x19
	.set L$set$231,LASF6-Lsection__debug_str
	.long L$set$231
	.byte	0x29
	.byte	0xf
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x2
	.byte	0x15
	.ascii "numberCovariates\0"
	.byte	0x29
	.byte	0x10
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0x2
	.byte	0x19
	.set L$set$232,LASF4-Lsection__debug_str
	.long L$set$232
	.byte	0x29
	.byte	0x11
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x2
	.byte	0x19
	.set L$set$233,LASF5-Lsection__debug_str
	.long L$set$233
	.byte	0x29
	.byte	0x12
	.long	0x20c7
	.byte	0x2
	.byte	0x23
	.byte	0x14
	.byte	0x2
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x25e5
	.byte	0x8
	.byte	0x8
	.long	0x22a2
	.byte	0x8
	.byte	0x8
	.long	0x50b
	.byte	0x2
	.byte	0x10
	.byte	0x4
	.ascii "long double\0"
	.byte	0xf
	.ascii "gsl_block_struct\0"
	.byte	0x10
	.byte	0x2a
	.byte	0x27
	.long	0x26a9
	.byte	0xa
	.ascii "size\0"
	.byte	0x2a
	.byte	0x28
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x21
	.set L$set$234,LASF7-Lsection__debug_str
	.long L$set$234
	.byte	0x2a
	.byte	0x29
	.long	0x265d
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x3
	.ascii "gsl_block\0"
	.byte	0x2a
	.byte	0x2c
	.long	0x2672
	.byte	0x9
	.byte	0x28
	.byte	0x2b
	.byte	0x2a
	.long	0x2711
	.byte	0xa
	.ascii "size\0"
	.byte	0x2b
	.byte	0x2b
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "stride\0"
	.byte	0x2b
	.byte	0x2c
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x21
	.set L$set$235,LASF7-Lsection__debug_str
	.long L$set$235
	.byte	0x2b
	.byte	0x2d
	.long	0x265d
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "block\0"
	.byte	0x2b
	.byte	0x2e
	.long	0x2711
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0xa
	.ascii "owner\0"
	.byte	0x2b
	.byte	0x2f
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x26a9
	.byte	0x3
	.ascii "gsl_vector\0"
	.byte	0x2b
	.byte	0x31
	.long	0x26ba
	.byte	0xf
	.ascii "gsl_block_float_struct\0"
	.byte	0x10
	.byte	0x2c
	.byte	0x27
	.long	0x2766
	.byte	0xa
	.ascii "size\0"
	.byte	0x2c
	.byte	0x28
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x21
	.set L$set$236,LASF7-Lsection__debug_str
	.long L$set$236
	.byte	0x2c
	.byte	0x29
	.long	0xb81
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x3
	.ascii "gsl_block_float\0"
	.byte	0x2c
	.byte	0x2c
	.long	0x2729
	.byte	0x9
	.byte	0x28
	.byte	0x2d
	.byte	0x2a
	.long	0x27d4
	.byte	0xa
	.ascii "size\0"
	.byte	0x2d
	.byte	0x2b
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "stride\0"
	.byte	0x2d
	.byte	0x2c
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x21
	.set L$set$237,LASF7-Lsection__debug_str
	.long L$set$237
	.byte	0x2d
	.byte	0x2d
	.long	0xb81
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "block\0"
	.byte	0x2d
	.byte	0x2e
	.long	0x27d4
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0xa
	.ascii "owner\0"
	.byte	0x2d
	.byte	0x2f
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2766
	.byte	0x3
	.ascii "gsl_vector_float\0"
	.byte	0x2d
	.byte	0x31
	.long	0x277d
	.byte	0x9
	.byte	0x30
	.byte	0x2e
	.byte	0x2a
	.long	0x2857
	.byte	0xa
	.ascii "size1\0"
	.byte	0x2e
	.byte	0x2b
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "size2\0"
	.byte	0x2e
	.byte	0x2c
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "tda\0"
	.byte	0x2e
	.byte	0x2d
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x21
	.set L$set$238,LASF7-Lsection__debug_str
	.long L$set$238
	.byte	0x2e
	.byte	0x2e
	.long	0xb81
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0xa
	.ascii "block\0"
	.byte	0x2e
	.byte	0x2f
	.long	0x27d4
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0xa
	.ascii "owner\0"
	.byte	0x2e
	.byte	0x30
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x0
	.byte	0x3
	.ascii "gsl_matrix_float\0"
	.byte	0x2e
	.byte	0x31
	.long	0x27f2
	.byte	0x22
	.set L$set$239,LASF33-Lsection__debug_str
	.long L$set$239
	.byte	0x1
	.byte	0x30
	.byte	0x1
	.long	0x80f
	.quad	LFB680
	.quad	LFE680
	.set L$set$240,LLST0-Lsection__debug_loc
	.long L$set$240
	.long	0x28b0
	.byte	0x23
	.set L$set$241,LASF8-Lsection__debug_str
	.long L$set$241
	.byte	0x1
	.byte	0x30
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x23
	.set L$set$242,LASF9-Lsection__debug_str
	.long L$set$242
	.byte	0x1
	.byte	0x30
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2591
	.byte	0x24
	.set L$set$243,LASF10-Lsection__debug_str
	.long L$set$243
	.byte	0x1
	.byte	0x38
	.byte	0x1
	.quad	LFB681
	.quad	LFE681
	.set L$set$244,LLST1-Lsection__debug_loc
	.long L$set$244
	.long	0x291e
	.byte	0x23
	.set L$set$245,LASF8-Lsection__debug_str
	.long L$set$245
	.byte	0x1
	.byte	0x38
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x23
	.set L$set$246,LASF9-Lsection__debug_str
	.long L$set$246
	.byte	0x1
	.byte	0x38
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x23
	.set L$set$247,LASF7-Lsection__debug_str
	.long L$set$247
	.byte	0x1
	.byte	0x38
	.long	0x258b
	.byte	0x2
	.byte	0x91
	.byte	0x48
	.byte	0x25
	.ascii "design\0"
	.byte	0x1
	.byte	0x38
	.long	0x2651
	.byte	0x2
	.byte	0x91
	.byte	0x40
	.byte	0x26
	.ascii "i\0"
	.byte	0x1
	.byte	0x42
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x6c
	.byte	0x0
	.byte	0x24
	.set L$set$248,LASF11-Lsection__debug_str
	.long L$set$248
	.byte	0x1
	.byte	0x54
	.byte	0x1
	.quad	LFB682
	.quad	LFE682
	.set L$set$249,LLST2-Lsection__debug_loc
	.long L$set$249
	.long	0x2970
	.byte	0x23
	.set L$set$250,LASF8-Lsection__debug_str
	.long L$set$250
	.byte	0x1
	.byte	0x54
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x23
	.set L$set$251,LASF9-Lsection__debug_str
	.long L$set$251
	.byte	0x1
	.byte	0x54
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x26
	.ascii "objc_super\0"
	.byte	0x1
	.byte	0x56
	.long	0x2970
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x0
	.byte	0xf
	.ascii "_objc_super\0"
	.byte	0x10
	.byte	0x9
	.byte	0x0
	.long	0x29a1
	.byte	0x21
	.set L$set$252,LASF8-Lsection__debug_str
	.long L$set$252
	.byte	0x9
	.byte	0x0
	.long	0x80f
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "cls\0"
	.byte	0x9
	.byte	0x0
	.long	0x7f6
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x0
	.byte	0x24
	.set L$set$253,LASF12-Lsection__debug_str
	.long L$set$253
	.byte	0x1
	.byte	0x5a
	.byte	0x1
	.quad	LFB683
	.quad	LFE683
	.set L$set$254,LLST3-Lsection__debug_loc
	.long L$set$254
	.long	0x29de
	.byte	0x23
	.set L$set$255,LASF8-Lsection__debug_str
	.long L$set$255
	.byte	0x1
	.byte	0x5a
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x23
	.set L$set$256,LASF9-Lsection__debug_str
	.long L$set$256
	.byte	0x1
	.byte	0x5a
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x0
	.byte	0x24
	.set L$set$257,LASF13-Lsection__debug_str
	.long L$set$257
	.byte	0x1
	.byte	0x5f
	.byte	0x1
	.quad	LFB684
	.quad	LFE684
	.set L$set$258,LLST4-Lsection__debug_loc
	.long L$set$258
	.long	0x2a1b
	.byte	0x23
	.set L$set$259,LASF8-Lsection__debug_str
	.long L$set$259
	.byte	0x1
	.byte	0x5f
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x23
	.set L$set$260,LASF9-Lsection__debug_str
	.long L$set$260
	.byte	0x1
	.byte	0x5f
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x0
	.byte	0x27
	.ascii "__block_descriptor_withcopydispose\0"
	.byte	0x1
	.byte	0x20
	.byte	0x1
	.word	0x154
	.long	0x2a99
	.byte	0x28
	.set L$set$261,LASF14-Lsection__debug_str
	.long L$set$261
	.byte	0x1
	.word	0x154
	.long	0x16c
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x29
	.ascii "Size\0"
	.byte	0x1
	.word	0x154
	.long	0x16c
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x29
	.ascii "CopyFuncPtr\0"
	.byte	0x1
	.word	0x154
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x29
	.ascii "DestroyFuncPtr\0"
	.byte	0x1
	.word	0x154
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x0
	.byte	0x24
	.set L$set$262,LASF15-Lsection__debug_str
	.long L$set$262
	.byte	0x1
	.byte	0x66
	.byte	0x1
	.quad	LFB685
	.quad	LFE685
	.set L$set$263,LLST5-Lsection__debug_loc
	.long L$set$263
	.long	0x2cd0
	.byte	0x23
	.set L$set$264,LASF8-Lsection__debug_str
	.long L$set$264
	.byte	0x1
	.byte	0x66
	.long	0x28b0
	.byte	0x3
	.byte	0x91
	.byte	0xa8,0x7d
	.byte	0x23
	.set L$set$265,LASF9-Lsection__debug_str
	.long L$set$265
	.byte	0x1
	.byte	0x66
	.long	0x83b
	.byte	0x3
	.byte	0x91
	.byte	0xa0,0x7d
	.byte	0x23
	.set L$set$266,LASF16-Lsection__debug_str
	.long L$set$266
	.byte	0x1
	.byte	0x66
	.long	0xb6
	.byte	0x3
	.byte	0x91
	.byte	0x9c,0x7d
	.byte	0x23
	.set L$set$267,LASF17-Lsection__debug_str
	.long L$set$267
	.byte	0x1
	.byte	0x66
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0x98,0x7d
	.byte	0x23
	.set L$set$268,LASF18-Lsection__debug_str
	.long L$set$268
	.byte	0x1
	.byte	0x66
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0x94,0x7d
	.byte	0x26
	.ascii "nbands\0"
	.byte	0x1
	.byte	0x6a
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x5c
	.byte	0x26
	.ascii "nslices\0"
	.byte	0x1
	.byte	0x6b
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x26
	.ascii "nrows\0"
	.byte	0x1
	.byte	0x6c
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x54
	.byte	0x26
	.ascii "ncols\0"
	.byte	0x1
	.byte	0x6d
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x2a
	.set L$set$269,LASF19-Lsection__debug_str
	.long L$set$269
	.byte	0x1
	.byte	0x6e
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x4c
	.byte	0x26
	.ascii "nr\0"
	.byte	0x1
	.byte	0x71
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x48
	.byte	0x26
	.ascii "nc\0"
	.byte	0x1
	.byte	0x72
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x44
	.byte	0x26
	.ascii "df\0"
	.byte	0x1
	.byte	0x75
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x40
	.byte	0x26
	.ascii "i\0"
	.byte	0x1
	.byte	0x77
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xbc,0x7f
	.byte	0x26
	.ascii "k\0"
	.byte	0x1
	.byte	0x78
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xb8,0x7f
	.byte	0x26
	.ascii "l\0"
	.byte	0x1
	.byte	0x79
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xb4,0x7f
	.byte	0x26
	.ascii "n\0"
	.byte	0x1
	.byte	0x7a
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xb0,0x7f
	.byte	0x26
	.ascii "m\0"
	.byte	0x1
	.byte	0x7b
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xac,0x7f
	.byte	0x26
	.ascii "nt\0"
	.byte	0x1
	.byte	0x7c
	.long	0xd9
	.byte	0x3
	.byte	0x91
	.byte	0xa8,0x7f
	.byte	0x2a
	.set L$set$270,LASF20-Lsection__debug_str
	.long L$set$270
	.byte	0x1
	.byte	0x7d
	.long	0xd9
	.byte	0x8
	.byte	0x91
	.byte	0xa0,0x7e
	.byte	0x23
	.byte	0x8
	.byte	0x6
	.byte	0x23
	.byte	0x18
	.byte	0x26
	.ascii "trace\0"
	.byte	0x1
	.byte	0x7f
	.long	0x502
	.byte	0x3
	.byte	0x91
	.byte	0xa4,0x7f
	.byte	0x26
	.ascii "trace2\0"
	.byte	0x1
	.byte	0x80
	.long	0x502
	.byte	0x3
	.byte	0x91
	.byte	0xa0,0x7f
	.byte	0x26
	.ascii "x\0"
	.byte	0x1
	.byte	0x88
	.long	0x50b
	.byte	0x3
	.byte	0x91
	.byte	0x90,0x7f
	.byte	0x26
	.ascii "X\0"
	.byte	0x1
	.byte	0x8a
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0x88,0x7f
	.byte	0x26
	.ascii "XInv\0"
	.byte	0x1
	.byte	0x8b
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0x80,0x7f
	.byte	0x26
	.ascii "SX\0"
	.byte	0x1
	.byte	0x8c
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xf8,0x7e
	.byte	0x2a
	.set L$set$271,LASF21-Lsection__debug_str
	.long L$set$271
	.byte	0x1
	.byte	0x8e
	.long	0x2d4e
	.byte	0x3
	.byte	0x91
	.byte	0xf0,0x7e
	.byte	0x26
	.ascii "S\0"
	.byte	0x1
	.byte	0x90
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xe8,0x7e
	.byte	0x26
	.ascii "Vc\0"
	.byte	0x1
	.byte	0x91
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xe0,0x7e
	.byte	0x26
	.ascii "P\0"
	.byte	0x1
	.byte	0x93
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xd8,0x7e
	.byte	0x26
	.ascii "R\0"
	.byte	0x1
	.byte	0x96
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xd0,0x7e
	.byte	0x26
	.ascii "RV\0"
	.byte	0x1
	.byte	0x97
	.long	0x2d48
	.byte	0x3
	.byte	0x91
	.byte	0xc8,0x7e
	.byte	0x26
	.ascii "queue\0"
	.byte	0x1
	.byte	0x99
	.long	0x775
	.byte	0x3
	.byte	0x91
	.byte	0xc0,0x7e
	.byte	0x26
	.ascii "fwhm\0"
	.byte	0x1
	.byte	0xca
	.long	0x502
	.byte	0x3
	.byte	0x91
	.byte	0x9c,0x7f
	.byte	0x26
	.ascii "sigma\0"
	.byte	0x1
	.byte	0xcb
	.long	0x4f3
	.byte	0x3
	.byte	0x91
	.byte	0x98,0x7f
	.byte	0x2b
	.quad	LBB2
	.quad	LBE2
	.byte	0x0
	.byte	0xf
	.ascii "__Block_byref_1_npix\0"
	.byte	0x20
	.byte	0x1
	.byte	0x7d
	.long	0x2d42
	.byte	0xa
	.ascii "__isa\0"
	.byte	0x1
	.byte	0x7d
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "__forwarding\0"
	.byte	0x1
	.byte	0x7d
	.long	0x2d42
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x21
	.set L$set$272,LASF22-Lsection__debug_str
	.long L$set$272
	.byte	0x1
	.byte	0x7d
	.long	0xf2
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "__size\0"
	.byte	0x1
	.byte	0x7d
	.long	0xf2
	.byte	0x2
	.byte	0x23
	.byte	0x14
	.byte	0x21
	.set L$set$273,LASF20-Lsection__debug_str
	.long L$set$273
	.byte	0x1
	.byte	0x7d
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2cd0
	.byte	0x8
	.byte	0x8
	.long	0x2857
	.byte	0x8
	.byte	0x8
	.long	0x2717
	.byte	0x2c
	.set L$set$274,LASF23-Lsection__debug_str
	.long L$set$274
	.byte	0x1
	.word	0x118
	.byte	0x1
	.quad	LFB686
	.quad	LFE686
	.set L$set$275,LLST8-Lsection__debug_loc
	.long L$set$275
	.long	0x2e30
	.byte	0x2d
	.set L$set$276,LASF24-Lsection__debug_str
	.long L$set$276
	.byte	0x1
	.word	0x118
	.long	0x2e30
	.byte	0x3
	.byte	0x91
	.byte	0xc8,0x7e
	.byte	0x2e
	.ascii "row\0"
	.byte	0x1
	.word	0x118
	.long	0x1de
	.byte	0x3
	.byte	0x91
	.byte	0xc0,0x7e
	.byte	0x2f
	.ascii "ncols\0"
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x2f
	.ascii "queue\0"
	.long	0x2fc6
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x30
	.set L$set$277,LASF8-Lsection__debug_str
	.long L$set$277
	.long	0x3288
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x48
	.byte	0x30
	.set L$set$278,LASF19-Lsection__debug_str
	.long L$set$278
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x64
	.byte	0x30
	.set L$set$279,LASF16-Lsection__debug_str
	.long L$set$279
	.long	0x328d
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x6e
	.byte	0x30
	.set L$set$280,LASF20-Lsection__debug_str
	.long L$set$280
	.long	0xd9
	.byte	0x1
	.byte	0x8
	.byte	0x91
	.byte	0x40
	.byte	0x6
	.byte	0x23
	.byte	0x8
	.byte	0x6
	.byte	0x23
	.byte	0x18
	.byte	0x30
	.set L$set$281,LASF17-Lsection__debug_str
	.long L$set$281
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x30
	.set L$set$282,LASF18-Lsection__debug_str
	.long L$set$282
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x5c
	.byte	0x30
	.set L$set$283,LASF21-Lsection__debug_str
	.long L$set$283
	.long	0x3292
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0xb8,0x7f
	.byte	0x2f
	.ascii "n\0"
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x2f
	.ascii "XInv\0"
	.long	0x3297
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0xb0,0x7f
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2e36
	.byte	0x31
	.ascii "__block_literal_2\0"
	.byte	0x68
	.byte	0x1
	.word	0x155
	.long	0x2f47
	.byte	0x29
	.ascii "__isa\0"
	.byte	0x1
	.word	0x155
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x28
	.set L$set$284,LASF22-Lsection__debug_str
	.long L$set$284
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x28
	.set L$set$285,LASF25-Lsection__debug_str
	.long L$set$285
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0x28
	.set L$set$286,LASF26-Lsection__debug_str
	.long L$set$286
	.byte	0x1
	.word	0x155
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x28
	.set L$set$287,LASF27-Lsection__debug_str
	.long L$set$287
	.byte	0x1
	.word	0x155
	.long	0x2f47
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x29
	.ascii "XInv\0"
	.byte	0x1
	.word	0x155
	.long	0x2d48
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x29
	.ascii "n\0"
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x28
	.set L$set$288,LASF21-Lsection__debug_str
	.long L$set$288
	.byte	0x1
	.word	0x155
	.long	0x2d4e
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x28
	.set L$set$289,LASF18-Lsection__debug_str
	.long L$set$289
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0x28
	.set L$set$290,LASF17-Lsection__debug_str
	.long L$set$290
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x3c
	.byte	0x28
	.set L$set$291,LASF16-Lsection__debug_str
	.long L$set$291
	.byte	0x1
	.word	0x155
	.long	0xb6
	.byte	0x2
	.byte	0x23
	.byte	0x40
	.byte	0x28
	.set L$set$292,LASF19-Lsection__debug_str
	.long L$set$292
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x44
	.byte	0x28
	.set L$set$293,LASF8-Lsection__debug_str
	.long L$set$293
	.byte	0x1
	.word	0x155
	.long	0x28b0
	.byte	0x2
	.byte	0x23
	.byte	0x48
	.byte	0x29
	.ascii "queue\0"
	.byte	0x1
	.word	0x155
	.long	0x775
	.byte	0x2
	.byte	0x23
	.byte	0x50
	.byte	0x29
	.ascii "ncols\0"
	.byte	0x1
	.word	0x155
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x58
	.byte	0x28
	.set L$set$294,LASF20-Lsection__debug_str
	.long L$set$294
	.byte	0x1
	.word	0x155
	.long	0x2d42
	.byte	0x2
	.byte	0x23
	.byte	0x60
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x2a1b
	.byte	0x2c
	.set L$set$295,LASF28-Lsection__debug_str
	.long L$set$295
	.byte	0x1
	.word	0x155
	.byte	0x1
	.quad	LFB690
	.quad	LFE690
	.set L$set$296,LLST7-Lsection__debug_loc
	.long L$set$296
	.long	0x2f8f
	.byte	0x2e
	.ascii "_dst\0"
	.byte	0x1
	.word	0x155
	.long	0x2e30
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x2e
	.ascii "_src\0"
	.byte	0x1
	.word	0x155
	.long	0x2e30
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x0
	.byte	0x2c
	.set L$set$297,LASF29-Lsection__debug_str
	.long L$set$297
	.byte	0x1
	.word	0x155
	.byte	0x1
	.quad	LFB691
	.quad	LFE691
	.set L$set$298,LLST6-Lsection__debug_loc
	.long L$set$298
	.long	0x2fc1
	.byte	0x2e
	.ascii "_src\0"
	.byte	0x1
	.word	0x155
	.long	0x2e30
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x0
	.byte	0xe
	.long	0xd9
	.byte	0xe
	.long	0x775
	.byte	0x2c
	.set L$set$299,LASF30-Lsection__debug_str
	.long L$set$299
	.byte	0x1
	.word	0x119
	.byte	0x1
	.quad	LFB687
	.quad	LFE687
	.set L$set$300,LLST11-Lsection__debug_loc
	.long L$set$300
	.long	0x3184
	.byte	0x2d
	.set L$set$301,LASF24-Lsection__debug_str
	.long L$set$301
	.byte	0x1
	.word	0x119
	.long	0x3184
	.byte	0x3
	.byte	0x91
	.byte	0xe8,0x7e
	.byte	0x2e
	.ascii "col\0"
	.byte	0x1
	.word	0x119
	.long	0x1de
	.byte	0x3
	.byte	0x91
	.byte	0xe0,0x7e
	.byte	0x30
	.set L$set$302,LASF8-Lsection__debug_str
	.long L$set$302
	.long	0x3288
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0xb8,0x7f
	.byte	0x2f
	.ascii "row\0"
	.long	0x3310
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0xb0,0x7f
	.byte	0x30
	.set L$set$303,LASF19-Lsection__debug_str
	.long L$set$303
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x30
	.set L$set$304,LASF16-Lsection__debug_str
	.long L$set$304
	.long	0x328d
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x6e
	.byte	0x30
	.set L$set$305,LASF20-Lsection__debug_str
	.long L$set$305
	.long	0xd9
	.byte	0x1
	.byte	0x9
	.byte	0x91
	.byte	0xa8,0x7f
	.byte	0x6
	.byte	0x23
	.byte	0x8
	.byte	0x6
	.byte	0x23
	.byte	0x18
	.byte	0x30
	.set L$set$306,LASF17-Lsection__debug_str
	.long L$set$306
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x30
	.set L$set$307,LASF18-Lsection__debug_str
	.long L$set$307
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x4c
	.byte	0x30
	.set L$set$308,LASF21-Lsection__debug_str
	.long L$set$308
	.long	0x3292
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0x88,0x7f
	.byte	0x2f
	.ascii "n\0"
	.long	0x2fc1
	.byte	0x1
	.byte	0x2
	.byte	0x91
	.byte	0x40
	.byte	0x2f
	.ascii "XInv\0"
	.long	0x3297
	.byte	0x1
	.byte	0x3
	.byte	0x91
	.byte	0xf8,0x7e
	.byte	0x32
	.quad	LBB3
	.quad	LBE3
	.byte	0x33
	.ascii "sum\0"
	.byte	0x1
	.word	0x120
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x64
	.byte	0x33
	.ascii "sum2\0"
	.byte	0x1
	.word	0x121
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x33
	.ascii "nx\0"
	.byte	0x1
	.word	0x122
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x5c
	.byte	0x33
	.ascii "y\0"
	.byte	0x1
	.word	0x123
	.long	0x3315
	.byte	0x3
	.byte	0x91
	.byte	0xa0,0x7f
	.byte	0x33
	.ascii "ptr1\0"
	.byte	0x1
	.word	0x124
	.long	0xb81
	.byte	0x3
	.byte	0x91
	.byte	0x98,0x7f
	.byte	0x33
	.ascii "i\0"
	.byte	0x1
	.word	0x125
	.long	0xd9
	.byte	0x2
	.byte	0x91
	.byte	0x54
	.byte	0x33
	.ascii "u\0"
	.byte	0x1
	.word	0x126
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x33
	.ascii "mean\0"
	.byte	0x1
	.word	0x132
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x48
	.byte	0x33
	.ascii "sig\0"
	.byte	0x1
	.word	0x133
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x44
	.byte	0x32
	.quad	LBB4
	.quad	LBE4
	.byte	0x33
	.ascii "ys\0"
	.byte	0x1
	.word	0x13d
	.long	0x3315
	.byte	0x3
	.byte	0x91
	.byte	0x90,0x7f
	.byte	0x33
	.ascii "beta\0"
	.byte	0x1
	.word	0x141
	.long	0x3315
	.byte	0x3
	.byte	0x91
	.byte	0x80,0x7f
	.byte	0x32
	.quad	LBB5
	.quad	LBE5
	.byte	0x33
	.ascii "val\0"
	.byte	0x1
	.word	0x148
	.long	0x331b
	.byte	0x3
	.byte	0x91
	.byte	0xf0,0x7e
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x318a
	.byte	0x31
	.ascii "__block_literal_1\0"
	.byte	0x60
	.byte	0x1
	.word	0x154
	.long	0x3288
	.byte	0x29
	.ascii "__isa\0"
	.byte	0x1
	.word	0x154
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0x28
	.set L$set$309,LASF22-Lsection__debug_str
	.long L$set$309
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x28
	.set L$set$310,LASF25-Lsection__debug_str
	.long L$set$310
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0x28
	.set L$set$311,LASF26-Lsection__debug_str
	.long L$set$311
	.byte	0x1
	.word	0x154
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0x28
	.set L$set$312,LASF27-Lsection__debug_str
	.long L$set$312
	.byte	0x1
	.word	0x154
	.long	0x2f47
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x29
	.ascii "XInv\0"
	.byte	0x1
	.word	0x154
	.long	0x2d48
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x29
	.ascii "n\0"
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x28
	.set L$set$313,LASF21-Lsection__debug_str
	.long L$set$313
	.byte	0x1
	.word	0x154
	.long	0x2d4e
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0x28
	.set L$set$314,LASF18-Lsection__debug_str
	.long L$set$314
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0x28
	.set L$set$315,LASF17-Lsection__debug_str
	.long L$set$315
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x3c
	.byte	0x28
	.set L$set$316,LASF16-Lsection__debug_str
	.long L$set$316
	.byte	0x1
	.word	0x154
	.long	0xb6
	.byte	0x2
	.byte	0x23
	.byte	0x40
	.byte	0x28
	.set L$set$317,LASF19-Lsection__debug_str
	.long L$set$317
	.byte	0x1
	.word	0x154
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x44
	.byte	0x29
	.ascii "row\0"
	.byte	0x1
	.word	0x154
	.long	0x1de
	.byte	0x2
	.byte	0x23
	.byte	0x48
	.byte	0x28
	.set L$set$318,LASF8-Lsection__debug_str
	.long L$set$318
	.byte	0x1
	.word	0x154
	.long	0x28b0
	.byte	0x2
	.byte	0x23
	.byte	0x50
	.byte	0x28
	.set L$set$319,LASF20-Lsection__debug_str
	.long L$set$319
	.byte	0x1
	.word	0x154
	.long	0x2d42
	.byte	0x2
	.byte	0x23
	.byte	0x58
	.byte	0x0
	.byte	0xe
	.long	0x28b0
	.byte	0xe
	.long	0xb6
	.byte	0xe
	.long	0x2d4e
	.byte	0xe
	.long	0x2d48
	.byte	0x2c
	.set L$set$320,LASF31-Lsection__debug_str
	.long L$set$320
	.byte	0x1
	.word	0x154
	.byte	0x1
	.quad	LFB688
	.quad	LFE688
	.set L$set$321,LLST10-Lsection__debug_loc
	.long L$set$321
	.long	0x32de
	.byte	0x2e
	.ascii "_dst\0"
	.byte	0x1
	.word	0x154
	.long	0x3184
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x2e
	.ascii "_src\0"
	.byte	0x1
	.word	0x154
	.long	0x3184
	.byte	0x2
	.byte	0x91
	.byte	0x60
	.byte	0x0
	.byte	0x2c
	.set L$set$322,LASF32-Lsection__debug_str
	.long L$set$322
	.byte	0x1
	.word	0x154
	.byte	0x1
	.quad	LFB689
	.quad	LFE689
	.set L$set$323,LLST9-Lsection__debug_loc
	.long L$set$323
	.long	0x3310
	.byte	0x2e
	.ascii "_src\0"
	.byte	0x1
	.word	0x154
	.long	0x3184
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x0
	.byte	0xe
	.long	0x1de
	.byte	0x8
	.byte	0x8
	.long	0x27da
	.byte	0x8
	.byte	0x8
	.long	0x8b1
	.byte	0x34
	.set L$set$324,LASF34-Lsection__debug_str
	.long L$set$324
	.byte	0x1
	.word	0x164
	.byte	0x1
	.long	0x4f3
	.quad	LFB692
	.quad	LFE692
	.set L$set$325,LLST12-Lsection__debug_loc
	.long L$set$325
	.long	0x3394
	.byte	0x2d
	.set L$set$326,LASF8-Lsection__debug_str
	.long L$set$326
	.byte	0x1
	.word	0x164
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x58
	.byte	0x2d
	.set L$set$327,LASF9-Lsection__debug_str
	.long L$set$327
	.byte	0x1
	.word	0x164
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x50
	.byte	0x2e
	.ascii "fwhm\0"
	.byte	0x1
	.word	0x164
	.long	0x4f3
	.byte	0x2
	.byte	0x91
	.byte	0x4c
	.byte	0x33
	.ascii "sigma\0"
	.byte	0x1
	.word	0x165
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x6c
	.byte	0x33
	.ascii "tr\0"
	.byte	0x1
	.word	0x166
	.long	0x502
	.byte	0x2
	.byte	0x91
	.byte	0x68
	.byte	0x0
	.byte	0x2c
	.set L$set$328,LASF35-Lsection__debug_str
	.long L$set$328
	.byte	0x1
	.word	0x175
	.byte	0x1
	.quad	LFB693
	.quad	LFE693
	.set L$set$329,LLST13-Lsection__debug_loc
	.long L$set$329
	.long	0x33d4
	.byte	0x2d
	.set L$set$330,LASF8-Lsection__debug_str
	.long L$set$330
	.byte	0x1
	.word	0x175
	.long	0x28b0
	.byte	0x2
	.byte	0x91
	.byte	0x48
	.byte	0x2d
	.set L$set$331,LASF9-Lsection__debug_str
	.long L$set$331
	.byte	0x1
	.word	0x175
	.long	0x83b
	.byte	0x2
	.byte	0x91
	.byte	0x40
	.byte	0x0
	.byte	0x26
	.ascii "NUMBER_OF_CHANNELS\0"
	.byte	0x27
	.byte	0x17
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_NUMBER_OF_CHANNELS
	.byte	0x26
	.ascii "DISPLAY_IMAGE_WIDTH\0"
	.byte	0x27
	.byte	0x18
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_DISPLAY_IMAGE_WIDTH
	.byte	0x26
	.ascii "DISPLAY_IMAGE_HEIGHT\0"
	.byte	0x27
	.byte	0x19
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_DISPLAY_IMAGE_HEIGHT
	.byte	0x26
	.ascii "SLICES_PER_ROW\0"
	.byte	0x27
	.byte	0x1a
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_SLICES_PER_ROW
	.byte	0x26
	.ascii "SLICES_PER_COL\0"
	.byte	0x27
	.byte	0x1b
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_SLICES_PER_COL
	.byte	0x26
	.ascii "SLICE_DIMENSION\0"
	.byte	0x27
	.byte	0x1c
	.long	0x2fc1
	.byte	0x9
	.byte	0x3
	.quad	_SLICE_DIMENSION
	.byte	0x35
	.ascii "__CFConstantStringClassReference\0"
	.long	0xb41
	.byte	0x1
	.byte	0x1
	.byte	0x1
	.byte	0x36
	.ascii "_DefaultRuneLocale\0"
	.byte	0x5
	.byte	0x84
	.long	0x4e0
	.byte	0x1
	.byte	0x1
	.byte	0x36
	.ascii "__stderrp\0"
	.byte	0x7
	.byte	0xa9
	.long	0x34fc
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x750
	.byte	0x37
	.ascii "mBetaOutput\0"
	.byte	0x1
	.byte	0x1b
	.long	0x258b
	.byte	0x1
	.byte	0x9
	.byte	0x3
	.quad	_mBetaOutput
	.byte	0x38
	.ascii "_NSConcreteStackBlock\0"
	.byte	0x1
	.word	0x154
	.long	0x181
	.byte	0x1
	.byte	0x1
	.byte	0x38
	.ascii "_objc_empty_cache\0"
	.byte	0x1
	.word	0x19e
	.long	0x181
	.byte	0x1
	.byte	0x1
	.byte	0xc
	.byte	0x1
	.long	0x80f
	.long	0x3572
	.byte	0xd
	.long	0x80f
	.byte	0xd
	.long	0x83b
	.byte	0x39
	.byte	0x0
	.byte	0x38
	.ascii "_objc_empty_vtable\0"
	.byte	0x1
	.word	0x19e
	.long	0x358f
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.byte	0x8
	.long	0x355c
	.byte	0xf
	.ascii "_class_t\0"
	.byte	0x28
	.byte	0x9
	.byte	0x0
	.long	0x372f
	.byte	0xa
	.ascii "isa\0"
	.byte	0x9
	.byte	0x0
	.long	0x372f
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "superclass\0"
	.byte	0x9
	.byte	0x0
	.long	0x372f
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0xa
	.ascii "cache\0"
	.byte	0x9
	.byte	0x0
	.long	0x181
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "vtable\0"
	.byte	0x9
	.byte	0x0
	.long	0x3735
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0xf
	.ascii "_class_ro_t\0"
	.byte	0x48
	.byte	0x9
	.byte	0x0
	.long	0x3721
	.byte	0xa
	.ascii "flags\0"
	.byte	0x9
	.byte	0x0
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x0
	.byte	0xa
	.ascii "instanceStart\0"
	.byte	0x9
	.byte	0x0
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x4
	.byte	0xa
	.ascii "instanceSize\0"
	.byte	0x9
	.byte	0x0
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0x8
	.byte	0x21
	.set L$set$332,LASF14-Lsection__debug_str
	.long L$set$332
	.byte	0x9
	.byte	0x0
	.long	0xd9
	.byte	0x2
	.byte	0x23
	.byte	0xc
	.byte	0xa
	.ascii "ivarLayout\0"
	.byte	0x9
	.byte	0x0
	.long	0x1d8
	.byte	0x2
	.byte	0x23
	.byte	0x10
	.byte	0xa
	.ascii "name\0"
	.byte	0x9
	.byte	0x0
	.long	0x1d8
	.byte	0x2
	.byte	0x23
	.byte	0x18
	.byte	0x10
	.ascii "_objc_method_list\0"
	.byte	0x1
	.byte	0xa
	.ascii "baseMethods\0"
	.byte	0x9
	.byte	0x0
	.long	0x373b
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x10
	.ascii "_protocol_list_t\0"
	.byte	0x1
	.byte	0xa
	.ascii "baseProtocols\0"
	.byte	0x9
	.byte	0x0
	.long	0x3741
	.byte	0x2
	.byte	0x23
	.byte	0x28
	.byte	0x10
	.ascii "_ivar_list_t\0"
	.byte	0x1
	.byte	0xa
	.ascii "ivars\0"
	.byte	0x9
	.byte	0x0
	.long	0x3747
	.byte	0x2
	.byte	0x23
	.byte	0x30
	.byte	0xa
	.ascii "weakIvarLayout\0"
	.byte	0x9
	.byte	0x0
	.long	0x1d8
	.byte	0x2
	.byte	0x23
	.byte	0x38
	.byte	0x10
	.ascii "_prop_list_t\0"
	.byte	0x1
	.byte	0xa
	.ascii "properties\0"
	.byte	0x9
	.byte	0x0
	.long	0x374d
	.byte	0x2
	.byte	0x23
	.byte	0x40
	.byte	0x0
	.byte	0xa
	.ascii "ro\0"
	.byte	0x9
	.byte	0x0
	.long	0x3753
	.byte	0x2
	.byte	0x23
	.byte	0x20
	.byte	0x0
	.byte	0x8
	.byte	0x8
	.long	0x3595
	.byte	0x8
	.byte	0x8
	.long	0x358f
	.byte	0x8
	.byte	0x8
	.long	0x366f
	.byte	0x8
	.byte	0x8
	.long	0x3699
	.byte	0x8
	.byte	0x8
	.long	0x36c4
	.byte	0x8
	.byte	0x8
	.long	0x36fc
	.byte	0x8
	.byte	0x8
	.long	0x35ea
	.byte	0x38
	.ascii "OBJC_CLASS_$_BAGUIPrototyp\0"
	.byte	0x1
	.word	0x19e
	.long	0x3595
	.byte	0x1
	.byte	0x1
	.byte	0x38
	.ascii "OBJC_CLASS_$_NSNotificationCenter\0"
	.byte	0x1
	.word	0x19e
	.long	0x3595
	.byte	0x1
	.byte	0x1
	.byte	0x38
	.ascii "OBJC_CLASS_$_NSNumber\0"
	.byte	0x1
	.word	0x19e
	.long	0x3595
	.byte	0x1
	.byte	0x1
	.byte	0x38
	.ascii "OBJC_CLASS_$_BADataElement\0"
	.byte	0x1
	.word	0x19e
	.long	0x3595
	.byte	0x1
	.byte	0x1
	.byte	0x0
	.section __DWARF,__debug_abbrev,regular,debug
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x25
	.byte	0x8
	.byte	0x13
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0xe5,0x7f
	.byte	0xb
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x10
	.byte	0x6
	.byte	0x0
	.byte	0x0
	.byte	0x2
	.byte	0x24
	.byte	0x0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0x0
	.byte	0x0
	.byte	0x3
	.byte	0x16
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x4
	.byte	0x24
	.byte	0x0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x5
	.byte	0xf
	.byte	0x0
	.byte	0xb
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x6
	.byte	0x1
	.byte	0x1
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x7
	.byte	0x21
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x8
	.byte	0xf
	.byte	0x0
	.byte	0xb
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x9
	.byte	0x13
	.byte	0x1
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0xa
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0xb
	.byte	0x13
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0xc
	.byte	0x15
	.byte	0x1
	.byte	0x27
	.byte	0xc
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0xd
	.byte	0x5
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0xe
	.byte	0x26
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0xf
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x10
	.byte	0x13
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3c
	.byte	0xc
	.byte	0x0
	.byte	0x0
	.byte	0x11
	.byte	0x4
	.byte	0x1
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x12
	.byte	0x28
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x1c
	.byte	0xd
	.byte	0x0
	.byte	0x0
	.byte	0x13
	.byte	0xf
	.byte	0x0
	.byte	0xb
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x14
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xe6,0x7f
	.byte	0xb
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x15
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x32
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x16
	.byte	0x1c
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x32
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x17
	.byte	0x21
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x18
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0xb
	.byte	0xb
	.byte	0xd
	.byte	0xb
	.byte	0xc
	.byte	0xb
	.byte	0x38
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x19
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x32
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x1a
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xe6,0x7f
	.byte	0xb
	.byte	0xb
	.byte	0x5
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x1b
	.byte	0x13
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0xe6,0x7f
	.byte	0xb
	.byte	0x3c
	.byte	0xc
	.byte	0x0
	.byte	0x0
	.byte	0x1c
	.byte	0x35
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x1d
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x32
	.byte	0xb
	.byte	0x0
	.byte	0x0
	.byte	0x1e
	.byte	0x4
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x1f
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xe6,0x7f
	.byte	0xb
	.byte	0xb
	.byte	0x6
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x20
	.byte	0x21
	.byte	0x0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0x6
	.byte	0x0
	.byte	0x0
	.byte	0x21
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x22
	.byte	0x2e
	.byte	0x1
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x27
	.byte	0xc
	.byte	0x49
	.byte	0x13
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x23
	.byte	0x5
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x24
	.byte	0x2e
	.byte	0x1
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x27
	.byte	0xc
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x25
	.byte	0x5
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x26
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x27
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xe4,0x7f
	.byte	0xc
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x28
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x29
	.byte	0xd
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x38
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x2a
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x2b
	.byte	0xb
	.byte	0x0
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x0
	.byte	0x0
	.byte	0x2c
	.byte	0x2e
	.byte	0x1
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x27
	.byte	0xc
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x2d
	.byte	0x5
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x2e
	.byte	0x5
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x2f
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x49
	.byte	0x13
	.byte	0x34
	.byte	0xc
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x30
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0xe
	.byte	0x49
	.byte	0x13
	.byte	0x34
	.byte	0xc
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x31
	.byte	0x13
	.byte	0x1
	.byte	0x3
	.byte	0x8
	.byte	0xb
	.byte	0xb
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x32
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x0
	.byte	0x0
	.byte	0x33
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x34
	.byte	0x2e
	.byte	0x1
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x27
	.byte	0xc
	.byte	0x49
	.byte	0x13
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.byte	0x1
	.byte	0x13
	.byte	0x0
	.byte	0x0
	.byte	0x35
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0xc
	.byte	0x34
	.byte	0xc
	.byte	0x3c
	.byte	0xc
	.byte	0x0
	.byte	0x0
	.byte	0x36
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0xc
	.byte	0x3c
	.byte	0xc
	.byte	0x0
	.byte	0x0
	.byte	0x37
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0xc
	.byte	0x2
	.byte	0xa
	.byte	0x0
	.byte	0x0
	.byte	0x38
	.byte	0x34
	.byte	0x0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0xc
	.byte	0x3c
	.byte	0xc
	.byte	0x0
	.byte	0x0
	.byte	0x39
	.byte	0x18
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.section __DWARF,__debug_pubnames,regular,debug
	.long	0x1e
	.word	0x2
	.set L$set$333,Ldebug_info0-Lsection__debug_info
	.long L$set$333
	.long	0x37f0
	.long	0x3502
	.ascii "mBetaOutput\0"
	.long	0x0
	.section __DWARF,__debug_pubtypes,regular,debug
	.long	0x50d
	.word	0x2
	.set L$set$334,Ldebug_info0-Lsection__debug_info
	.long L$set$334
	.long	0x37f0
	.long	0xe0
	.ascii "__uint32_t\0"
	.long	0x102
	.ascii "__int64_t\0"
	.long	0x155
	.ascii "__darwin_size_t\0"
	.long	0x183
	.ascii "__darwin_wchar_t\0"
	.long	0x19b
	.ascii "__darwin_rune_t\0"
	.long	0x1c2
	.ascii "__darwin_off_t\0"
	.long	0x1de
	.ascii "size_t\0"
	.long	0x23d
	.ascii "_RuneEntry\0"
	.long	0x285
	.ascii "_RuneRange\0"
	.long	0x2d2
	.ascii "_RuneCharClass\0"
	.long	0x4e0
	.ascii "_RuneLocale\0"
	.long	0x4f3
	.ascii "float_t\0"
	.long	0x515
	.ascii "fpos_t\0"
	.long	0x523
	.ascii "__sbuf\0"
	.long	0x559
	.ascii "__sFILE\0"
	.long	0x750
	.ascii "FILE\0"
	.long	0x775
	.ascii "dispatch_queue_t\0"
	.long	0x7f6
	.ascii "Class\0"
	.long	0x818
	.ascii "objc_object\0"
	.long	0x80f
	.ascii "id\0"
	.long	0x851
	.ascii "NSInteger\0"
	.long	0x862
	.ascii "NSUInteger\0"
	.long	0x874
	.ascii "NSObject\0"
	.long	0x896
	.ascii "NSValue\0"
	.long	0x8b1
	.ascii "NSNumber\0"
	.long	0x8cd
	.ascii "NSString\0"
	.long	0x8e9
	.ascii "NSData\0"
	.long	0x903
	.ascii "NSDictionary\0"
	.long	0x92f
	.ascii "NSSet\0"
	.long	0x948
	.ascii "NSMutableSet\0"
	.long	0x968
	.ascii "CGFloat\0"
	.long	0x977
	.ascii "CGPoint\0"
	.long	0x9a0
	.ascii "CGPoint\0"
	.long	0x9af
	.ascii "CGSize\0"
	.long	0x9e0
	.ascii "CGSize\0"
	.long	0x9ee
	.ascii "CGRect\0"
	.long	0xa1e
	.ascii "CGRect\0"
	.long	0xa2c
	.ascii "NSSize\0"
	.long	0xa40
	.ascii "NSRect\0"
	.long	0xa4e
	.ascii "NSNotificationCenter\0"
	.long	0xacf
	.ascii "NSURL\0"
	.long	0xb4c
	.ascii "CGColorSpaceRef\0"
	.long	0xb8d
	.ascii "NSResponder\0"
	.long	0xbc6
	.ascii "__VFlags\0"
	.long	0xe8a
	.ascii "_VFlags\0"
	.long	0xe99
	.ascii "__VFlags2\0"
	.long	0xf5d
	.ascii "NSView\0"
	.long	0x143a
	.ascii "__wFlags\0"
	.long	0x1070
	.ascii "NSWindow\0"
	.long	0x1413
	.ascii "NSColor\0"
	.long	0x1b7b
	.ascii "CIFormat\0"
	.long	0x1b8b
	.ascii "CIImage\0"
	.long	0x1bcf
	.ascii "__imageFlags\0"
	.long	0x1392
	.ascii "NSImage\0"
	.long	0x1e3b
	.ascii "GLuint\0"
	.long	0x1e49
	.ascii "GLfloat\0"
	.long	0x1e94
	.ascii "NSOpenGLPixelFormat\0"
	.long	0x1f5f
	.ascii "NSOpenGLContext\0"
	.long	0x1fc2
	.ascii "NSOpenGLView\0"
	.long	0x2046
	.ascii "BAAnalyzerElement\0"
	.long	0x206b
	.ascii "CIContext\0"
	.long	0x2099
	.ascii "CIFilter\0"
	.long	0x20c7
	.ascii "ImageDataType\0"
	.long	0x2104
	.ascii "ImagePropertyID\0"
	.long	0x21d5
	.ascii "BAElement\0"
	.long	0x21f2
	.ascii "BADataElement\0"
	.long	0x22a2
	.ascii "BAGUIPrototyp\0"
	.long	0x2591
	.ascii "BAAnalyzerGLM\0"
	.long	0x25e5
	.ascii "BADesignElement\0"
	.long	0x2672
	.ascii "gsl_block_struct\0"
	.long	0x26a9
	.ascii "gsl_block\0"
	.long	0x2717
	.ascii "gsl_vector\0"
	.long	0x2729
	.ascii "gsl_block_float_struct\0"
	.long	0x2766
	.ascii "gsl_block_float\0"
	.long	0x27da
	.ascii "gsl_vector_float\0"
	.long	0x2857
	.ascii "gsl_matrix_float\0"
	.long	0x2970
	.ascii "_objc_super\0"
	.long	0x2a1b
	.ascii "__block_descriptor_withcopydispose\0"
	.long	0x2cd0
	.ascii "__Block_byref_1_npix\0"
	.long	0x2e36
	.ascii "__block_literal_2\0"
	.long	0x318a
	.ascii "__block_literal_1\0"
	.long	0x3595
	.ascii "_class_t\0"
	.long	0x0
	.section __DWARF,__debug_aranges,regular,debug
	.long	0x2c
	.word	0x2
	.set L$set$335,Ldebug_info0-Lsection__debug_info
	.long L$set$335
	.byte	0x8
	.byte	0x0
	.word	0x0
	.word	0x0
	.quad	Ltext0
	.set L$set$336,Letext0-Ltext0
	.quad L$set$336
	.quad	0x0
	.quad	0x0
	.section __DWARF,__debug_str,regular,debug
LASF21:
	.ascii "kernel\0"
LASF11:
	.ascii "-[BAAnalyzerGLM dealloc]\0"
LASF5:
	.ascii "imageDataType\0"
LASF4:
	.ascii "numberTimesteps\0"
LASF15:
	.ascii "-[BAAnalyzerGLM Regression:::]\0"
LASF14:
	.ascii "reserved\0"
LASF19:
	.ascii "slice\0"
LASF35:
	.ascii "-[BAAnalyzerGLM createOutputImages]\0"
LASF9:
	.ascii "_cmd\0"
LASF22:
	.ascii "__flags\0"
LASF7:
	.ascii "data\0"
LASF6:
	.ascii "repetitionTimeInMs\0"
LASF27:
	.ascii "__descriptor\0"
LASF2:
	.ascii "_reserved2\0"
LASF3:
	.ascii "_reserved3\0"
LASF1:
	.ascii "_reserved1\0"
LASF12:
	.ascii "-[BAAnalyzerGLM OnNewData]\0"
LASF26:
	.ascii "__FuncPtr\0"
LASF16:
	.ascii "minval\0"
LASF10:
	.ascii "-[BAAnalyzerGLM anaylzeTheData:withDesign:]\0"
LASF24:
	.ascii ".block_descriptor\0"
LASF8:
	.ascii "self\0"
LASF29:
	.ascii "__destroy_helper_block_1\0"
LASF32:
	.ascii "__destroy_helper_block_2\0"
LASF23:
	.ascii "__-[BAAnalyzerGLM Regression:::]_block_invoke_1\0"
LASF30:
	.ascii "__-[BAAnalyzerGLM Regression:::]_block_invoke_2\0"
LASF25:
	.ascii "__reserved\0"
LASF13:
	.ascii "-[BAAnalyzerGLM sendFinishNotification]\0"
LASF28:
	.ascii "__copy_helper_block_1\0"
LASF31:
	.ascii "__copy_helper_block_2\0"
LASF0:
	.ascii "_dragTypes\0"
LASF33:
	.ascii "-[BAAnalyzerGLM init]\0"
LASF18:
	.ascii "last_timestep\0"
LASF17:
	.ascii "sliding_window_size\0"
LASF34:
	.ascii "-[BAAnalyzerGLM CalcSigma:]\0"
LASF20:
	.ascii "npix\0"
	.subsections_via_symbols
