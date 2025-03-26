li $v0, 5 # Read integer syscall (la -> load immediate)
syscall # Read an integer
move $a0, $v0 # Store input in $a0

jal check_even_odd  # Call the subroutine (jal -> jump and link)

move $a0, $v0 # Move result from $v0 to $a0 for printing
li $v0, 1 # Print integer syscall (la -> load immediate)
syscall # Print integer

li $v0, 10 # Exit syscall
syscall # Exit

check_even_odd:
    andi $v0, $a0, 1   # Check LSB (even if 0, odd if 1)
    jr $ra             # Return to main