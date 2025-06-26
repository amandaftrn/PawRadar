import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Pet {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final Color avatarColor;
  final Uint8List? imageBytes;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.avatarColor,
    this.imageBytes,
  });
}

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final List<Pet> _pets = [
    Pet(
      name: 'Max',
      breed: 'Golden Retriever',
      age: '3 tahun',
      gender: 'Jantan',
      avatarColor: Colors.amber,
    ),
    Pet(
      name: 'Bella',
      breed: 'Kucing Persia',
      age: '2 tahun',
      gender: 'Betina',
      avatarColor: Colors.pinkAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pets...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),

          // Pet List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                return _buildPetCard(_pets[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPetDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildPetCard(Pet pet, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Avatar/Image Area - Will be replaced with camera image later
          Stack(
            children: [
              InkWell(
                onTap: pet.imageBytes == null
                    ? () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    setState(() {
                      _pets[index] = Pet(
                        name: pet.name,
                        breed: pet.breed,
                        age: pet.age,
                        gender: pet.gender,
                        avatarColor: pet.avatarColor,
                        imageBytes: bytes,
                      );
                    });
                  }
                }
                    : null,
                child: pet.imageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.memory(
                    pet.imageBytes!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: pet.avatarColor.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          pet.gender == 'Jantan' ? Icons.pets : Icons.catching_pokemon,
                          size: 60,
                          color: pet.avatarColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ketuk untuk ambil foto",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (pet.imageBytes != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () async {
                        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          final bytes = await pickedFile.readAsBytes();
                          setState(() {
                            _pets[index] = Pet(
                              name: pet.name,
                              breed: pet.breed,
                              age: pet.age,
                              gender: pet.gender,
                              avatarColor: pet.avatarColor,
                              imageBytes: bytes,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: pet.gender == 'Jantan'
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.pink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        pet.gender,
                        style: TextStyle(
                          color: pet.gender == 'Jantan' ? Colors.blue : Colors.pink,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  pet.breed,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Umur: ${pet.age}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.event,
                      label: 'Jadwal',
                      color: Colors.orange,
                      onTap: () {
                        // Schedule appointment
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jadwalkan janji untuk ${pet.name}'))
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.history,
                      label: 'Riwayat',
                      color: Colors.green,
                      onTap: () {
                        // View medical history
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lihat riwayat ${pet.name}'))
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      color: Colors.blue,
                      onTap: () {
                        // Edit pet info
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Edit informasi ${pet.name}'))
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambahkan hewan baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nama Hewan',
                    hintText: 'Masukan nama hewan',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Jenis',
                    hintText: 'Masukan jenis/ras',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Umur',
                    hintText: 'Masukkan umur (mis: 2 tahun',
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Jenis Kelamin',
                  ),
                  items: ['Jantan', 'Betina'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle gender selection
                  },
                ),
                SizedBox(height: 16.0),
                // Add a placeholder for future camera functionality
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Berhasil ambil foto untuk hewan baru!'))
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("Ketuk untuk ambil foto", style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add pet logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sukses menambahkan hewan baru!'))
                );
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}