Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 14 0 173] 
#[ 0 42 0 181] 
#[ 0 42 0 185] 
#[ 0 42 0 189] 
#[ 0 82 0 197] 
#[ 0 90 0 197]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-23T15:47:19.610944+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp);
%hierarchy TopLevelAxiom (TopLevelEqualityAxiom TopLevelSubsortAxiom);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
	;
<identifierCharacter>
	: <isLzIdentifierCharacter>
	;
<opIdentifier>
	: <identifierCharacter> (\d | \. | <identifierCharacter>)*
	;
<varIdentifier>
	: <opIdentifier> \_+
	;
<string>
	: \"" [^""]* \""
	;
<integer>
	: \-? \d+
	;
<rationalNumber>
	: \-?  \d+ \/ [1-9] \d*
	;
<fpNumber>
	: (<integer> \. \d* (e <integer>)?) | (<integer> e <integer>)
	;
Start 
	: TopLevelSort
	;
TopLevelOp
	: Op 'op'  "":"" 'colon' Term 'sort' {{}}
	;
TopLevelSort
	: Op 'op' {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| NonInfixTerm 'arg' <opIdentifier> 'opName' NonInfixTerm 'arg' {{InfixOp}}
	;
TopLevelAxiom
	: Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? {{TopLevelEqualityAxiom}}
	| Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' {{TopLevelSubsortAxiom}}
	;
TopLevelRule
	: Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? {{TopLevelRewriteRule}}
	| Term 'pattern' ""→"" 'arrow' <string> 'code' ("":"" <opIdentifier> 'class')? (""|"" Term 'condition')? {{TopLevelFunctionRule}}
	;
TopLevelTerm
	: Term 'term' {{}}
	;
Term
	: NonInfixTerm 'arg' (<opIdentifier> 'opName' NonInfixTerm 'arg')+ {{InfixOpTerm}}
	| NonInfixTerm
	;
NonInfixTerm
	: SimpleTerm
	| SimpleTerm 'arg'
		""["" 'leftBracket'  Term 'arg'
			("","" 'comma' Term 'arg')*
		""]"" 'rightBracket' {{BracketOpTerm}}
	| SimpleTerm 'arg'
		""^("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SuperscriptOpTerm}}
	| SimpleTerm 'arg'
		""\("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SubscriptOpTerm}}
	;
SimpleTerm
	: LiteralTerm
	| ""("" Term "")""
	| ArrayTerm
	| PrefixOpTerm
	| VarTerm
	;
PrefixOpTerm
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{}}
	;
VarTerm
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{VarTermWithSort}}
	| <varIdentifier> 'varName' {{}}
	;
ArrayTerm
	: ""{"" 'leftBrace' ArrayElements 'arrayElements' ""}"" 'rightBrace' {{}}
	;
ArrayElements
	: ""["" 'leftBracket' ArrayElement 'element'
		("","" 'comma' ArrayElement 'element')* ""]"" 'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
	;
LiteralTerm
	: IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
StringLiteralTerm
	: <string> 'text' {{}}
	;
IntegerLiteralTerm
	: <integer> 'text' {{}}
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'text' {{}}
	;
FpNumberLiteralTerm
	: <fpNumber> 'text' {{}}
	;"
]

{ #category : #initializing }
LzParser2 class >> initialize [
	LeParser annotationParsers
		at: 'lzSort'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSort ].
	LeParser annotationParsers
		at: 'lzOp'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelOp ].
	LeParser annotationParsers
		at: 'lzAxiom'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAxiom ].
	LeParser annotationParsers
		at: 'lzRule'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelRule ].
	LeParser annotationParsers
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ].
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	LeParser annotationParsers removeKey: 'lzSort' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzOp' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzAxiom' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzRule' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzTerm' ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(27 1 #reduceActionForOp1: 1069057 false) 
	#(38 1 #reduceActionForPrefixOpTerm1: 2339841 false) 
	#(39 1 #reduceActionForVarTerm2: 2468866 false) 
	#(46 1 #reduceActionForStringLiteralTerm1: 2958337 false) 
	#(47 1 #reduceActionForIntegerLiteralTerm1: 3004417 false) 
	#(48 1 #reduceActionForRationalNumberLiteralTerm1: 3052545 false) 
	#(49 1 #reduceActionForFpNumberLiteralTerm1: 3115009 false) 
	#(24 1 #liftFirstValue: 953345 false) 
	#(26 1 #reduceActionForTopLevelSort1: 1036289 false) 
	#(36 1 #liftFirstValue: 1853441 false) 
	#(37 1 #liftFirstValue: 2252804 false) 
	#(37 1 #liftFirstValue: 2252805 false) 
	#(37 1 #liftFirstValue: 2252803 false) 
	#(37 1 #liftFirstValue: 2252801 false) 
	#(45 1 #liftFirstValue: 2845700 false) 
	#(45 1 #liftFirstValue: 2845697 false) 
	#(45 1 #liftFirstValue: 2845698 false) 
	#(45 1 #liftFirstValue: 2845699 false) 
	#(32 1 #reduceActionForTopLevelTerm1: 1705985 false) 
	#(33 1 #liftFirstValue: 1742850 false) 
	#(35 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1770497 false) 
	#(33 2 #reduceActionForTerm1: 1742849 false) 
	#(37 3 #liftSecondValue: 2252802 false) 
	#(44 1 #liftFirstValue: 2803713 false) 
	#(44 1 #liftFirstValue: 2803714 false) 
	#(43 0 #reduceActionFor______comma__ArrayElement__element___1: 2737153 false) 
	#(40 3 #reduceActionForArrayTerm1: 2589697 false) 
	#(29 0 #reduceActionFor______comma__ArrayElement__element___1: 1133569 false) 
	#(39 3 #reduceActionForVarTerm1: 2468865 false) 
	#(27 3 #reduceActionForOp3: 1069059 false) 
	#(34 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1770497 false) 
	#(35 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1770498 false) 
	#(25 3 #reduceActionForTopLevelOp1: 979969 false) 
	#(30 3 #reduceActionForTopLevelAxiom1: 1274881 false) 
	#(30 3 #reduceActionForTopLevelAxiom3: 1274883 false) 
	#(31 3 #reduceActionForTopLevelRule3: 1462275 false) 
	#(31 3 #reduceActionForTopLevelRule1: 1462273 false) 
	#(41 4 #reduceActionForArrayElements1: 2675713 false) 
	#(43 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 2737154 false) 
	#(27 5 #reduceActionForOp2: 1069058 false) 
	#(38 5 #reduceActionForPrefixOpTerm2: 2339842 false) 
	#(29 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1133570 false) 
	#(36 5 #reduceActionForNonInfixTerm2: 1853442 false) 
	#(36 5 #reduceActionForNonInfixTerm4: 1853444 false) 
	#(36 5 #reduceActionForNonInfixTerm3: 1853443 false) 
	#(30 5 #reduceActionForTopLevelAxiom2: 1274882 false) 
	#(31 5 #reduceActionForTopLevelRule5: 1462277 false) 
	#(31 5 #reduceActionForTopLevelRule4: 1462276 false) 
	#(31 5 #reduceActionForTopLevelRule2: 1462274 false) 
	#(42 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 2737153 false) 
	#(28 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1133569 false) 
	#(31 7 #reduceActionForTopLevelRule6: 1462278 false)
	).
]

{ #category : #generated }
LzParser2 class >> scannerClass [
	^LzScanner
]

{ #category : #generated }
LzParser2 class >> startingStateForStart [
	^ 1
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAxiom [
	^ 5
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelOp [
	^ 3
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelRule [
	^ 6
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSort [
	^ 4
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' 'TopLevelSort' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelSortNode #LzTopLevelSortNode #LzTopLevelOpNode #LzTopLevelSortNode #LzOpNode #OrderedCollection #OrderedCollection #LzTopLevelAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzParseTreeNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 29 0 1 0 33 0 10 0 37 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 61 0 24 0 61 0 26 0 69 0 27 0 73 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 117 0 32 0 121 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 37 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 129 0 25 0 133 0 27 0 73 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 37 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 137 0 26 0 69 0 27 0 73 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 141 0 30 0 145 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 149 0 31 0 153 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 157 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 161 0 6 0 165 0 41] 
#[1 0 169 0 1 0 6 0 4 0 10 0 6 0 10 0 7 0 10 0 9 0 10 0 17 0 6 0 50] 
#[1 0 14 0 2 0 14 0 3 0 7 0 4 0 14 0 5 0 14 0 6 0 14 0 7 0 14 0 8 0 14 0 9 0 14 0 11 0 14 0 13 0 14 0 14 0 14 0 15 0 14 0 17 0 14 0 50] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 30 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 0 0 50] 
#[0 0 34 0 50] 
#[0 0 38 0 50] 
#[0 0 177 0 17] 
#[1 0 42 0 2 0 42 0 3 0 42 0 4 0 42 0 5 0 11 0 6 0 15 0 7 0 42 0 8 0 19 0 9 0 42 0 11 0 42 0 13 0 42 0 14 0 42 0 15 0 42 0 17 0 42 0 50] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[1 0 193 0 1 0 10 0 2 0 10 0 3 0 10 0 4 0 10 0 5 0 10 0 6 0 10 0 7 0 10 0 8 0 10 0 9 0 10 0 11 0 10 0 13 0 10 0 14 0 10 0 15 0 10 0 17 0 10 0 50] 
#[0 0 0 0 50] 
#[0 0 78 0 50] 
#[1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 82 0 6 0 82 0 7 0 82 0 8 0 82 0 9 0 82 0 11 0 82 0 13 0 82 0 14 0 82 0 15 0 23 0 17 0 201 0 34 0 205 0 35 0 82 0 50] 
#[0 0 0 0 50] 
#[0 0 209 0 4] 
#[0 0 0 0 50] 
#[0 0 0 0 50] 
#[1 0 213 0 5 0 217 0 15] 
#[0 0 0 0 50] 
#[1 0 221 0 13 0 225 0 14] 
#[0 0 229 0 2] 
#[1 0 29 0 1 0 161 0 6 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 241 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 241 0 41 0 241 0 44 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 245 0 12] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 249 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 0 253 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 1 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 5 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 9 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 13 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 17 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 21 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[1 0 90 0 2 0 90 0 3 0 90 0 4 0 90 0 5 0 90 0 6 0 90 0 7 0 90 0 8 0 90 0 9 0 90 0 11 0 90 0 13 0 90 0 14 0 90 0 15 0 27 0 17 1 25 0 34 0 90 0 50] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 29 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 33 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 37 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 1 41 0 19] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 45 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 98 0 3 0 8] 
#[0 0 102 0 3 0 8] 
#[1 0 106 0 3 0 106 0 8 1 49 0 43] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[1 0 114 0 2 0 114 0 3 1 53 0 29] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 122 0 4 0 50] 
#[1 0 114 0 3 0 114 0 8 1 57 0 29] 
#[1 0 114 0 2 0 114 0 3 1 61 0 29] 
#[1 0 114 0 2 0 114 0 3 1 65 0 29] 
#[1 0 114 0 2 0 114 0 3 1 69 0 29] 
#[0 0 126 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 130 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 134 0 50] 
#[1 1 73 0 11 0 138 0 50] 
#[0 0 142 0 50] 
#[1 1 77 0 4 1 81 0 11 0 146 0 50] 
#[1 1 85 0 11 0 150 0 50] 
#[1 1 89 0 3 1 93 0 8 1 97 0 42] 
#[1 1 101 0 2 1 105 0 3 1 109 0 28] 
#[1 1 105 0 3 1 113 0 8 1 109 0 28] 
#[1 1 117 0 2 1 105 0 3 1 109 0 28] 
#[1 1 121 0 2 1 105 0 3 1 109 0 28] 
#[1 1 125 0 2 1 105 0 3 1 109 0 28] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 129 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 1 133 0 17] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 137 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 141 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[1 0 29 0 1 0 161 0 6 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 145 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 1 145 0 41 1 145 0 44 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 154 0 3 0 8 0 12] 
#[0 0 158 0 3 0 8] 
#[1 0 162 0 4 0 166 0 6 0 166 0 7 0 166 0 9 0 166 0 17 0 162 0 50] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 149 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 170 0 2 0 3 0 8] 
#[0 0 174 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 178 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 182 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 166 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 11 0 13 0 14 0 15 0 17 0 50] 
#[0 0 186 0 50] 
#[1 1 153 0 11 0 190 0 50] 
#[0 0 194 0 50] 
#[0 0 198 0 50] 
#[0 0 202 0 3 0 8] 
#[0 0 206 0 2 0 3 0 8] 
#[1 0 29 0 1 0 33 0 10 0 113 0 17 0 41 0 18 0 45 0 19 0 49 0 20 0 53 0 21 0 57 0 22 1 157 0 33 0 125 0 36 0 77 0 37 0 77 0 38 0 77 0 39 0 77 0 40 0 77 0 45 0 77 0 46 0 77 0 47 0 77 0 48 0 77 0 49] 
#[0 0 210 0 50]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBracket: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayTerm1: nodes [
	| result |
	result := LzArrayTermNode new.
	result leftBrace: (nodes at: 1).
	result arrayElements: (nodes at: 2).
	result rightBrace: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForFpNumberLiteralTerm1: nodes [
	| result |
	result := LzFpNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForIntegerLiteralTerm1: nodes [
	| result |
	result := LzIntegerLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm2: nodes [
	| result |
	result := LzBracketOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftBracket: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm3: nodes [
	| result |
	result := LzSuperscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm4: nodes [
	| result |
	result := LzSubscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp1: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp2: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp3: nodes [
	| result |
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm1: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm2: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRationalNumberLiteralTerm1: nodes [
	| result |
	result := LzRationalNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStringLiteralTerm1: nodes [
	| result |
	result := LzStringLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTerm1: nodes [
	| result |
	result := LzInfixOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result addTokens: ((nodes at: 2) at: 1) to: result opNames.
	result addNodes: ((nodes at: 2) at: 2) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom1: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result left: (nodes at: 1).
	result equals: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom2: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result left: (nodes at: 1).
	result equals: (nodes at: 2).
	result right: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom3: nodes [
	| result |
	result := LzTopLevelSubsortAxiomNode new.
	result subsort: (nodes at: 1).
	result subsetOf: (nodes at: 2).
	result supersort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result op: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule1: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result replacement: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule2: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result replacement: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule5: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result _class: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule6: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result _class: (nodes at: 5).
	result condition: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result op: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result term: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
	| result |
	result := LzVarTermWithSortNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm2: nodes [
	| result |
	result := LzVarTermNode new.
	result varName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor______comma__ArrayElement__element___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]
