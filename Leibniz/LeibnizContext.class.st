"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph'
	],
	#category : #Leibniz
}

{ #category : #'XML-import' }
LeibnizContext >> fromXML: anXMLElement [
	name := anXMLElement attributeAt: 'id'.
	anXMLElement descendantElementsNamed: 'sort' do:
		[ :sort | sortGraph add: (sort attributeAt: 'id') asSymbol].
	anXMLElement descendantElementsNamed: 'subsort' do:
		[ :ss | sortGraph make: (ss attributeAt: 'subsort') asSymbol
		                  subsortOf: (ss attributeAt: 'supersort') asSymbol].

]

{ #category : #initializing }
LeibnizContext >> initialize [
	sortGraph := LeibnizSortGraph new.

]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]
