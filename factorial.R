.bss

.text

name: .asciz "Assignment 3: factorial\n"
input: .asciz "%ld"
output: .asciz "%ld\n"

.global main

main:
	movq %rsp, %rbp // moving rsp address to rbp
	movq $name, %rdi // copying name into  register rdi
	movq $0, %rax // one argument
	call printf // calling printing function
	call inout // calling inout subroutine
	jmp end // jump to end subroutine


inout: 
	pushq %rbp // moving rbp to top of the stack
	movq %rsp, %rbp // copying rsp memory address into rbp
	
	subq $8, %rsp // subtracting 8 from rsp to create new stack frame
	leaq -8(%rbp), %rsi // load stack address into rsi
	movq $input, %rdi // copying input into rdi
	movq $0, %rax // one argument
	call scanf // calling scanner function

	pop %rsi // copying value from the top of the stack into rsi
	movq %rsi, %rdi // copying value from rsi into rdi
	call factorial // call factorial subroutine
	movq %rax, %rsi // copying value from rax into rsi

	movq $output, %rdi // moving output into rdi
	movq $0, %rax // one argument
	call printf // calling printing function

	movq %rbp, %rsp // copying rbp memory address into rsp
	pop %rbp // 
	ret

factorial:
	pushq %rbp
	movq %rsp, %rbp

	cmpq $0, %rdi
	je basecase

	push %rdi
	subq $1, %rdi
	call factorial
	pop %rsi
	mulq %rsi

f:
	movq %rbp, %rsp
	pop %rbp
	ret

basecase:
	movq $1, %rax
	jmp f

end:
	movq $0, %rdi
	call exit
