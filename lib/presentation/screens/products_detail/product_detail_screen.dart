import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import for SchedulerBinding
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../data/model/product.dart';
import '../../components/product_card.dart';
import '../../../service/cart_service.dart';

// --- Pantalla Principal ---
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();
  // Lista de sugerencias por defecto si el producto no tiene las suyas.
  List<Product>? _defaultSuggestions;
  int _quantity = 1;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurar que el contexto esté listo
    // y que la UI inicial ya se haya construido antes de cargar las sugerencias.
    // Si el producto no trae sugerencias, cargamos un conjunto por defecto.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Siempre cargamos las sugerencias por defecto para asegurar que se muestren.
      _loadDefaultSuggestions();
    });
  }

  Future<void> _loadDefaultSuggestions() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/product_details.json',
      );
      final data = json.decode(response) as Map<String, dynamic>;
      if (data['suggestions'] != null) {
        setState(() {
          _defaultSuggestions = (data['suggestions'] as List)
              .map((i) => Product.fromJson(i as Map<String, dynamic>))
              .toList();
          // Asegurarse de que el producto actual no esté en las sugerencias por defecto
          _defaultSuggestions?.removeWhere((s) => s.id == widget.product.id);
        });
      }
    } catch (e) {
      print('Error loading default suggestions: $e');
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumbs(),
            _buildImageCarousel(widget.product.images),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildProductContent(widget.product),
            ),
          ],
        ),
      ),
      // Aquí puedes añadir tu `MenuFooter` si lo necesitas en esta pantalla.
      // bottomNavigationBar: MenuFooter(navigationShell: ...),
    );
  }

  // --- Widgets Secundarios ---
  // Nuevo widget para organizar el contenido del producto
  Widget _buildProductContent(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductInfo(product),
        _buildDescription(product.description),
        const SizedBox(height: 20),
        _buildControls(),
        const SizedBox(height: 24),
        // Mostrar sugerencias si se cargaron sugerencias por defecto.
        if (_defaultSuggestions != null && _defaultSuggestions!.isNotEmpty)
          _buildSuggestions(_defaultSuggestions!),
        const SizedBox(height: 20),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFE53935)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: Icon(Icons.search, color: Color(0xFFE53935)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Color(0xFFE53935)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFE53935)),
          onPressed: () => context.push('/cart'),
        ),
      ],
    );
  }

  Widget _buildBreadcrumbs() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        'Bebidas/Gaseosas',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return Column(
      children: [
        Container(
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 2.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildProductInfo(Product product) {
    final priceLabel = product.price % 1 == 0
        ? '${product.price.toInt()} BS'
        : '${product.price.toStringAsFixed(2)} BS';

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            priceLabel,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          description,
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selector de cantidad
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementQuantity,
                splashRadius: 20,
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementQuantity,
                splashRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Botón de añadir al carrito
        ElevatedButton.icon(
          onPressed: () {
            _cartService.addProduct(widget.product, _quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$_quantity ${widget.product.name} añadido(s) al carrito',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Añadir'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(List<Product> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sugerencias',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200, // Altura fija para el carrusel
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: suggestions[index],
                onTap: () {
                  // Navegamos a la pantalla de detalles del producto sugerido.
                  // Usamos context.replace() para reemplazar la pantalla actual
                  // con la nueva pantalla de detalles del producto sugerido.
                  // Esto evita que la pila de navegación crezca indefinidamente.
                  // La ruta 'product-detail' es una ruta hija de la rama actual.
                  // GoRouter encontrará la ruta correcta automáticamente.
                  // Si la ruta actual es '/', la ruta completa sería '/product-detail'.
                  // Si la ruta actual es '/categories', la ruta completa sería '/categories/product-detail'.
                  // GoRouter es inteligente para resolver rutas relativas dentro de la rama.
                  // Para asegurar que la pantalla se reconstruya, usamos replace.
                  context.replace('product-detail', extra: suggestions[index]);
                },
                onAddToCart: () {
                  // Lógica para añadir el producto sugerido al carrito
                  print(
                    'Add to cart from suggestion: ${suggestions[index].name}',
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}
