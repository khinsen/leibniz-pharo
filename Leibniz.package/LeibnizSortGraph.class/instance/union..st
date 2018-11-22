adding
union: aSortGraph 
	| sg |
	sg := self deepCopy.
	aSortGraph asSet do: [ :each | sg add: each ].
	aSortGraph withSubsortRelationsDo: [ :s1 :s2 | sg make: s1 subsortOf: s2 ].
	^ sg
