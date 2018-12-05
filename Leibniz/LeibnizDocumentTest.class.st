Class {
	#name : #LeibnizDocumentTest,
	#superclass : #TestCase,
	#category : #Leibniz
}

{ #category : #testing }
LeibnizDocumentTest >> testFromDocHash [
	"This test does not do any explicit checks. It's just there to catch errors that might occur."
	| docHash doc |
	docHash := 'deef8e5ff0d061e9524af0694049a0ae0cd62e3008bd00f3a741d5df0e8d5781'.
	doc := LeibnizDocument fromDocHash: docHash.

]
