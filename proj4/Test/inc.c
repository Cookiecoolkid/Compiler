int inc(int a) 
{
  int b = a + 1;
  return b;
}

int main()
{
  int lcVar = 2 * 2;
  int rcVar = inc(lcVar);
  write(rcVar);
  return 0;
}