import 'package:flutter/material.dart';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/provider/environment_provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool isLogginIn = false;

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
    if (isLogginIn) {
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
                  width: 300,
                  initialSelection: environmentProvider.getEnvironment(),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        label: 'Development', value: ApiEnvironment.dev),
                    DropdownMenuEntry(
                        label: 'Staging', value: ApiEnvironment.stag),
                    DropdownMenuEntry(
                        label: 'Production', value: ApiEnvironment.prod),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case ApiEnvironment.prod:
                        environmentProvider.setEnvironment(ApiEnvironment.prod);
                        break;
                      case ApiEnvironment.stag:
                        environmentProvider.setEnvironment(ApiEnvironment.stag);
                        break;
                      case ApiEnvironment.dev:
                        environmentProvider.setEnvironment(ApiEnvironment.dev);
                        break;
                      case null:
                        environmentProvider.setEnvironment(ApiEnvironment.dev);
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
                    login(context);
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
                    login(context);
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
                    login(context);
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

  void login(BuildContext context) async {
    isLogginIn = true;
    setState(() {});
    var loginSuccess = await authState.login(email, password);
    if (!loginSuccess && context.mounted) {
      isLogginIn = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }
}
