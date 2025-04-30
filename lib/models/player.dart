class Player {
  final String name;
  bool isSpy;
  String? secretWord;
  bool hasVoted;
  int votesReceived;
  bool hasAskedQuestion;
  
  Player({
    required this.name,
    this.isSpy = false,
    this.secretWord,
    this.hasVoted = false,
    this.votesReceived = 0,
    this.hasAskedQuestion = false,
  });
  
  void resetForNewRound() {
    hasVoted = false;
    votesReceived = 0;
    hasAskedQuestion = false;
  }
  
  Player copyWith({
    String? name,
    bool? isSpy,
    String? secretWord,
    bool? hasVoted,
    int? votesReceived,
    bool? hasAskedQuestion,
  }) {
    return Player(
      name: name ?? this.name,
      isSpy: isSpy ?? this.isSpy,
      secretWord: secretWord ?? this.secretWord,
      hasVoted: hasVoted ?? this.hasVoted,
      votesReceived: votesReceived ?? this.votesReceived,
      hasAskedQuestion: hasAskedQuestion ?? this.hasAskedQuestion,
    );
  }
}