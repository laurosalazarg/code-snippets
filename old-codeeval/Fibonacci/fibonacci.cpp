#include<iostream>
#include<fstream>
using namespace std;

int Fibonacci(int i){
	if(i<3){return 1;}
	return Fibonacci(i - 1) + Fibonacci(i - 2);
}

int main(int argc, char *argv[]){
	int N;
	ifstream input;
	input.open(argv[1]);

	while(!input.eof()){
		input >> N;
		cout<< Fibonacci(N)<<endl;

		}


return 0;

}