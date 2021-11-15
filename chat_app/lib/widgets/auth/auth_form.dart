import 'package:image_picker/image_picker.dart';
import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(
    this.submitFn,
    this.isLoading, {
    Key? key,
  }) : super(
          key: key,
        );
  final bool isLoading;
  final void Function(
    String email,
    String userName,
    String password,
    XFile? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isFocused = false;
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  FocusNode focusNode = FocusNode();
  XFile? _userImageFile;

  @override
  void initState() {
    focusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _pickedImage(XFile image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (_userImageFile == null && !_isLogin) {
    //   _userImageFile = XFile(
    //       const AssetImage('assets/images/user-profile-default-image.png')
    //           .toString());
    // }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = !_isFocused);
  }

  void _toggleShowPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserIamgePicker(_pickedImage),
                  const SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        focusNode: focusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Center(
                            child: Text('Email Address'),
                          ),
                          // labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: const Text(
                            'Email Address',
                            style: TextStyle(fontSize: 16),
                            strutStyle: StrutStyle(
                              forceStrutHeight: true,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      textCapitalization: TextCapitalization.words,
                      autocorrect: true,
                      onSaved: (value) {
                        _userName = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        label: const Center(
                          child: Text('User Name'),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 45.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      label: Container(
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.only(left: 45.0),
                        child: const Text(
                          'Password',
                        ),
                      ),
                      //labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => _toggleShowPassword(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                    // obscuringCharacter: '*',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: () => _submit(),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () => setState(() {
                        _isLogin = !_isLogin;
                      }),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
