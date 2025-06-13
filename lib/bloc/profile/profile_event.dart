part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Событие запроса загрузки профиля пользователя
final class ProfileLoadRequested extends ProfileEvent {}

// Событие обновления фотографии профиля (например, аватарка пользователя)
final class ProfileImageUpdateRequested extends ProfileEvent {
  final Uint8List imageData;

  const ProfileImageUpdateRequested(this.imageData);

  @override
  List<Object?> get props => [imageData];
}

// Событие обновления имени пользователя в профиле
final class ProfileNameUpdateRequested extends ProfileEvent {
  final String newName;

  const ProfileNameUpdateRequested(this.newName);

  @override
  List<Object?> get props => [newName];
}
