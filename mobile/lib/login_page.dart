import 'package:flutter/material.dart';
import 'package:flutter_application_1/CriarConta.dart';
import 'package:flutter_application_1/Menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGreen = const Color(0xFF2E8B57);
    final beige = const Color(0xFFF3EDE7);
    const titleText = 'Clinimolelos';
    const titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
    final textPainter = TextPainter(
      text: const TextSpan(text: titleText, style: titleStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final logoWidth = textPainter.width;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: logoWidth,
                        child: Image.asset(
                          'assets/CliniMolelos.png',
                          width: logoWidth,
                          fit: BoxFit.contain,


                          //quando a imagem não é carregada chama
                          errorBuilder: (context, error, stackTrace) =>
                              SizedBox(
                                width: logoWidth,
                                height: logoWidth * 0.4,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                              ),


                        ),
                      ),
                    ),
                    Text(titleText, style: titleStyle),
                    const Text(
                      'Aceda à sua conta',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity, //ocupa a maior largura (ou altura) possível
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Iniciar sessão',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        //Email
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nome de utilizador',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      //password
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Palavra-passe',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Menu(),
                              ),
                            );
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: beige,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recuperar Palavra-passe'),
                              ),
                            );
                          },
                          child: const Text('Recuperar Palavra-passe'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccount(),
                      ),
                    );
                  },
                  child: const Text(
                    'Ainda não tens conta? Criar Conta',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
