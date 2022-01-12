	.data
a:	.space	80 # 10*8
	.eqv	SIZE,10
	.text
	.globl main
main:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	li	$s0,0
for:	
	bge	$s0,SIZE,endfor
	
	li	$v0,5
	syscall
	move	$s1,$v0
	mtc1	$s1,$f0
	cvt.d.w	$f0,$f0		# $f0 = (double) read_int();
	
	sll	$s2,$s0,3
	la	$s3,a
	addu	$s2,$s2,$s3
	s.d	$f0,0($s2)
	addiu	$s0,$s0,1
	j	for
endfor:
	la	$a0,a
	li	$a1,SIZE
	jal	average
	mov.d	$f12,$f0
	li	$v0,3
	syscall
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra













########################################################################
# *array: $a0, n: $a1, i: $t0, sum: $f0, temp: $f2
average:			# double average(double *array, int n) {
				#   int i = n;
				#   double sum 0.0;
				#   for(; i > 0; i--) {
				#     sum += array[i-1];
				#   }
				#   return sum / (double)n;
				# }
	move	$t0,$a1
	mtc1	$0,$f0
	cvt.d.w	$f0,$f0
average_for:
	blez	$t0,average_endfor
	sll	$t1,$t0,3
	addu	$t1,$t1,$a0
	l.d	$f2,-8($t1)
	add.d	$f0,$f0,$f2
	addi	$t0,$t0,-1
	j	average_for
average_endfor:
	mtc1	$a1,$f2
	cvt.d.w	$f2,$f2
	div.d	$f0,$f0,$f2
	jr	$ra

















