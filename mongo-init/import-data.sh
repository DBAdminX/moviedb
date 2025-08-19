#!/bin/bash
set -e

echo "Waiting for MongoDB to start..."
# 等待 MongoDB 完全启动并可以接受连接
until mongosh --host localhost --port 27017 --username root --password rootpassword --authenticationDatabase admin --eval "db.adminCommand('ping')" &> /dev/null; do
    echo "MongoDB is not ready yet..."
    sleep 2
done

echo "MongoDB is ready! Starting data import..."

# 导入数据
mongoimport --host localhost:27017 \
  --username root --password rootpassword \
  --authenticationDatabase admin \
  --db movie_db \
  --collection movies \
  --type json \
  --file /docker-entrypoint-initdb.d/movies.json \
  --jsonArray

echo "Data import completed successfully"

# 可选：创建应用程序专用用户
echo "Creating application user..."
mongosh --host localhost:27017 --username root --password rootpassword --authenticationDatabase admin <<EOF
use movie_db
db.createUser({
  user: "appuser",
  pwd: "apppassword",
  roles: [{
    role: "readWrite",
    db: "movie_db"
  }]
})
print("Application user created successfully!")
EOF

echo "Database initialization completed!"