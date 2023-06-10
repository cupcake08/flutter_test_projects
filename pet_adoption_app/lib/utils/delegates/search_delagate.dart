import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/home/pet_detail_screen.dart';
import 'package:provider/provider.dart';

class PetSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = context.read<PetsProvider>();
    if (provider.searchPets.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }
    return _listOfPets(provider.searchPets);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      context.read<PetsProvider>().getPetsListBySearch(query);
    } else {
      return const Center(
        child: Text('Search Pets'),
      );
    }
    return Selector<PetsProvider, bool>(
      builder: (context, searchingPets, _) {
        if (searchingPets) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final pets = context.read<PetsProvider>().searchPets;
        return _listOfPets(pets);
      },
      selector: (context, provider) => provider.searchingPets,
    );
  }

  _listOfPets(List<Pet> pets) {
    if (pets.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PetDetailScreen(pet: pet);
            }));
          },
          leading: Hero(
            tag: 'pet${pet.id}',
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                pet.image,
              ),
            ),
          ),
          title: Text(pet.name),
          subtitle: Text(pet.description),
        );
      },
    );
  }
}
