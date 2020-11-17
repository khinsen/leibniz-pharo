Class {
	#name : #LbRewriteFailure,
	#superclass : #Exception,
	#category : #'Leibniz-4-Rules'
}

{ #category : #accessing }
LbRewriteFailure >> defaultAction [
	"The default action taken if the exception is signaled."

	UnhandledError signalForException: self
]
