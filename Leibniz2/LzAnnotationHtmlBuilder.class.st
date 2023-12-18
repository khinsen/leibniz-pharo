Class {
	#name : #LzAnnotationHtmlBuilder,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'context'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #'api - building' }
LzAnnotationHtmlBuilder >> build [

]

{ #category : #accessing }
LzAnnotationHtmlBuilder >> context [
	^ context
]

{ #category : #accessing }
LzAnnotationHtmlBuilder >> context: anObject [
	context := anObject
]
