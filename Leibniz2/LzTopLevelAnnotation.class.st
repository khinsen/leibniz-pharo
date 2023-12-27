Class {
	#name : #LzTopLevelAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#instVars : [
		'options'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #rendering }
LzTopLevelAnnotation >> color [
	({ nil. true } includes: (self optionsAt: #example))
		ifTrue: [ ^ LzColors exampleColor ].
	^ LzColors declarationColor
]

{ #category : #testing }
LzTopLevelAnnotation >> definesContext [
	^ self declaration definesContext
		and: [ (self optionsAt: #example)
				ifNil: [ true ]
				ifNotNil: [ :e | e not ] ]
]

{ #category : #testing }
LzTopLevelAnnotation >> definesSubcontext: aSubcontextName [
	^ self definesContext
		and: [
			| subcontext |
			subcontext := (self optionsAt: #subcontext).
			subcontext isNil or: [ subcontext = aSubcontextName ] ]
]

{ #category : #accessing }
LzTopLevelAnnotation >> options [
	^ options
]

{ #category : #accessing }
LzTopLevelAnnotation >> options: aDictionary [
	options := aDictionary
]

{ #category : #accessing }
LzTopLevelAnnotation >> optionsAt: aSymbol [
	^ options at: aSymbol ifAbsent: [ nil ]
]
