.eqv OK 1

.data
	dest: .word

.text
.globl list_subset_sum

list_subset_sum:
# param a0: pointer to 'first'
# param a1: pointer to start of array 'indices'
# param a2: length of array 'indices'

	# backup ra, parameters and s0,s1 on stack
	addi sp, sp, -24
	sw s0, 20(sp)
	sw s1, 16(sp)
	sw ra, 12(sp)
	sw a0, 8(sp)
	sw a1, 4(sp)
	sw a2, (sp)

	# check for uninitialized list and uninitialized array
	beqz a0, error
	beqz a1, error
	
	mv s0, a1
	mv s1, zero
	
	# if a2 == 0, don't execute the loop
	beqz a2, end
	
loop:
# s0 = address of the current index
# s1 = sum so far
	
	# parameters to list_get
	lw a0, 8(sp)	# original a0
	la a1, dest
	lw a2, (s0)
	jal list_get
	# if something went wrong in list_get (e.g. INDEX_OUT_OF_BOUNDS)
	bne a0, OK, error
	
	# increase sum
	lw t0, dest	# the newly loaded value
	add s1, s1, t0
	
	# increment index
	addi s0, s0, 4
	
	# loop should continue if (incremented) s0 < (start+length) of array 'indices'
	lw t1, 4(sp)	# original a1 (pointer to start of array 'indices')
	lw t2, (sp)	# original a2 (length of array 'indices')
	add t2, t1, t2
	blt s0, t2, loop
	
	# if loop does not continue, go to no_error
	j no_error

error:
	mv a0, 0
	j end
	
no_error:
	mv a0, 1
	j end

end:
	# restore the stack
	lw s0, 20(sp)
	lw s1, 16(sp)
	lw ra, 12(sp)
	addi sp, sp, 24
	
	# return
	ret
	
