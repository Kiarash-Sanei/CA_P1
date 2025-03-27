# Kiarash Sanei 402106156

.data
prompt_n:      .asciiz "Enter a positive number n: "
prompt_nums:   .asciiz "Enter numbers: "
histogram_msg: .asciiz "The histogram of your numbers is: "
ending:        .asciiz ", "
colon:         .asciiz ":"

.text
.globl main

main:
    # Prompt for number n
    li $v0, 4                # Syscall code for printing string
    la $a0, prompt_n         # Load address of prompt_n
    syscall

    # Read n from user
    li   $v0, 5              # Syscall code for reading integer
    syscall
    move $s0, $v0            # Store n in $s0

    # Prompt for numbers
    li $v0, 4                # Syscall code for printing string
    la $a0, prompt_nums      # Load address of prompt_nums
    syscall

    # Allocate space for n numbers and frequency
    mul $a0, $s0, 8          # Calculate total bytes needed for n integers (n * 4 bytes per integer + n * 4 bytes per frequency)
    li $v0, 9                # Syscall code for allocating memory
    syscall
    move $s1, $v0            # Store base address of the array in $s1

    # Read n numbers and store them with frequency in the allocated memory
    move $s2, $zero          # Initialize counter for reading numbers
    move $s3, $zero          # Initialize length of the list

read_numbers:
    beq $s2, $s0, print_histogram # If counter = n, end loop

    li $v0, 5                # Syscall for reading int
    syscall

    move $a0, $v0            # Store the number in $a0
    move $a1, $s3            # Store the length in $a1
    move $a2, $s1            # Store the array pointer in $a2
    jal find_same
    add $s3, $s3, $v0        # Update the length

    addi $s2, $s2, 1         # Increment counter
    j read_numbers

find_same:
    move $t0, $zero          # Start a counter for iterating 
    move $t1, $a2            # Make a copy of the array pointer
loop_find:
    beq $t0, $a1, go_back_zero # If all previous numbers are checked, go back
    lw $t2, 0($t1)           # Load another number to compare
    beq $t2, $a0, go_back_one # If numbers are equal, increment frequency
    addi $t0, $t0, 1         # Increment counter
    addi $t1, $t1, 8         # Move to the next number in the array
    j loop_find
go_back_zero:
    sw $a0, 0($t1)           # Store the read number in memory
    li $t0, 1                # The number we want to saved
    sw $t0, 4($t1)           # Store the one in memory
    li $v0, 1                # The number of elements we added
    jr $ra                   # Jump back to the main program
go_back_one:
    lw $t0, 4($t1)           # Read the frequency from memory
    addi $t0, $t0, 1         # The number we want to saved
    sw $t0, 4($t1)           # Store the one in memory
    move $v0, $zero          # The number of elements we added
    jr $ra                   # Jump back to the main program

print_histogram:
    li $v0, 4                # Syscall code for printing string
    la $a0, histogram_msg    # Load address of histogram_msg
    syscall

    move $t0, $zero          # Start a counter for iterating 
    move $t1, $s1            # Make a copy of the array pointer
loop_histogram:
    beq $t0, $s3, end_program # Exit loop if we've printed all the elements

    li $v0, 1                # Syscall for printing integer
    lw $a0, 0($t1)           # The number is loaded
    syscall                  # Print integer

    li $v0, 4                # Syscall code for printing string
    la $a0, colon            # Load address of colon
    syscall

    li $v0, 1                # Syscall for printing integer
    lw $a0, 4($t1)           # The frequency is loaded
    syscall                  # Print integer

    addi $t0, $t0, 1         # Increment counter
    beq $t0, $s3, end_loop   # Don't print for ending for the last element
    
    li $v0, 4                # Syscall code for printing string
    la $a0, ending           # Load address of ending
    syscall

end_loop:
    addi $t1, $t1, 8         # Move to the next number in the array
    j loop_histogram

end_program:
    # Exit program
    li $v0, 10               # Syscall code for exit
    syscall                  # Exit program
