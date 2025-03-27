int f(int a, int b, float c);


int f(int a, int b, float c) {
  c = a + b;
  return c;
}

int main() {
  int a = 1;
  int b = 2;
  float c = 3.0;
  int d = f(a, b, c);
  return 0;
}