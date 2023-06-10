import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 800.ms,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder(
        future: context.read<PetsProvider>().getAdoptedPets(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              } else {
                final data = snap.data!;
                if (data.isEmpty) {
                  return const Center(child: Text('No history'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final pet = data[index];
                    return SlideTransition(
                      position: _animationController.drive(
                        Tween<Offset>(
                          begin: const Offset(0.0, 1),
                          end: Offset.zero,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: _animationController.drive(
                          CurveTween(curve: Curves.easeIn),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return PetDetailScreen(pet: pet);
                            }));
                          },
                          leading: Hero(
                            tag: "pet${pet.id}",
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(pet.image),
                            ),
                          ),
                          title: Text(pet.name),
                          subtitle: Text(pet.description),
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
