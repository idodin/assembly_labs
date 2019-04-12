int main() {
	int a[5] = {48,20,3,40,5};
	int max_val = 0;
	int i = (sizeof(a)/sizeof(a[0]))-1;
	for(i; i>=0; i--){
		if(a[i] > max_val){
			max_val = a[i];
		}
	}
	return max_val;
}
