Class {
	#name : #LzShadowedBindings,
	#superclass : #Object,
	#instVars : [
		'shadowedVars',
		'bindings'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzShadowedBindings >> bindingFor: aName [
	(shadowedVars includes: aName) ifTrue: [ ^ nil ].
	^ bindings bindingFor: aName
]

{ #category : #accessing }
LzShadowedBindings >> bindings [
	^ bindings
]

{ #category : #accessing }
LzShadowedBindings >> bindings: anObject [
	bindings := anObject
]

{ #category : #testing }
LzShadowedBindings >> hasNoBindings [
	^ bindings hasNoBindings
]

{ #category : #accessing }
LzShadowedBindings >> shadowedVars [
	^ shadowedVars
]

{ #category : #accessing }
LzShadowedBindings >> shadowedVars: anObject [
	shadowedVars := anObject
]
