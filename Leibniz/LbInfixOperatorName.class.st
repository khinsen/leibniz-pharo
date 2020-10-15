Class {
	#name : #LbInfixOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbInfixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]
