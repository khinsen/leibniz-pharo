Class {
	#name : #LzBooleanTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzBooleanTerm class >> signature: aSignature value: aBoolean [
	^ LzOpTerm new
		signature: aSignature;
		opName: (LzPrefixOperatorName for: aBoolean printString asSymbol);
		args: #();
		beRecursivelyReadOnlyObject;
		yourself
]
