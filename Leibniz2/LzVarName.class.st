Class {
	#name : #LzVarName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #'instance creation' }
LzVarName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #converting }
LzVarName >> addAsRopedTextTo: aRopedText [
	| text |
	text := internalSymbol asRopedText
		attribute: LzVarNameAttribute new.
	text
		attribute: LzDoNotRenderAttribute new
		from: text size to: text size.
	aRopedText append: text
]

{ #category : #converting }
LzVarName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText [
	self assert: anArrayOfTerms isEmpty.
	self addAsRopedTextTo: aRopedText
]

{ #category : #modifying }
LzVarName >> addPrefix: aSymbol [
	^ LzVarName for: aSymbol, internalSymbol
]

{ #category : #modifying }
LzVarName >> addScope: aSymbol [
	^ LzScopedVarName for: internalSymbol scope: aSymbol
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
