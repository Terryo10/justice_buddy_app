import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/document_bloc/document_bloc.dart';
import '../../models/document_model.dart';

@RoutePage()
class GetDocumentsPage extends StatefulWidget {
  const GetDocumentsPage({super.key});

  @override
  State<GetDocumentsPage> createState() => _GetDocumentsPageState();
}

class _GetDocumentsPageState extends State<GetDocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedFileType;
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Load documents when page loads
    context.read<DocumentBloc>().add(const LoadDocuments());
    // Load categories for filter
    context.read<DocumentBloc>().add(const LoadDocumentCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Documents'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DocumentBloc>().add(const LoadDocuments());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search documents...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: _performSearch,
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: BlocBuilder<DocumentBloc, DocumentState>(
                        buildWhen:
                            (previous, current) =>
                                current is DocumentCategoriesLoaded,
                        builder: (context, state) {
                          List<String> categories = [];
                          if (state is DocumentCategoriesLoaded) {
                            categories = state.categories;
                          }
                          return DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ...categories.map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(_formatCategoryName(category)),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                              _applyFilters();
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // File Type Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFileType,
                        decoration: const InputDecoration(
                          labelText: 'File Type',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Types'),
                          ),
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(
                            value: 'doc',
                            child: Text('Word Doc'),
                          ),
                          DropdownMenuItem(
                            value: 'docx',
                            child: Text('Word DocX'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFileType = value;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sort and Action Row
                Row(
                  children: [
                    // Sort Options
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Sort by: '),
                          DropdownButton<String>(
                            value: _sortBy,
                            items: const [
                              DropdownMenuItem(
                                value: 'name',
                                child: Text('Name'),
                              ),
                              DropdownMenuItem(
                                value: 'downloads',
                                child: Text('Downloads'),
                              ),
                              DropdownMenuItem(
                                value: 'created_at',
                                child: Text('Date'),
                              ),
                              DropdownMenuItem(
                                value: 'size',
                                child: Text('Size'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _sortBy = value;
                                });
                                _applySort();
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _sortAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                            ),
                            onPressed: () {
                              setState(() {
                                _sortAscending = !_sortAscending;
                              });
                              _applySort();
                            },
                          ),
                        ],
                      ),
                    ),
                    // Quick Actions
                    TextButton.icon(
                      onPressed: () {
                        context.read<DocumentBloc>().add(
                          const LoadFeaturedDocuments(),
                        );
                      },
                      icon: const Icon(Icons.star),
                      label: const Text('Featured'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<DocumentBloc>().add(
                          const LoadPopularDocuments(),
                        );
                      },
                      icon: const Icon(Icons.trending_up),
                      label: const Text('Popular'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Documents List
          Expanded(
            child: BlocConsumer<DocumentBloc, DocumentState>(
              listener: (context, state) {
                if (state is DocumentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is DocumentDownloaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Document downloaded to: ${state.filePath}',
                      ),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'Open',
                        onPressed: () => _openFile(state.filePath),
                      ),
                    ),
                  );
                } else if (state is DocumentDownloading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading document...'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is DocumentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DocumentsLoaded) {
                  return _buildDocumentsList(state.documents);
                } else if (state is DocumentError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DocumentBloc>().add(
                              const LoadDocuments(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('No documents available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(List<DocumentModel> documents) {
    if (documents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No documents found'),
            SizedBox(height: 8),
            Text('Try adjusting your filters or search terms'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(DocumentModel document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Header
            Row(
              children: [
                // File Type Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getFileTypeColor(document.fileExtension),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileTypeIcon(document.fileExtension),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Document Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (document.hasCategory) ...[
                            Chip(
                              label: Text(
                                document.displayCategory,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.blue.shade100,
                              side: BorderSide.none,
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (document.isFeatured) ...[
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            document.fileTypeDisplay,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Download Button
                IconButton(
                  onPressed: () => _downloadDocument(document),
                  icon: const Icon(Icons.download),
                  tooltip: 'Download',
                ),
              ],
            ),
            // Document Description
            if (document.hasDescription) ...[
              const SizedBox(height: 12),
              Text(
                document.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Document Tags
            if (document.hasTags) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    document.tags
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
            // Document Meta Info
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.file_download,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${document.downloadCount} downloads',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.storage, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      document.displayFileSize,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  _formatDate(document.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getFileTypeColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileTypeIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatCategoryName(String category) {
    return category
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : word,
        )
        .join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      context.read<DocumentBloc>().add(const LoadDocuments());
    } else {
      context.read<DocumentBloc>().add(
        SearchDocuments(
          searchQuery: query,
          category: _selectedCategory,
          fileType: _selectedFileType,
          sortBy: _sortBy,
          sortDirection: _sortAscending ? 'asc' : 'desc',
        ),
      );
    }
  }

  void _applyFilters() {
    context.read<DocumentBloc>().add(
      LoadDocuments(
        category: _selectedCategory,
        extension: _selectedFileType,
        sortBy: _sortBy,
        sortDirection: _sortAscending ? 'asc' : 'desc',
      ),
    );
  }

  void _applySort() {
    context.read<DocumentBloc>().add(
      SortDocuments(
        sortBy: _sortBy,
        sortDirection: _sortAscending ? 'asc' : 'desc',
      ),
    );
  }

  void _downloadDocument(DocumentModel document) {
    context.read<DocumentBloc>().add(DownloadDocument(slug: document.slug));
  }

  void _openFile(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not open file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
