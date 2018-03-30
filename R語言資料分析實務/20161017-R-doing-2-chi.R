#### STEP 1：準備要分析的資料 ####
# [網址] http://www.appledaily.com.tw/realtimenews/article/life/20161016/968938/




#### STEP 2：安裝和載入所需的套件 ####
# 安裝套件
install.packages("rvest")      # "網頁分析"用
install.packages("jiebaR")     # "中文斷詞"用
install.packages("tm")         # "文字探勘"用
install.packages("wordcloud2") # 產生"文字雲"用

# 載入套件
library("rvest")
library("jiebaR")
library("tm")
library("wordcloud2")




#### STEP 3：進行"文字探勘" ####
# 擷取網頁內容，將網頁下載後存入"source.page"物件
source.page <- read_html("http://www.appledaily.com.tw/realtimenews/article/life/20161016/968938/")

# 利用 Xpath 取得文章內容
source.content <- html_nodes(source.page, xpath = '//*[@id="summary"]')

# 取得 HTML 中的文字資料
content <- html_text(source.content)

# 顯示資料 (此時文章仍包含多餘字元)
content

# 啟用 jiebaR 套件裡的斷詞引擎
mixseg = worker()
content.vec <- segment(code = content, jiebar = mixseg)


space_tokenizer = function(x){
  unlist(strsplit(as.character(x[[1]]), '[[:space:]]+'))
}

jieba_tokenizer = function(d){
  unlist(segment(d[[1]], mixseg))
}

# 撰寫 CNCorpus 副程式
#### CNCorpus Function Start ####
CNCorpus = function(d.vec){
  
  doc <- VCorpus(VectorSource(d.vec))
  doc <- unlist(tm_map(doc ,jieba_tokenizer), recursive = F)
  doc <- lapply(doc ,function(d)paste(d, collapse = ' '))
  Corpus(VectorSource(doc))
}
#### CNCorpus Function END ####




#### STEP 4：製作"字詞矩陣" ####
content.corpus = CNCorpus(list(content.vec))    # 執行 CNCorpus 副程式
content.corpus <- tm_map(content.corpus, removeNumbers)    # 移除數字

control.list = list(wordLengths = c(2, Inf),tokenize = space_tokenizer)
content.dtm <- DocumentTermMatrix(content.corpus, control = control.list)

inspect(content.dtm)    # 檢查內容




#### STEP 5：產生"文字雲" ####
frequency <- colSums(as.matrix(content.dtm))
frequency <- sort(frequency, decreasing = TRUE)[1:100]

wordcloud2(as.table(frequency), fontFamily = '微软雅黑', shape = 'star')