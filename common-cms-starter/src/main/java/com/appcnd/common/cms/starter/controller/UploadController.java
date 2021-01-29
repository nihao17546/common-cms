package com.appcnd.common.cms.starter.controller;

import com.appcnd.common.cms.entity.constant.ObjectStorageType;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.pojo.vo.UeditorImage;
import com.appcnd.common.cms.starter.pojo.vo.UeditorVideo;
import com.appcnd.common.cms.starter.service.IUploadService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * created by nihao 2020/1/13
 */
@Slf4j
@RequestMapping("/upload/api")
public class UploadController extends BaseController {
    @Autowired
    @Qualifier(BasicConstant.beanNamePrefix + "hwUploadService")
    private IUploadService hwUploadService;

    @Autowired
    @Qualifier(BasicConstant.beanNamePrefix + "qnUploadService")
    private IUploadService qnUploadService;

    private IUploadService getUploadService(String storage) {
        if (ObjectStorageType.HW.name().equals(storage)) {
            return hwUploadService;
        }
        return qnUploadService;
    }

    @RequestMapping(value = "/token/{storage}", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String token(@RequestParam(value = "file_name") String fileName,
                        @RequestParam String type,
                        @PathVariable String storage) {
        IUploadService uploadService = getUploadService(storage);
        return uploadService.token(fileName, type).json();
    }

    @PostMapping(value = "/image/{storage}", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public UeditorImage uploadPic(@RequestParam(value = "upfile") MultipartFile file,
                                  @PathVariable String storage) {
        IUploadService uploadService = getUploadService(storage);
        return uploadService.uploadImage(file, file.getOriginalFilename());
    }

    @PostMapping(value = "/video/{storage}", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public UeditorVideo uploadVideo(@RequestParam(value = "upfile") MultipartFile file,
                                    @PathVariable String storage) {
        IUploadService uploadService = getUploadService(storage);
        return uploadService.uploadVideo(file, file.getOriginalFilename());
    }

}
