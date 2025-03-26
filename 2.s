# Kiarash Sanei 402106156

.data
prompt:      .asciiz "Enter a number: "  # Message for user input
result_msg:  .asciiz " is the extracted decimal value."  # Message before printing result

.text
.globl main

main:
    # Print prompt message
    li $v0, 4                # Syscall for printing string
    la $a0, prompt           # Load prompt message address
    syscall                  # Print message

    # Read an integer from the user
    li $v0, 5                # Syscall code for reading integer
    syscall                  # Read input
    move $a0, $v0            # Store input in $a0

    # Call subroutine to extract bits
    jal extract_bits

    # Print extracted value
    move $a0, $v0            # Move computed result to $a0 for printing
    li $v0, 1                # Syscall for printing integer
    syscall                  # Print integer
    
    # Print result message
    li $v0, 4                # Syscall for printing string
    la $a0, result_msg       # Load result message address
    syscall                  # Print message

    # Exit program
    li $v0, 10               # Syscall code for exit
    syscall                  # Exit program

# Subroutine to extract bits 14-17
extract_bits:
    li $t0, 0x1E000          # Mask for bits 14 to 17 (binary: 0001 1110 0000 0000 0000)
    and $v0, $a0, $t0        # Apply mask to extract desired bits
    srl $v0, $v0, 13         # Shift right to move bits into lowest position
    jr $ra                   # Return to main program
