#include <iostream>
#include <fstream>
#include<string>
using namespace std;

int main () {
    string line, outline="";
    ifstream myfile;
    myfile.open ("p2.txt");
    ofstream outfile;
    outfile.open("abs.txt");
    while(getline(myfile,line)){
        
        outline+=line;        
        outline+="\\\\";
        outline+='\n';
        cout<<outline;
        
    }
    outfile<<outline;
    myfile.close();
    return 0;
}