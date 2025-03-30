struct circle {
    int radius;
    float area;
};

int main() {
    struct circle c;
    c.radius = 10;
    c.area = 3.14 * c.radius * c.radius;
    return 0;
}