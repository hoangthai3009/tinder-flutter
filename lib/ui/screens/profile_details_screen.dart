import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/user/user_bloc.dart';
import 'package:tinder/data/models/user/profile.dart';
import 'package:tinder/data/models/user/top_picks.dart';
import 'package:tinder/data/models/user/user.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _bio;
  late int _age;
  late String _gender;
  late List<String> _interests;
  late String _avatar;
  late List<String> _pictures;
  late bool _topPicksEnabled;
  late bool _verified;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadUserEvent());
  }

  void _updateProfile(User user) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedUser = User(
        id: user.id,
        name: _name,
        email: _email,
        verified: _verified,
        newUser: user.newUser,
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
        profile: UserProfile(
          bio: _bio,
          age: _age,
          gender: _gender,
          interests: _interests,
          avatar: _avatar,
          picture: _pictures,
          location: user.profile.location,
        ),
        superLikes: user.superLikes,
        boosts: user.boosts,
        topPicks: TopPicks(
          enabled: _topPicksEnabled,
          lastUpdated: DateTime.now(),
        ),
      );
      BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(user: updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final state = BlocProvider.of<UserBloc>(context).state;
              if (state is UserLoaded) {
                _updateProfile(state.user);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final user = state.user;
            _name = user.name;
            _email = user.email;
            _bio = user.profile.bio;
            _age = user.profile.age;
            _gender = user.profile.gender;
            _interests = List.from(user.profile.interests);
            _avatar = user.profile.avatar;
            _pictures = List.from(user.profile.picture);
            _topPicksEnabled = user.topPicks.enabled;
            _verified = user.verified;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      label: 'Name',
                      initialValue: _name,
                      onSaved: (value) => _name = value!,
                    ),
                    _buildTextField(
                      label: 'Email',
                      initialValue: _email,
                      onSaved: (value) => _email = value!,
                      enabled: false,
                    ),
                    _buildTextField(
                      label: 'Bio',
                      initialValue: _bio,
                      onSaved: (value) => _bio = value!,
                    ),
                    _buildTextField(
                      label: 'Age',
                      initialValue: _age.toString(),
                      onSaved: (value) => _age = int.parse(value!),
                      keyboardType: TextInputType.number,
                    ),
                    _buildDropdownField(
                      label: 'Gender',
                      value: _gender,
                      items: ['male', 'female', 'other'],
                      onChanged: (newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                      onSaved: (value) => _gender = value!,
                    ),
                    _buildTextField(
                      label: 'Interests',
                      initialValue: _interests.join(', '),
                      onSaved: (value) => _interests = value!.split(', ').toList(),
                    ),
                    _buildTextField(
                      label: 'Avatar URL',
                      initialValue: _avatar,
                      onSaved: (value) => _avatar = value!,
                    ),
                    _buildTextField(
                      label: 'Pictures URLs',
                      initialValue: _pictures.join(', '),
                      onSaved: (value) => _pictures = value!.split(', ').toList(),
                    ),
                    _buildSwitchTextField(
                      title: 'Top Picks Enabled',
                      value: _topPicksEnabled,
                      onChanged: (value) {
                        setState(() {
                          _topPicksEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTextField(
                      title: 'Verified',
                      value: _verified,
                      onChanged: (value) {
                        setState(() {
                          _verified = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text('Failed to load user: ${state.error}'));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: onSaved,
        keyboardType: keyboardType,
        enabled: enabled,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChanged,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildSwitchTextField({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
