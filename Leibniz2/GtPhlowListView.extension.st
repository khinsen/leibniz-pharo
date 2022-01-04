Extension { #name : #GtPhlowListView }

{ #category : #'*Leibniz2' }
GtPhlowListView >> itemLzCode: aBlockOrSymbol [
	"Variant of itemText: that uses an appropriate Unicode font for Leibniz code"
	self itemText: aBlockOrSymbol.
	self itemStencil: LzCodeFont brLabelCellStencil
]
