Class {
	#name : 'BaselineOfWordPiece',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWordPiece',
	#package : 'BaselineOfWordPiece'
}

{ #category : 'baselines' }
BaselineOfWordPiece >> baseline: spec [
    <baseline>
    spec for: #common do: [
			spec
				package: #'WordPiece'.
			spec
				group: 'Core' with: #( 'WordPiece' );
				group: 'default'
				with: #( 'WordPiece' ) ]
]
