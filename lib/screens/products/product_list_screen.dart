import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/product.dart';
import '../../services/product_service.dart';
import 'product_crud_screen.dart';
import '../../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _products;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _products = ProductService().getProducts();
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await ProductService().deleteProduct(productId);
      final updatedProducts = await ProductService().getProducts();
      setState(() {
        _products = Future.value(updatedProducts);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      print('Detailed error deleting product: $e');
      if (e is http.Response) {
        print('Status code: ${e.statusCode}');
        print('Response body: ${e.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

  Future<void> _confirmDelete(int productId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await _deleteProduct(productId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductCrudScreen()),
              ).then((_) {
                setState(() {
                  _products = ProductService().getProducts();
                });
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load products'));
              } else {
                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductCrudScreen(product: product),
                          ),
                        ).then((_) {
                          setState(() {
                            _products = ProductService().getProducts();
                          });
                        });
                      },
                      onDelete: () => _confirmDelete(product.id),
                      isLoading: _isLoading,
                    );
                  },
                );
              }
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
