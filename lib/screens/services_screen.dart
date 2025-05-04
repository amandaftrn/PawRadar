import 'package:flutter/material.dart';

class ServiceCategory {
  final String name;
  final IconData icon;
  final List<Service> services;

  ServiceCategory({
    required this.name,
    required this.icon,
    required this.services,
  });
}

class Service {
  final String name;
  final String description;
  final String price;
  final IconData icon;

  Service({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ServiceCategory> categories = [
    ServiceCategory(
      name: 'Dokter Hewan',
      icon: Icons.medical_services,
      services: [
        Service(
          name: 'Pemeriksaan umum',
          description: 'Pemeriksaan kesehatan lengkap untuk hewan peliharaan',
          price: 'Rp 150.000',
          icon: Icons.health_and_safety,
        ),
        Service(
          name: 'Vaksinasi',
          description: 'Vaksin untuk mencegah penyakit',
          price: 'Rp 100.000 - Rp 250.000',
          icon: Icons.vaccines,
        ),
        Service(
          name: 'Perawatan Gigi',
          description: 'Pembersihan dan perawatan kesehatan gigi',
          price: 'Rp 300.000',
          icon: Icons.clean_hands,
        ),
        Service(
          name: 'Operasi',
          description: 'Berbagai prosedur operasi',
          price: 'Bervariasi',
          icon: Icons.medical_services,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Grooming',
      icon: Icons.spa,
      services: [
        Service(
          name: 'Mandi & Sisir',
          description: 'Layanan mandi dan penyisiran',
          price: 'Rp 100.000',
          icon: Icons.shower,
        ),
        Service(
          name: 'Grooming Lengkap',
          description: 'Paket grooming lengkap, sudah termasuk potong rambut',
          price: 'Rp 200.000',
          icon: Icons.content_cut,
        ),
        Service(
          name: 'Potong Kuku',
          description: 'Layanan potong kuku profesional',
          price: 'Rp 50.000',
          icon: Icons.content_cut,
        ),
        Service(
          name: 'Pembersihan Telinga',
          description: 'Layanan pembersihan telinga',
          price: 'Rp 75.000',
          icon: Icons.clean_hands,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Pelatihan',
      icon: Icons.school,
      services: [
        Service(
          name: 'Pelatihan Dasar',
          description: 'Perintah dasar dan pelatihan perilaku',
          price: 'Rp 150.000/sesi',
          icon: Icons.pets,
        ),
        Service(
          name: 'Pelatihan Anak Anjing',
          description: 'Pelatihan awal untuk anak anjing',
          price: 'Rp 125.000/sesi',
          icon: Icons.child_care,
        ),
        Service(
          name: 'Koreksi Perilaku',
          description: 'Mengatasi masalah perilaku tertentu',
          price: 'Rp 175.000/sesi',
          icon: Icons.psychology,
        ),
        Service(
          name: 'Pelatihan Lanjutan',
          description: 'Pelatihan lanjutan dan trik',
          price: 'Rp 200.000/sesi',
          icon: Icons.military_tech,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Penitipan',
      icon: Icons.hotel,
      services: [
        Service(
          name: 'Penitipan Harian',
          description: 'Pengawasan dan perawatan sepanjang hari',
          price: 'Rp 75.000/hari',
          icon: Icons.wb_sunny,
        ),
        Service(
          name: 'Menginap',
          description: 'Akomodasi penginapan yang nyaman',
          price: 'Rp 125.000/malam',
          icon: Icons.hotel,
        ),
        Service(
          name: 'Penitipan Jangka Panjang',
          description: 'Layanan penitipan jangka panjang',
          price: 'Rp 100.000/malam',
          icon: Icons.night_shelter,
        ),
        Service(
          name: 'Paket VIP',
          description: 'Penitipan premium dengan fasilitas ekstra',
          price: 'Rp 200.000/malam',
          icon: Icons.star,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme
                .of(context)
                .primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme
                .of(context)
                .primaryColor,
            tabs: categories.map((category) {
              return Tab(
                text: category.name,
                icon: Icon(category.icon),
              );
            }).toList(),
          ),
        ),

        // Tab Bar View
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              return _buildServiceList(category.services);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceList(List<Service> services) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(services[index]);
      },
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    service.icon,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        service.description,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  service.price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showServiceDetails(context, service);
                  },
                  child: Text('Details'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _bookService(context, service);
                  },
                  child: Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetails(BuildContext context, Service service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(service.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deskripsi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(service.description),
              SizedBox(height: 16.0),
              Text(
                'Harga',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(service.price),
              SizedBox(height: 16.0),
              Text(
                'Durasi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text('30-60 menit (bervariasi)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bookService(context, service);
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _bookService(BuildContext context, Service service) {
    // Show a toast notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${service.name} service...'),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            // Navigate to bookings page
          },
        ),
      ),
    );

    // Show booking confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pemesanan'),
          content: Text(
              'Layanan ${service.name} berhasil dipesan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}