import 'package:flutter/material.dart';

class PaymentMethodInformation extends StatefulWidget {
  const PaymentMethodInformation({Key? key}) : super(key: key);

  @override
  State<PaymentMethodInformation> createState() => _PaymentMethodInformationState();
}

class _PaymentMethodInformationState extends State<PaymentMethodInformation> {
  int _selectedMethod = 0; // 0: Card, 1: QR

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cupón de descuento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cupón de descuento', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ABC123',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Método de pago
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text('Método de pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMethodIcon(0, Icons.credit_card, 'Tarjeta'),
            const SizedBox(width: 16),
            _buildMethodIcon(1, Icons.qr_code, 'QR'),
          ],
        ),
        const SizedBox(height: 16),
        if (_selectedMethod == 0) _buildCardForm(),
        if (_selectedMethod == 1) _buildQRSection(),
      ],
    );
  }

  Widget _buildMethodIcon(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _selectedMethod == index ? Colors.black : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: _selectedMethod == index ? Colors.grey.shade200 : Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Numero de Tarjeta', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: '1234 1234 1234 1234',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.credit_card),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Image.asset('assets/images/icons/visa.png', width: 32),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Image.asset('assets/images/icons/mastercard.png', width: 32),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fecha de Expiracion', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'MM / YY',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CVC', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'CVC',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pais', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'CVC',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Codigo Postal', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'CVC',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 160,
              height: 160,
              color: Colors.white,
              child: Image.asset('assets/images/icons/qr_placeholder.png'), // Reemplaza con tu QR
            ),
          ),
        ],
      ),
    );
  }
}
