import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../validators/username_validator.dart';
import '../widgets/custom_text_field.dart';

/// Profile completion screen for SSO users
class SSOProfileCompletionScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String name;
  final String? photoURL;

  const SSOProfileCompletionScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.name,
    this.photoURL,
  });

  @override
  State<SSOProfileCompletionScreen> createState() =>
      _SSOProfileCompletionScreenState();
}

class _SSOProfileCompletionScreenState
    extends State<SSOProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isOwner = false;
  bool _isWorker = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final username = Username.dirty(_usernameController.text);

    setState(() {
      _isFormValid = username.isValid && (_isOwner || _isWorker);
    });
  }

  void _handleComplete() {
    if (_formKey.currentState!.validate() && (_isOwner || _isWorker)) {
      context.read<AuthBloc>().add(
            AuthSSOProfileCompletionRequested(
              userId: widget.userId,
              email: widget.email,
              name: widget.name,
              username: _usernameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              isOwner: _isOwner,
              isWorker: _isWorker,
              photoURL: widget.photoURL,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile photo
                      if (widget.photoURL != null)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget.photoURL!),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Name (pre-filled, read-only)
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Email (pre-filled, read-only)
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Just a few more details...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                        hint: 'Choose a username',
                        prefixIcon: const Icon(Icons.alternate_email),
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        validator: (value) {
                          final username = Username.dirty(value ?? '');
                          return username.errorMessage;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      CustomTextField(
                        controller: _descriptionController,
                        label: 'Bio (Optional)',
                        hint: 'Tell us about yourself',
                        prefixIcon: const Icon(Icons.info_outlined),
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Role selection
                      const Text(
                        'I am a: (Select at least one)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        title: const Text('Farm Owner'),
                        subtitle: const Text('I own or manage a farm'),
                        value: _isOwner,
                        enabled: !isLoading,
                        onChanged: (value) {
                          setState(() {
                            _isOwner = value ?? false;
                            _validateForm();
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Farm Worker'),
                        subtitle: const Text('I work on a farm'),
                        value: _isWorker,
                        enabled: !isLoading,
                        onChanged: (value) {
                          setState(() {
                            _isWorker = value ?? false;
                            _validateForm();
                          });
                        },
                      ),

                      if (!_isOwner && !_isWorker)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please select at least one role',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Complete button
                      ElevatedButton(
                        onPressed:
                            isLoading || !_isFormValid ? null : _handleComplete,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Completing...',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : const Text(
                                'Complete Profile',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
