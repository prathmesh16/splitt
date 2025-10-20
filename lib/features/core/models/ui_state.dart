abstract class UIState<T> {}

class Idle<T> implements UIState<T> {
  const Idle();
}

class Loading<T> implements UIState<T> {
  const Loading();
}

class Success<T> implements UIState<T> {
  final T data;

  const Success(this.data);

  T getData() {
    return data;
  }
}

class Failure<T> implements UIState<T> {
  final Error error;

  const Failure(this.error);
}
