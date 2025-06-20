import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/profile/profile_bloc.dart';
import '../../repositories/profile_repository.dart';
import 'terms_of_service_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        repository: ProfileRepository(
          firestore: FirebaseFirestore.instance,
          picker: ImagePicker(),
        ),
        userId: userId,
      )..add(ProfileLoadRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Поварской профиль')),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<ProfileBloc>().add(ProfileLoadRequested());
            }
          },
          builder: (context, state) => _buildContent(state),
        ),
      ),
    );
  }

  Widget _buildContent(ProfileState state) {
    if (state is ProfileReady) {
      return _ProfileView(state: state);
    }

    if (state is ProfileLoading) {
      return _LoadingFallback(
        name: state.cachedName,
        image: state.cachedImage,
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}

class _ProfileView extends StatelessWidget {
  final ProfileReady state;

  const _ProfileView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _UserAvatar(
              image: state.image,
              isUpdating: state.isUpdatingImage,
            ),
            const SizedBox(height: 20),
            _ImageUpdateButton(isUpdating: state.isUpdatingImage),
            const SizedBox(height: 20),
            _UserNameSection(
              name: state.name,
              isUpdating: state.isUpdatingName,
            ),
            _TermsOfServiceSection(context),
          ],
        ),
        if (state.isUpdatingImage) const _ProcessingOverlay(),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final Uint8List? image;
  final bool isUpdating;

  const _UserAvatar({required this.image, required this.isUpdating});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 100,
          backgroundImage: image != null ? MemoryImage(image!) : null,
          child: image == null
              ? const Icon(Icons.restaurant_menu, size: 100)
              : null,
        ),
        if (isUpdating)
          const CircularProgressIndicator(color: Colors.white),
      ],
    );
  }
}

class _ImageUpdateButton extends StatelessWidget {
  final bool isUpdating;

  const _ImageUpdateButton({required this.isUpdating});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isUpdating ? null : () => _pickImage(context),
      child: const Text('Обновить фото повара'),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    try {
      final bytes = await bloc.repository.pickImage();
      if (bytes != null) {
        bloc.add(ProfileImageUpdateRequested(bytes));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выбора изображения: $e')),
      );
    } finally {
      if (context.mounted) {
        bloc.add(ProfileLoadRequested());
      }
    }
  }
}

class _UserNameSection extends StatelessWidget {
  final String name;
  final bool isUpdating;

  const _UserNameSection({required this.name, required this.isUpdating});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'Имя повара',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _EditableNameCard(name: name, isUpdating: isUpdating),
        ],
      ),
    );
  }
}

class _EditableNameCard extends StatelessWidget {
  final String name;
  final bool isUpdating;

  const _EditableNameCard({required this.name, required this.isUpdating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 18)),
        trailing: isUpdating
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showNameEditor(context),
              ),
      ),
    );
  }

  void _showNameEditor(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    final controller = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          title: const Text('Редактировать имя повара'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (dialogContext, state) {
                final isLoading =
                    state is ProfileReady && state.isUpdatingName;
                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () => _saveName(dialogContext, controller.text),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Сохранить'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveName(BuildContext dialogContext, String newName) {
    if (newName.isNotEmpty) {
      dialogContext
          .read<ProfileBloc>()
          .add(ProfileNameUpdateRequested(newName));
    }
    Navigator.pop(dialogContext);
  }
}

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 5),
      ),
    );
  }
}

class _LoadingFallback extends StatelessWidget {
  final String? name;
  final Uint8List? image;

  const _LoadingFallback({this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _UserAvatar(image: image, isUpdating: true),
            const _ImageUpdateButton(isUpdating: true),
            _UserNameSection(
              name: name ?? 'Загрузка...',
              isUpdating: true,
            ),
          ],
        ),
        const _ProcessingOverlay(),
      ],
    );
  }
}

Widget _TermsOfServiceSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsOfServiceScreen(),
            ),
          ),
          child: const Text(
            'Условия публикации рецептов',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
