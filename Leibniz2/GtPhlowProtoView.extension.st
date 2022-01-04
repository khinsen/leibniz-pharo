Extension { #name : #GtPhlowProtoView }

{ #category : #'*Leibniz2' }
GtPhlowProtoView >> lzColumnedTree [
	^ LzPhlowColumnedTreeView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector new 
			stack: thisContext stack;
			collect)
]

{ #category : #'*Leibniz2' }
GtPhlowProtoView >> lzTree [
	^ LbPhlowTreeView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector new 
			stack: thisContext stack;
			collect)
]
