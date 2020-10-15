Class {
	#name : #LbPrefixOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbPrefixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]
