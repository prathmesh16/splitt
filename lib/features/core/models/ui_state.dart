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
}

class Error<T> implements UIState<T> {
  final Exception exception;

  const Error(this.exception);
}
