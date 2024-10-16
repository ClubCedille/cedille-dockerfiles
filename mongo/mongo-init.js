db.auth(process.env.MONGO_INITDB_ROOT_USERNAME, process.env.MONGO_INITDB_ROOT_PASSWORD)

db = db.getSiblingDB('admin')

db.createUser({
  user: process.env.MONGO_USER,
  pwd: process.env.MONGO_PASSWORD,
  roles: [
    {
      role: 'root',
      db: 'admin',
    },
  ],
});

db.dropUser(process.env.MONGO_INITDB_ROOT_USERNAME);