Class {
	#name : #LeibnizRewriteFailure,
	#superclass : #Exception,
	#category : #'Leibniz-4-Rules'
}

{ #category : #accessing }
LeibnizRewriteFailure >> defaultAction [
	"The default action taken if the exception is signaled."

	UnhandledError signalForException: self
]
