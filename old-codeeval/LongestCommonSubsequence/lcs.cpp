#include<iostream>
#include<fstream>
#include<algorithm>
#include<string>
using namespace std;


string LCS(string str1, string str2){

	// cout<<"String 1: "<<str1<<"\n"<<"String 2: " <<str2<<endl;
		// str1 "XMJYAUZ";
		// str2 "MZJAWXU";

	int m = str1.length(), n=str2.length();
	// cout<< "m : "<< m << " n: " <<n <<endl;
	int i,j;
	int c[m+1][n+1],  b[m+1][n+1];
	string seq="";

// initialize
	for(i=0;i<=m;i++){
		c[i][0]=0;
		for(j=0;j<=n;j++){
			c[0][j]=0;
		}
	}
// calculate
	for ( i = 1; i <= m; i++) {
        for ( j = 1; j <= n; j++) {
            if (str1[i-1] == str2[j-1]) {
                c[i][j] = c[i-1][j-1] + 1;
                b[i][j] = 1;
            } else if (c[i-1][j] >= c[i][j-1]) {
                c[i][j] = c[i-1][j];
                b[i][j] = 2;	} 
             else {
                c[i][j] = c[i][j-1];
                b[i][j] = 3; }
        }
    }
	i=m;
	j=n;
// get seq
	while (i > 0 && j > 0) {
		if (b[i][j] == 1) {
    		 seq = str1[i-1] + seq;
    		 i-=1;
     	 	 j-=1; } 
 		else if (b[i][j] == 2) {
             i-=1;
        }
  	    else if(b[i][j]==3) {
             j-=1;
        }
    }
    return seq;
}


int main(int argc, char *argv[]){

	ifstream input;
	input.open(argv[1]);
	string str,token;
	string delimeter=";";
	size_t pos=0;
	// int ii=0;
	while(!input.eof()){
		// get line by line
		getline(input,str);
		//remove empty spaces
		str.erase(remove(str.begin(),str.end(),' '),str.end());
		// cout<<"Line: " <<ii<<endl;
		// cout<<str<<endl;
		// ii+=1;
		while( (pos=str.find(delimeter)) != string::npos){
			token = str.substr(0,pos);
			str.erase(0,pos+delimeter.length());
		}
		cout<< LCS(token,str)<<endl;

		}
		

}