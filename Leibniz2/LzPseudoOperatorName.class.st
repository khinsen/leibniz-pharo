Class {
	#name : #LzPseudoOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzPseudoOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol asSymbol
]
