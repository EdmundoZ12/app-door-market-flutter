import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Pantalla Principal de Checkout ---
class CheckoutScreen extends StatefulWidget {
  static const String name = 'checkout_screen';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0; // 0 para tarjeta, 1 para QR

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(label: 'Nombre', initialValue: 'Pepito Perez'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Direccion',
                initialValue: 'Edif Toledo Piso 4 #41',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Celular',
                initialValue: '755 112 14',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              Text(
                'Ubicación',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildMapPlaceholder(),
              const SizedBox(height: 24),
              Text(
                'Forma de pago',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodSelector(),
              const SizedBox(height: 24),
              _buildOrderSummary(),
              const SizedBox(height: 80), // Espacio para el botón flotante
            ],
          ),
        ),
      ),
      bottomSheet: _buildConfirmButton(),
    );
  }

  // --- Widgets Secundarios ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.black, size: 20),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Color(0xFFE53935),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Realizar Pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/maps.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: Icon(Icons.location_pin, color: Color(0xFFE53935), size: 40),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaymentIcon(
          icon: Icons.credit_card,
          isSelected: _selectedPaymentMethod == 0,
          onTap: () => setState(() => _selectedPaymentMethod = 0),
        ),
        const SizedBox(width: 24),
        _buildPaymentIcon(
          icon: Icons.qr_code_2,
          isSelected: _selectedPaymentMethod == 1,
          onTap: () => setState(() => _selectedPaymentMethod = 1),
        ),
      ],
    );
  }

  Widget _buildPaymentIcon({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 40,
          color: isSelected ? Colors.blueAccent : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        _buildSummaryRow('Tus items', '25'),
        const SizedBox(height: 8),
        _buildSummaryRow('Tiempo estimado', '15 Min'),
        const Divider(height: 24),
        _buildSummaryRow('Subtotal', '700.00 Bs', isBold: true),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: isBold ? 18 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {
          // Lógica para confirmar el pedido
          print('Pedido Confirmado!');
          // podrías mostrar un diálogo de éxito y navegar a la pantalla de órdenes.
          // context.go('/orders');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9FA8DA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirmar pedido',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
