Class {
	#name : #LzArgNameAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzArgNameAnnotation >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(name asRopedText attribute: LzArgNameAttribute new).
	aRopedText append: ':' asRopedText.
	declaration addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzArgNameAnnotation >> name [
	^ name
]

{ #category : #accessing }
LzArgNameAnnotation >> name: aSymbol [
	name := aSymbol
]
