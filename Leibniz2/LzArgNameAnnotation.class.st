Class {
	#name : #LzArgNameAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzArgNameAnnotation >> addAsFirstArgOfInfixTermWithOpName: anOpName asRopedTextTo: aRopedText [
	self addAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzArgNameAnnotation >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(name asRopedText attribute: LzArgNameAttribute new).
	aRopedText append: ':' asRopedText.
	declaration addAsRopedTextTo: aRopedText
]

{ #category : #testing }
LzArgNameAnnotation >> isInfix [
	^ false
]

{ #category : #accessing }
LzArgNameAnnotation >> name [
	^ name
]

{ #category : #accessing }
LzArgNameAnnotation >> name: aSymbol [
	name := aSymbol
]
