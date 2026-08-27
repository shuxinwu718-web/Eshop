# ---- Build Stage ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests -B

# ---- Runtime Stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app
# 时区与业务保持一致（订单/秒杀时间敏感）
ENV TZ=Asia/Shanghai
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8080
VOLUME /app/uploads
ENTRYPOINT ["java", "-jar", "app.jar"]
