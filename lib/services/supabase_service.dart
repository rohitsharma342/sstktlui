import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Authentication methods
  Future<AuthResponse?> signUp(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
        
        // Create user profile in database
        await insertData('user_profiles', {
          'id': response.user!.id,
          'name': name,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }
  
  Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
      }
      
      return response;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await _clearUserData();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
  
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
  
  Stream<AuthState> authStateChanges() {
    return supabase.auth.onAuthStateChange;
  }
  
  // Database CRUD operations
  Future<List<Map<String, dynamic>>> fetchData(String table, {String? orderBy, bool ascending = true}) async {
    try {
      var query = supabase.from(table).select();
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data from $table: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>?> fetchById(String table, String id) async {
    try {
      final response = await supabase
          .from(table)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      print('Error fetching $table by id $id: $e');
      return null;
    }
  }
  
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    try {
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await supabase.from(table).insert(data);
    } catch (e) {
      print('Error inserting data into $table: $e');
      rethrow;
    }
  }
  
  Future<void> updateData(String table, String id, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await supabase
          .from(table)
          .update(data)
          .eq('id', id);
    } catch (e) {
      print('Error updating data in $table: $e');
      rethrow;
    }
  }
  
  Future<void> deleteData(String table, String id) async {
    try {
      await supabase.from(table).delete().eq('id', id);
    } catch (e) {
      print('Error deleting data from $table: $e');
      rethrow;
    }
  }
  
  // Storage operations
  Future<String> uploadFile(String bucket, String path, File file) async {
    try {
      await supabase.storage.from(bucket).upload(path, file);
      final url = supabase.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
  
  Future<void> deleteFile(String bucket, String path) async {
    try {
      await supabase.storage.from(bucket).remove([path]);
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }
  
  // User-specific queries
  Future<List<Map<String, dynamic>>> fetchUserCartItems(String userId) async {
    try {
      final response = await supabase
          .from('cart_items')
          .select('*, paintings(*)')
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user cart items: $e');
      rethrow;
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchUserOrders(String userId) async {
    try {
      final response = await supabase
          .from('orders')
          .select('*, order_items(*, paintings(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user orders: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
  
  // Local storage helpers
  Future<void> _saveUserToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
    }
  }
  
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }
  
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }
  
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
  
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
  }
}