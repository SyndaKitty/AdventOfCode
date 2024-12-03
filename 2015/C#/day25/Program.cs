int x = 1;
int y = 1;

long num = 20151125;
long mul = 252533;
long div = 33554393;

// To continue, please consult the code grid in the manual.  Enter the code at row 2981, column 3075.
int targetX = 3075;
int targetY = 2981;

while (x != targetX || y != targetY) {
    (x, y) = nextCoord(x, y);
    num = nextCode(num);

}
Console.WriteLine(x + ", " + y + ": " + num);

long nextCode(long code) {
    return (code * mul) % div;
}

(int, int) nextCoord(int x, int y) {
    int nx = x + 1;
    int ny = y - 1;
    if (ny == 0) {
        ny = nx;
        nx = 1;
    }
    return (nx, ny);
}