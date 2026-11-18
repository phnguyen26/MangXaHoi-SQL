## 1
```
SELECT BV.MaBaiViet, BV.MaNguoiDung, BV.MaAlbum, BV.NoiDung, BV.TrangThai, BV.NgayDang, H.TenHashtag from BaiViet BV
JOIN BaiViet_Hashtag BVH ON BV.MaBaiViet = BVH.MaBaiViet
JOIN  Hashtag H ON H.MaHashtag = BVH.MaHashtag
WHERE H.TenHashtag = 'CongNghe'
AND BV.NgayDang >= DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR);
```

![](results/1.png)

## 2
```
SELECT ND.MaNguoiDung, ND.TenDangNhap, BL.NoiDung FROM NguoiDung ND
JOIN BinhLuan BL ON BL.MaNguoiDung = ND.MaNguoiDung
WHERE BL.MaBaiViet = 'BV505';
```

![](results/2.png)



## 3

```
SELECT ND.MaNguoiDung, COUNT(isLike), COUNT(isComment), COUNT(isShare)
FROM NguoiDung ND
JOIN (
	SELECT MaNguoiDung , 1 AS isLike, 0 AS isComment, 0 AS isShare
    FROM TuongTac
    WHERE NgayTuongTac >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    
    UNION ALL
    
    SELECT MaNguoiDung , 0, 1, 0
    FROM BinhLuan
    WHERE NgayBinhLuan >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    
    UNION ALL
    
    SELECT MaNguoiDung , 0, 0, 1
    FROM Chiase
    WHERE NgayChiaSe >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
   ) tmp
ON tmp.MaNguoiDung = ND.MaNguoiDung
GROUP BY MaNguoiDung;
```
![](results/3.png)



## 4
```
WITH 
tmp1 AS(
    SELECT TuongTac.MaBaiViet AS MBV, COUNT(*) AS LikePerPost
    FROM TuongTac 
    GROUP BY TuongTac.MaBaiViet
),
tmp2 as(
    SELECT ND.MaNguoiDung as MND, AVG(LikePerPost) AS AVGLikePerPost
    FROM tmp1
    JOIN BaiViet BV ON tmp1.MBV = BV.MaBaiViet
    JOIN NguoiDung ND ON ND.MaNguoiDung = BV.MaNguoiDung
    GROUP BY ND.MaNguoiDung
)
SELECT MaNguoiDungBeingFollowed, ND.TenDangNhap, COUNT(*) AS Follower, tmp2.AVGLikePerPost from TheoDoi 
JOIN NguoiDung ND ON ND.MaNguoiDung = TheoDoi.MaNguoiDungBeingFollowed
JOIN tmp2 on MaNguoiDungBeingFollowed = tmp2.MND
GROUP BY MaNguoiDungBeingFollowed, tmp2.AVGLikePerPost
HAVING Followers >= 10000
and tmp2.AVGLikePerPost < 0.5/100 * Followers;
```
![](results/4.png)


