Extension { #name : #GtPhlowTreeView }

{ #category : #'*Leibniz2' }
GtPhlowTreeView >> itemLzCode: aBlockOrSymbol [
	self flag: #todo. "Obsolete, to be deleted."
	"Variant of itemText: that uses an appropriate Unicode font for Leibniz code"
	self itemText: aBlockOrSymbol.
	self itemStencil: LzCodeFont brLabelCellStencil
]
