Extension { #name : #GtPhlowColumnedTreeView }

{ #category : #'*Leibniz2' }
GtPhlowColumnedTreeView >> column: aTitleString lzCode: aBlock [
	"A variant of column:text: that uses
	 an appropriate Unicode font for Leibniz code"
	self column: aTitleString do: [ :aColumn |
		aColumn cellStencil: LzCodeFont brLabelCellStencil;
		dataBinder: [ :eachLabel :eachItem |
			eachLabel text: (aBlock value: eachItem)  ] ]
]

{ #category : #'*Leibniz2' }
GtPhlowColumnedTreeView >> column: aTitleString lzCode: aBlock weight: aNumber [
	"A variant of column:text: that uses
	 an appropriate Unicode font for Leibniz code"
	self column: aTitleString do: [ :aColumn |
		aColumn cellStencil: LzCodeFont brLabelCellStencil;
		dataBinder: [ :eachLabel :eachItem |
			eachLabel text: (aBlock value: eachItem)  ];
		weight: aNumber ]
]
