import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/authentication_bloc.dart';
import 'package:tinder/bloc/user/user_bloc.dart';
import 'package:tinder/shared/component.dart';
import 'package:tinder/ui/screens/profile_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => UserBloc()..add(LoadUserEvent()),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserTokenExpired) {
              showSessionExpiredDialog(context);
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return buildLoading();
              } else if (state is UserLoaded) {
                return _buildProfile(context, state);
              } else if (state is UserError) {
                return buildError(state.error);
              } else {
                return buildDefaultError();
              }
            },
          ),
        ),
      ),
    );
  }

  ListView _buildProfile(BuildContext context, UserLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProfileInfo(context, state),
        const SizedBox(height: 20),
        _buildPicturesSection(context, state),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<AuthenticationBloc>().add(LogoutEvent());
            Navigator.pushReplacementNamed(context, '/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  Container _buildProfileInfo(BuildContext context, UserLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _boxDecoration(),
      child: Stack(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(state.user.profile.avatar),
              ),
              const SizedBox(height: 16),
              Text(
                state.user.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProfileStat(title: 'Attention', value: '130'),
                  _ProfileStat(title: 'Followers', value: '10M'),
                  _ProfileStat(title: 'Following', value: '26'),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileDetailsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPicturesSection(BuildContext context, UserLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(
            'Pictures (${state.user.profile.picture.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: state.user.profile.picture.take(3).map((url) {
              int idx = state.user.profile.picture.indexOf(url);
              return idx == 2 && state.user.profile.picture.length > 3 ? _buildExtraPictures(context, state) : _GalleryImage(url: url);
            }).toList(),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0),
      ],
    );
  }

  Stack _buildExtraPictures(BuildContext context, UserLoaded state) {
    return Stack(
      children: [
        _GalleryImage(url: state.user.profile.picture[2]),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Colors.black54,
              child: Center(
                child: TextButton(
                  onPressed: () => _showGalleryDialog(context, state),
                  child: Text(
                    '+${state.user.profile.picture.length - 3}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGalleryDialog(BuildContext context, UserLoaded state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10.0,
              runSpacing: 10.0,
              children: state.user.profile.picture.map((url) => _GalleryImage(url: url)).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  final String url;

  const _GalleryImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
