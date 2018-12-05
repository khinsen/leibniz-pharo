"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Leibniz
}

{ #category : #'XML-import' }
LeibnizContext >> fromXML: anXMLElement [
	name := anXMLElement attributeAt: 'id'.

]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]
