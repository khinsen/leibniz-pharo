"
I am a convenience constructor for creating boolean terms from Pharo code
"
Class {
	#name : #LbBooleanTerm,
	#superclass : #LbOpTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbBooleanTerm class >> value: aBoolean signature: aSignature [
	^ LbOpTerm
		name: (LbPrefixOperatorName for:
				(aBoolean ifTrue: [ #true ] ifFalse: [ #false ]))
		args: Array new
		sort: #boolean
		signature: aSignature
]
