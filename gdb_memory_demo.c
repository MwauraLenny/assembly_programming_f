int main(void)
{
    long long num1 = 42;
    char msg[] = "GDB memory demo";

    return num1 == 42 && msg[0] == 'G' ? 0 : 1;
}