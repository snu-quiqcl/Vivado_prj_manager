class foo{
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

int main(void){
    int a;
    foo q;

    a  = q.a;
    a = a + 1;
    a = q.goo(23432);
    return a;
}

