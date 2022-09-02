Class {
	#name : #LzPythonCode,
	#superclass : #Object,
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzPythonCode class >> fromChildrenOfSnippet: aUidString [
	| snippet code |
	snippet := LzSnippetTerm snippetWithUID: aUidString.
	code := String streamContents: [ :s |
		snippet allChildrenDepthFirstDo: [ :each |
			(each isKindOf: LePythonSnippet) ifTrue: [
				s << each text asString.
				s << Character cr ] ] ].
	^ code
]
