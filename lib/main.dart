import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String name;
  double price;
  int stock;

  Product({required this.name, required this.price, required this.stock});
}

class ShoppingCart {
  List<Product> items = [];
}

class MyApp extends StatelessWidget {
  final ShoppingCart cart = ShoppingCart();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Carrinho de Compras'),
        ),
        body: SingleChildScrollView(
          child: ShoppingScreen(cart: cart),
        ),
      ),
    );
  }
}

class ShoppingScreen extends StatefulWidget {
  final ShoppingCart cart;

  ShoppingScreen({required this.cart});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Produtos Disponíveis:'),
          SizedBox(height: 8),
          _buildProductList(),
          SizedBox(height: 16),
          Text('Carrinho de Compras:'),
          SizedBox(height: 8),
          _buildCart(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showPaymentOptions();
            },
            child: Text('Finalizar Compra'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    List<Product> products = [
      Product(name: 'Arroz Kg', price: 10.74, stock: 20),
      Product(name: 'Feijão Kg', price: 8.99, stock: 20),
      Product(name: 'Guaraná 2L', price: 7.99, stock: 20),
      Product(name: 'Macarrão Kg', price: 4.99, stock: 20),
      Product(name: 'Frango Kg', price: 14.99, stock: 20),
      Product(name: 'Carne Kg', price: 19.99, stock: 20),
      Product(name: 'Cebola Kg', price: 7.49, stock: 20),
      Product(name: 'Presunto Kg', price: 39.59, stock: 20),
      Product(name: 'Queijo Kg', price: 49.90, stock: 20),
    ];

    return Column(
      children: products.map((product) {
        return ListTile(
          title: Text('${product.name} - R\$${product.price.toString()}'),
          subtitle: Text('Estoque: ${product.stock} unidades'),
          trailing: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.cart.items.add(product);
              });
            },
            child: Text('Adicionar'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCart() {
    return Column(
      children: widget.cart.items.map((product) {
        return ListTile(
          title: Text('${product.name} - R\$${product.price.toString()}'),
          subtitle: Text('Quantidade: 1'),
        );
      }).toList(),
    );
  }

  void _showPaymentOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolher Método de Pagamento'),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _completePurchase('Cartão de Débito');
                },
                child: Text('Cartão de Débito'),
              ),
              ElevatedButton(
                onPressed: () {
                  _completePurchase('Cartão de Crédito');
                },
                child: Text('Cartão de Crédito'),
              ),
              ElevatedButton(
                onPressed: () {
                  _completePurchase('PIX');
                },
                child: Text('PIX'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _completePurchase(String paymentMethod) {
    double total =
        widget.cart.items.fold(0, (sum, product) => sum + product.price);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Compra Concluída'),
          content:
              Text('Total: R\$${total.toString()}\nPagamento: $paymentMethod'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.cart.items.clear();
                });
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
