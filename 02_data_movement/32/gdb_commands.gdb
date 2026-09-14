set pagination off
break _start
run

printf "\nnum1 address and contents:\n"
p/x &num1
info address num1
x/bd &num1
x/hd &num1
x/wd &num1
x/gd &num1

printf "\nmsg contents:\n"
x/s &msg
x/5cb &msg
x/5xb &msg
print *(char[5]*)&msg

printf "\nregister values after immediate moves:\n"
si
p/d $eax
p/x $eax
si
p/d $ebx
p/x $ebx
si
p/d $eax
p/x $eax
info reg eax ebx eflags