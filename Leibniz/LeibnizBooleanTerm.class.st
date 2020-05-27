"
I am a convenience constructor for creating boolean terms from Pharo code
"
Class {
	#name : #LeibnizBooleanTerm,
	#superclass : #LeibnizOpTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizBooleanTerm class >> value: aBoolean forSignature: aSignature [
	^ LeibnizOpTerm symbol: (aBoolean ifTrue: [ #true ] ifFalse: [ #false ])
						 args: Array new
						 sort: #boolean
						 forSignature: aSignature
]
