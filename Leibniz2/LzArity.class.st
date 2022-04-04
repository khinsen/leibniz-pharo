Class {
	#name : #LzArity,
	#superclass : #Array,
	#type : #variable,
	#traits : 'TLzPrintable',
	#classTraits : 'TLzPrintable classTrait',
	#category : #'Leibniz2-Signatures'
}

{ #category : #constructing }
LzArity class >> forArgs: anArrayOfTerms [
	| arity |
	arity := self new: anArrayOfTerms size.
	anArrayOfTerms collect: #sort into: arity.
	^ arity
]

{ #category : #comparing }
LzArity >> <= anArity [
	self species = anArity species ifFalse: [ ^ false ].
	self size = anArity size ifFalse: [ ^ false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #constructing }
LzArity >> kindArity [
	| kindArity |
	kindArity := LzArity new: self size.
	self collect: #kind into: kindArity.
	^ kindArity
]

{ #category : #printing }
LzArity >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $(.
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $).
]

{ #category : #printing }
LzArity >> printVariablesAsLeibnizSyntaxOn: aStream [
	| printVars vars sortVars |
	printVars := [ :var :sort |
		aStream nextPutAll: var asSymbol.
		aStream nextPut: $:.
		aStream nextPutAll: sort asLeibnizSyntaxString.
		aStream nextPutAll: ' ' ].
	vars := self vars.
	sortVars := (vars values collect: [ :each | each term vars ])
					inject: Dictionary new
					into: [ :total :each | total union: each ].
	sortVars keysAndValuesDo: printVars.
	vars keysAndValuesDo: printVars
]

{ #category : #accessing }
LzArity >> vars [
	^ self
		inject: Dictionary new
		into: [ :total :each | total union: each vars ]
]
