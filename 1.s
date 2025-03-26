# Kiarash Sanei 402106156

.data
prompt:      .asciiz "Enter a number: "          # Prompt message for user input
result_msg:  .asciiz " is the result."           # Message for the result (even/odd)

.text
.globl main

main:
    # Print prompt message
    li $v0, 4                # Syscall for printing string
    la $a0, prompt           # Load address of prompt message
    syscall                  # Print prompt message

    # Read an integer from the user
    li $v0, 5                # Syscall code for reading an integer
    syscall                  # Read the integer input
    move $a0, $v0            # Store the input number in $a0
    
    # Call subroutine to check even/odd
    jal check_even_odd       # Jump to check_even_odd subroutine

    # Print the result (0 for even, 1 for odd)
    move $a0, $v0            # Move result (even/odd) to $a0 for printing
    li $v0, 1                # Syscall for printing integer
    syscall                  # Print integer result

    # Print result message
    li $v0, 4                # Syscall for printing string
    la $a0, result_msg       # Load address of result message
    syscall                  # Print result message

    # Exit program
    li $v0, 10               # Syscall code for exit
    syscall                  # Exit program

# Subroutine: Check if the number is even or odd
check_even_odd:
    move $v0, $a0            # Copy the input number to $v0 to avoid modifying $a0
    srl $v0, $v0, 1          # Shift right by 1 (divide by 2)
    sll $v0, $v0, 1          # Shift left by 1 (multiply by 2)

    # Compare the shifted value with the original number
    slt $v0, $v0, $a0        # If the shifted value is less than the original number, set $v0 to 1 (odd), otherwise set $v0 to 0 (even)
    jr $ra                   # Return to the caller (main program)
