Extension { #name : 'GtPhlowProtoView' }

{ #category : '*Leibniz' }
GtPhlowProtoView >> lbColumnedTree [
	^ LbPhlowColumnedTreeView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector new 
			stack: thisContext stack;
			collect)
]

{ #category : '*Leibniz' }
GtPhlowProtoView >> lbTree [
	^ LbPhlowTreeView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector new 
			stack: thisContext stack;
			collect)
]
