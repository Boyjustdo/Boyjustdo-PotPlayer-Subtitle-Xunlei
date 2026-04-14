/*
     迅雷字幕搜索插件 for PotPlayer
 */
 
 // 插件元信息
 string GetTitle() {
     return "迅雷在线字幕";
 }
 
 string GetVersion() {
     return "1.0";
 }
 
 string GetDesc() {
     return "通过迅雷 API 搜索电影字幕";
 }
 
 // 核心搜索逻辑
array<dictionary> SubtitleSearch(string MovieFileName, dictionary MovieMetaData)
{
     array<dictionary> results;
     
     // 优先使用电影名，如果没有则使用文件名
     string query = string(MovieMetaData["title"]);;
     if (query.empty()) return results;
 
     // 构建请求 URL (注意：AngelScript 环境下可能需要处理 URL 编码)
     string url = "http://api-shoulei-ssl.xunlei.com/oracle/subtitle?name=" + query;
     
     // 发起请求
     string headers = "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0\r\n";
     headers += "Accept: */*\r\n";
     
     string json = HostUrlGetString(url, headers);
     
     // 解析 JSON (根据迅雷 API 实际返回结构)
     // 注意：PotPlayer 的 Json 解析器用法取决于版本，这里演示通用逻辑
     JsonReader reader;
     JsonValue root;
     if (reader.parse(json, root) && root.isObject()) {
         JsonValue list = root["data"]; // 使用实际返回的 data 字段
         if (list.isArray()) {
             for (int i = 0; i < list.size(); i++) {
                 JsonValue sub = list[i];
                 dictionary item;
				 item["id"] = sub["url"].asString();
                 item["fileName"] = sub["name"].asString(); // 字幕标题
                 item["url"] = sub["url"].asString();   // 下载地址
                 item["format"] = sub["ext"].asString(); // 使用实际返回的格式后缀
                 results.insertLast(item);
             }
         }
     }
 
     return results;
 }
 
string SubtitleDownload(string url)
{
	return HostUrlGetString(url);
}
