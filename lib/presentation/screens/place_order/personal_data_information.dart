import 'package:flutter/material.dart';

class PersonalDataInformation extends StatefulWidget {
  const PersonalDataInformation({Key? key}) : super(key: key);

  @override
  State<PersonalDataInformation> createState() =>
      _PersonalDataInformationState();
}

class _PersonalDataInformationState extends State<PersonalDataInformation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Valores por defecto (puedes cargarlos de SharedPreferences o usuario logueado)
    _nameController.text = 'Pepito Perez';
    _addressController.text = 'Edif Toledo Piso 4 #41';
    _phoneController.text = '755 112 14';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Información personal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),

          // Campo Nombre
          _buildTextField(
            label: 'Nombre',
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),

          // Campo Dirección
          _buildTextField(
            label: 'Dirección',
            controller: _addressController,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 12),

          // Campo Celular
          _buildTextField(
            label: 'Celular',
            controller: _phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16, color: Color(0xFF2D3142)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE02C2D), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
