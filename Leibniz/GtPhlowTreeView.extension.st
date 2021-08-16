Extension { #name : 'GtPhlowTreeView' }

{ #category : '*Leibniz' }
GtPhlowTreeView >> itemLbCode: aBlockOrSymbol [
	"Variant of itemText: that uses an appropriate Unicode font for Leibniz code"
	self itemText: aBlockOrSymbol.
	self itemStencil: LbCodeFont brLabelCellStencil
]
