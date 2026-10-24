// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OrganizersTable extends Organizers
    with TableInfo<$OrganizersTable, OrganizerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _followersMeta = const VerificationMeta(
    'followers',
  );
  @override
  late final GeneratedColumn<int> followers = GeneratedColumn<int>(
    'followers',
    aliasedName,
    false,
    check: () => ComparableExpr(followers).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventsCountMeta = const VerificationMeta(
    'eventsCount',
  );
  @override
  late final GeneratedColumn<int> eventsCount = GeneratedColumn<int>(
    'events_count',
    aliasedName,
    false,
    check: () => ComparableExpr(eventsCount).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, bio, followers, eventsCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    } else if (isInserting) {
      context.missing(_bioMeta);
    }
    if (data.containsKey('followers')) {
      context.handle(
        _followersMeta,
        followers.isAcceptableOrUnknown(data['followers']!, _followersMeta),
      );
    } else if (isInserting) {
      context.missing(_followersMeta);
    }
    if (data.containsKey('events_count')) {
      context.handle(
        _eventsCountMeta,
        eventsCount.isAcceptableOrUnknown(
          data['events_count']!,
          _eventsCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventsCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganizerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      )!,
      followers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers'],
      )!,
      eventsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}events_count'],
      )!,
    );
  }

  @override
  $OrganizersTable createAlias(String alias) {
    return $OrganizersTable(attachedDatabase, alias);
  }
}

class OrganizerRow extends DataClass implements Insertable<OrganizerRow> {
  final String id;
  final String name;
  final String bio;
  final int followers;
  final int eventsCount;
  const OrganizerRow({
    required this.id,
    required this.name,
    required this.bio,
    required this.followers,
    required this.eventsCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['bio'] = Variable<String>(bio);
    map['followers'] = Variable<int>(followers);
    map['events_count'] = Variable<int>(eventsCount);
    return map;
  }

  OrganizersCompanion toCompanion(bool nullToAbsent) {
    return OrganizersCompanion(
      id: Value(id),
      name: Value(name),
      bio: Value(bio),
      followers: Value(followers),
      eventsCount: Value(eventsCount),
    );
  }

  factory OrganizerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizerRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bio: serializer.fromJson<String>(json['bio']),
      followers: serializer.fromJson<int>(json['followers']),
      eventsCount: serializer.fromJson<int>(json['eventsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'bio': serializer.toJson<String>(bio),
      'followers': serializer.toJson<int>(followers),
      'eventsCount': serializer.toJson<int>(eventsCount),
    };
  }

  OrganizerRow copyWith({
    String? id,
    String? name,
    String? bio,
    int? followers,
    int? eventsCount,
  }) => OrganizerRow(
    id: id ?? this.id,
    name: name ?? this.name,
    bio: bio ?? this.bio,
    followers: followers ?? this.followers,
    eventsCount: eventsCount ?? this.eventsCount,
  );
  OrganizerRow copyWithCompanion(OrganizersCompanion data) {
    return OrganizerRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bio: data.bio.present ? data.bio.value : this.bio,
      followers: data.followers.present ? data.followers.value : this.followers,
      eventsCount: data.eventsCount.present
          ? data.eventsCount.value
          : this.eventsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('followers: $followers, ')
          ..write('eventsCount: $eventsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bio, followers, eventsCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.bio == this.bio &&
          other.followers == this.followers &&
          other.eventsCount == this.eventsCount);
}

class OrganizersCompanion extends UpdateCompanion<OrganizerRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> bio;
  final Value<int> followers;
  final Value<int> eventsCount;
  final Value<int> rowid;
  const OrganizersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.followers = const Value.absent(),
    this.eventsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizersCompanion.insert({
    required String id,
    required String name,
    required String bio,
    required int followers,
    required int eventsCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       bio = Value(bio),
       followers = Value(followers),
       eventsCount = Value(eventsCount);
  static Insertable<OrganizerRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? bio,
    Expression<int>? followers,
    Expression<int>? eventsCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (followers != null) 'followers': followers,
      if (eventsCount != null) 'events_count': eventsCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? bio,
    Value<int>? followers,
    Value<int>? eventsCount,
    Value<int>? rowid,
  }) {
    return OrganizersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      eventsCount: eventsCount ?? this.eventsCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (followers.present) {
      map['followers'] = Variable<int>(followers.value);
    }
    if (eventsCount.present) {
      map['events_count'] = Variable<int>(eventsCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('followers: $followers, ')
          ..write('eventsCount: $eventsCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EventCategory>($EventsTable.$convertercategory);
  static const VerificationMeta _organizerIdMeta = const VerificationMeta(
    'organizerId',
  );
  @override
  late final GeneratedColumn<String> organizerId = GeneratedColumn<String>(
    'organizer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizers (id)',
    ),
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _venueNameMeta = const VerificationMeta(
    'venueName',
  );
  @override
  late final GeneratedColumn<String> venueName = GeneratedColumn<String>(
    'venue_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venueAddressMeta = const VerificationMeta(
    'venueAddress',
  );
  @override
  late final GeneratedColumn<String> venueAddress = GeneratedColumn<String>(
    'venue_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> joinUrl =
      GeneratedColumn<String>(
        'join_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Uri?>($EventsTable.$converterjoinUrln);
  static const VerificationMeta _featuredMeta = const VerificationMeta(
    'featured',
  );
  @override
  late final GeneratedColumn<bool> featured = GeneratedColumn<bool>(
    'featured',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("featured" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attendeeCountMeta = const VerificationMeta(
    'attendeeCount',
  );
  @override
  late final GeneratedColumn<int> attendeeCount = GeneratedColumn<int>(
    'attendee_count',
    aliasedName,
    false,
    check: () => ComparableExpr(attendeeCount).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    false,
    check: () => ComparableExpr(capacity).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EventStatus>($EventsTable.$converterstatus);
  static const VerificationMeta _previousStartsAtMeta = const VerificationMeta(
    'previousStartsAt',
  );
  @override
  late final GeneratedColumn<DateTime> previousStartsAt =
      GeneratedColumn<DateTime>(
        'previous_starts_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    organizerId,
    startsAt,
    endsAt,
    timeZone,
    venueName,
    venueAddress,
    city,
    joinUrl,
    featured,
    attendeeCount,
    capacity,
    status,
    previousStartsAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('organizer_id')) {
      context.handle(
        _organizerIdMeta,
        organizerId.isAcceptableOrUnknown(
          data['organizer_id']!,
          _organizerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizerIdMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneMeta);
    }
    if (data.containsKey('venue_name')) {
      context.handle(
        _venueNameMeta,
        venueName.isAcceptableOrUnknown(data['venue_name']!, _venueNameMeta),
      );
    }
    if (data.containsKey('venue_address')) {
      context.handle(
        _venueAddressMeta,
        venueAddress.isAcceptableOrUnknown(
          data['venue_address']!,
          _venueAddressMeta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('featured')) {
      context.handle(
        _featuredMeta,
        featured.isAcceptableOrUnknown(data['featured']!, _featuredMeta),
      );
    }
    if (data.containsKey('attendee_count')) {
      context.handle(
        _attendeeCountMeta,
        attendeeCount.isAcceptableOrUnknown(
          data['attendee_count']!,
          _attendeeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attendeeCountMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('previous_starts_at')) {
      context.handle(
        _previousStartsAtMeta,
        previousStartsAt.isAcceptableOrUnknown(
          data['previous_starts_at']!,
          _previousStartsAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: $EventsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      organizerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizer_id'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      venueName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue_name'],
      ),
      venueAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue_address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      joinUrl: $EventsTable.$converterjoinUrln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}join_url'],
        ),
      ),
      featured: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}featured'],
      )!,
      attendeeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attendee_count'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      )!,
      status: $EventsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      previousStartsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}previous_starts_at'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EventCategory, String, String> $convertercategory =
      const EnumNameConverter<EventCategory>(EventCategory.values);
  static TypeConverter<Uri, String> $converterjoinUrl = const UriConverter();
  static TypeConverter<Uri?, String?> $converterjoinUrln =
      NullAwareTypeConverter.wrap($converterjoinUrl);
  static JsonTypeConverter2<EventStatus, String, String> $converterstatus =
      const EnumNameConverter<EventStatus>(EventStatus.values);
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final String organizerId;
  final DateTime startsAt;
  final DateTime endsAt;

  /// The venue's IANA zone ("Europe/London").
  final String timeZone;
  final String? venueName;
  final String? venueAddress;
  final String? city;
  final Uri? joinUrl;
  final bool featured;
  final int attendeeCount;
  final int capacity;
  final EventStatus status;
  final DateTime? previousStartsAt;
  const EventRow({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.organizerId,
    required this.startsAt,
    required this.endsAt,
    required this.timeZone,
    this.venueName,
    this.venueAddress,
    this.city,
    this.joinUrl,
    required this.featured,
    required this.attendeeCount,
    required this.capacity,
    required this.status,
    this.previousStartsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['category'] = Variable<String>(
        $EventsTable.$convertercategory.toSql(category),
      );
    }
    map['organizer_id'] = Variable<String>(organizerId);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    map['time_zone'] = Variable<String>(timeZone);
    if (!nullToAbsent || venueName != null) {
      map['venue_name'] = Variable<String>(venueName);
    }
    if (!nullToAbsent || venueAddress != null) {
      map['venue_address'] = Variable<String>(venueAddress);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || joinUrl != null) {
      map['join_url'] = Variable<String>(
        $EventsTable.$converterjoinUrln.toSql(joinUrl),
      );
    }
    map['featured'] = Variable<bool>(featured);
    map['attendee_count'] = Variable<int>(attendeeCount);
    map['capacity'] = Variable<int>(capacity);
    {
      map['status'] = Variable<String>(
        $EventsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || previousStartsAt != null) {
      map['previous_starts_at'] = Variable<DateTime>(previousStartsAt);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      organizerId: Value(organizerId),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
      timeZone: Value(timeZone),
      venueName: venueName == null && nullToAbsent
          ? const Value.absent()
          : Value(venueName),
      venueAddress: venueAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(venueAddress),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      joinUrl: joinUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(joinUrl),
      featured: Value(featured),
      attendeeCount: Value(attendeeCount),
      capacity: Value(capacity),
      status: Value(status),
      previousStartsAt: previousStartsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(previousStartsAt),
    );
  }

  factory EventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: $EventsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      organizerId: serializer.fromJson<String>(json['organizerId']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      venueName: serializer.fromJson<String?>(json['venueName']),
      venueAddress: serializer.fromJson<String?>(json['venueAddress']),
      city: serializer.fromJson<String?>(json['city']),
      joinUrl: serializer.fromJson<Uri?>(json['joinUrl']),
      featured: serializer.fromJson<bool>(json['featured']),
      attendeeCount: serializer.fromJson<int>(json['attendeeCount']),
      capacity: serializer.fromJson<int>(json['capacity']),
      status: $EventsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      previousStartsAt: serializer.fromJson<DateTime?>(
        json['previousStartsAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(
        $EventsTable.$convertercategory.toJson(category),
      ),
      'organizerId': serializer.toJson<String>(organizerId),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
      'timeZone': serializer.toJson<String>(timeZone),
      'venueName': serializer.toJson<String?>(venueName),
      'venueAddress': serializer.toJson<String?>(venueAddress),
      'city': serializer.toJson<String?>(city),
      'joinUrl': serializer.toJson<Uri?>(joinUrl),
      'featured': serializer.toJson<bool>(featured),
      'attendeeCount': serializer.toJson<int>(attendeeCount),
      'capacity': serializer.toJson<int>(capacity),
      'status': serializer.toJson<String>(
        $EventsTable.$converterstatus.toJson(status),
      ),
      'previousStartsAt': serializer.toJson<DateTime?>(previousStartsAt),
    };
  }

  EventRow copyWith({
    String? id,
    String? title,
    String? description,
    EventCategory? category,
    String? organizerId,
    DateTime? startsAt,
    DateTime? endsAt,
    String? timeZone,
    Value<String?> venueName = const Value.absent(),
    Value<String?> venueAddress = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<Uri?> joinUrl = const Value.absent(),
    bool? featured,
    int? attendeeCount,
    int? capacity,
    EventStatus? status,
    Value<DateTime?> previousStartsAt = const Value.absent(),
  }) => EventRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    organizerId: organizerId ?? this.organizerId,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
    timeZone: timeZone ?? this.timeZone,
    venueName: venueName.present ? venueName.value : this.venueName,
    venueAddress: venueAddress.present ? venueAddress.value : this.venueAddress,
    city: city.present ? city.value : this.city,
    joinUrl: joinUrl.present ? joinUrl.value : this.joinUrl,
    featured: featured ?? this.featured,
    attendeeCount: attendeeCount ?? this.attendeeCount,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    previousStartsAt: previousStartsAt.present
        ? previousStartsAt.value
        : this.previousStartsAt,
  );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      organizerId: data.organizerId.present
          ? data.organizerId.value
          : this.organizerId,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      venueName: data.venueName.present ? data.venueName.value : this.venueName,
      venueAddress: data.venueAddress.present
          ? data.venueAddress.value
          : this.venueAddress,
      city: data.city.present ? data.city.value : this.city,
      joinUrl: data.joinUrl.present ? data.joinUrl.value : this.joinUrl,
      featured: data.featured.present ? data.featured.value : this.featured,
      attendeeCount: data.attendeeCount.present
          ? data.attendeeCount.value
          : this.attendeeCount,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      previousStartsAt: data.previousStartsAt.present
          ? data.previousStartsAt.value
          : this.previousStartsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('organizerId: $organizerId, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('venueName: $venueName, ')
          ..write('venueAddress: $venueAddress, ')
          ..write('city: $city, ')
          ..write('joinUrl: $joinUrl, ')
          ..write('featured: $featured, ')
          ..write('attendeeCount: $attendeeCount, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('previousStartsAt: $previousStartsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    organizerId,
    startsAt,
    endsAt,
    timeZone,
    venueName,
    venueAddress,
    city,
    joinUrl,
    featured,
    attendeeCount,
    capacity,
    status,
    previousStartsAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.organizerId == this.organizerId &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.timeZone == this.timeZone &&
          other.venueName == this.venueName &&
          other.venueAddress == this.venueAddress &&
          other.city == this.city &&
          other.joinUrl == this.joinUrl &&
          other.featured == this.featured &&
          other.attendeeCount == this.attendeeCount &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.previousStartsAt == this.previousStartsAt);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<EventCategory> category;
  final Value<String> organizerId;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<String> timeZone;
  final Value<String?> venueName;
  final Value<String?> venueAddress;
  final Value<String?> city;
  final Value<Uri?> joinUrl;
  final Value<bool> featured;
  final Value<int> attendeeCount;
  final Value<int> capacity;
  final Value<EventStatus> status;
  final Value<DateTime?> previousStartsAt;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.organizerId = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.venueName = const Value.absent(),
    this.venueAddress = const Value.absent(),
    this.city = const Value.absent(),
    this.joinUrl = const Value.absent(),
    this.featured = const Value.absent(),
    this.attendeeCount = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.previousStartsAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required EventCategory category,
    required String organizerId,
    required DateTime startsAt,
    required DateTime endsAt,
    required String timeZone,
    this.venueName = const Value.absent(),
    this.venueAddress = const Value.absent(),
    this.city = const Value.absent(),
    this.joinUrl = const Value.absent(),
    this.featured = const Value.absent(),
    required int attendeeCount,
    required int capacity,
    required EventStatus status,
    this.previousStartsAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       category = Value(category),
       organizerId = Value(organizerId),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt),
       timeZone = Value(timeZone),
       attendeeCount = Value(attendeeCount),
       capacity = Value(capacity),
       status = Value(status);
  static Insertable<EventRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? organizerId,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<String>? timeZone,
    Expression<String>? venueName,
    Expression<String>? venueAddress,
    Expression<String>? city,
    Expression<String>? joinUrl,
    Expression<bool>? featured,
    Expression<int>? attendeeCount,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<DateTime>? previousStartsAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (organizerId != null) 'organizer_id': organizerId,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (timeZone != null) 'time_zone': timeZone,
      if (venueName != null) 'venue_name': venueName,
      if (venueAddress != null) 'venue_address': venueAddress,
      if (city != null) 'city': city,
      if (joinUrl != null) 'join_url': joinUrl,
      if (featured != null) 'featured': featured,
      if (attendeeCount != null) 'attendee_count': attendeeCount,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (previousStartsAt != null) 'previous_starts_at': previousStartsAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<EventCategory>? category,
    Value<String>? organizerId,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<String>? timeZone,
    Value<String?>? venueName,
    Value<String?>? venueAddress,
    Value<String?>? city,
    Value<Uri?>? joinUrl,
    Value<bool>? featured,
    Value<int>? attendeeCount,
    Value<int>? capacity,
    Value<EventStatus>? status,
    Value<DateTime?>? previousStartsAt,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      organizerId: organizerId ?? this.organizerId,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      timeZone: timeZone ?? this.timeZone,
      venueName: venueName ?? this.venueName,
      venueAddress: venueAddress ?? this.venueAddress,
      city: city ?? this.city,
      joinUrl: joinUrl ?? this.joinUrl,
      featured: featured ?? this.featured,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      previousStartsAt: previousStartsAt ?? this.previousStartsAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $EventsTable.$convertercategory.toSql(category.value),
      );
    }
    if (organizerId.present) {
      map['organizer_id'] = Variable<String>(organizerId.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (venueName.present) {
      map['venue_name'] = Variable<String>(venueName.value);
    }
    if (venueAddress.present) {
      map['venue_address'] = Variable<String>(venueAddress.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (joinUrl.present) {
      map['join_url'] = Variable<String>(
        $EventsTable.$converterjoinUrln.toSql(joinUrl.value),
      );
    }
    if (featured.present) {
      map['featured'] = Variable<bool>(featured.value);
    }
    if (attendeeCount.present) {
      map['attendee_count'] = Variable<int>(attendeeCount.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $EventsTable.$converterstatus.toSql(status.value),
      );
    }
    if (previousStartsAt.present) {
      map['previous_starts_at'] = Variable<DateTime>(previousStartsAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('organizerId: $organizerId, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('venueName: $venueName, ')
          ..write('venueAddress: $venueAddress, ')
          ..write('city: $city, ')
          ..write('joinUrl: $joinUrl, ')
          ..write('featured: $featured, ')
          ..write('attendeeCount: $attendeeCount, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('previousStartsAt: $previousStartsAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketOffersTable extends TicketOffers
    with TableInfo<$TicketOffersTable, TicketOfferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TicketType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TicketType>($TicketOffersTable.$convertertype);
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(priceMinor).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    check: () => currency.length.equals(3),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    false,
    check: () => ComparableExpr(capacity).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingMeta = const VerificationMeta(
    'remaining',
  );
  @override
  late final GeneratedColumn<int> remaining = GeneratedColumn<int>(
    'remaining',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    type,
    priceMinor,
    currency,
    capacity,
    remaining,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticket_offers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TicketOfferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('remaining')) {
      context.handle(
        _remainingMeta,
        remaining.isAcceptableOrUnknown(data['remaining']!, _remainingMeta),
      );
    } else if (isInserting) {
      context.missing(_remainingMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId, type};
  @override
  TicketOfferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketOfferRow(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      type: $TicketOffersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      )!,
      remaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TicketOffersTable createAlias(String alias) {
    return $TicketOffersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TicketType, String, String> $convertertype =
      const EnumNameConverter<TicketType>(TicketType.values);
}

class TicketOfferRow extends DataClass implements Insertable<TicketOfferRow> {
  final String eventId;
  final TicketType type;

  /// Minor units (pence, cents): money is never a floating-point number.
  final int priceMinor;
  final String currency;
  final int capacity;
  final int remaining;

  /// The server's order of the ticket types.
  final int sortOrder;
  const TicketOfferRow({
    required this.eventId,
    required this.type,
    required this.priceMinor,
    required this.currency,
    required this.capacity,
    required this.remaining,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    {
      map['type'] = Variable<String>(
        $TicketOffersTable.$convertertype.toSql(type),
      );
    }
    map['price_minor'] = Variable<int>(priceMinor);
    map['currency'] = Variable<String>(currency);
    map['capacity'] = Variable<int>(capacity);
    map['remaining'] = Variable<int>(remaining);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TicketOffersCompanion toCompanion(bool nullToAbsent) {
    return TicketOffersCompanion(
      eventId: Value(eventId),
      type: Value(type),
      priceMinor: Value(priceMinor),
      currency: Value(currency),
      capacity: Value(capacity),
      remaining: Value(remaining),
      sortOrder: Value(sortOrder),
    );
  }

  factory TicketOfferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketOfferRow(
      eventId: serializer.fromJson<String>(json['eventId']),
      type: $TicketOffersTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      capacity: serializer.fromJson<int>(json['capacity']),
      remaining: serializer.fromJson<int>(json['remaining']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'type': serializer.toJson<String>(
        $TicketOffersTable.$convertertype.toJson(type),
      ),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'capacity': serializer.toJson<int>(capacity),
      'remaining': serializer.toJson<int>(remaining),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TicketOfferRow copyWith({
    String? eventId,
    TicketType? type,
    int? priceMinor,
    String? currency,
    int? capacity,
    int? remaining,
    int? sortOrder,
  }) => TicketOfferRow(
    eventId: eventId ?? this.eventId,
    type: type ?? this.type,
    priceMinor: priceMinor ?? this.priceMinor,
    currency: currency ?? this.currency,
    capacity: capacity ?? this.capacity,
    remaining: remaining ?? this.remaining,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TicketOfferRow copyWithCompanion(TicketOffersCompanion data) {
    return TicketOfferRow(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      type: data.type.present ? data.type.value : this.type,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      remaining: data.remaining.present ? data.remaining.value : this.remaining,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketOfferRow(')
          ..write('eventId: $eventId, ')
          ..write('type: $type, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('capacity: $capacity, ')
          ..write('remaining: $remaining, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    type,
    priceMinor,
    currency,
    capacity,
    remaining,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketOfferRow &&
          other.eventId == this.eventId &&
          other.type == this.type &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.capacity == this.capacity &&
          other.remaining == this.remaining &&
          other.sortOrder == this.sortOrder);
}

class TicketOffersCompanion extends UpdateCompanion<TicketOfferRow> {
  final Value<String> eventId;
  final Value<TicketType> type;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<int> capacity;
  final Value<int> remaining;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TicketOffersCompanion({
    this.eventId = const Value.absent(),
    this.type = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.capacity = const Value.absent(),
    this.remaining = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketOffersCompanion.insert({
    required String eventId,
    required TicketType type,
    required int priceMinor,
    required String currency,
    required int capacity,
    required int remaining,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       type = Value(type),
       priceMinor = Value(priceMinor),
       currency = Value(currency),
       capacity = Value(capacity),
       remaining = Value(remaining),
       sortOrder = Value(sortOrder);
  static Insertable<TicketOfferRow> custom({
    Expression<String>? eventId,
    Expression<String>? type,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<int>? capacity,
    Expression<int>? remaining,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (type != null) 'type': type,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (capacity != null) 'capacity': capacity,
      if (remaining != null) 'remaining': remaining,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketOffersCompanion copyWith({
    Value<String>? eventId,
    Value<TicketType>? type,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<int>? capacity,
    Value<int>? remaining,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TicketOffersCompanion(
      eventId: eventId ?? this.eventId,
      type: type ?? this.type,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      capacity: capacity ?? this.capacity,
      remaining: remaining ?? this.remaining,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TicketOffersTable.$convertertype.toSql(type.value),
      );
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (remaining.present) {
      map['remaining'] = Variable<int>(remaining.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketOffersCompanion(')
          ..write('eventId: $eventId, ')
          ..write('type: $type, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('capacity: $capacity, ')
          ..write('remaining: $remaining, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    title,
    speaker,
    room,
    startsAt,
    endsAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    } else if (isInserting) {
      context.missing(_roomMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      speaker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final String eventId;
  final String title;
  final String speaker;
  final String room;
  final DateTime startsAt;
  final DateTime endsAt;
  const SessionRow({
    required this.id,
    required this.eventId,
    required this.title,
    required this.speaker,
    required this.room,
    required this.startsAt,
    required this.endsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['title'] = Variable<String>(title);
    map['speaker'] = Variable<String>(speaker);
    map['room'] = Variable<String>(room);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      title: Value(title),
      speaker: Value(speaker),
      room: Value(room),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      title: serializer.fromJson<String>(json['title']),
      speaker: serializer.fromJson<String>(json['speaker']),
      room: serializer.fromJson<String>(json['room']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'title': serializer.toJson<String>(title),
      'speaker': serializer.toJson<String>(speaker),
      'room': serializer.toJson<String>(room),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
    };
  }

  SessionRow copyWith({
    String? id,
    String? eventId,
    String? title,
    String? speaker,
    String? room,
    DateTime? startsAt,
    DateTime? endsAt,
  }) => SessionRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    title: title ?? this.title,
    speaker: speaker ?? this.speaker,
    room: room ?? this.room,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      title: data.title.present ? data.title.value : this.title,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      room: data.room.present ? data.room.value : this.room,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('title: $title, ')
          ..write('speaker: $speaker, ')
          ..write('room: $room, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, title, speaker, room, startsAt, endsAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.title == this.title &&
          other.speaker == this.speaker &&
          other.room == this.room &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> title;
  final Value<String> speaker;
  final Value<String> room;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.title = const Value.absent(),
    this.speaker = const Value.absent(),
    this.room = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String eventId,
    required String title,
    required String speaker,
    required String room,
    required DateTime startsAt,
    required DateTime endsAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       title = Value(title),
       speaker = Value(speaker),
       room = Value(room),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? title,
    Expression<String>? speaker,
    Expression<String>? room,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (title != null) 'title': title,
      if (speaker != null) 'speaker': speaker,
      if (room != null) 'room': room,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? title,
    Value<String>? speaker,
    Value<String>? room,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      speaker: speaker ?? this.speaker,
      room: room ?? this.room,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('title: $title, ')
          ..write('speaker: $speaker, ')
          ..write('room: $room, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedEventsTable extends SavedEvents
    with TableInfo<$SavedEventsTable, SavedEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  SavedEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedEventRow(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedEventsTable createAlias(String alias) {
    return $SavedEventsTable(attachedDatabase, alias);
  }
}

class SavedEventRow extends DataClass implements Insertable<SavedEventRow> {
  final String eventId;
  final DateTime savedAt;
  const SavedEventRow({required this.eventId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedEventsCompanion toCompanion(bool nullToAbsent) {
    return SavedEventsCompanion(
      eventId: Value(eventId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedEventRow(
      eventId: serializer.fromJson<String>(json['eventId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedEventRow copyWith({String? eventId, DateTime? savedAt}) => SavedEventRow(
    eventId: eventId ?? this.eventId,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedEventRow copyWithCompanion(SavedEventsCompanion data) {
    return SavedEventRow(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedEventRow(')
          ..write('eventId: $eventId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedEventRow &&
          other.eventId == this.eventId &&
          other.savedAt == this.savedAt);
}

class SavedEventsCompanion extends UpdateCompanion<SavedEventRow> {
  final Value<String> eventId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedEventsCompanion({
    this.eventId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedEventsCompanion.insert({
    required String eventId,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       savedAt = Value(savedAt);
  static Insertable<SavedEventRow> custom({
    Expression<String>? eventId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedEventsCompanion copyWith({
    Value<String>? eventId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedEventsCompanion(
      eventId: eventId ?? this.eventId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketsTable extends Tickets with TableInfo<$TicketsTable, TicketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TicketType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TicketType>($TicketsTable.$convertertype);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bookedAtMeta = const VerificationMeta(
    'bookedAt',
  );
  @override
  late final GeneratedColumn<DateTime> bookedAt = GeneratedColumn<DateTime>(
    'booked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    code,
    type,
    note,
    bookedAt,
    cancelledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<TicketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('booked_at')) {
      context.handle(
        _bookedAtMeta,
        bookedAt.isAcceptableOrUnknown(data['booked_at']!, _bookedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_bookedAtMeta);
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TicketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      type: $TicketsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      bookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}booked_at'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
    );
  }

  @override
  $TicketsTable createAlias(String alias) {
    return $TicketsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TicketType, String, String> $convertertype =
      const EnumNameConverter<TicketType>(TicketType.values);
}

class TicketRow extends DataClass implements Insertable<TicketRow> {
  final String id;
  final String eventId;
  final String code;
  final TicketType type;
  final String note;
  final DateTime bookedAt;
  final DateTime? cancelledAt;
  const TicketRow({
    required this.id,
    required this.eventId,
    required this.code,
    required this.type,
    required this.note,
    required this.bookedAt,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['code'] = Variable<String>(code);
    {
      map['type'] = Variable<String>($TicketsTable.$convertertype.toSql(type));
    }
    map['note'] = Variable<String>(note);
    map['booked_at'] = Variable<DateTime>(bookedAt);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      code: Value(code),
      type: Value(type),
      note: Value(note),
      bookedAt: Value(bookedAt),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
    );
  }

  factory TicketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketRow(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      code: serializer.fromJson<String>(json['code']),
      type: $TicketsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      note: serializer.fromJson<String>(json['note']),
      bookedAt: serializer.fromJson<DateTime>(json['bookedAt']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'code': serializer.toJson<String>(code),
      'type': serializer.toJson<String>(
        $TicketsTable.$convertertype.toJson(type),
      ),
      'note': serializer.toJson<String>(note),
      'bookedAt': serializer.toJson<DateTime>(bookedAt),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  TicketRow copyWith({
    String? id,
    String? eventId,
    String? code,
    TicketType? type,
    String? note,
    DateTime? bookedAt,
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => TicketRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    code: code ?? this.code,
    type: type ?? this.type,
    note: note ?? this.note,
    bookedAt: bookedAt ?? this.bookedAt,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  TicketRow copyWithCompanion(TicketsCompanion data) {
    return TicketRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      code: data.code.present ? data.code.value : this.code,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      bookedAt: data.bookedAt.present ? data.bookedAt.value : this.bookedAt,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, code, type, note, bookedAt, cancelledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.code == this.code &&
          other.type == this.type &&
          other.note == this.note &&
          other.bookedAt == this.bookedAt &&
          other.cancelledAt == this.cancelledAt);
}

class TicketsCompanion extends UpdateCompanion<TicketRow> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> code;
  final Value<TicketType> type;
  final Value<String> note;
  final Value<DateTime> bookedAt;
  final Value<DateTime?> cancelledAt;
  final Value<int> rowid;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.code = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.bookedAt = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketsCompanion.insert({
    required String id,
    required String eventId,
    required String code,
    required TicketType type,
    this.note = const Value.absent(),
    required DateTime bookedAt,
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       code = Value(code),
       type = Value(type),
       bookedAt = Value(bookedAt);
  static Insertable<TicketRow> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? code,
    Expression<String>? type,
    Expression<String>? note,
    Expression<DateTime>? bookedAt,
    Expression<DateTime>? cancelledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (code != null) 'code': code,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (bookedAt != null) 'booked_at': bookedAt,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? code,
    Value<TicketType>? type,
    Value<String>? note,
    Value<DateTime>? bookedAt,
    Value<DateTime?>? cancelledAt,
    Value<int>? rowid,
  }) {
    return TicketsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      code: code ?? this.code,
      type: type ?? this.type,
      note: note ?? this.note,
      bookedAt: bookedAt ?? this.bookedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TicketsTable.$convertertype.toSql(type.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (bookedAt.present) {
      map['booked_at'] = Variable<DateTime>(bookedAt.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionBookmarksTable extends SessionBookmarks
    with TableInfo<$SessionBookmarksTable, SessionBookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sessionId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionBookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  SessionBookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionBookmarkRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionBookmarksTable createAlias(String alias) {
    return $SessionBookmarksTable(attachedDatabase, alias);
  }
}

class SessionBookmarkRow extends DataClass
    implements Insertable<SessionBookmarkRow> {
  final String sessionId;
  final DateTime createdAt;
  const SessionBookmarkRow({required this.sessionId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionBookmarksCompanion toCompanion(bool nullToAbsent) {
    return SessionBookmarksCompanion(
      sessionId: Value(sessionId),
      createdAt: Value(createdAt),
    );
  }

  factory SessionBookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionBookmarkRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionBookmarkRow copyWith({String? sessionId, DateTime? createdAt}) =>
      SessionBookmarkRow(
        sessionId: sessionId ?? this.sessionId,
        createdAt: createdAt ?? this.createdAt,
      );
  SessionBookmarkRow copyWithCompanion(SessionBookmarksCompanion data) {
    return SessionBookmarkRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionBookmarkRow(')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionBookmarkRow &&
          other.sessionId == this.sessionId &&
          other.createdAt == this.createdAt);
}

class SessionBookmarksCompanion extends UpdateCompanion<SessionBookmarkRow> {
  final Value<String> sessionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SessionBookmarksCompanion({
    this.sessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionBookmarksCompanion.insert({
    required String sessionId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       createdAt = Value(createdAt);
  static Insertable<SessionBookmarkRow> custom({
    Expression<String>? sessionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionBookmarksCompanion copyWith({
    Value<String>? sessionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SessionBookmarksCompanion(
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionBookmarksCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FollowedOrganizersTable extends FollowedOrganizers
    with TableInfo<$FollowedOrganizersTable, FollowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowedOrganizersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _organizerIdMeta = const VerificationMeta(
    'organizerId',
  );
  @override
  late final GeneratedColumn<String> organizerId = GeneratedColumn<String>(
    'organizer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizers (id)',
    ),
  );
  static const VerificationMeta _followedAtMeta = const VerificationMeta(
    'followedAt',
  );
  @override
  late final GeneratedColumn<DateTime> followedAt = GeneratedColumn<DateTime>(
    'followed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [organizerId, followedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'followed_organizers';
  @override
  VerificationContext validateIntegrity(
    Insertable<FollowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('organizer_id')) {
      context.handle(
        _organizerIdMeta,
        organizerId.isAcceptableOrUnknown(
          data['organizer_id']!,
          _organizerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizerIdMeta);
    }
    if (data.containsKey('followed_at')) {
      context.handle(
        _followedAtMeta,
        followedAt.isAcceptableOrUnknown(data['followed_at']!, _followedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_followedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {organizerId};
  @override
  FollowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowRow(
      organizerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizer_id'],
      )!,
      followedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}followed_at'],
      )!,
    );
  }

  @override
  $FollowedOrganizersTable createAlias(String alias) {
    return $FollowedOrganizersTable(attachedDatabase, alias);
  }
}

class FollowRow extends DataClass implements Insertable<FollowRow> {
  final String organizerId;
  final DateTime followedAt;
  const FollowRow({required this.organizerId, required this.followedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['organizer_id'] = Variable<String>(organizerId);
    map['followed_at'] = Variable<DateTime>(followedAt);
    return map;
  }

  FollowedOrganizersCompanion toCompanion(bool nullToAbsent) {
    return FollowedOrganizersCompanion(
      organizerId: Value(organizerId),
      followedAt: Value(followedAt),
    );
  }

  factory FollowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowRow(
      organizerId: serializer.fromJson<String>(json['organizerId']),
      followedAt: serializer.fromJson<DateTime>(json['followedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'organizerId': serializer.toJson<String>(organizerId),
      'followedAt': serializer.toJson<DateTime>(followedAt),
    };
  }

  FollowRow copyWith({String? organizerId, DateTime? followedAt}) => FollowRow(
    organizerId: organizerId ?? this.organizerId,
    followedAt: followedAt ?? this.followedAt,
  );
  FollowRow copyWithCompanion(FollowedOrganizersCompanion data) {
    return FollowRow(
      organizerId: data.organizerId.present
          ? data.organizerId.value
          : this.organizerId,
      followedAt: data.followedAt.present
          ? data.followedAt.value
          : this.followedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowRow(')
          ..write('organizerId: $organizerId, ')
          ..write('followedAt: $followedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(organizerId, followedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowRow &&
          other.organizerId == this.organizerId &&
          other.followedAt == this.followedAt);
}

class FollowedOrganizersCompanion extends UpdateCompanion<FollowRow> {
  final Value<String> organizerId;
  final Value<DateTime> followedAt;
  final Value<int> rowid;
  const FollowedOrganizersCompanion({
    this.organizerId = const Value.absent(),
    this.followedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowedOrganizersCompanion.insert({
    required String organizerId,
    required DateTime followedAt,
    this.rowid = const Value.absent(),
  }) : organizerId = Value(organizerId),
       followedAt = Value(followedAt);
  static Insertable<FollowRow> custom({
    Expression<String>? organizerId,
    Expression<DateTime>? followedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (organizerId != null) 'organizer_id': organizerId,
      if (followedAt != null) 'followed_at': followedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowedOrganizersCompanion copyWith({
    Value<String>? organizerId,
    Value<DateTime>? followedAt,
    Value<int>? rowid,
  }) {
    return FollowedOrganizersCompanion(
      organizerId: organizerId ?? this.organizerId,
      followedAt: followedAt ?? this.followedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (organizerId.present) {
      map['organizer_id'] = Variable<String>(organizerId.value);
    }
    if (followedAt.present) {
      map['followed_at'] = Variable<DateTime>(followedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowedOrganizersCompanion(')
          ..write('organizerId: $organizerId, ')
          ..write('followedAt: $followedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventRemindersTable extends EventReminders
    with TableInfo<$EventRemindersTable, EventReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  EventReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventReminderRow(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $EventRemindersTable createAlias(String alias) {
    return $EventRemindersTable(attachedDatabase, alias);
  }
}

class EventReminderRow extends DataClass
    implements Insertable<EventReminderRow> {
  final String eventId;
  final bool enabled;
  const EventReminderRow({required this.eventId, required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  EventRemindersCompanion toCompanion(bool nullToAbsent) {
    return EventRemindersCompanion(
      eventId: Value(eventId),
      enabled: Value(enabled),
    );
  }

  factory EventReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventReminderRow(
      eventId: serializer.fromJson<String>(json['eventId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  EventReminderRow copyWith({String? eventId, bool? enabled}) =>
      EventReminderRow(
        eventId: eventId ?? this.eventId,
        enabled: enabled ?? this.enabled,
      );
  EventReminderRow copyWithCompanion(EventRemindersCompanion data) {
    return EventReminderRow(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventReminderRow(')
          ..write('eventId: $eventId, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventReminderRow &&
          other.eventId == this.eventId &&
          other.enabled == this.enabled);
}

class EventRemindersCompanion extends UpdateCompanion<EventReminderRow> {
  final Value<String> eventId;
  final Value<bool> enabled;
  final Value<int> rowid;
  const EventRemindersCompanion({
    this.eventId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventRemindersCompanion.insert({
    required String eventId,
    required bool enabled,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       enabled = Value(enabled);
  static Insertable<EventReminderRow> custom({
    Expression<String>? eventId,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventRemindersCompanion copyWith({
    Value<String>? eventId,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return EventRemindersCompanion(
      eventId: eventId ?? this.eventId,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventRemindersCompanion(')
          ..write('eventId: $eventId, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventChangesTable extends EventChanges
    with TableInfo<$EventChangesTable, EventChangeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventChangeKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EventChangeKind>($EventChangesTable.$converterkind);
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seenMeta = const VerificationMeta('seen');
  @override
  late final GeneratedColumn<bool> seen = GeneratedColumn<bool>(
    'seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventId, kind, detectedAt, seen];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventChangeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('seen')) {
      context.handle(
        _seenMeta,
        seen.isAcceptableOrUnknown(data['seen']!, _seenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventChangeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventChangeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      kind: $EventChangesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
      seen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}seen'],
      )!,
    );
  }

  @override
  $EventChangesTable createAlias(String alias) {
    return $EventChangesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EventChangeKind, String, String> $converterkind =
      const EnumNameConverter<EventChangeKind>(EventChangeKind.values);
}

class EventChangeRow extends DataClass implements Insertable<EventChangeRow> {
  final int id;
  final String eventId;
  final EventChangeKind kind;
  final DateTime detectedAt;
  final bool seen;
  const EventChangeRow({
    required this.id,
    required this.eventId,
    required this.kind,
    required this.detectedAt,
    required this.seen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    {
      map['kind'] = Variable<String>(
        $EventChangesTable.$converterkind.toSql(kind),
      );
    }
    map['detected_at'] = Variable<DateTime>(detectedAt);
    map['seen'] = Variable<bool>(seen);
    return map;
  }

  EventChangesCompanion toCompanion(bool nullToAbsent) {
    return EventChangesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      kind: Value(kind),
      detectedAt: Value(detectedAt),
      seen: Value(seen),
    );
  }

  factory EventChangeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventChangeRow(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      kind: $EventChangesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      seen: serializer.fromJson<bool>(json['seen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'kind': serializer.toJson<String>(
        $EventChangesTable.$converterkind.toJson(kind),
      ),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'seen': serializer.toJson<bool>(seen),
    };
  }

  EventChangeRow copyWith({
    int? id,
    String? eventId,
    EventChangeKind? kind,
    DateTime? detectedAt,
    bool? seen,
  }) => EventChangeRow(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    kind: kind ?? this.kind,
    detectedAt: detectedAt ?? this.detectedAt,
    seen: seen ?? this.seen,
  );
  EventChangeRow copyWithCompanion(EventChangesCompanion data) {
    return EventChangeRow(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      kind: data.kind.present ? data.kind.value : this.kind,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      seen: data.seen.present ? data.seen.value : this.seen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventChangeRow(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('seen: $seen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, kind, detectedAt, seen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventChangeRow &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.kind == this.kind &&
          other.detectedAt == this.detectedAt &&
          other.seen == this.seen);
}

class EventChangesCompanion extends UpdateCompanion<EventChangeRow> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<EventChangeKind> kind;
  final Value<DateTime> detectedAt;
  final Value<bool> seen;
  const EventChangesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.kind = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.seen = const Value.absent(),
  });
  EventChangesCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required EventChangeKind kind,
    required DateTime detectedAt,
    this.seen = const Value.absent(),
  }) : eventId = Value(eventId),
       kind = Value(kind),
       detectedAt = Value(detectedAt);
  static Insertable<EventChangeRow> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? kind,
    Expression<DateTime>? detectedAt,
    Expression<bool>? seen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (kind != null) 'kind': kind,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (seen != null) 'seen': seen,
    });
  }

  EventChangesCompanion copyWith({
    Value<int>? id,
    Value<String>? eventId,
    Value<EventChangeKind>? kind,
    Value<DateTime>? detectedAt,
    Value<bool>? seen,
  }) {
    return EventChangesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      kind: kind ?? this.kind,
      detectedAt: detectedAt ?? this.detectedAt,
      seen: seen ?? this.seen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $EventChangesTable.$converterkind.toSql(kind.value),
      );
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (seen.present) {
      map['seen'] = Variable<bool>(seen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventChangesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('seen: $seen')
          ..write(')'))
        .toString();
  }
}

class $RecentSearchesTable extends RecentSearches
    with TableInfo<$RecentSearchesTable, RecentSearchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentSearchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchedAtMeta = const VerificationMeta(
    'searchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
    'searched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [query, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_searches';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentSearchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(
        _searchedAtMeta,
        searchedAt.isAcceptableOrUnknown(data['searched_at']!, _searchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {query};
  @override
  RecentSearchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentSearchRow(
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      searchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}searched_at'],
      )!,
    );
  }

  @override
  $RecentSearchesTable createAlias(String alias) {
    return $RecentSearchesTable(attachedDatabase, alias);
  }
}

class RecentSearchRow extends DataClass implements Insertable<RecentSearchRow> {
  final String query;
  final DateTime searchedAt;
  const RecentSearchRow({required this.query, required this.searchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query'] = Variable<String>(query);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    return map;
  }

  RecentSearchesCompanion toCompanion(bool nullToAbsent) {
    return RecentSearchesCompanion(
      query: Value(query),
      searchedAt: Value(searchedAt),
    );
  }

  factory RecentSearchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentSearchRow(
      query: serializer.fromJson<String>(json['query']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'query': serializer.toJson<String>(query),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
    };
  }

  RecentSearchRow copyWith({String? query, DateTime? searchedAt}) =>
      RecentSearchRow(
        query: query ?? this.query,
        searchedAt: searchedAt ?? this.searchedAt,
      );
  RecentSearchRow copyWithCompanion(RecentSearchesCompanion data) {
    return RecentSearchRow(
      query: data.query.present ? data.query.value : this.query,
      searchedAt: data.searchedAt.present
          ? data.searchedAt.value
          : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchRow(')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(query, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentSearchRow &&
          other.query == this.query &&
          other.searchedAt == this.searchedAt);
}

class RecentSearchesCompanion extends UpdateCompanion<RecentSearchRow> {
  final Value<String> query;
  final Value<DateTime> searchedAt;
  final Value<int> rowid;
  const RecentSearchesCompanion({
    this.query = const Value.absent(),
    this.searchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentSearchesCompanion.insert({
    required String query,
    required DateTime searchedAt,
    this.rowid = const Value.absent(),
  }) : query = Value(query),
       searchedAt = Value(searchedAt);
  static Insertable<RecentSearchRow> custom({
    Expression<String>? query,
    Expression<DateTime>? searchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (query != null) 'query': query,
      if (searchedAt != null) 'searched_at': searchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentSearchesCompanion copyWith({
    Value<String>? query,
    Value<DateTime>? searchedAt,
    Value<int>? rowid,
  }) {
    return RecentSearchesCompanion(
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchesCompanion(')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    check: () => id.equals(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> avatarUrl =
      GeneratedColumn<String>(
        'avatar_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Uri?>($ProfilesTable.$converteravatarUrln);
  @override
  List<GeneratedColumn> get $columns => [id, name, email, avatarUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      avatarUrl: $ProfilesTable.$converteravatarUrln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}avatar_url'],
        ),
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<Uri, String> $converteravatarUrl = const UriConverter();
  static TypeConverter<Uri?, String?> $converteravatarUrln =
      NullAwareTypeConverter.wrap($converteravatarUrl);
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String name;
  final String email;
  final Uri? avatarUrl;
  const ProfileRow({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(
        $ProfilesTable.$converteravatarUrln.toSql(avatarUrl),
      );
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      avatarUrl: serializer.fromJson<Uri?>(json['avatarUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'avatarUrl': serializer.toJson<Uri?>(avatarUrl),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? name,
    String? email,
    Value<Uri?> avatarUrl = const Value.absent(),
  }) => ProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, avatarUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<Uri?> avatarUrl;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    this.avatarUrl = const Value.absent(),
  }) : name = Value(name),
       email = Value(email);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? avatarUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<Uri?>? avatarUrl,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(
        $ProfilesTable.$converteravatarUrln.toSql(avatarUrl.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganizersTable organizers = $OrganizersTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $TicketOffersTable ticketOffers = $TicketOffersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SavedEventsTable savedEvents = $SavedEventsTable(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $SessionBookmarksTable sessionBookmarks = $SessionBookmarksTable(
    this,
  );
  late final $FollowedOrganizersTable followedOrganizers =
      $FollowedOrganizersTable(this);
  late final $EventRemindersTable eventReminders = $EventRemindersTable(this);
  late final $EventChangesTable eventChanges = $EventChangesTable(this);
  late final $RecentSearchesTable recentSearches = $RecentSearchesTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final Index eventsByStart = Index(
    'events_by_start',
    'CREATE INDEX events_by_start ON events (starts_at)',
  );
  late final Index eventsByCategory = Index(
    'events_by_category',
    'CREATE INDEX events_by_category ON events (category)',
  );
  late final Index eventsByCity = Index(
    'events_by_city',
    'CREATE INDEX events_by_city ON events (city)',
  );
  late final Index sessionsByEvent = Index(
    'sessions_by_event',
    'CREATE INDEX sessions_by_event ON sessions (event_id, starts_at)',
  );
  late final Index ticketsOneActivePerEvent = Index(
    'tickets_one_active_per_event',
    'CREATE UNIQUE INDEX tickets_one_active_per_event ON tickets (event_id) WHERE cancelled_at IS NULL',
  );
  late final CatalogDao catalogDao = CatalogDao(this as AppDatabase);
  late final UserDataDao userDataDao = UserDataDao(this as AppDatabase);
  late final EventsDao eventsDao = EventsDao(this as AppDatabase);
  late final SavedEventsDao savedEventsDao = SavedEventsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organizers,
    events,
    ticketOffers,
    sessions,
    savedEvents,
    tickets,
    sessionBookmarks,
    followedOrganizers,
    eventReminders,
    eventChanges,
    recentSearches,
    profiles,
    eventsByStart,
    eventsByCategory,
    eventsByCity,
    sessionsByEvent,
    ticketsOneActivePerEvent,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_offers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_bookmarks', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$OrganizersTableCreateCompanionBuilder = OrganizersCompanion Function({
  required String id,
  required String name,
  required String bio,
  required int followers,
  required int eventsCount,
  Value<int> rowid,
});
typedef $$OrganizersTableUpdateCompanionBuilder = OrganizersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> bio,
  Value<int> followers,
  Value<int> eventsCount,
  Value<int> rowid,
});

final class $$OrganizersTableReferences
    extends BaseReferences<_$AppDatabase, $OrganizersTable, OrganizerRow> {
  $$OrganizersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<EventRow>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'organizers__id__events__organizer_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.organizerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FollowedOrganizersTable, List<FollowRow>>
  _followedOrganizersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.followedOrganizers,
        aliasName: 'organizers__id__followed_organizers__organizer_id',
      );

  $$FollowedOrganizersTableProcessedTableManager get followedOrganizersRefs {
    final manager = $$FollowedOrganizersTableTableManager(
      $_db,
      $_db.followedOrganizers,
    ).filter((f) => f.organizerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _followedOrganizersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganizersTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizersTable> {
  $$OrganizersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventsCount => $composableBuilder(
    column: $table.eventsCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.organizerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> followedOrganizersRefs(
    Expression<bool> Function($$FollowedOrganizersTableFilterComposer f) f,
  ) {
    final $$FollowedOrganizersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.followedOrganizers,
      getReferencedColumn: (t) => t.organizerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FollowedOrganizersTableFilterComposer(
            $db: $db,
            $table: $db.followedOrganizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizersTable> {
  $$OrganizersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventsCount => $composableBuilder(
    column: $table.eventsCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizersTable> {
  $$OrganizersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<int> get followers =>
      $composableBuilder(column: $table.followers, builder: (column) => column);

  GeneratedColumn<int> get eventsCount => $composableBuilder(
    column: $table.eventsCount,
    builder: (column) => column,
  );

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.organizerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> followedOrganizersRefs<T extends Object>(
    Expression<T> Function($$FollowedOrganizersTableAnnotationComposer a) f,
  ) {
    final $$FollowedOrganizersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.followedOrganizers,
          getReferencedColumn: (t) => t.organizerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FollowedOrganizersTableAnnotationComposer(
                $db: $db,
                $table: $db.followedOrganizers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrganizersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizersTable,
          OrganizerRow,
          $$OrganizersTableFilterComposer,
          $$OrganizersTableOrderingComposer,
          $$OrganizersTableAnnotationComposer,
          $$OrganizersTableCreateCompanionBuilder,
          $$OrganizersTableUpdateCompanionBuilder,
          (OrganizerRow, $$OrganizersTableReferences),
          OrganizerRow,
          PrefetchHooks Function({bool eventsRefs, bool followedOrganizersRefs})
        > {
  $$OrganizersTableTableManager(_$AppDatabase db, $OrganizersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<int> followers = const Value.absent(),
                Value<int> eventsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizersCompanion(
                id: id,
                name: name,
                bio: bio,
                followers: followers,
                eventsCount: eventsCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String bio,
                required int followers,
                required int eventsCount,
                Value<int> rowid = const Value.absent(),
              }) => OrganizersCompanion.insert(
                id: id,
                name: name,
                bio: bio,
                followers: followers,
                eventsCount: eventsCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganizersTable, OrganizerRow>(table),
                  $$OrganizersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({eventsRefs = false, followedOrganizersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eventsRefs) db.events,
                    if (followedOrganizersRefs) db.followedOrganizers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventsRefs)
                        await $_getPrefetchedDataByColumns<
                          OrganizerRow,
                          $OrganizersTable,
                          EventRow,
                          $EventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizersTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizersTableReferences(
                                db,
                                table,
                                p0,
                              ).eventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'organizer_id',
                          typedResults: items,
                        ),
                      if (followedOrganizersRefs)
                        await $_getPrefetchedDataByColumns<
                          OrganizerRow,
                          $OrganizersTable,
                          FollowRow,
                          $FollowedOrganizersTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizersTableReferences
                              ._followedOrganizersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizersTableReferences(
                                db,
                                table,
                                p0,
                              ).followedOrganizersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'organizer_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrganizersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizersTable,
      OrganizerRow,
      $$OrganizersTableFilterComposer,
      $$OrganizersTableOrderingComposer,
      $$OrganizersTableAnnotationComposer,
      $$OrganizersTableCreateCompanionBuilder,
      $$OrganizersTableUpdateCompanionBuilder,
      (OrganizerRow, $$OrganizersTableReferences),
      OrganizerRow,
      PrefetchHooks Function({bool eventsRefs, bool followedOrganizersRefs})
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  required String id,
  required String title,
  required String description,
  required EventCategory category,
  required String organizerId,
  required DateTime startsAt,
  required DateTime endsAt,
  required String timeZone,
  Value<String?> venueName,
  Value<String?> venueAddress,
  Value<String?> city,
  Value<Uri?> joinUrl,
  Value<bool> featured,
  required int attendeeCount,
  required int capacity,
  required EventStatus status,
  Value<DateTime?> previousStartsAt,
  Value<int> rowid,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<EventCategory> category,
  Value<String> organizerId,
  Value<DateTime> startsAt,
  Value<DateTime> endsAt,
  Value<String> timeZone,
  Value<String?> venueName,
  Value<String?> venueAddress,
  Value<String?> city,
  Value<Uri?> joinUrl,
  Value<bool> featured,
  Value<int> attendeeCount,
  Value<int> capacity,
  Value<EventStatus> status,
  Value<DateTime?> previousStartsAt,
  Value<int> rowid,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, EventRow> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizersTable _organizerIdTable(_$AppDatabase db) =>
      db.organizers.createAlias('events__organizer_id__organizers__id');

  $$OrganizersTableProcessedTableManager get organizerId {
    final $_column = $_itemColumn<String>('organizer_id')!;

    final manager = $$OrganizersTableTableManager(
      $_db,
      $_db.organizers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TicketOffersTable, List<TicketOfferRow>>
  _ticketOffersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ticketOffers,
    aliasName: 'events__id__ticket_offers__event_id',
  );

  $$TicketOffersTableProcessedTableManager get ticketOffersRefs {
    final manager = $$TicketOffersTableTableManager(
      $_db,
      $_db.ticketOffers,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketOffersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<SessionRow>>
  _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'events__id__sessions__event_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavedEventsTable, List<SavedEventRow>>
  _savedEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savedEvents,
    aliasName: 'events__id__saved_events__event_id',
  );

  $$SavedEventsTableProcessedTableManager get savedEventsRefs {
    final manager = $$SavedEventsTableTableManager(
      $_db,
      $_db.savedEvents,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_savedEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<TicketRow>> _ticketsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: 'events__id__tickets__event_id',
  );

  $$TicketsTableProcessedTableManager get ticketsRefs {
    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventRemindersTable, List<EventReminderRow>>
  _eventRemindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventReminders,
    aliasName: 'events__id__event_reminders__event_id',
  );

  $$EventRemindersTableProcessedTableManager get eventRemindersRefs {
    final manager = $$EventRemindersTableTableManager(
      $_db,
      $_db.eventReminders,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventRemindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventChangesTable, List<EventChangeRow>>
  _eventChangesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventChanges,
    aliasName: 'events__id__event_changes__event_id',
  );

  $$EventChangesTableProcessedTableManager get eventChangesRefs {
    final manager = $$EventChangesTableTableManager(
      $_db,
      $_db.eventChanges,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventChangesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventCategory, EventCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venueAddress => $composableBuilder(
    column: $table.venueAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get joinUrl =>
      $composableBuilder(
        column: $table.joinUrl,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get featured => $composableBuilder(
    column: $table.featured,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendeeCount => $composableBuilder(
    column: $table.attendeeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventStatus, EventStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get previousStartsAt => $composableBuilder(
    column: $table.previousStartsAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizersTableFilterComposer get organizerId {
    final $$OrganizersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableFilterComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketOffersRefs(
    Expression<bool> Function($$TicketOffersTableFilterComposer f) f,
  ) {
    final $$TicketOffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketOffers,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketOffersTableFilterComposer(
            $db: $db,
            $table: $db.ticketOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savedEventsRefs(
    Expression<bool> Function($$SavedEventsTableFilterComposer f) f,
  ) {
    final $$SavedEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedEventsTableFilterComposer(
            $db: $db,
            $table: $db.savedEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ticketsRefs(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventRemindersRefs(
    Expression<bool> Function($$EventRemindersTableFilterComposer f) f,
  ) {
    final $$EventRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventReminders,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventRemindersTableFilterComposer(
            $db: $db,
            $table: $db.eventReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventChangesRefs(
    Expression<bool> Function($$EventChangesTableFilterComposer f) f,
  ) {
    final $$EventChangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventChanges,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventChangesTableFilterComposer(
            $db: $db,
            $table: $db.eventChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venueName => $composableBuilder(
    column: $table.venueName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venueAddress => $composableBuilder(
    column: $table.venueAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinUrl => $composableBuilder(
    column: $table.joinUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get featured => $composableBuilder(
    column: $table.featured,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendeeCount => $composableBuilder(
    column: $table.attendeeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get previousStartsAt => $composableBuilder(
    column: $table.previousStartsAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizersTableOrderingComposer get organizerId {
    final $$OrganizersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableOrderingComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EventCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<String> get venueName =>
      $composableBuilder(column: $table.venueName, builder: (column) => column);

  GeneratedColumn<String> get venueAddress => $composableBuilder(
    column: $table.venueAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get joinUrl =>
      $composableBuilder(column: $table.joinUrl, builder: (column) => column);

  GeneratedColumn<bool> get featured =>
      $composableBuilder(column: $table.featured, builder: (column) => column);

  GeneratedColumn<int> get attendeeCount => $composableBuilder(
    column: $table.attendeeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EventStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get previousStartsAt => $composableBuilder(
    column: $table.previousStartsAt,
    builder: (column) => column,
  );

  $$OrganizersTableAnnotationComposer get organizerId {
    final $$OrganizersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableAnnotationComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ticketOffersRefs<T extends Object>(
    Expression<T> Function($$TicketOffersTableAnnotationComposer a) f,
  ) {
    final $$TicketOffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketOffers,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketOffersTableAnnotationComposer(
            $db: $db,
            $table: $db.ticketOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savedEventsRefs<T extends Object>(
    Expression<T> Function($$SavedEventsTableAnnotationComposer a) f,
  ) {
    final $$SavedEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.savedEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ticketsRefs<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventRemindersRefs<T extends Object>(
    Expression<T> Function($$EventRemindersTableAnnotationComposer a) f,
  ) {
    final $$EventRemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventReminders,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventRemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.eventReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventChangesRefs<T extends Object>(
    Expression<T> Function($$EventChangesTableAnnotationComposer a) f,
  ) {
    final $$EventChangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventChanges,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventChangesTableAnnotationComposer(
            $db: $db,
            $table: $db.eventChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventRow,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventRow, $$EventsTableReferences),
          EventRow,
          PrefetchHooks Function({
            bool organizerId,
            bool ticketOffersRefs,
            bool sessionsRefs,
            bool savedEventsRefs,
            bool ticketsRefs,
            bool eventRemindersRefs,
            bool eventChangesRefs,
          })
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<EventCategory> category = const Value.absent(),
                Value<String> organizerId = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String?> venueName = const Value.absent(),
                Value<String?> venueAddress = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<Uri?> joinUrl = const Value.absent(),
                Value<bool> featured = const Value.absent(),
                Value<int> attendeeCount = const Value.absent(),
                Value<int> capacity = const Value.absent(),
                Value<EventStatus> status = const Value.absent(),
                Value<DateTime?> previousStartsAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                organizerId: organizerId,
                startsAt: startsAt,
                endsAt: endsAt,
                timeZone: timeZone,
                venueName: venueName,
                venueAddress: venueAddress,
                city: city,
                joinUrl: joinUrl,
                featured: featured,
                attendeeCount: attendeeCount,
                capacity: capacity,
                status: status,
                previousStartsAt: previousStartsAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required EventCategory category,
                required String organizerId,
                required DateTime startsAt,
                required DateTime endsAt,
                required String timeZone,
                Value<String?> venueName = const Value.absent(),
                Value<String?> venueAddress = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<Uri?> joinUrl = const Value.absent(),
                Value<bool> featured = const Value.absent(),
                required int attendeeCount,
                required int capacity,
                required EventStatus status,
                Value<DateTime?> previousStartsAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                organizerId: organizerId,
                startsAt: startsAt,
                endsAt: endsAt,
                timeZone: timeZone,
                venueName: venueName,
                venueAddress: venueAddress,
                city: city,
                joinUrl: joinUrl,
                featured: featured,
                attendeeCount: attendeeCount,
                capacity: capacity,
                status: status,
                previousStartsAt: previousStartsAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, EventRow>(table),
                  $$EventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizerId = false,
                ticketOffersRefs = false,
                sessionsRefs = false,
                savedEventsRefs = false,
                ticketsRefs = false,
                eventRemindersRefs = false,
                eventChangesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketOffersRefs) db.ticketOffers,
                    if (sessionsRefs) db.sessions,
                    if (savedEventsRefs) db.savedEvents,
                    if (ticketsRefs) db.tickets,
                    if (eventRemindersRefs) db.eventReminders,
                    if (eventChangesRefs) db.eventChanges,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizerId,
                            referencedTable: $$EventsTableReferences
                                ._organizerIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._organizerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketOffersRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          TicketOfferRow,
                          $TicketOffersTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._ticketOffersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketOffersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          SessionRow,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (savedEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          SavedEventRow,
                          $SavedEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._savedEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).savedEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (ticketsRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          TicketRow,
                          $TicketsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._ticketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (eventRemindersRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          EventReminderRow,
                          $EventRemindersTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._eventRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventRemindersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (eventChangesRefs)
                        await $_getPrefetchedDataByColumns<
                          EventRow,
                          $EventsTable,
                          EventChangeRow,
                          $EventChangesTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._eventChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventChangesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventRow,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventRow, $$EventsTableReferences),
      EventRow,
      PrefetchHooks Function({
        bool organizerId,
        bool ticketOffersRefs,
        bool sessionsRefs,
        bool savedEventsRefs,
        bool ticketsRefs,
        bool eventRemindersRefs,
        bool eventChangesRefs,
      })
    >;
typedef $$TicketOffersTableCreateCompanionBuilder =
    TicketOffersCompanion Function({
      required String eventId,
      required TicketType type,
      required int priceMinor,
      required String currency,
      required int capacity,
      required int remaining,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$TicketOffersTableUpdateCompanionBuilder =
    TicketOffersCompanion Function({
      Value<String> eventId,
      Value<TicketType> type,
      Value<int> priceMinor,
      Value<String> currency,
      Value<int> capacity,
      Value<int> remaining,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TicketOffersTableReferences
    extends BaseReferences<_$AppDatabase, $TicketOffersTable, TicketOfferRow> {
  $$TicketOffersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('ticket_offers__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TicketOffersTableFilterComposer
    extends Composer<_$AppDatabase, $TicketOffersTable> {
  $$TicketOffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<TicketType, TicketType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketOffersTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketOffersTable> {
  $$TicketOffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketOffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketOffersTable> {
  $$TicketOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<TicketType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<int> get remaining =>
      $composableBuilder(column: $table.remaining, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketOffersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicketOffersTable,
          TicketOfferRow,
          $$TicketOffersTableFilterComposer,
          $$TicketOffersTableOrderingComposer,
          $$TicketOffersTableAnnotationComposer,
          $$TicketOffersTableCreateCompanionBuilder,
          $$TicketOffersTableUpdateCompanionBuilder,
          (TicketOfferRow, $$TicketOffersTableReferences),
          TicketOfferRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$TicketOffersTableTableManager(_$AppDatabase db, $TicketOffersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<TicketType> type = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> capacity = const Value.absent(),
                Value<int> remaining = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketOffersCompanion(
                eventId: eventId,
                type: type,
                priceMinor: priceMinor,
                currency: currency,
                capacity: capacity,
                remaining: remaining,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required TicketType type,
                required int priceMinor,
                required String currency,
                required int capacity,
                required int remaining,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => TicketOffersCompanion.insert(
                eventId: eventId,
                type: type,
                priceMinor: priceMinor,
                currency: currency,
                capacity: capacity,
                remaining: remaining,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TicketOffersTable, TicketOfferRow>(table),
                  $$TicketOffersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$TicketOffersTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$TicketOffersTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TicketOffersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicketOffersTable,
      TicketOfferRow,
      $$TicketOffersTableFilterComposer,
      $$TicketOffersTableOrderingComposer,
      $$TicketOffersTableAnnotationComposer,
      $$TicketOffersTableCreateCompanionBuilder,
      $$TicketOffersTableUpdateCompanionBuilder,
      (TicketOfferRow, $$TicketOffersTableReferences),
      TicketOfferRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String eventId,
  required String title,
  required String speaker,
  required String room,
  required DateTime startsAt,
  required DateTime endsAt,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> eventId,
  Value<String> title,
  Value<String> speaker,
  Value<String> room,
  Value<DateTime> startsAt,
  Value<DateTime> endsAt,
  Value<int> rowid,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('sessions__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionBookmarksTable, List<SessionBookmarkRow>>
  _sessionBookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionBookmarks,
    aliasName: 'sessions__id__session_bookmarks__session_id',
  );

  $$SessionBookmarksTableProcessedTableManager get sessionBookmarksRefs {
    final manager = $$SessionBookmarksTableTableManager(
      $_db,
      $_db.sessionBookmarks,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionBookmarksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionBookmarksRefs(
    Expression<bool> Function($$SessionBookmarksTableFilterComposer f) f,
  ) {
    final $$SessionBookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionBookmarks,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionBookmarksTableFilterComposer(
            $db: $db,
            $table: $db.sessionBookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionBookmarksRefs<T extends Object>(
    Expression<T> Function($$SessionBookmarksTableAnnotationComposer a) f,
  ) {
    final $$SessionBookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionBookmarks,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionBookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionBookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRow, $$SessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({bool eventId, bool sessionBookmarksRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> speaker = const Value.absent(),
                Value<String> room = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                eventId: eventId,
                title: title,
                speaker: speaker,
                room: room,
                startsAt: startsAt,
                endsAt: endsAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String title,
                required String speaker,
                required String room,
                required DateTime startsAt,
                required DateTime endsAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                eventId: eventId,
                title: title,
                speaker: speaker,
                room: room,
                startsAt: startsAt,
                endsAt: endsAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, SessionRow>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({eventId = false, sessionBookmarksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionBookmarksRefs) db.sessionBookmarks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (eventId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$SessionsTableReferences
                                ._eventIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._eventIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionBookmarksRefs)
                        await $_getPrefetchedDataByColumns<
                          SessionRow,
                          $SessionsTable,
                          SessionBookmarkRow,
                          $SessionBookmarksTable
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._sessionBookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionBookmarksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, $$SessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({bool eventId, bool sessionBookmarksRefs})
    >;
typedef $$SavedEventsTableCreateCompanionBuilder =
    SavedEventsCompanion Function({
      required String eventId,
      required DateTime savedAt,
      Value<int> rowid,
    });
typedef $$SavedEventsTableUpdateCompanionBuilder =
    SavedEventsCompanion Function({
      Value<String> eventId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

final class $$SavedEventsTableReferences
    extends BaseReferences<_$AppDatabase, $SavedEventsTable, SavedEventRow> {
  $$SavedEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('saved_events__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavedEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedEventsTable> {
  $$SavedEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedEventsTable> {
  $$SavedEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedEventsTable> {
  $$SavedEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedEventsTable,
          SavedEventRow,
          $$SavedEventsTableFilterComposer,
          $$SavedEventsTableOrderingComposer,
          $$SavedEventsTableAnnotationComposer,
          $$SavedEventsTableCreateCompanionBuilder,
          $$SavedEventsTableUpdateCompanionBuilder,
          (SavedEventRow, $$SavedEventsTableReferences),
          SavedEventRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$SavedEventsTableTableManager(_$AppDatabase db, $SavedEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedEventsCompanion(
                eventId: eventId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required DateTime savedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedEventsCompanion.insert(
                eventId: eventId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedEventsTable, SavedEventRow>(table),
                  $$SavedEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$SavedEventsTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$SavedEventsTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SavedEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedEventsTable,
      SavedEventRow,
      $$SavedEventsTableFilterComposer,
      $$SavedEventsTableOrderingComposer,
      $$SavedEventsTableAnnotationComposer,
      $$SavedEventsTableCreateCompanionBuilder,
      $$SavedEventsTableUpdateCompanionBuilder,
      (SavedEventRow, $$SavedEventsTableReferences),
      SavedEventRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$TicketsTableCreateCompanionBuilder = TicketsCompanion Function({
  required String id,
  required String eventId,
  required String code,
  required TicketType type,
  Value<String> note,
  required DateTime bookedAt,
  Value<DateTime?> cancelledAt,
  Value<int> rowid,
});
typedef $$TicketsTableUpdateCompanionBuilder = TicketsCompanion Function({
  Value<String> id,
  Value<String> eventId,
  Value<String> code,
  Value<TicketType> type,
  Value<String> note,
  Value<DateTime> bookedAt,
  Value<DateTime?> cancelledAt,
  Value<int> rowid,
});

final class $$TicketsTableReferences
    extends BaseReferences<_$AppDatabase, $TicketsTable, TicketRow> {
  $$TicketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('tickets__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TicketsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TicketType, TicketType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bookedAt => $composableBuilder(
    column: $table.bookedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bookedAt => $composableBuilder(
    column: $table.bookedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TicketType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get bookedAt =>
      $composableBuilder(column: $table.bookedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicketsTable,
          TicketRow,
          $$TicketsTableFilterComposer,
          $$TicketsTableOrderingComposer,
          $$TicketsTableAnnotationComposer,
          $$TicketsTableCreateCompanionBuilder,
          $$TicketsTableUpdateCompanionBuilder,
          (TicketRow, $$TicketsTableReferences),
          TicketRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$TicketsTableTableManager(_$AppDatabase db, $TicketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<TicketType> type = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> bookedAt = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                eventId: eventId,
                code: code,
                type: type,
                note: note,
                bookedAt: bookedAt,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String code,
                required TicketType type,
                Value<String> note = const Value.absent(),
                required DateTime bookedAt,
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion.insert(
                id: id,
                eventId: eventId,
                code: code,
                type: type,
                note: note,
                bookedAt: bookedAt,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TicketsTable, TicketRow>(table),
                  $$TicketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$TicketsTableReferences._eventIdTable(
                          db,
                        ),
                        referencedColumn: $$TicketsTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicketsTable,
      TicketRow,
      $$TicketsTableFilterComposer,
      $$TicketsTableOrderingComposer,
      $$TicketsTableAnnotationComposer,
      $$TicketsTableCreateCompanionBuilder,
      $$TicketsTableUpdateCompanionBuilder,
      (TicketRow, $$TicketsTableReferences),
      TicketRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$SessionBookmarksTableCreateCompanionBuilder =
    SessionBookmarksCompanion Function({
      required String sessionId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SessionBookmarksTableUpdateCompanionBuilder =
    SessionBookmarksCompanion Function({
      Value<String> sessionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SessionBookmarksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SessionBookmarksTable,
          SessionBookmarkRow
        > {
  $$SessionBookmarksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_bookmarks__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $SessionBookmarksTable> {
  $$SessionBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionBookmarksTable> {
  $$SessionBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionBookmarksTable> {
  $$SessionBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionBookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionBookmarksTable,
          SessionBookmarkRow,
          $$SessionBookmarksTableFilterComposer,
          $$SessionBookmarksTableOrderingComposer,
          $$SessionBookmarksTableAnnotationComposer,
          $$SessionBookmarksTableCreateCompanionBuilder,
          $$SessionBookmarksTableUpdateCompanionBuilder,
          (SessionBookmarkRow, $$SessionBookmarksTableReferences),
          SessionBookmarkRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SessionBookmarksTableTableManager(
    _$AppDatabase db,
    $SessionBookmarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionBookmarksCompanion(
                sessionId: sessionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionBookmarksCompanion.insert(
                sessionId: sessionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionBookmarksTable, SessionBookmarkRow>(
                    table,
                  ),
                  $$SessionBookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionBookmarksTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionBookmarksTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionBookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionBookmarksTable,
      SessionBookmarkRow,
      $$SessionBookmarksTableFilterComposer,
      $$SessionBookmarksTableOrderingComposer,
      $$SessionBookmarksTableAnnotationComposer,
      $$SessionBookmarksTableCreateCompanionBuilder,
      $$SessionBookmarksTableUpdateCompanionBuilder,
      (SessionBookmarkRow, $$SessionBookmarksTableReferences),
      SessionBookmarkRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$FollowedOrganizersTableCreateCompanionBuilder =
    FollowedOrganizersCompanion Function({
      required String organizerId,
      required DateTime followedAt,
      Value<int> rowid,
    });
typedef $$FollowedOrganizersTableUpdateCompanionBuilder =
    FollowedOrganizersCompanion Function({
      Value<String> organizerId,
      Value<DateTime> followedAt,
      Value<int> rowid,
    });

final class $$FollowedOrganizersTableReferences
    extends BaseReferences<_$AppDatabase, $FollowedOrganizersTable, FollowRow> {
  $$FollowedOrganizersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganizersTable _organizerIdTable(_$AppDatabase db) => db.organizers
      .createAlias('followed_organizers__organizer_id__organizers__id');

  $$OrganizersTableProcessedTableManager get organizerId {
    final $_column = $_itemColumn<String>('organizer_id')!;

    final manager = $$OrganizersTableTableManager(
      $_db,
      $_db.organizers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FollowedOrganizersTableFilterComposer
    extends Composer<_$AppDatabase, $FollowedOrganizersTable> {
  $$FollowedOrganizersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizersTableFilterComposer get organizerId {
    final $$OrganizersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableFilterComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FollowedOrganizersTableOrderingComposer
    extends Composer<_$AppDatabase, $FollowedOrganizersTable> {
  $$FollowedOrganizersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizersTableOrderingComposer get organizerId {
    final $$OrganizersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableOrderingComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FollowedOrganizersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FollowedOrganizersTable> {
  $$FollowedOrganizersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => column,
  );

  $$OrganizersTableAnnotationComposer get organizerId {
    final $$OrganizersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizerId,
      referencedTable: $db.organizers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizersTableAnnotationComposer(
            $db: $db,
            $table: $db.organizers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FollowedOrganizersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FollowedOrganizersTable,
          FollowRow,
          $$FollowedOrganizersTableFilterComposer,
          $$FollowedOrganizersTableOrderingComposer,
          $$FollowedOrganizersTableAnnotationComposer,
          $$FollowedOrganizersTableCreateCompanionBuilder,
          $$FollowedOrganizersTableUpdateCompanionBuilder,
          (FollowRow, $$FollowedOrganizersTableReferences),
          FollowRow,
          PrefetchHooks Function({bool organizerId})
        > {
  $$FollowedOrganizersTableTableManager(
    _$AppDatabase db,
    $FollowedOrganizersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FollowedOrganizersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FollowedOrganizersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FollowedOrganizersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> organizerId = const Value.absent(),
                Value<DateTime> followedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowedOrganizersCompanion(
                organizerId: organizerId,
                followedAt: followedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String organizerId,
                required DateTime followedAt,
                Value<int> rowid = const Value.absent(),
              }) => FollowedOrganizersCompanion.insert(
                organizerId: organizerId,
                followedAt: followedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FollowedOrganizersTable, FollowRow>(table),
                  $$FollowedOrganizersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organizerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (organizerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organizerId,
                        referencedTable: $$FollowedOrganizersTableReferences
                            ._organizerIdTable(db),
                        referencedColumn: $$FollowedOrganizersTableReferences
                            ._organizerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FollowedOrganizersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FollowedOrganizersTable,
      FollowRow,
      $$FollowedOrganizersTableFilterComposer,
      $$FollowedOrganizersTableOrderingComposer,
      $$FollowedOrganizersTableAnnotationComposer,
      $$FollowedOrganizersTableCreateCompanionBuilder,
      $$FollowedOrganizersTableUpdateCompanionBuilder,
      (FollowRow, $$FollowedOrganizersTableReferences),
      FollowRow,
      PrefetchHooks Function({bool organizerId})
    >;
typedef $$EventRemindersTableCreateCompanionBuilder =
    EventRemindersCompanion Function({
      required String eventId,
      required bool enabled,
      Value<int> rowid,
    });
typedef $$EventRemindersTableUpdateCompanionBuilder =
    EventRemindersCompanion Function({
      Value<String> eventId,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$EventRemindersTableReferences
    extends
        BaseReferences<_$AppDatabase, $EventRemindersTable, EventReminderRow> {
  $$EventRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('event_reminders__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $EventRemindersTable> {
  $$EventRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $EventRemindersTable> {
  $$EventRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventRemindersTable> {
  $$EventRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventRemindersTable,
          EventReminderRow,
          $$EventRemindersTableFilterComposer,
          $$EventRemindersTableOrderingComposer,
          $$EventRemindersTableAnnotationComposer,
          $$EventRemindersTableCreateCompanionBuilder,
          $$EventRemindersTableUpdateCompanionBuilder,
          (EventReminderRow, $$EventRemindersTableReferences),
          EventReminderRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventRemindersTableTableManager(
    _$AppDatabase db,
    $EventRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventRemindersCompanion(
                eventId: eventId,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required bool enabled,
                Value<int> rowid = const Value.absent(),
              }) => EventRemindersCompanion.insert(
                eventId: eventId,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventRemindersTable, EventReminderRow>(table),
                  $$EventRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$EventRemindersTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$EventRemindersTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventRemindersTable,
      EventReminderRow,
      $$EventRemindersTableFilterComposer,
      $$EventRemindersTableOrderingComposer,
      $$EventRemindersTableAnnotationComposer,
      $$EventRemindersTableCreateCompanionBuilder,
      $$EventRemindersTableUpdateCompanionBuilder,
      (EventReminderRow, $$EventRemindersTableReferences),
      EventReminderRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$EventChangesTableCreateCompanionBuilder =
    EventChangesCompanion Function({
      Value<int> id,
      required String eventId,
      required EventChangeKind kind,
      required DateTime detectedAt,
      Value<bool> seen,
    });
typedef $$EventChangesTableUpdateCompanionBuilder =
    EventChangesCompanion Function({
      Value<int> id,
      Value<String> eventId,
      Value<EventChangeKind> kind,
      Value<DateTime> detectedAt,
      Value<bool> seen,
    });

final class $$EventChangesTableReferences
    extends BaseReferences<_$AppDatabase, $EventChangesTable, EventChangeRow> {
  $$EventChangesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('event_changes__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventChangesTableFilterComposer
    extends Composer<_$AppDatabase, $EventChangesTable> {
  $$EventChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventChangeKind, EventChangeKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $EventChangesTable> {
  $$EventChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventChangesTable> {
  $$EventChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EventChangeKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get seen =>
      $composableBuilder(column: $table.seen, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventChangesTable,
          EventChangeRow,
          $$EventChangesTableFilterComposer,
          $$EventChangesTableOrderingComposer,
          $$EventChangesTableAnnotationComposer,
          $$EventChangesTableCreateCompanionBuilder,
          $$EventChangesTableUpdateCompanionBuilder,
          (EventChangeRow, $$EventChangesTableReferences),
          EventChangeRow,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventChangesTableTableManager(_$AppDatabase db, $EventChangesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<EventChangeKind> kind = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<bool> seen = const Value.absent(),
              }) => EventChangesCompanion(
                id: id,
                eventId: eventId,
                kind: kind,
                detectedAt: detectedAt,
                seen: seen,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventId,
                required EventChangeKind kind,
                required DateTime detectedAt,
                Value<bool> seen = const Value.absent(),
              }) => EventChangesCompanion.insert(
                id: id,
                eventId: eventId,
                kind: kind,
                detectedAt: detectedAt,
                seen: seen,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventChangesTable, EventChangeRow>(table),
                  $$EventChangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$EventChangesTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$EventChangesTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventChangesTable,
      EventChangeRow,
      $$EventChangesTableFilterComposer,
      $$EventChangesTableOrderingComposer,
      $$EventChangesTableAnnotationComposer,
      $$EventChangesTableCreateCompanionBuilder,
      $$EventChangesTableUpdateCompanionBuilder,
      (EventChangeRow, $$EventChangesTableReferences),
      EventChangeRow,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$RecentSearchesTableCreateCompanionBuilder =
    RecentSearchesCompanion Function({
      required String query,
      required DateTime searchedAt,
      Value<int> rowid,
    });
typedef $$RecentSearchesTableUpdateCompanionBuilder =
    RecentSearchesCompanion Function({
      Value<String> query,
      Value<DateTime> searchedAt,
      Value<int> rowid,
    });

class $$RecentSearchesTableFilterComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentSearchesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentSearchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => column,
  );
}

class $$RecentSearchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentSearchesTable,
          RecentSearchRow,
          $$RecentSearchesTableFilterComposer,
          $$RecentSearchesTableOrderingComposer,
          $$RecentSearchesTableAnnotationComposer,
          $$RecentSearchesTableCreateCompanionBuilder,
          $$RecentSearchesTableUpdateCompanionBuilder,
          (
            RecentSearchRow,
            BaseReferences<
              _$AppDatabase,
              $RecentSearchesTable,
              RecentSearchRow
            >,
          ),
          RecentSearchRow,
          PrefetchHooks Function()
        > {
  $$RecentSearchesTableTableManager(
    _$AppDatabase db,
    $RecentSearchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentSearchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentSearchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentSearchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> query = const Value.absent(),
                Value<DateTime> searchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentSearchesCompanion(
                query: query,
                searchedAt: searchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String query,
                required DateTime searchedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecentSearchesCompanion.insert(
                query: query,
                searchedAt: searchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentSearchesTable, RecentSearchRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecentSearchesTable,
                    RecentSearchRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentSearchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentSearchesTable,
      RecentSearchRow,
      $$RecentSearchesTableFilterComposer,
      $$RecentSearchesTableOrderingComposer,
      $$RecentSearchesTableAnnotationComposer,
      $$RecentSearchesTableCreateCompanionBuilder,
      $$RecentSearchesTableUpdateCompanionBuilder,
      (
        RecentSearchRow,
        BaseReferences<_$AppDatabase, $RecentSearchesTable, RecentSearchRow>,
      ),
      RecentSearchRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  Value<Uri?> avatarUrl,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<Uri?> avatarUrl,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get avatarUrl =>
      $composableBuilder(
        column: $table.avatarUrl,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<Uri?> avatarUrl = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String email,
                Value<Uri?> avatarUrl = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$TicketOffersTableTableManager get ticketOffers =>
      $$TicketOffersTableTableManager(_db, _db.ticketOffers);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SavedEventsTableTableManager get savedEvents =>
      $$SavedEventsTableTableManager(_db, _db.savedEvents);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$SessionBookmarksTableTableManager get sessionBookmarks =>
      $$SessionBookmarksTableTableManager(_db, _db.sessionBookmarks);
  $$FollowedOrganizersTableTableManager get followedOrganizers =>
      $$FollowedOrganizersTableTableManager(_db, _db.followedOrganizers);
  $$EventRemindersTableTableManager get eventReminders =>
      $$EventRemindersTableTableManager(_db, _db.eventReminders);
  $$EventChangesTableTableManager get eventChanges =>
      $$EventChangesTableTableManager(_db, _db.eventChanges);
  $$RecentSearchesTableTableManager get recentSearches =>
      $$RecentSearchesTableTableManager(_db, _db.recentSearches);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
}
