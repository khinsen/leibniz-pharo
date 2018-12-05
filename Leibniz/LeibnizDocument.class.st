"
I represent a Leibniz document containing named contexts and references to other Leibniz documents.

"
Class {
	#name : #LeibnizDocument,
	#superclass : #Object,
	#category : #Leibniz
}

{ #category : #'instance creation' }
LeibnizDocument class >> fromDocHash: aString [ 
	| file |
	"TODO: implement a more complete lookup scheme."
	file := FileLocator home / '.leibniz' / (aString , '.html').
	"Check that the document's hash is equal to the requested one."
	self assert: (SHA256 hashStream: file binaryReadStream) hex equals: aString.
	^ self fromStream: file readStream.
]

{ #category : #'instance creation' }
LeibnizDocument class >> fromStream: aStream [
	| dom docElement |
	dom := XMLDOMParser parse: aStream.
	docElement := dom root descendantElementsNamed: 'leibniz-document'.
	^ self fromXML: docElement
]

{ #category : #'instance creation' }
LeibnizDocument class >> fromXML: anXMLElement [ 
	self shouldBeImplemented.
]
