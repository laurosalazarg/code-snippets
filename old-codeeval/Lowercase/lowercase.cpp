#include<iostream>
#include<fstream>
#include<algorithm>
#include<string>
using namespace std;

int main(int argc, char *argv[]){
	ifstream input;
	input.open(argv[1]);

	for(string line; getline(input,line) ;){
		transform(line.begin(), line.end(), line.begin(), ::tolower);
		cout<<line<<endl;
		}


}