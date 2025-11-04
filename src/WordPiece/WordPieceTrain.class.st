Class {
	#name : 'WordPieceTrain',
	#superclass : 'Object',
	#instVars : [
		'tokens',
		'words',
		'vocabulary',
		'pairesFrequency',
		'pairesScores',
		'lettersFrequency'
	],
	#category : 'WordPiece',
	#package : 'WordPiece'
}

{ #category : 'as yet unclassified' }
WordPieceTrain >> addToVocabulary: aString [
	vocabulary add: aString 
]

{ #category : 'nodes' }
WordPieceTrain >> collectPairFrom: anAssociation [
	|word|
	word:=anAssociation key.
	word overlappingPairsWithIndexDo: [ :a :b :index| pairesFrequency add:{a.b} withOccurrences:anAssociation value ]
]

{ #category : 'adding' }
WordPieceTrain >> computePairesFrequency [
	pairesFrequency := Bag new.
	tokens associationsDo: [ :association| self collectPairFrom: association ]
]

{ #category : 'as yet unclassified' }
WordPieceTrain >> computePairesScores [
	pairesScores := Dictionary new.
	pairesFrequency associationsDo: [ :each| pairesScores at: each key put: each value/ ((self frequencyOfLetter: each key first) * (self frequencyOfLetter: each key second)) asFloat ]
]

{ #category : 'adding' }
WordPieceTrain >> computeVocabulary [ 
	tokens associationsDo: [ :token| token key do:[:each| vocabulary add: each withOccurrences: token value ]. ]
]

{ #category : 'adding' }
WordPieceTrain >> computelettersFrequency [ 
	lettersFrequency := Bag new .
	tokens associationsDo: [ :token| token key do:[:each| lettersFrequency add: each withOccurrences: token value ]. ]
]

{ #category : 'as yet unclassified' }
WordPieceTrain >> frequencyOfLetter: aLetter [
	^ (lettersFrequency occurrencesOf: aLetter )
]

{ #category : 'as yet unclassified' }
WordPieceTrain >> frequencyOfPair: aPair [
	^ (pairesFrequency occurrencesOf: aPair )
]

{ #category : 'initialize' }
WordPieceTrain >> initialize [ 
	super initialize .
	tokens := Bag new .
	vocabulary := Set new.
]

{ #category : 'accessing' }
WordPieceTrain >> lettersFrequency [ 
	^lettersFrequency 
]

{ #category : 'merges' }
WordPieceTrain >> mergesOneStep [ 
	|newVocabularyItem pair|
	pair := (self pairesScores associations detectMax: [:assoc | assoc value]) key.
	newVocabularyItem := pair first, pair second allButFirst .
	self addToVocabulary: newVocabularyItem .
	self updateCorpusFrom: pair to: newVocabularyItem .
	self computelettersFrequency .
	self computePairesFrequency .
	self computePairesScores .
]

{ #category : 'accessing' }
WordPieceTrain >> pairesFrequency [
	^pairesFrequency 
]

{ #category : 'accessing' }
WordPieceTrain >> pairesScores [
	^pairesScores 
]

{ #category : 'compute' }
WordPieceTrain >> prepareWordsFromText: aText [
	|rawWords|
	rawWords :=(aText substrings: {Character space . Character cr . Character tab}).
	tokens addAll: (rawWords collect: [:word|
		|col|
		col:=OrderedCollection new .
		col add: word first asString.
		2 to: word size do: [ :i| col add: '#',(word at: i) asString ] .
		col ] )
]

{ #category : 'accessing' }
WordPieceTrain >> tokens [
	^tokens 
]

{ #category : 'as yet unclassified' }
WordPieceTrain >> updateCorpusFrom: pair to: newVocabularyItem [
	|bag|
	bag:= Bag new.
	tokens keys copy do:[ :word| bag add: (word copyReplaceAll: pair with: {newVocabularyItem} ) withOccurrences: (tokens occurrencesOf: word )].
	tokens := bag .
]

{ #category : 'accessing' }
WordPieceTrain >> vocabulary [ 
	^vocabulary 
]

{ #category : 'accessing' }
WordPieceTrain >> words [ 
	^words 
]
