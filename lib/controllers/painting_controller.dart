import 'package:get/get.dart';
import '../models/painting.dart';
import '../services/data_service.dart';

class PaintingController extends GetxController {
  final DataService _dataService = Get.find<DataService>();
  
  final RxList<Painting> _filteredPaintings = <Painting>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'All'.obs;
  
  List<Painting> get allPaintings => _dataService.paintings;
  List<Painting> get filteredPaintings => _filteredPaintings;
  List<Painting> get trendingPaintings => _dataService.paintings.where((p) => p.isTrending).toList();
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  List<String> get categories => _dataService.categories;
  bool get isLoading => _dataService.isLoading.value;
  String get error => _dataService.error.value;
  
  @override
  void onInit() {
    super.onInit();
    _initializeFilters();
  }
  
  void _initializeFilters() {
    // Listen to changes in the data service paintings list
    ever(_dataService.paintings, (_) => _applyFilters());
    _filteredPaintings.value = _dataService.paintings;
  }
  
  Future<void> refreshPaintings() async {
    await _dataService.fetchPaintings();
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
    List<Painting> filtered = List.from(_dataService.paintings);
    
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
  
  Future<Painting?> getPaintingById(String id) async {
    // First check in memory
    try {
      return _dataService.paintings.firstWhere((p) => p.id == id);
    } catch (e) {
      // If not found in memory, fetch from database
      return await _dataService.getPaintingById(id);
    }
  }
  
  void clearFilters() {
    _searchQuery.value = '';
    _selectedCategory.value = 'All';
    _applyFilters();
  }
}