Extension { #name : 'Symbol' }

{ #category : '*Leibniz' }
Symbol >> asLbOperatorName [
	^ LbOperatorName fromInternalSymbol: self
]
