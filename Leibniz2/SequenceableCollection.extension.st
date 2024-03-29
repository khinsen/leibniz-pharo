Extension { #name : #SequenceableCollection }

{ #category : #'*Leibniz2' }
SequenceableCollection >> cartesianProductDo: aBlock [
	self cartesianProductWith: #() do: aBlock
]

{ #category : #'*Leibniz2' }
SequenceableCollection >> cartesianProductWith: anArray do: aBlock [
	self
		ifEmpty: [ aBlock cull: anArray ]
		ifNotEmpty: [ self first do: [ :each |
							self allButFirst
								cartesianProductWith: (anArray, { each })
								do: aBlock ] ]
]
