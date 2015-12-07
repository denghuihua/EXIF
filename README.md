# EXIF
 1、UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);  写入相册的时候，写入
 图片的
 kCGImagePropertyIPTCDictionary数据会消失
 2、UIImageJPEGRepresentation  使用次API转化data之后，kCGImagePropertyIPTCDictionary数据消失 
 
 没有找到合适的方法，将修改过的IPTC数据成功写入相册
