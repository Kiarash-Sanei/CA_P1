# Kiarash Sanei 402106156

.data
prompt_n:    .asciiz "Enter n (decimal number): "  
prompt_r:    .asciiz "Enter r (base, max 10): "  
result_msg:  .asciiz "The converted number is "
exit_msg:    .asciiz "."

.text
.globl main

main:
    # Prompt for n
    li $v0, 4                # Syscall code for printing string
    la $a0, prompt_n         # Load prompt message address
    syscall                  # Print message           

    # Read n from user
    li $v0, 5                # Syscall code for reading integer
    syscall                  # Read n
    move $t0, $v0            # Store n in $t0

    # Prompt for r
    li $v0, 4                # Syscall for printing string
    la $a0, prompt_r         # Load prompt message address
    syscall                  # Print message 

    # Read r from user
    li $v0, 5                # Syscall code for reading integer
    syscall                  # Read n
    move $t1, $v0            # Store r in $t1

    # Call recursive function convert(n, r)
    move $a0, $t0            # Pass n
    move $a1, $t1            # Pass r
    move $fp, $sp            # Save stack pointer for further use!
    jal convert_base         # Call the recursive function

exit:
    # End of the result message
    li $v0, 4                # Syscall for printing string
    la $a0, exit_msg         # Load exit message address
    syscall 

    # Exit program
    li $v0, 10               # Syscall code for exit
    syscall                  # Exit program

# Recursive function to convert n to base r
convert_base:
    beq $a0, $zero, base_case_return # Base case: if n == 0, return

    # Recursive case: call convert_base(n / r, r)
    div $a0, $a1          
    mflo $t2                 # t2 = n / r
    mfhi $t3                 # t3 = n % r (remainder to print later)
    
    # Push n % r on stack
    addi $sp, $sp, -4        # Decrement stack pointer by 4 (allocate for an integer)
    sw $t3, 0($sp)           # Store value of n % r at address pointed by $sp

    # Recursive call with n / r
    move $a0, $t2            # Move new n to $a0 for call the function recursively
    jal convert_base         # Call the function recursively

    # Push n % r on stack
    lw $a0, 0($sp)           # Load value from memory at address pointed by $sp into $a0
    addi $sp, $sp, 4         # Increment the stack pointer by 4 (deallocate the space)

    # Print the digit
    li $v0, 1                # Syscall for printing integer
    syscall                  # Print integer

    beq $fp, $sp, exit       # Check if all the pushed digit are printed!

    jr $ra                   # Return to caller

base_case_return:
    # Base case: print the result message
    li $v0, 4                # Syscall for printing string
    la $a0, result_msg       # Load result message address
    syscall                  
    jr $ra                   # Return to caller
