/*class foo{
    public:
        int a;
        int b;
    public:
        foo( int a = 365){
            this->a = a;
            this->b = a+20;
        };
        char out( int q, int c = 20){
            int b = 30;
            return (char) b;
        };
        int goo(int c){
            this->a = c;
            return c + 30;
        };
};
*/

template<typename T>
T sum(T a, T b){
    return a + b;
}

int main(void){
    int a;
    sum<int>(a,a);
    sum<char>(a,10);

    int array[10] = {1,2,3};

    a = a + 1;
    return a;
}

