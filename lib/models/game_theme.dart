class GameTheme {
  final String name;
  final String iconPath;
  final List<String> words;
  
  const GameTheme({
    required this.name,
    required this.iconPath,
    required this.words,
  });
}

class GameThemes {
  static const GameTheme countries = GameTheme(
    name: 'Countries',
    iconPath: 'assets/icons/countries.png',
    words: [
      'France', 'Japan', 'Brazil', 'Egypt', 'Australia',
      'India', 'Canada', 'Mexico', 'Russia', 'Italy',
      'South Africa', 'Thailand', 'Argentina', 'Greece', 'Spain',
    ],
  );
  
  static const GameTheme places = GameTheme(
    name: 'Places',
    iconPath: 'assets/icons/places.png',
    words: [
      'Beach', 'Library', 'Hospital', 'Airport', 'Restaurant',
      'School', 'Museum', 'Park', 'Mall', 'Zoo',
      'Movie Theater', 'Office', 'Gym', 'Bank', 'Hotel',
    ],
  );
  
  static const GameTheme sports = GameTheme(
    name: 'Sports',
    iconPath: 'assets/icons/sports.png',
    words: [
      'Football', 'Basketball', 'Tennis', 'Swimming', 'Baseball',
      'Golf', 'Hockey', 'Volleyball', 'Rugby', 'Boxing',
      'Cycling', 'Skiing', 'Cricket', 'Gymnastics', 'Wrestling',
    ],
  );
  
  static const GameTheme objects = GameTheme(
    name: 'Objects',
    iconPath: 'assets/icons/objects.png',
    words: [
      'Chair', 'Phone', 'Computer', 'Book', 'Pen',
      'Glasses', 'Camera', 'Watch', 'Umbrella', 'Keys',
      'Wallet', 'Headphones', 'Backpack', 'Lamp', 'Mug',
    ],
  );
  
  static const GameTheme animals = GameTheme(
    name: 'Animals',
    iconPath: 'assets/icons/animals.png',
    words: [
      'Lion', 'Elephant', 'Penguin', 'Dolphin', 'Eagle',
      'Snake', 'Tiger', 'Wolf', 'Giraffe', 'Kangaroo',
      'Panda', 'Crocodile', 'Bear', 'Monkey', 'Turtle',
    ],
  );
  
  static const GameTheme transportation = GameTheme(
    name: 'Transportation',
    iconPath: 'assets/icons/transportation.png',
    words: [
      'Car', 'Airplane', 'Train', 'Bicycle', 'Boat',
      'Bus', 'Motorcycle', 'Helicopter', 'Subway', 'Truck',
      'Scooter', 'Taxi', 'Ship', 'Tram', 'Rocket',
    ],
  );
  
  static List<GameTheme> getAllThemes() {
    return [
      countries,
      places,
      sports,
      objects,
      animals,
      transportation,
    ];
  }
}