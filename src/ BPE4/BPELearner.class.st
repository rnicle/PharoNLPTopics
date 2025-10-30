Class {
	#name : 'BPELearner',
	#superclass : 'Object',
	#instVars : [
		'words',
		'paires',
		'pairesPosition',
		'vocabulary',
		'merges'
	],
	#category : ' BPE4',
	#package : ' BPE4'
}

{ #category : 'adding' }
BPELearner >> addToMergesPair: aCollection mergedInto: aString [
	merges add: aCollection -> aString
]

{ #category : 'adding' }
BPELearner >> addToPaires: anAssociation [
"Ajoute la paire donnée et son nombre d’occurrences au dictionnaire des paires."
	self paires add: anAssociation key withOccurrences: anAssociation value .
]

{ #category : 'adding' }
BPELearner >> addToPairesPosition: anAssociation [
"Ajoute la position associée à une paire dans le dictionnaire des positions."
	self pairesPosition at: anAssociation key update: [:set| set add: anAssociation value; yourself ] initial: (Set with: anAssociation value) 
]

{ #category : 'adding' }
BPELearner >> addToVocabulary: aString [
	vocabulary add: aString 
]

{ #category : 'nodes' }
BPELearner >> collectPairFrom: aNode [
	self addToPaires: (self extractPairAndOccurencesFrom: aNode) .
	self addToPairesPosition: (self extractPairAndPositionFrom: aNode )
]

{ #category : 'adding' }
BPELearner >> computePairs [
"Parcours la liste chaînée des mots pour construire toutes les paires possibles."
	|current|
	current := self words firstLink .
	[current nextLink notNil ] whileTrue: [
		current nextLink value buildPairFrom: current in: self .
		current := current nextLink .
		].

]

{ #category : 'adding' }
BPELearner >> computeVocabulary [ 
	|i|
	i:=words firstLink .
	[ i notNil ] whileTrue: [ 
	[ i value class ~= EndOfWord ] whileTrue: [ 
	vocabulary add: (i value subword ).
	i:= i nextLink 
	 ].
	i:= i nextLink 
	 ]
]

{ #category : 'nodes' }
BPELearner >> extractPairAndOccurencesFrom: aNode [
"Construit et renvoie une association représentant la paire formée par le nœud donné et son suivant, ainsi que l’occurrence de la paire."
	|pairAndOccurence|
	pairAndOccurence := Association key: { aNode value subword . aNode nextLink value subword } value: aNode value occurence .
	^pairAndOccurence 
]

{ #category : 'nodes' }
BPELearner >> extractPairAndPositionFrom: aNode [
"Construit et renvoie une association représentant la paire formée par le nœud donné et son suivant, ainsi que leurs références dans la liste chaînée."
	|pairAndPosition |
	pairAndPosition := Association key: { aNode value subword . aNode nextLink value subword } value: {aNode . aNode nextLink }.
	^pairAndPosition
]

{ #category : 'instance creation' }
BPELearner >> fromText: aText [
	self words: aText .
	self computeVocabulary .
	self computePairs 
]

{ #category : 'nodes' }
BPELearner >> fusion: anArray [
"Concatène les sous-mots du premier et du second nœud référencés dans le vecteur fourni, en mettant à jour le sous-mot du premier nœud, puis supprime le second nœud de la liste chaînée."
	anArray first value subword: (anArray first value subword , anArray second value subword ).
	words removeLink: anArray second .
]

{ #category : 'initalize' }
BPELearner >> initialize [ 
	super initialize. 
	words :=DoubleLinkedList new.
	vocabulary := Set new.
	paires := Bag new .
	pairesPosition := Dictionary new.
	merges:= OrderedCollection new .
]

{ #category : 'accessing' }
BPELearner >> merges [ 
	^merges 
]

{ #category : 'merges' }
BPELearner >> mergesOneStep [ 
	|paire vocabulaire|
	paire :=self paires sortedCounts first value..
	vocabulaire:= paire first , paire second.
	self addToMergesPair: paire mergedInto: vocabulaire .
	self addToVocabulary: vocabulaire .
	self update: paire .
]

{ #category : 'accessing' }
BPELearner >> paires [ 
"Renvoie un dictionnaire dont les clés sont les paires et les valeurs sont leur occurrence."
	^paires 
]

{ #category : 'accessing' }
BPELearner >> pairesPosition [ 
"Renvoie le dictionnaire dont les cles sont les paires et les valeurs sont un ensemble de positions des paires dans la liste chaînée."
	^pairesPosition 
]

{ #category : 'pretokenisation' }
BPELearner >> prepareWordrsFrom: anObject [
	|bag |
	(anObject isArray ) ifTrue: [ bag :=self prepareWordsFromArray:anObject ].
	(anObject isString ) ifTrue: [ bag := self pretokenization: anObject ].
	^bag 
]

{ #category : 'pretokenisation' }
BPELearner >> prepareWordsFromArray:anArray [
	|bag|
	bag := anArray asBag .
	^bag 
]

{ #category : 'pretokenisation' }
BPELearner >> pretokenization:aText [
"Transforme le texte en un bag de tokens en séparant les mots."
	|rawWords bag|
	bag := Bag new.
	rawWords :=(aText substrings: {Character space . Character cr . Character tab}).
	bag addAll: (rawWords collect: [:each|
		|col|
		col:=OrderedCollection new: each size + 1 .
		each do: [:aChar|col add: aChar asString].
		col ] ).
	^bag 
	
]

{ #category : 'update' }
BPELearner >> update: anArray [
"Met à jour toutes les occurrences, les positions d’une paire donnée et ses voisines dans la liste chaînée, effectue la fusion, et ajout de nouvelles paires."
	|position|
	position := self pairesPosition at: anArray .
	position do: [ :each|
		each first value updatePairFromNode: each first previousLink in: self.
		each second nextLink value updatePairFromNode: each second in: self.
		self fusion: each .
		each first value buildPairFrom: each first previousLink in: self.
		each first nextLink value buildPairFrom: each first in: self.
		].
	self paires removeKey: anArray ifAbsent: [  ].
	self pairesPosition removeKey: anArray ifAbsent: [  ].
]

{ #category : 'update' }
BPELearner >> updatePairFrom: aNode [
	self updatePaires: (self extractPairAndOccurencesFrom: aNode ).
	self updatePairesPosition: (self extractPairAndPositionFrom: aNode )
]

{ #category : 'update' }
BPELearner >> updatePaires: anAssociation [
"Met à jour le nombre d’occurrences d’une paire dans le dictionnaire, et la supprime si son occurrence devient zéro."
	self paires add: anAssociation key withOccurrences: anAssociation value negated .
	(paires occurrencesOf: anAssociation key) = 0 ifTrue: [ paires removeKey: anAssociation key ifAbsent: []]
]

{ #category : 'update' }
BPELearner >> updatePairesPosition: anAssociation [
"Supprime les positions associées à une paire et supprime la clé dans la dictionnaire pairesPosition si l'ensemble des positions est vides."
	self pairesPosition at: anAssociation key update: [:set| set remove: anAssociation value ifAbsent:[] ; yourself ].
	(self pairesPosition at: anAssociation key)size =0 ifTrue: [ self pairesPosition removeKey: anAssociation key ]
]

{ #category : 'accessing' }
BPELearner >> vocabulary [
	^vocabulary 
]

{ #category : 'accessing' }
BPELearner >> words [ 
	^words 
]

{ #category : 'adding' }
BPELearner >> words: anObject [
	|text|
	text:=self prepareWordrsFrom: anObject .
	text associationsDo: [ :each|
			each key do:[:char|
			words add: (Subword subword: char asString occurence: each value)].
		words add: (Subword subword: '</t>' occurence: each value).
		words add: EndOfWord new ].
	^words
]
