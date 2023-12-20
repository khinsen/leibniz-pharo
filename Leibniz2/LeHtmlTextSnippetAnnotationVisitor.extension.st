Extension { #name : #LeHtmlTextSnippetAnnotationVisitor }

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelAsset: aLzTopLevelAssetNode [
	LzHTMLTextSnippetAssetWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelAssetNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelEqualityAxiom: aLzTopLevelEqualityAxiomNode [
	LzHTMLTextSnippetEqualityAxiomWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelEqualityAxiomNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelFunctionRule: aLzTopLevelFunctionRuleNode [
	LzHTMLTextSnippetRuleWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelFunctionRuleNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelOp: aLzTopLevelOpNode [
	LzHTMLTextSnippetOpWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelOpNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelRewriteRule: aLzTopLevelRewriteRuleNode [
	LzHTMLTextSnippetRuleWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelRewriteRuleNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSort: aLzTopLevelSortNode [
	LzHTMLTextSnippetSortWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSortNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSpecialTerms: aLzTopLevelSpecialTermsNode [
	LzHTMLTextSnippetSpecialTermsWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSpecialTermsNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelSubsort: aLzTopLevelSubsortNode [
	LzHTMLTextSnippetSubsortWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelSubsortNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelTerm: aLzTopLevelTermNode [
	LzHTMLTextSnippetTermWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelTermNode;
		write
]

{ #category : #'*Leibniz2' }
LeHtmlTextSnippetAnnotationVisitor >> visitTopLevelUseContext: aLzTopLevelUseContextNode [
	LzHTMLTextSnippetUseContextWriter new
		snippet: snippet;
		context: context;
		annotation: aLzTopLevelUseContextNode;
		write
]
