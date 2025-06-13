part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

// Начальное состояние загрузки профиля (например, еще не загружены данные пользователя)
final class ProfileInitial extends ProfileState {}

// Состояние загрузки профиля — может содержать закэшированное имя и аватар пользователя
final class ProfileLoading extends ProfileState {
  final String? cachedName;
  final Uint8List? cachedImage;

  const ProfileLoading({this.cachedName, this.cachedImage});

  @override
  List<Object?> get props => [cachedName, cachedImage];
}

// Основное состояние с данными профиля пользователя
final class ProfileReady extends ProfileState {
  final String name;
  final Uint8List? image; // фото пользователя (аватар)
  final bool isUpdatingImage; // индикатор обновления фото
  final bool isUpdatingName; // индикатор обновления имени

  const ProfileReady({
    required this.name,
    this.image,
    this.isUpdatingImage = false,
    this.isUpdatingName = false,
  });

  ProfileReady copyWith({
    String? name,
    Uint8List? image,
    bool? isUpdatingImage,
    bool? isUpdatingName,
  }) {
    return ProfileReady(
      name: name ?? this.name,
      image: image ?? this.image,
      isUpdatingImage: isUpdatingImage ?? this.isUpdatingImage,
      isUpdatingName: isUpdatingName ?? this.isUpdatingName,
    );
  }

  @override
  List<Object?> get props => [name, image, isUpdatingImage, isUpdatingName];
}

// Ошибка загрузки или обновления профиля — с сохранением предыдущего состояния
final class ProfileError extends ProfileState {
  final String message;
  final ProfileState previousState;

  const ProfileError(this.message, this.previousState);

  @override
  List<Object?> get props => [message, previousState];
}
