Extension { #name : #LeDatabase }

{ #category : #'*Leibniz2' }
LeDatabase >> lzDBCache [
	^ LzDBRegistry uniqueInstance dbCacheFor: self
]
