extern int MAX_2(int x, int y);

int main() {
	/*int a, b, c;
	a = 1;
	b = 2;
	c = MAX_2(a,b);
	return c;*/
	int a[5] = {48,20,3,40,5};
	int max_val = 0;
	int i = (sizeof(a)/sizeof(a[0]))-1;
	for(i; i>=0; i--){
		max_val = MAX_2(a[i], max_val);
	}
	return max_val;
}
