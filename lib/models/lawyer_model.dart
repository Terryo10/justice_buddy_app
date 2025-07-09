import 'package:equatable/equatable.dart';

class LawyerModel extends Equatable {
  final int id;
  final String fullName;
  final String firstName;
  final String lastName;
  final String? firmName;
  final String email;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? licenseNumber;
  final String? profileImage;
  final String? bio;
  final List<String> specializations;
  final List<String> languages;
  final int? yearsExperience;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? formattedAddress;
  final double? latitude;
  final double? longitude;
  final DateTime? admissionDate;
  final String? lawSociety;
  final List<String> courtsAdmitted;
  final double? consultationFee;
  final List<String> consultationMethods;
  final bool acceptsNewClients;
  final Map<String, dynamic>? businessHours;
  final String? website;
  final Map<String, dynamic>? socialMedia;
  final double? rating;
  final int reviewCount;
  final String slug;
  final double? distance;
  final DateTime? verifiedAt;

  const LawyerModel({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    this.firmName,
    required this.email,
    this.phone,
    this.mobile,
    this.fax,
    this.licenseNumber,
    this.profileImage,
    this.bio,
    required this.specializations,
    required this.languages,
    this.yearsExperience,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.formattedAddress,
    this.latitude,
    this.longitude,
    this.admissionDate,
    this.lawSociety,
    this.courtsAdmitted = const [],
    this.consultationFee,
    required this.consultationMethods,
    required this.acceptsNewClients,
    this.businessHours,
    this.website,
    this.socialMedia,
    this.rating,
    required this.reviewCount,
    required this.slug,
    this.distance,
    this.verifiedAt,
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      firmName: json['firm_name'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      fax: json['fax'] as String?,
      licenseNumber: json['license_number'] as String?,
      profileImage: json['profile_image'] as String?,
      bio: json['bio'] as String?,
      specializations: List<String>.from(json['specializations'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      yearsExperience: json['years_experience'] as int?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      admissionDate:
          json['admission_date'] != null
              ? DateTime.tryParse(json['admission_date'])
              : null,
      lawSociety: json['law_society'] as String?,
      courtsAdmitted: List<String>.from(json['courts_admitted'] ?? []),
      consultationFee:
          json['consultation_fee'] != null
              ? double.tryParse(json['consultation_fee'].toString())
              : null,
      consultationMethods: List<String>.from(
        json['consultation_methods'] ?? [],
      ),
      acceptsNewClients: json['accepts_new_clients'] as bool? ?? false,
      businessHours: json['business_hours'] as Map<String, dynamic>?,
      website: json['website'] as String?,
      socialMedia: json['social_media'] as Map<String, dynamic>?,
      rating:
          json['rating'] != null
              ? double.tryParse(json['rating'].toString())
              : null,
      reviewCount: json['review_count'] as int? ?? 0,
      slug: json['slug'] as String,
      distance:
          json['distance'] != null
              ? double.tryParse(json['distance'].toString())
              : null,
      verifiedAt:
          json['verified_at'] != null
              ? DateTime.tryParse(json['verified_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'first_name': firstName,
      'last_name': lastName,
      'firm_name': firmName,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'fax': fax,
      'license_number': licenseNumber,
      'profile_image': profileImage,
      'bio': bio,
      'specializations': specializations,
      'languages': languages,
      'years_experience': yearsExperience,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'formatted_address': formattedAddress,
      'latitude': latitude,
      'longitude': longitude,
      'admission_date': admissionDate?.toIso8601String(),
      'law_society': lawSociety,
      'courts_admitted': courtsAdmitted,
      'consultation_fee': consultationFee,
      'consultation_methods': consultationMethods,
      'accepts_new_clients': acceptsNewClients,
      'business_hours': businessHours,
      'website': website,
      'social_media': socialMedia,
      'rating': rating,
      'review_count': reviewCount,
      'slug': slug,
      'distance': distance,
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }

  LawyerModel copyWith({
    int? id,
    String? fullName,
    String? firstName,
    String? lastName,
    String? firmName,
    String? email,
    String? phone,
    String? mobile,
    String? fax,
    String? licenseNumber,
    String? profileImage,
    String? bio,
    List<String>? specializations,
    List<String>? languages,
    int? yearsExperience,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? formattedAddress,
    double? latitude,
    double? longitude,
    DateTime? admissionDate,
    String? lawSociety,
    List<String>? courtsAdmitted,
    double? consultationFee,
    List<String>? consultationMethods,
    bool? acceptsNewClients,
    Map<String, dynamic>? businessHours,
    String? website,
    Map<String, dynamic>? socialMedia,
    double? rating,
    int? reviewCount,
    String? slug,
    double? distance,
    DateTime? verifiedAt,
  }) {
    return LawyerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      firmName: firmName ?? this.firmName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      fax: fax ?? this.fax,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      specializations: specializations ?? this.specializations,
      languages: languages ?? this.languages,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      admissionDate: admissionDate ?? this.admissionDate,
      lawSociety: lawSociety ?? this.lawSociety,
      courtsAdmitted: courtsAdmitted ?? this.courtsAdmitted,
      consultationFee: consultationFee ?? this.consultationFee,
      consultationMethods: consultationMethods ?? this.consultationMethods,
      acceptsNewClients: acceptsNewClients ?? this.acceptsNewClients,
      businessHours: businessHours ?? this.businessHours,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      slug: slug ?? this.slug,
      distance: distance ?? this.distance,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    firstName,
    lastName,
    firmName,
    email,
    phone,
    mobile,
    fax,
    licenseNumber,
    profileImage,
    bio,
    specializations,
    languages,
    yearsExperience,
    address,
    city,
    province,
    postalCode,
    formattedAddress,
    latitude,
    longitude,
    admissionDate,
    lawSociety,
    courtsAdmitted,
    consultationFee,
    consultationMethods,
    acceptsNewClients,
    businessHours,
    website,
    socialMedia,
    rating,
    reviewCount,
    slug,
    distance,
    verifiedAt,
  ];
}
