part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int water;
  const HomeState({required this.water});

  @override
  List<Object> get props => [water];
}
