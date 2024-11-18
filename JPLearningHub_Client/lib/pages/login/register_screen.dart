import 'package:flutter/material.dart';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/provider/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  final void Function(String email, String password) onLogin;

  const RegisterScreen({super.key, required this.onLogin});

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: getContent(),
      ),
    );
  }

  Widget getContent() {
    if (isRegistering) {
      return const CircularProgressIndicator();
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Text(
                  'Environment',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                DropdownMenu(
                  initialSelection: 'development',
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        label: 'Development', value: 'development'),
                    DropdownMenuEntry(label: 'Staging', value: 'staging'),
                    DropdownMenuEntry(label: 'Production', value: 'production'),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'production':
                        apiFacade.setEnvironment(ApiEnvironment.prod);
                        break;
                      case 'staging':
                        apiFacade.setEnvironment(ApiEnvironment.stag);
                        break;
                      case 'development':
                        apiFacade.setEnvironment(ApiEnvironment.dev);
                        break;
                    }
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  onSubmitted: (_) {
                    register(context);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  onSubmitted: (_) {
                    register(context);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide()),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  onSubmitted: (_) {
                    register(context);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide()),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  // press on enter
                  onLongPress: () {
                    widget.onLogin(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    register(context);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text(
                    'Forgot Password?',
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void register(BuildContext context) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    isRegistering = true;
    setState(() {});
    var loginSuccess = await authState.login(email, password);
    if (!loginSuccess && context.mounted) {
      isRegistering = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }
}
