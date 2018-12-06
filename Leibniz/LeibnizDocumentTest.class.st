Class {
	#name : #LeibnizDocumentTest,
	#superclass : #TestCase,
	#category : #Leibniz
}

{ #category : #testing }
LeibnizDocumentTest >> testFromDocHash [
	| docHash doc |
	docHash := 'deef8e5ff0d061e9524af0694049a0ae0cd62e3008bd00f3a741d5df0e8d5781'.
	doc := LeibnizDocument fromDocHash: docHash.
	self assert: doc contexts keys asSet
	     equals: #('quantities' 'quantity-template' 'template-test' 'apply-quantity-template'
	               '-function-template-domain-quantity' '-function-template-image-quantity'
	               'quantity-function-template' 'apply-quantity-function-template'
	               '-function-template-image-div-domain-quantity' '-function-template-SQD→SQID'
	               'quantity-derivative-template' 'apply-quantity-derivative-template') asSet.

]
