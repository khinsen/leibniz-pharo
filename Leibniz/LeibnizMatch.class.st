Class {
	#name : #LeibnizMatch,
	#superclass : #Object,
	#instVars : [
		'substitutions'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizMatch >> combineWith: anotherMatch [
	"TODO"
	^ nil
]

{ #category : #initialization }
LeibnizMatch >> initialize [
	substitutions := Dictionary new
]

{ #category : #accessing }
LeibnizMatch >> var: aSymbol value: aTerm [
	substitutions at: aSymbol put: aTerm

]
