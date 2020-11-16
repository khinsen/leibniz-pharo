Class {
	#name : #LeibnizLibraryTest,
	#superclass : #TestCase,
	#instVars : [
		'library'
	],
	#category : #'Leibniz-7-Documents'
}

{ #category : #initializing }
LeibnizLibraryTest >> setUp [
	library := LeibnizLibrary uniqueInstance.

]

{ #category : #testing }
LeibnizLibraryTest >> testContextNamedInDocumentWithHash [
	| docHash context |
	docHash := 'deef8e5ff0d061e9524af0694049a0ae0cd62e3008bd00f3a741d5df0e8d5781'.
	context := library contextNamed: 'quantities' inDocumentWithHash: docHash.
	self assert: context name equals: 'quantities'.

]

{ #category : #testing }
LeibnizLibraryTest >> testDocumentWithHash [
	| docHash doc |
	docHash := 'deef8e5ff0d061e9524af0694049a0ae0cd62e3008bd00f3a741d5df0e8d5781'.
	doc := library documentWithHash: docHash.
	self assert: doc contexts keys asSet
	     equals: #('quantities' 'quantity-template' 'template-test' 'apply-quantity-template'
	               '-function-template-domain-quantity' '-function-template-image-quantity'
	               'quantity-function-template' 'apply-quantity-function-template'
	               '-function-template-image-div-domain-quantity' '-function-template-SQD→SQID'
	               'quantity-derivative-template' 'apply-quantity-derivative-template') asSet.

]
