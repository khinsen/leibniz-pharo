Class {
	#name : #LzVarName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Parser'
}

{ #category : #'instance creation' }
LzVarName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #modifying }
LzVarName >> addPrefix: aSymbol [
	^ LzVarName for: aSymbol, internalSymbol
]

{ #category : #accessing }
LzVarName >> name [
	^ self
]

{ #category : #printing }
LzVarName >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: internalSymbol
]

{ #category : #printing }
LzVarName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self printForArgs: anENodeArray on: aStream
]

{ #category : #printing }
LzVarName >> printForArity: anArity on: aStream [
	self assert: anArity isEmpty.
	self printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzVarName >> tag [
	^ nil
]
