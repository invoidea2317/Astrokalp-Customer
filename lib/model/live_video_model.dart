class VideoRecord {
  final int? id;
  final String? youtubeLink;
  final String? coverImage;
  final String? videoTitle;
  final int? isActive;
  final int? astrologerId;
  final int? isDelete;
  final String? createdAt;
  final String? updatedAt;
  final int? createdBy;
  final int? modifiedBy;
  final String? astroName;
  final String? astroImage;

  VideoRecord({
    this.id,
    this.youtubeLink,
    this.coverImage,
    this.videoTitle,
    this.isActive,
    this.astrologerId,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.astroName,
    this.astroImage,
  });

  factory VideoRecord.fromJson(Map<String, dynamic> json) {
    return VideoRecord(
      id: json['id'],
      youtubeLink: json['youtubeLink'],
      coverImage: json['coverImage'],
      videoTitle: json['videoTitle'],
      isActive: json['isActive'],
      astrologerId: json['astrologer_id'],
      isDelete: json['isDelete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      createdBy: json['createdBy'],
      modifiedBy: json['modifiedBy'],
      astroName: json['astroName'],
      astroImage: json['astroImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'youtubeLink': youtubeLink,
      'coverImage': coverImage,
      'videoTitle': videoTitle,
      'isActive': isActive,
      'astrologer_id': astrologerId,
      'isDelete': isDelete,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
      'astroName': astroName,
      'astroImage': astroImage,
    };
  }
}
