# 构建阶段 - 使用 JDK 17
FROM maven:3.8.3-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .

# 下载依赖 (利用Docker缓存层)
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段 - 使用精简版 JRE 17
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# 添加时区支持
RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai

# 复制构建结果
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]