// 创建 admin 用户
// db.createUser({
//   user: "admin",
//   pwd: "PxwyAx84RR4r1W4HI",
//   roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
// });

var rootUser = 'root';
var rootPassword = 'wViWwYOUsmRbd0KAMU';

var dbName = 'cuckoo';
var user = 'cuckoo';
var password = 'ATyGEw2rjdZgoclBXQ';

db = connect(`${rootUser}:${rootPassword}@localhost:27017/admin`);
db = db.getSiblingDB(dbName);
// 创建 cuckoo 用户
db.createUser({
  user: user,
  pwd: password,
  roles: [ { role: "dbOwner", db: dbName } ]
});

conn = connect(`${user}:${password}@localhost:27017/${dbName}`);
db = conn.getSiblingDB(dbName);
db.test.insertOne({ a: 1 });

// mongo -u cuckoo -p ATyGEw2rjdZgoclBXQ --authenticationDatabase cuckoo

// 启用身份验证
// db.getSiblingDB("admin").createUser({
//   user: "root",
//   pwd: "wViWwYOUsmRbd0KAMU",
//   roles: [ { role: "root", db: "admin" } ]
// });

// db.getSiblingDB("admin").auth("root", "wViWwYOUsmRbd0KAMU");
// db.getSiblingDB("admin").shutdownServer();
