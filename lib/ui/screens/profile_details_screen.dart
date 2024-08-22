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
  late DateTime _dateOfBirth;
  late String _gender;
  late List<String> _interests;
  late String _avatar;
  late List<String> _pictures;

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
        verified: user.verified,
        newUser: user.newUser,
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
        profile: UserProfile(
          bio: _bio,
          dateOfBirth: _dateOfBirth,
          gender: _gender,
          interests: _interests,
          avatar: _avatar,
          picture: _pictures,
          location: user.profile.location,
        ),
        superLikes: user.superLikes,
        boosts: user.boosts,
        topPicks: TopPicks(
          enabled: user.topPicks.enabled,
          lastUpdated: user.topPicks.lastUpdated,
        ),
      );

      BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(user: updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chi tiết'),
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
            _initializeFields(state.user);

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
                    _buildDateField(
                      label: 'Date of Birth',
                      initialValue: _dateOfBirth,
                      onSaved: (value) => _dateOfBirth = value!,
                    ),
                    _buildDropdownField(
                      label: 'Gender',
                      value: _gender,
                      items: ['male', 'female', 'other'],
                      onChanged: (newValue) => setState(() {
                        _gender = newValue!;
                      }),
                      onSaved: (value) => _gender = value!,
                    ),
                    _buildTextField(
                      label: 'Interests',
                      initialValue: _interests.join(', '),
                      onSaved: (value) => _interests = value!.split(', ').toList(),
                    ),
                    _buildImagePicker(
                      label: 'Avatar',
                      imageUrl: _avatar,
                      onImageSelected: (path) {
                        setState(() {
                          _avatar = path;
                        });
                      },
                    ),
                    _buildImagePicker(
                      label: 'Pictures',
                      imageUrl: _pictures.isNotEmpty ? _pictures[0] : '',
                      onImageSelected: (path) {
                        setState(() {
                          _pictures.add(path);
                        });
                      },
                      multiple: true,
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

  void _initializeFields(User user) {
    _name = user.name;
    _email = user.email;
    _bio = user.profile.bio;
    _dateOfBirth = user.profile.dateOfBirth;
    _gender = user.profile.gender;
    _interests = List.from(user.profile.interests);
    _avatar = user.profile.avatar;
    _pictures = List.from(user.profile.picture);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != _dateOfBirth) {
      setState(() {
        _dateOfBirth = selectedDate;
      });
    }
  }

  Widget _buildDateField({
    required String label,
    required DateTime initialValue,
    required void Function(DateTime?) onSaved,
  }) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            hintText: initialValue.toLocal().toString().split(' ')[0],
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          initialValue: initialValue.toLocal().toString().split(' ')[0],
          onSaved: (value) => onSaved(DateTime.parse(value!)),
          keyboardType: TextInputType.none,
        ),
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

  Widget _buildImagePicker({
    required String label,
    required String imageUrl,
    required ValueChanged<String> onImageSelected,
    bool multiple = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            )
          else
            const Text('No image selected'),
          ElevatedButton(
            onPressed: () async {
              String path = 'path/to/selected/image';
              onImageSelected(path);
            },
            child: Text(multiple ? 'Add Pictures' : 'Select Image'),
          ),
        ],
      ),
    );
  }
}
