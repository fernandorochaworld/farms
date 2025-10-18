import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_event.dart';
import '../bloc/person_state.dart';
import '../models/person_model.dart';
import '../widgets/person_type_selector.dart';
import '../constants/enums.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../../authentication/models/person_model.dart' as auth;

/// Mode for PersonFormScreen
enum PersonFormMode { create, edit }

/// Screen for creating or editing a person
///
/// Features:
/// - Create new person with name, type, description, admin flag
/// - Edit existing person (all fields except userId)
/// - Form validation
/// - User search and linking
class PersonFormScreen extends StatefulWidget {
  final String farmId;
  final String farmName;
  final Person currentUser;
  final PersonFormMode mode;
  final Person? person;

  const PersonFormScreen({
    super.key,
    required this.farmId,
    required this.farmName,
    required this.currentUser,
    required this.mode,
    this.person,
  });

  static const String routeName = '/farm/person/form';

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailSearchController = TextEditingController();

  late PersonType _selectedType;
  late bool _isAdmin;
  bool _isFormValid = false;
  auth.Person? _selectedUser;
  bool _isSearchingUser = false;

  @override
  void initState() {
    super.initState();

    if (widget.mode == PersonFormMode.edit && widget.person != null) {
      _nameController.text = widget.person!.name;
      _descriptionController.text = widget.person!.description ?? '';
      _selectedType = widget.person!.personType;
      _isAdmin = widget.person!.isAdmin;
    } else {
      _selectedType = PersonType.worker;
      _isAdmin = false;
    }

    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _emailSearchController.addListener(_onEmailSearchChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emailSearchController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();

    setState(() {
      _isFormValid = name.length >= 3 && name.length <= 100;
    });
  }

  void _onEmailSearchChanged() {
    final email = _emailSearchController.text.trim();
    if (email.length >= 3) {
      context.read<PersonBloc>().add(SearchUsers(email: email));
    }
  }

  void _selectUser(auth.Person user) {
    setState(() {
      _selectedUser = user;
      _nameController.text = user.name;
      _isSearchingUser = false;
      _emailSearchController.clear();
    });
  }

  void _clearSelectedUser() {
    setState(() {
      _selectedUser = null;
      _nameController.clear();
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate() || !_isFormValid) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (widget.mode == PersonFormMode.create) {
      // Use selected user's ID or current user's ID
      final userId = _selectedUser?.id ?? widget.currentUser.userId;

      final person = Person(
        id: '',
        farmId: widget.farmId,
        userId: userId,
        name: name,
        description: description.isNotEmpty ? description : null,
        personType: _selectedType,
        isAdmin: _isAdmin,
        createdAt: DateTime.now(),
      );

      context.read<PersonBloc>().add(
            CreatePerson(farmId: widget.farmId, person: person),
          );
    } else {
      final updatedPerson = widget.person!.copyWith(
        name: name,
        description: description.isNotEmpty ? description : null,
        personType: _selectedType,
        isAdmin: _isAdmin,
      );

      context.read<PersonBloc>().add(
            UpdatePerson(farmId: widget.farmId, person: updatedPerson),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCreate = widget.mode == PersonFormMode.create;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCreate ? 'Add Person' : 'Edit Person'),
            Text(
              widget.farmName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          if (state is PersonOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PersonOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PersonOperationInProgress;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User selection section (only for create mode)
                  if (isCreate) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_search,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Link to User (Optional)',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (_selectedUser != null) ...[
                              // Selected user display
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        _selectedUser!.name[0].toUpperCase(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedUser!.name,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            _selectedUser!.email,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: _clearSelectedUser,
                                      tooltip: 'Clear selection',
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // User search
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isSearchingUser = !_isSearchingUser;
                                  });
                                },
                                icon: Icon(_isSearchingUser
                                    ? Icons.close
                                    : Icons.search),
                                label: Text(_isSearchingUser
                                    ? 'Cancel Search'
                                    : 'Search by Email'),
                              ),

                              if (_isSearchingUser) ...[
                                const SizedBox(height: 12),
                                CustomTextField(
                                  controller: _emailSearchController,
                                  label: 'Email Address',
                                  hint: 'Enter email to search',
                                  prefixIcon: const Icon(Icons.email),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),

                                // Search results
                                if (state is UserSearchResults) ...[
                                  if (state.users.isEmpty)
                                    Text(
                                      _emailSearchController.text.trim().length >= 3
                                          ? 'No users found'
                                          : 'Enter at least 3 characters',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    )
                                  else
                                    ...state.users.map((user) => Card(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              child: Text(
                                                user.name[0].toUpperCase(),
                                              ),
                                            ),
                                            title: Text(user.name),
                                            subtitle: Text(user.email),
                                            trailing: const Icon(
                                                Icons.arrow_forward),
                                            onTap: () => _selectUser(user),
                                          ),
                                        )),
                                ],
                              ],
                            ],

                            const SizedBox(height: 12),
                            Text(
                              _selectedUser == null
                                  ? 'Search and link an existing user to this farm, or leave empty to add yourself to the farm'
                                  : 'This farm access will be granted to the selected user',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Note: A person represents farm access. You don\'t need to create users - just link existing ones.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    label: 'Person Name',
                    hint: 'Enter person name',
                    prefixIcon: const Icon(Icons.person),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      if (value.length > 100) {
                        return 'Name must not exceed 100 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description (optional)',
                    hint: 'Enter description or notes',
                    prefixIcon: const Icon(Icons.notes),
                    maxLines: 3,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Person type selector
                  PersonTypeSelector(
                    selectedType: _selectedType,
                    onChanged: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Admin toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text('Admin Privileges'),
                      subtitle: const Text(
                        'Grant admin access to manage farm settings',
                      ),
                      value: _isAdmin,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _isAdmin = value;
                              });
                            },
                      secondary: const Icon(Icons.shield),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  FilledButton(
                    onPressed: isLoading || !_isFormValid ? null : _handleSubmit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(isCreate ? 'Add Person' : 'Update Person'),
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  OutlinedButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
