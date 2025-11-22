class Bundle {
  final String id;
  final String title;
  final String description;
  final String category;
  final String categoryTypeName;
  final List<Service> services;
  final DateTime serviceDate;
  final String serviceTimeStart;
  final String serviceTimeEnd;
  final int bundleDiscount;
  final double finalPrice;
  final Creator creator;
  final List<Participant> participants;
  final Address address;
  final String status;
  final int maxParticipants;
  final int currentParticipants;
  final int availableSpots;
  final String? shareToken;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String userRole;
  final bool canJoin;

  Bundle({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryTypeName,
    required this.services,
    required this.serviceDate,
    required this.serviceTimeStart,
    required this.serviceTimeEnd,
    required this.bundleDiscount,
    required this.finalPrice,
    required this.creator,
    required this.participants,
    required this.address,
    required this.status,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.availableSpots,
    this.shareToken,
    required this.createdAt,
    required this.expiresAt,
    required this.userRole,
    required this.canJoin,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] as Map<String, dynamic>? ?? {};

    return Bundle(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      categoryTypeName: json['categoryTypeName'] ?? '',
      services: (json['services'] as List?)
          ?.map((s) => Service.fromJson(s))
          .toList() ??
          [],
      serviceDate: DateTime.parse(json['serviceDate']),
      serviceTimeStart: json['serviceTimeStart'] ?? '00:00',
      serviceTimeEnd: json['serviceTimeEnd'] ?? '00:00',
      bundleDiscount: json['bundleDiscount'] ?? 0,
      finalPrice: (pricing['finalPrice'] as num?)?.toDouble() ?? 0.0,
      creator: Creator.fromJson(json['creator']),
      participants: (json['participants'] as List?)
          ?.map((p) => Participant.fromJson(p))
          .toList() ??
          [],
      address: Address.fromJson(json['address']),
      status: json['status'] ?? 'pending',
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      availableSpots: json['availableSpots'] ?? 0,
      shareToken: json['shareToken'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      userRole: json['userRole'] ?? 'viewer',
      canJoin: json['canJoin'] ?? false,
    );
  }
}

class Creator {
  final String firstName;
  final String lastName;
  final ProfileImage profileImage;
  final Address address;

  Creator({
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.address,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImage: ProfileImage.fromJson(json['profileImage']),
      address: Address.fromJson(json['address']),
    );
  }
}
class Participant {
  final String id;
  final String status;
  final DateTime joinedAt;
  final Customer customer;
  final Address address;

  Participant({
    required this.id,
    required this.status,
    required this.joinedAt,
    required this.customer,
    required this.address,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      status: json['status'],
      joinedAt: DateTime.parse(json['joinedAt']),
      customer: Customer.fromJson(json['customer']),
      address: Address.fromJson(json['address']),
    );
  }
}
class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final ProfileImage profileImage;
  final Address address;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImage: ProfileImage.fromJson(json['profileImage']),
      address: Address.fromJson(json['address']),
    );
  }
}
class Address {
  final String street;
  final String city;
  final String state;
  final String aptSuite;
  final String? zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.aptSuite,
    this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      aptSuite: json['aptSuite'],
      zipCode: json['zipCode'],
    );
  }
}
class ProfileImage {
  final String url;
  final String publicId;

  ProfileImage({
    required this.url,
    required this.publicId,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      url: json['url'],
      publicId: json['publicId'],
    );
  }
}

class Service {
  final String id;
  final String name;
  final double hourlyRate;
  final double estimatedHours;

  Service({
    required this.id,
    required this.name,
    required this.hourlyRate,
    required this.estimatedHours,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      estimatedHours: (json['estimatedHours'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BundleListResponse {
  final bool success;
  final String message;
  final BundleData data;

  BundleListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BundleListResponse.fromJson(Map<String, dynamic> json) {
    return BundleListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BundleData.fromJson(json['data']),
    );
  }
}

class BundleData {
  final List<Bundle> bundles;
  final CustomerLocation customerLocation;
  final SearchCriteria searchCriteria;
  final Pagination pagination;

  BundleData({
    required this.bundles,
    required this.customerLocation,
    required this.searchCriteria,
    required this.pagination,
  });

  factory BundleData.fromJson(Map<String, dynamic> json) {
    return BundleData(
      bundles: (json['bundles'] as List)
          .map((b) => Bundle.fromJson(b))
          .toList(),
      customerLocation: CustomerLocation.fromJson(json['customerLocation']),
      searchCriteria: SearchCriteria.fromJson(json['searchCriteria']),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

// You can optionally define these too if needed:
class CustomerLocation {
  final String zipCode;
  final Address address;
  CustomerLocation({required this.zipCode, required this.address});
  factory CustomerLocation.fromJson(Map<String, dynamic> json) => CustomerLocation(
    zipCode: json['zipCode'],
    address: Address.fromJson(json['address']),
  );
}

class SearchCriteria {
  final String zipCode;
  final String category;
  final String status;
  SearchCriteria({required this.zipCode, required this.category, required this.status});
  factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
    zipCode: json['zipCode'],
    category: json['category'],
    status: json['status'],
  );
}

class Pagination {
  final int current, total, pages;
  Pagination({required this.current, required this.total, required this.pages});
  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    current: json['current'],
    total: json['total'],
    pages: json['pages'],
  );
}