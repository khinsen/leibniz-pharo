Class {
	#name : #LzRule,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature',
		'condition',
		'pattern',
		'variables'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #accessing }
LzRule >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzRule >> valueSlots [
	^ #(variables pattern condition)
]
