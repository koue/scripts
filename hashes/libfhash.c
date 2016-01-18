unsigned long fhash(const char *key)
{
	unsigned long result = 0;
	while(*key)
	{
		result += (unsigned char) *key++;
		result += result << 10;
		result ^= result >> 6;
	}
	
	result += result << 3;
	result ^= result >> 11;
	result += result << 15;
	return result;
}
