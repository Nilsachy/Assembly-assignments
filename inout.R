.bss

.text

name: .asciz "Assignment 1b: inout\n"
input: .asciz "%ld"
output: .asciz "%ld\n"

.global main

main:
	movq %rsp, %rbp
	movq $name, %rdi
	movq $0, %rax
	call printf
	call inout
	jmp end


inout: 
	pushq %rbp
	movq %rsp, %rbp
	
	subq $8, %rsp
	leaq -8(%rbp), %rsi
	movq $input, %rdi
	movq $0, %rax
	call scanf

	pop %rsi
	addq $1, %rsi

	movq $output, %rdi
	movq $0, %rax
	call printf

	movq %rbp, %rsp
	pop %rbp
	ret

end:
	movq $0, %rdi
	call exit

