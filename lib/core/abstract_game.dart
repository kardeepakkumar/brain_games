abstract class Game {

  Game();
  bool isGameEnded() {
    return (isGameWon() || isGameOver());
  }
  bool isGameWon();
  bool isGameOver();
}