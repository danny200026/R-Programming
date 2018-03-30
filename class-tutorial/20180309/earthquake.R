# 921 地震 - 1999 年 9 月 21 日 1 時 47 分 16 秒
# 花蓮地震 - 2018 年 2 月 6 日 23 時 50 分 42 秒

# 將時間全換算成"秒"
year_s <- 31104000
month_s <- 2592000
day_s <- 86400
hour_s <- 3600
min_s <- 60
sec_s <- 1

# 將兩個地震發生的時間，進行轉換後相減
time1 <- as.POSIXct("1999-09-21 01:47:16", tz = "GMT")
time2 <- as.POSIXct("2018-02-06 23:50:42", tz = "GMT")

interval <- as.integer(time2) - as.integer(time1)


# 轉換單位
r_year <- as.integer(interval / year_s)
r_hour <- as.integer((interval %% day_s) / hour_s)
r_min <- as.integer((interval %% hour_s) / min_s)
r_sec <- as.integer((interval %% min_s))


# 輸出結果
cat("地震時間相隔", r_year, "年", "...", r_hour, "時", r_min, "分", r_sec, "秒")
