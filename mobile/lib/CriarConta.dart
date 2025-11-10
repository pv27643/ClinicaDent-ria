import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _nomeCompleto = TextEditingController();
  final _telefone = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    /*"dispose" desliga o controlo e limpa memória, ao sair de uma página, 
    sem o "dispose" continua ocupando memória desnecessária, o dispose evita isso*/
  _nomeCompleto.dispose();
  _telefone.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final bg = const Color(0xFFFAF7F4);
  final cardBg = Colors.white;
  final primaryGreen = const Color(0xFF2E8B57);
    const titleText = 'Criar Conta';
    const titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

    final textPainter = TextPainter(
      text: const TextSpan(text: titleText, style: titleStyle),
      textDirection: TextDirection.ltr,
    )..layout();

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
                      //espaço entre conteúdo e bordas do container
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
                        width: textPainter.width,
                        child: Image.asset('assets/CliniMolelos.png'),
                      ),
                    ),

                    //titulos
                    const SizedBox(height: 8),
                    const Text(
                      'Clinimolelos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Registo de novo paciente',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Cards
                Container(
                  width: double.infinity, //ocupa toda a largura disponivel do pai (Column)
                  padding: const EdgeInsets.all(18), //espaçamento interior

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
                    /*Cross axis para um Column é o eixo horizontal. 
                    stretch força cada filho a ocupar a largura máxima*/

                    children: [
                      const Text(
                        'Dados da conta',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      //INPUTS
                      _buildInput(
                        controller: _nomeCompleto,
                        hint: 'Nome completo',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 10),

                      _buildInput(
                        controller: _telefone,
                        hint: 'Telefone',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                      ),
                      const SizedBox(height: 10),

                      _buildInput(
                        controller: _emailController,
                        hint: 'E-mail',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),

                      _buildPasswordInput(
                        controller: _passwordController,
                        hint: 'Palavra-passe',
                        obscure: _obscurePassword,    //esconde a senha    //mostra a senha
                        onToggle: () => setState(() => _obscurePassword = !_obscurePassword), 
                        //obscure password é para ocultar a senha
                      ),
                      const SizedBox(height: 10),

                      _buildPasswordInput(
                        controller: _confirmPasswordController,
                        hint: 'Confirmar Palavra-passe',
                        obscure: _obscureConfirm,    //esconde a senha    //mostra a senha
                        onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      const SizedBox(height: 12),

                      //checkbox dos termos
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                          ),
                          const Expanded(
                            child: Text('Concordo com os Termos e a Política de Privacidade.'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Botão de Criar Conta
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),


                          // Validação e mostrar notificação
                          onPressed: () {
                            if (!_acceptedTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Aceite os Termos para continuar.')),
                              );
                              return;
                            }
                            // Validação do telefone: apenas dígitos permitidos e exatamente 9 caracteres
                            final phone = _telefone.text.trim(); 
                            if (phone.isEmpty || phone.length != 9) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Introduza um número de telefone com 9 dígitos.')),
                              );
                              return;
                            }
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('As palavras-passe não coincidem.')),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Conta criada (simulada)')),
                            );
                          },

                          child: const Text('Criar Conta', style: TextStyle(color: Colors.white),),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Já tem conta? '),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            ),
                            child: Text('Voltar para Entrar', style: TextStyle(color: primaryGreen)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters, //RESTRIÇÃO PARA APENAS NUM
  }) {
    final bg = const Color(0xFFFAF7F4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }

  Widget _buildPasswordInput({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final bg = const Color(0xFFFAF7F4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
