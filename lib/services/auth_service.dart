import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db   = FirebaseFirestore.instance;

  // ── Sign Up ────────────────────────────────────────────────────────────────
  // Only creates the Auth user + saves to Firestore
  // Email verification is handled separately in the screen
  static Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String dob,
    required String gender,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await _db.collection('users').doc(cred.user!.uid).set({
      'name':      name.trim(),
      'email':     email.trim(),
      'phone':     phone.trim(),
      'dob':       dob.trim(),
      'gender':    gender,
      'role':      role,
      'photoUrl':  '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return cred;
  }

  // ── Log In ─────────────────────────────────────────────────────────────────
  static Future<UserCredential> logIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ── Reset Password ─────────────────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Get user role from Firestore ───────────────────────────────────────────
  static Future<String> getUserRole() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'passenger';
  }

  // ── Sign Out ───────────────────────────────────────────────────────────────
  static Future<void> signOut() async => await _auth.signOut();

  // ── Current user ──────────────────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;
}