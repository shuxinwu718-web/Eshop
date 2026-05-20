#!/bin/bash
# 启动脚本 - 使用 IntelliJ JBR (Java 25)
export JAVA_HOME="C:/Program Files/JetBrains/IntelliJ IDEA 2026.1.1/jbr"
export PATH="$JAVA_HOME/bin:$PATH"

cd "$(dirname "$0")"
./mvnw.cmd spring-boot:run
