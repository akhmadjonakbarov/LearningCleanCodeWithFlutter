import 'package:flutter/material.dart';
import 'package:learning_clean_code/features/product/data/repositories/fake_product_repository.dart';
import 'package:learning_clean_code/features/product/domain/entities/product_entity.dart';
import 'package:learning_clean_code/features/product/presentation/controllers/product_controller.dart';

// Single-file, ready-to-run Flutter example.
// Paste this into `lib/main.dart` of a new Flutter project and run.
// No external packages required.

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with SingleTickerProviderStateMixin {
  final ProductController productController = ProductController(
    productRepository: FakeProductRepository(),
  );

  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  bool _showFavoriteOnly = false;
  final Set<String> _favorites = {};

  // simple animation controller for entrance
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    productController.getProducts().then((value) {
      setState(() {});
    });
    _searchCtrl.addListener(() {
      setState(() => _search = _searchCtrl.text);
    });
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  int crossAxisCountForWidth(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(ctx).viewInsets,
          child: _FilterSheet(showFavoriteOnly: _showFavoriteOnly),
        );
      },
    );

    if (result != null && result.containsKey('favorites')) {
      setState(() => _showFavoriteOnly = result['favorites'] as bool);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amazing Products'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Filters',
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutQuad,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search products, categories...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => _favorites.clear()),
                  child: Tooltip(
                    message: 'Clear favorites',
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = crossAxisCountForWidth(constraints.maxWidth);
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildChipsRow(),
                const SizedBox(height: 12),
                if (productController.isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: productController.products.isEmpty
                        ? _EmptyState(search: _search)
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                            itemCount: productController.products.length,
                            itemBuilder: (ctx, idx) {
                              final p = productController.products[idx];
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: _entranceController,
                                  curve: Interval(
                                    0.0,
                                    1.0,
                                    curve: Curves.easeIn,
                                  ),
                                ),
                                child: ProductCard(
                                  product: p,
                                  isFavorite: _favorites.contains(p.id),
                                  onFavoriteToggle: () {},
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailPage(
                                          product: p,
                                          isFavorite: _favorites.contains(p.id),
                                          onFavToggle: () {},
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChipsRow() {
    final chips = ['All', 'Popular', 'New', 'Recommended', 'Budget'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          if (i == chips.length) {
            return FilterChip(
              selected: _showFavoriteOnly,
              label: const Text('Favorites'),
              onSelected: (v) => setState(() => _showFavoriteOnly = v),
              avatar: const Icon(Icons.favorite_outline),
            );
          }
          return ActionChip(
            label: Text(chips[i]),
            onPressed: () {
              // lightweight simulated filter
              setState(() {
                _searchCtrl.text = chips[i] == 'All' ? '' : chips[i];
              });
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Hero(
                tag: 'hero-\${product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder:
                            'assets/placeholder.png', // optional: add asset or fallback
                        image: product.imgUrl,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (c, e, s) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: InkWell(
                          onTap: () {
                            // favorite button handled by parent
                            onFavoriteToggle();
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white70,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black87,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 4),
                              // Text(product..toStringAsFixed(1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback onFavToggle;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: onFavToggle,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'hero-\${product.id}',
              child: AspectRatio(
                aspectRatio: 1.2,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: product.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 6),
                      // Text(product.rating.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      Text(
                        'Free returns • 30-day warranty',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About this product',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Buy Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final bool showFavoriteOnly;
  const _FilterSheet({required this.showFavoriteOnly});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late bool _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = widget.showFavoriteOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pop({'favorites': _favorites}),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _favorites,
            onChanged: (v) => setState(() => _favorites = v),
            title: const Text('Show favorites only'),
            subtitle: const Text('Quickly see items you tapped the heart on.'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String search;
  const _EmptyState({required this.search});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72),
            const SizedBox(height: 12),
            Text(
              search.isEmpty
                  ? 'No products found'
                  : 'No results for "\$search"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Try adjusting filters or search terms.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
