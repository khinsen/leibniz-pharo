Extension { #name : #LeDatabase }

{ #category : #'*Leibniz2' }
LeDatabase >> importLeibnizBookPageNamed: aString [
	self addPage:
		(Smalltalk compiler
			evaluate: (LzBook pageNamed: aString)
						storeString)
]

{ #category : #'*Leibniz2' }
LeDatabase >> lzDBCache [
	^ LzDBRegistry uniqueInstance dbCacheFor: self
]
