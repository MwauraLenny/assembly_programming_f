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
p/d $rax
p/x $rax
si
p/d $rbx
p/x $rbx
si
p/d $rax
p/x $rax
info reg rax rbx eflags