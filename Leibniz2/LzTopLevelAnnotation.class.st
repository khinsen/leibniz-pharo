Class {
	#name : #LzTopLevelAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#instVars : [
		'options'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzTopLevelAnnotation >> options: aDictionary [
	options := aDictionary
]

{ #category : #accessing }
LzTopLevelAnnotation >> optionsAt: aSymbol [
	^ options at: aSymbol ifAbsent: [ nil ]
]
