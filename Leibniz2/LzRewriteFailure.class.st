Class {
	#name : #LzRewriteFailure,
	#superclass : #Exception,
	#category : #'Leibniz2-Rules'
}

{ #category : #accessing }
LzRewriteFailure >> defaultAction [
	"The default action taken if the exception is signaled."
	UnhandledError signalForException: self
]
