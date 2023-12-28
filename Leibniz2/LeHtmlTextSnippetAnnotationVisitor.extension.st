Extension { #name : #LeHtmlTextSnippetAnnotationVisitor }

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelAsset: aLzTopLevelAssetNode [
	LzHtmlTextSnippetAssetWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelAssetNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelEqualityAxiom: aLzTopLevelEqualityAxiomNode [
	LzHtmlTextSnippetEqualityAxiomWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelEqualityAxiomNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelFunctionRule: aLzTopLevelFunctionRuleNode [
	LzHtlmTextSnippetRuleWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelFunctionRuleNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelOp: aLzTopLevelOpNode [
	LzHtmlTextSnippetOpWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelOpNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelRewriteRule: aLzTopLevelRewriteRuleNode [
	LzHtlmTextSnippetRuleWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelRewriteRuleNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSort: aLzTopLevelSortNode [
	LzHtlmTextSnippetSortWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSortNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSpecialTerms: aLzTopLevelSpecialTermsNode [
	LzHtmlTextSnippetSpecialTermsWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSpecialTermsNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSubsort: aLzTopLevelSubsortNode [
	LzHtmlTextSnippetSubsortWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSubsortNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelTerm: aLzTopLevelTermNode [
	LzHtmlTextSnippetTermWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelTermNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelUseContext: aLzTopLevelUseContextNode [
	| writer |
	writer := LzHtmlTextSnippetUseContextWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelUseContextNode.
	context pageLinks
		linkTitled: aLzTopLevelUseContextNode pageName
						source allButFirst allButLast
		ifFound: [ :aPageLink | 
			context html
				inlineTag: #a
				attributes: {'href'.
						self context hrefBuilder hrefFromPageLink: aPageLink}
				do: [ writer write ]]
		ifNone: [ writer write ]
]
