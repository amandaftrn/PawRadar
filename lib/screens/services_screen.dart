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
      name: 'Veterinary',
      icon: Icons.medical_services,
      services: [
        Service(
          name: 'General Check-up',
          description: 'Complete health examination for your pet',
          price: '\$50',
          icon: Icons.health_and_safety,
        ),
        Service(
          name: 'Vaccination',
          description: 'Essential vaccines for disease prevention',
          price: '\$30 - \$45',
          icon: Icons.vaccines,
        ),
        Service(
          name: 'Dental Care',
          description: 'Cleaning and dental health maintenance',
          price: '\$80',
          icon: Icons.clean_hands,
        ),
        Service(
          name: 'Surgery',
          description: 'Various surgical procedures',
          price: 'Varies',
          icon: Icons.medical_services,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Grooming',
      icon: Icons.spa,
      services: [
        Service(
          name: 'Bath & Brush',
          description: 'Basic bath and brushing service',
          price: '\$35',
          icon: Icons.shower,
        ),
        Service(
          name: 'Full Groom',
          description: 'Complete grooming package including haircut',
          price: '\$60',
          icon: Icons.content_cut,
        ),
        Service(
          name: 'Nail Trimming',
          description: 'Professional nail trimming service',
          price: '\$15',
          icon: Icons.content_cut,
        ),
        Service(
          name: 'Ear Cleaning',
          description: 'Gentle ear cleaning service',
          price: '\$20',
          icon: Icons.clean_hands,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Training',
      icon: Icons.school,
      services: [
        Service(
          name: 'Basic Obedience',
          description: 'Essential commands and behavior training',
          price: '\$45/session',
          icon: Icons.pets,
        ),
        Service(
          name: 'Puppy Training',
          description: 'Early training for puppies',
          price: '\$40/session',
          icon: Icons.child_care,
        ),
        Service(
          name: 'Behavior Correction',
          description: 'Address specific behavior problems',
          price: '\$55/session',
          icon: Icons.psychology,
        ),
        Service(
          name: 'Advanced Training',
          description: 'Advanced commands and tricks',
          price: '\$60/session',
          icon: Icons.military_tech,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Boarding',
      icon: Icons.hotel,
      services: [
        Service(
          name: 'Day Care',
          description: 'Supervised play and care during the day',
          price: '\$25/day',
          icon: Icons.wb_sunny,
        ),
        Service(
          name: 'Overnight Stay',
          description: 'Comfortable overnight accommodation',
          price: '\$45/night',
          icon: Icons.hotel,
        ),
        Service(
          name: 'Extended Boarding',
          description: 'Long-term boarding services',
          price: '\$40/night',
          icon: Icons.night_shelter,
        ),
        Service(
          name: 'VIP Suite',
          description: 'Premium boarding with extra amenities',
          price: '\$60/night',
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
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(service.description),
              SizedBox(height: 16.0),
              Text(
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(service.price),
              SizedBox(height: 16.0),
              Text(
                'Duration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text('30-60 minutes (varies)'),
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
          label: 'View',
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
          title: Text('Booking Confirmation'),
          content: Text(
              'Your ${service.name} service has been booked successfully!'),
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