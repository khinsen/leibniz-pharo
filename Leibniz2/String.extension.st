Extension { #name : #String }

{ #category : #'*Leibniz2' }
String >> asLzPage [
	^ LzBook pageNamed: self
]
