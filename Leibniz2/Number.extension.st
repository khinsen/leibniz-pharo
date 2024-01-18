Extension { #name : #Number }

{ #category : #'*Leibniz2' }
Number >> asLeibnizSyntax [
	^ self printString asRopedText
]
