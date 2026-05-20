package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/v1/files")
@Tag(name = "文件上传管理", description = "负责文件上传的位置")
public class FileUploadController {

    @Value("${spring.file.upload-dir:./uploads}")
    private String uploadDir;

    @PostMapping("")
    public Result<Map<String, String>> uploadFile(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("上传文件不能为空");
        }

        try {
            // 获取项目根目录的绝对路径
            Path basePath = Paths.get(uploadDir).toAbsolutePath().normalize();
            String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String newFileName = UUID.randomUUID() + extension;
            Path relativePath = Paths.get(datePath, newFileName);
            Path absolutePath = basePath.resolve(relativePath);

            // 创建目录
            Files.createDirectories(absolutePath.getParent());
            // 保存文件
            file.transferTo(absolutePath.toFile());

            // 返回访问 URL（相对路径，用于前端访问）
            String fileUrl = "/uploads/" + relativePath.toString().replace("\\", "/");
            Map<String, String> result = new HashMap<>();
            result.put("url", fileUrl);
            return Result.success(result);
        } catch (IOException e) {
            log.error("文件上传失败", e);
            return Result.error("文件上传失败：" + e.getMessage());
        }
    }
}