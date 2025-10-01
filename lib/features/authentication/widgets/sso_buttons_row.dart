import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

/// Widget that displays Google and Facebook sign-in buttons
class SSOButtonsRow extends StatelessWidget {
  const SSOButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google Sign-In Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
            },
            icon: const Icon(Icons.g_mobiledata, size: 30),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Facebook Sign-In Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthFacebookSignInRequested());
            },
            icon: const Icon(Icons.facebook, size: 24),
            label: const Text('Facebook'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
