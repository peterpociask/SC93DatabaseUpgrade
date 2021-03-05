print('--------------------------------------------------------');
print('Start upgrading [collection] database from 9.0.2 to 9.1');
print('--------------------------------------------------------');

print('Start dropping all the non _id indexes. The defulat indexes on the _id fields cannot be dropped.');

print('Dropping indexes from the [Changes] collection.');

db.Changes.dropIndex('lm_DateTime_1_TTL');

print('Dropping indexes from the [Contacts] collection.');

db.Contacts.dropIndex('crdt_1');

print('Dropping indexes from the [Interactions] collection.');

db.Interactions.dropIndex('_id.parent_id_1_start_dt_-1_end_dt_-1');
db.Interactions.dropIndex('start_dt_1_lm_-1__id.id_-1');

print('Finish dropping all the non _id indexes...');

print('Start creating indexes in background for the [Changes] collection...');

// The value of the setting is equal to 120 hours (3600 seconds/hour * 120 hours = 432000 seconds).
db.Changes.createIndex( { 'lmdt': 1 }, { name: 'lm_DateTime_1_TTL', expireAfterSeconds: 432000, background: true} );
print('  - Index creation in background - [lm_DateTime_1_TTL]');

print('Start creating indexes in background for the [Contacts] collection...');

db.Contacts.createIndex( { 'created_dt': 1, '_id.id': 1, 'percentile_d': 1}, { name: 'created_dt_1__id.id_1_percentile_d_1', background: true} );
print('  - Index creation in background - [created_dt_1__id.id_1_percentile_d_1]');

print('Start creating indexes in background for the [Interactions] collection...');

db.Interactions.createIndex( { '_id.parent_id': 1, 'start_dt': -1, 'end_dt': -1 }, { name: '_id.parent_id_1_start_dt_-1_end_dt_-1', background: true}  );
print('  - Index creation in background - [_id.parent_id_1_start_dt_-1_end_dt_-1]');

db.Interactions.createIndex( { 'start_dt': 1, 'lm': -1, 'percentile_d': 1, '_id.id': -1 }, { name: 'start_dt_1_lm_-1_percentile_d_1_id.id_-1', background: true}  );
print('  - Index creation in background - [start_dt_1_lm_-1_percentile_d_1_id.id_-1]');

print('--------------------------------------------------------');
print('Finish upgrade.');
print('--------------------------------------------------------');