Class {
	#name : #LbPseudoOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #accessing }
LbPseudoOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol asSymbol
]
