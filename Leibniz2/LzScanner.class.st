Class {
	#name : #LzScanner,
	#superclass : #SmaCCScanner,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-initialization' }
LzScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(32 'arrays' 12) #(32 'floatingPointNumbers' 13) #(32 'integers' 14) #(32 'name' 15) #(32 'name=' 16) #(32 'rationalNumbers' 17) #(32 'steps' 18) #(32 'strings' 19) #(32 'termClasses' 20))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
LzScanner >> emptySymbolTokenId [
	^ 85
]

{ #category : #generated }
LzScanner >> errorTokenId [
	^ 86
]

{ #category : #generated }
LzScanner >> scan1 [
	[ self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan10 [
	self step.
	currentCharacter == $- ifTrue: [ self step ].
	(currentCharacter between: $0 and: $9)
		ifTrue: [ [ self recordMatch: #(31).
			self step.
			currentCharacter between: $0 and: $9 ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan11 [
	self recordMatch: #(6 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan12 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $h ifTrue: [ ^ self scan13 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan13 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $a ifTrue: [ ^ self scan14 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan14 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $r ifTrue: [ ^ self scan15 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan15 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $o ifTrue: [ ^ self scan16 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan16 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $: ifTrue: [ ^ self recordAndReportMatch: #(7) ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan17 [
	self recordMatch: #(23 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan18 [
	self recordMatch: #(25 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan19 [
	self recordMatch: #(26 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan2 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan3 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan3 [
	[ self recordMatch: #(29 32).
	self step.
	currentCharacter == $. ifTrue: [ ^ self scan4 ].
	currentCharacter == $/ ifTrue: [ ^ self scan8 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan4 [
	[ self recordMatch: #(31 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan5 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $- ifTrue: [ ^ self scan6 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan6 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan7 [
	[ self recordMatch: #(31 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan8 [
	self recordMatch: #(32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $1 and: $9) ifTrue: [ ^ self scan9 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ '.0' includes: currentCharacter ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan9 [
	[ self recordMatch: #(30 32).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(33).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForToken [
	self step.
	currentCharacter == $"
		ifTrue: [ [ self step.
			currentCharacter == $" ifTrue: [ ^ self recordAndReportMatch: #(28) ].
			true ] whileTrue ].
	^ self scanForTokenX8
]

{ #category : #generated }
LzScanner >> scanForTokenX1 [
	[ self recordMatch: #(29).
	self step.
	currentCharacter == $.
		ifTrue: [ [ self recordMatch: #(31).
			self step.
			currentCharacter == $e ifTrue: [ ^ self scan10 ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $/
		ifTrue: [ self step.
			(currentCharacter between: $1 and: $9)
				ifTrue: [ [ self recordMatch: #(30).
					self step.
					currentCharacter between: $0 and: $9 ] whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan10 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX2 [
	[ self recordMatch: #(27).
	self step.
	currentCharacter isSeparator or: [ currentCharacter == Character pageUp ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX3 [
	self recordMatch: #(21).
	self step.
	currentCharacter == $. ifTrue: [ ^ self recordAndReportMatch: #(22) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX4 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(11) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX5 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX6 [
	self step.
	currentCharacter == $} ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX7 [
	currentCharacter == $^ ifTrue: [ ^ self scanForTokenX4 ].
	currentCharacter == ${ ifTrue: [ ^ self scanForTokenX3 ].
	currentCharacter == $| ifTrue: [ ^ self scan17 ].
	currentCharacter == $} ifTrue: [ ^ self recordAndReportMatch: #(24) ].
	currentCharacter = (Character value: 8658) ifTrue: [ ^ self scan18 ].
	currentCharacter = (Character value: 8838) ifTrue: [ ^ self scan19 ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scanForTokenX1 ].
	(currentCharacter isSeparator or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scanForTokenX2 ].
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX8 [
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	currentCharacter == $) ifTrue: [ ^ self recordAndReportMatch: #(2) ].
	currentCharacter == $, ifTrue: [ ^ self recordAndReportMatch: #(3) ].
	currentCharacter == $- ifTrue: [ ^ self scan2 ].
	currentCharacter == $. ifTrue: [ ^ self scanForTokenX6 ].
	currentCharacter == $: ifTrue: [ ^ self recordAndReportMatch: #(5) ].
	currentCharacter == $= ifTrue: [ ^ self scan11 ].
	currentCharacter == $P ifTrue: [ ^ self scan12 ].
	currentCharacter == $[ ifTrue: [ ^ self recordAndReportMatch: #(8) ].
	currentCharacter == $\ ifTrue: [ ^ self scanForTokenX5 ].
	currentCharacter == $] ifTrue: [ ^ self recordAndReportMatch: #(10) ].
	^ self scanForTokenX7
]

{ #category : #generated }
LzScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #whitespace)
]
