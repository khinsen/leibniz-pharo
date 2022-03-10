Class {
	#name : #LzPseudoOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzPseudoOpName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol asSymbol
]
