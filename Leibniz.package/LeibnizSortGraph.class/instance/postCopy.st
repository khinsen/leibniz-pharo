copying
postCopy
	super postCopy.
	kinds := kinds deepCopy.
	supersorts := supersorts deepCopy.
	subsorts := subsorts deepCopy.