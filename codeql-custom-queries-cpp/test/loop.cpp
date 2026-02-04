#include <iostream>
#include <vector>

    // should flag 2 times
void test_nested_loops() {
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            std::cout << i << "," << j << std::endl;
        }
    }

    int count = 0;
    while (count < 5) {
        for (int k = 0; k < 2; k++) {
            count++;
        }
    }

    for (int a = 0; a < 3; a++) {
    }
    for (int b = 0; b < 3; b++) { 
    }
}

int main() {
    test_nested_loops();
    return 0;
}