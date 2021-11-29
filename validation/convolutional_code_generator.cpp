#include <iostream>
#include <bitset>
#include <string>
using namespace std;

const int a_reg_size = 5;
const int c_reg_size = 10;


string convolutional_code_generator (const string a_input_s) 
{
	/*	a_register
		a[k] | a[k-1] | a[k-2] | a[k-3]
		  0      1        2        3
	
		a(k - j) <=> a_reg[j]
	*/
	bitset<a_reg_size> a_reg;

	/*	c_register
		c[k-1] | c[k-2] | c[k-3] ... c[k-10]
		   0        1        2    ...   9

		c(k - j) <=> c_reg[j - 1]
	*/
	bitset<c_reg_size> c_reg;

	string convolutional_code = "";

	for (unsigned int i = 0; i < a_input_s.length(); i++) {
		// cout << "a: " << a_reg << endl << "c: " << c_reg << endl;
		a_reg <<= 1;

		a_reg[0] = (a_input_s.at(i) == '1');

		// c[k] = a[k] xor a[k-3] xor a[k-4] xor c[k-8] xor c[k-10]
		bool c_k = a_reg[0] ^ a_reg[3] ^ a_reg[4] ^ c_reg[7] ^ c_reg[9];
		convolutional_code = convolutional_code.append((c_k ? "1" : "0"));

		c_reg <<= 1;
		c_reg[0] = c_k;
	}

	return convolutional_code;
}

int main ()
{
	const string test1("10101010101010101010");
	cout << convolutional_code_generator(test1) << endl;
}