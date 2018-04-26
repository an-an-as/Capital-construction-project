#include "enumeration.h"
enum animals { Dog, Cat, Invalid };

void dog(void){
    puts("wangwang");
}
void cat(void){
    puts("miaomiao");
}
enum animals selectingAnimal(void) {
    int temp;
    do {
        printf("Select : 0---🐶, 1--🐱");
        scanf("%d",&temp);
        
    } while (temp < Dog || temp > Invalid);
    return (enum animals) temp;
}
int main(int argc, const char * argv[]) {
    enum animals selected;
    switch (selected = selectingAnimal()) {
        case Dog: dog();
            break;
        case Cat: cat();
        default:
            break;
    }
    return 0;
}
