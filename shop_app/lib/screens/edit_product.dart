import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/product.dart';
import '/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceForcusNode = FocusNode();
  final _descriptionForcusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlForcusNode = FocusNode();
  final _keyform = GlobalKey<FormState>();
  //GlobalKey: lưu giữ widget khi bị thay đổi trên widget tree
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  final _isinit = true;

  @override
  void dispose() {
    _priceForcusNode.dispose();
    _descriptionForcusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlForcusNode.dispose();
    _imageUrlForcusNode.removeListener(() {
      _updateImageUrl();
    });
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlForcusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct =
          Provider.of<Products>(context, listen: false).findById(productId);
      _initValues = {
        'title': _editedProduct.title,
        'price': _editedProduct.price.toString(),
        'description': _editedProduct.description,
        // 'imageUrl': _editedProduct.imageUrl
        'imageUrl': ''
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlForcusNode.hasFocus) {
      if ((_imageUrlController.text.isEmpty ||
              !_imageUrlController.text.startsWith('http') &&
                  !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveform() {
    final isValid = _keyform.currentState?.validate();
    if (isValid!) {
      return;
    }
    //Saves every [FormField] that is a descendant of this [Form].
    _keyform.currentState!.save();
    if (_editedProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveform,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _keyform,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceForcusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provider a value';
                  }
                  return null;
                },
                onSaved: ((newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: newValue!,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                }),
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(
                  label: Text('Price'),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceForcusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionForcusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  // if (double.parse(value) == null) {
                  //   return 'Please enter a valid number';
                  // }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: ((value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: value!.isNotEmpty ? double.parse(value) : 0.0,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }),
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionForcusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlForcusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: ((newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: newValue!,
                    imageUrl: _editedProduct.imageUrl,
                  );
                }),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text(
                            'Enter a URL',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _imageUrlController.text,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue: _initValues['imageUrl'],
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlForcusNode,
                      onFieldSubmitted: (_) => _saveform(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provider an image URL';
                        }
                        if (value.startsWith('http') &&
                            value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                      onSaved: ((newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: newValue!,
                        );
                      }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
