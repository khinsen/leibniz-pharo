Extension { #name : #LeSnippet }

{ #category : #'*Leibniz2' }
LeSnippet >> nestingLevel [
	^ 1 + self parent nestingLevel
]
