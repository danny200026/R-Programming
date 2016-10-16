#### STEP 1：準備要分析的資料 ####
# [網址] http://www.technewsworld.com/story/83998.html




#### STEP 2：安裝和載入所需的套件 ####
# 安裝套件
install.packages("rvest")    # "網頁分析"用
install.packages("tm")  # "文字探勘"用
install.packages("SnowballC") # Text stemming
install.packages("wordcloud") # 產生"文字雲"用
install.packages("RColorBrewer") # Color palettes

# 載入套件
library("rvest")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")




#### STEP 3：進行"文字探勘" ####
# 擷取網頁內容，將網頁下載後存入"source.page"物件
source.page <- read_html("http://www.technewsworld.com/story/83998.html")

# 利用 Xpath 取得文章內容
source.content <- html_nodes(source.page, xpath = '//*[@id="story-body"]')

# 取得 HTML 中的文字資料
content <- html_text(source.content)

# 顯示資料 (此時文章仍包含多餘字元)
content


# 將內容以"語料庫"的形式儲存
docs <- Corpus(VectorSource(content))

# 檢查內容
inspect(docs)


# 將特殊的字元以"空白"取代
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

docs <- tm_map(docs, toSpace, "/")    # 將"/"以"空白"取代
docs <- tm_map(docs, toSpace, "@")    # 將"@"以"空白"取代
docs <- tm_map(docs, toSpace, "\\|")  # 將"\\|"以"空白"取代


# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)    # 移除數字

# 移除常見的"轉折詞彙"
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)  # 移除標點符號
docs <- tm_map(docs, stripWhitespace)    # 移除額外的"空白"




#### STEP 4：製作"字詞矩陣" ####
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing = TRUE)
d <- data.frame(word = names(v),freq = v)


# 顯示前10個出現頻率最高的字詞
head(d, 10)




#### STEP 5：產生"文字雲" ####
# 設定可重複的亂數序列
set.seed(1000)

# 製作文字雲
wordcloud(words = d$word, freq = d$freq, min.freq = 2,
          max.words = 30, random.order = FALSE, rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))