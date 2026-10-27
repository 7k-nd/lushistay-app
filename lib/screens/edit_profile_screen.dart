import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:elxau/theme.dart';
import 'package:elxau/cupertino_ui.dart';
import 'package:elxau/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nomKey = GlobalKey<AppFormFieldState>();
  final _prenomKey = GlobalKey<AppFormFieldState>();
  final _emailKey = GlobalKey<AppFormFieldState>();
  final _phoneKey = GlobalKey<AppFormFieldState>();
  final _entityNameKey = GlobalKey<AppFormFieldState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _entityNameController;
  bool _isEntity = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nomController = TextEditingController(text: user?.nom);
    _prenomController = TextEditingController(text: user?.prenom);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.telephone);
    _entityNameController = TextEditingController(text: user?.entityName);
    _isEntity = user?.isEntity ?? false;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _entityNameController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    return null;
  }

  Future<void> _handleSave() async {
    final keys = [_nomKey, _prenomKey, _emailKey, _phoneKey];
    if (_isEntity) keys.add(_entityNameKey);
    if (!validateFields(keys)) return;

    final authService = context.read<AuthService>();
    final result = await authService.updateProfile(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      telephone: _phoneController.text.trim(),
      isEntity: _isEntity,
      entityName: _isEntity ? _entityNameController.text.trim() : null,
    );

    if (mounted) {
      if (result['success']) {
        await showAppMessage(
          context,
          'Profil mis à jour avec succès',
          title: 'Profil',
        );
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        await showAppMessage(
          context,
          result['message'] ?? 'Une erreur est survenue',
          title: 'Erreur',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthService>().isLoading;

    return AppScaffold(
      navigationBar: AppNavBar(
        middle: Text(
          'Modifier le profil',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: ElxauTheme.accent),
        ),
        trailing: isLoading
            ? null
            : CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: _handleSave,
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(color: ElxauTheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Stack(
                  children: [
                    AppAvatar(
                      radius: 50,
                      backgroundColor: ElxauTheme.white,
                      child: Icon(CupertinoIcons.person, size: 50, color: ElxauTheme.primary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: AppAvatar(
                        radius: 16,
                        backgroundColor: ElxauTheme.primary,
                        child: Icon(CupertinoIcons.camera_fill, size: 16, color: ElxauTheme.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildSectionTitle('INFORMATIONS PERSONNELLES'),
              const SizedBox(height: 16),
              AppFormField(
                key: _nomKey,
                controller: _nomController,
                label: 'Nom',
                placeholder: 'Nom',
                prefixIcon: CupertinoIcons.person,
                validator: _required,
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _prenomKey,
                controller: _prenomController,
                label: 'Prénom',
                placeholder: 'Prénom',
                prefixIcon: CupertinoIcons.person,
                validator: _required,
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _emailKey,
                controller: _emailController,
                label: 'Email',
                placeholder: 'Email',
                prefixIcon: CupertinoIcons.mail,
                enabled: false,
                fillColor: ElxauTheme.bg,
                validator: _required,
              ),
              const SizedBox(height: 16),
              AppFormField(
                key: _phoneKey,
                controller: _phoneController,
                label: 'Téléphone',
                placeholder: 'Téléphone',
                prefixIcon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('STATUT PROFESSIONNEL'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: ElxauTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ElxauTheme.softShadow,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    CupertinoCheckbox(
                      value: _isEntity,
                      activeColor: ElxauTheme.primary,
                      onChanged: (val) {
                        setState(() {
                          _isEntity = val ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Je suis une agence/entité immobilière',
                        style: TextStyle(fontWeight: FontWeight.w600, color: ElxauTheme.accent, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isEntity) ...[
                const SizedBox(height: 16),
                AppFormField(
                  key: _entityNameKey,
                  controller: _entityNameController,
                  label: 'Nom de l\'agence/entité',
                  placeholder: 'Nom de l\'agence/entité',
                  prefixIcon: CupertinoIcons.building_2_fill,
                  validator: _required,
                ),
              ],
              const SizedBox(height: 40),
              Text(
                'L\'email ne peut pas être modifié.',
                style: TextStyle(color: ElxauTheme.secondaryText.withValues(alpha: 0.6), fontSize: 12),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(child: CupertinoActivityIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        color: ElxauTheme.secondaryText,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    );
  }
}
