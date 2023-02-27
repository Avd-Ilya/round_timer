class Ticker {
  const Ticker();
  Stream<Duration> tick({required Duration ticks}) {
    return Stream<Duration>.periodic(const Duration(seconds: 1),
        (x) => ticks - Duration(seconds: x) - const Duration(seconds: 1)).take(ticks.inSeconds);
  }
}
