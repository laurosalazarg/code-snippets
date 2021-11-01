#include<iostream>
#include<fstream>
using namespace std;

int main(int argc, char *argv[]){
	int A,B,N;
	bool FizzBuzz;
	ifstream input;
	input.open(argv[1]);
	while(!input.eof()){
		input >> A >> B >> N;
		for(int i=1;i<=N;i++){
			FizzBuzz=0;
			if( ((i % B ) == 0 ) && ((i % A ) == 0 )){
				cout<<"FB";
				FizzBuzz = 1;
			}
			else if( (i % A ) == 0){
				if(FizzBuzz==0){
				cout<<"F"; } 
			}
			else if( (i % B ) == 0){
				if(FizzBuzz==0){
				cout<<"B"; }
			}
			else{
				cout<<i;
			}
			if(i+1<=N){
				cout<<" ";
			}
			else{
				cout<<endl;
			}

		}
		
	}
	return 0;
}