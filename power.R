.bss

.text

name: .asciz "Asking user for non negative base and exponent\n"
input: .asciz "%ld"
output: .asciz "%ld\n"

.global main

main:
    movq %rsp, %rbp  // moving %rsp to %rbp
	movq $name, %rdi // moving name into the printing register
	movq $0, %rax // making sure we are only printing out from one register
    call printf // printing the function
	call inout // calling inout subroutine
	jmp end // ending the program


inout: 
	pushq %rbp // putting %rbp to the top of the stack
	movq %rsp, %rbp // moving %rbp to %rsp
	subq $8, %rsp  // creating memory space
	leaq -8(%rbp), %rsi // 
	movq $input, %rdi // copying the input into %rdi
	movq $0, %rax // making sure we are only printing out from one register
	call scanf // ask for user input - base

	subq $16, %rsp // creating memory space
	leaq -24(%rbp), %rsi //
	movq $input, %rdi // copying the input into %rdi
	movq $0, %rax // making sure we are only printing out from one register
	call scanf // ask for user input - exponent
	
	movq -8(%rbp), %rdi // copying stack value to %rdi
	movq -24(%rbp), %rsi // copying stack value to %rsi
	call pow // calling the pow subroutine

	movq %rax, %rsi // copying %rax to %rsi

	movq $output, %rdi // setting the output to %rdi
	movq $0, %rax // making sure we are only printing out from one register
	call printf // printing the program

	movq %rbp, %rsp // closing the stack
	pop %rbp // cleaning %rbp
	ret // return to line 17

pow:
	pushq %rbp // setting %rbp to the top of the stack
	movq %rsp, %rbp // moving %rsp to %rbp

	movq $1, %rcx // setting %rcx to 1 to start the loop
	movq $1, %rax // setting %rax to 1 as our temporarily result
	jmp loop // go to loop

endloop:
	movq %rbp, %rsp // closing the stack
	pop %rbp // cleaning %rbp
	ret // return to line 38

loop:
	cmpq %rcx, %rsi // compare value of %rcx and %rsi
	jl endloop // jump to endloop if %rcx is smaller than %rsi

	mulq %rdi // multiply %rax by %rdi and store it in %rax

	addq $1, %rcx // increment %rcx by 1
	jmp loop // jump back to loop

end:
	movq $0, %rdi // cleaning %rdi
	call exit // closing the program
