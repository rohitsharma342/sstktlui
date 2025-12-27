import 'package:get/get.dart';
import '../models/painting.dart';
import '../services/data_service.dart';

class PaintingController extends GetxController {
  final RxList<Painting> _allPaintings = <Painting>[].obs;
  final RxList<Painting> _filteredPaintings = <Painting>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxList<String> _categories = <String>[].obs;
  
  List<Painting> get allPaintings => _allPaintings;
  List<Painting> get filteredPaintings => _filteredPaintings;
  List<Painting> get trendingPaintings => _allPaintings.where((p) => p.isTrending).toList();
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  List<String> get categories => _categories;
  
  @override
  void onInit() {
    super.onInit();
    loadPaintings();
    loadCategories();
  }
  
  void loadPaintings() {
    _allPaintings.value = DataService.getPaintings();
    _filteredPaintings.value = _allPaintings;
  }
  
  void loadCategories() {
    _categories.value = DataService.getCategories();
  }
  
  void searchPaintings(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }
  
  void filterByCategory(String category) {
    _selectedCategory.value = category;
    _applyFilters();
  }
  
  void _applyFilters() {
    List<Painting> filtered = _allPaintings;
    
    if (_selectedCategory.value != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory.value).toList();
    }
    
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.title.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
        p.artist.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
        p.description.toLowerCase().contains(_searchQuery.value.toLowerCase())
      ).toList();
    }
    
    _filteredPaintings.value = filtered;
  }
  
  Painting? getPaintingById(String id) {
    try {
      return _allPaintings.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}