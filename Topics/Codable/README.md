---
#### 定义
- Codable的定义是这样的：`typealias Codable = Decodable & Encodable` 
- 其中Decodable表示把JSON的字符串表示映射到一个Swift model，而Encodable则表示把Swift model映射成JSON的字符串表示；

### 转换过程
标准过程：
- 把JSON数据存到本地的Model里，需要定义两个类型,参与类型转换的所有的类型，都遵从Codable。
- EpisodeType: 视频"type"的选项
- Episode: 每个属性名、类型要和JSON中的要一致, 遵循了Codable就会自动映射

自定义：
- 在Swift里，我们习惯使用驼峰式的命名，这和JSON数据不一致需要自定义
- 为了实现这个过程，编译器会在遵从了Codable的类型中安插一个enum CodingKeys: String, CodingKey类型，并通过这个类型完成映射
- 因此，为了自定义映射规则，我们只要在遵循了codable的结构体内重定义CodingKeys这个类型就好了,把每个属性都列举出来

#### 解码过程
- 创建解码器： let decoder = JSONDecoder()
- 调用decoder.decode方法完成字符串到类型的映射

#### decode方法 
```
func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable）
```

+ 将data数据的类型通过type inference得到变量episode的类型，将data数据转换为模型类型，转换有可能失败 需要try 捕获错误

#### 编码过程
- 创建编码器 let encoder = JSONEncoder()
- 调用decoder.encode方法
- 打印样式 encoder.outputFormatting = .prettyPrinted


+ 编码器和解码器 对于 日期格式 数据格式 特殊浮点数的处理（无穷Infinity，空数NaN）
-  处理时间显示样式：encoding.dateEncodingStrategy = .iso8601
-  处理特殊无限浮点数 Nan: nonConformingFloatEncodingStrategy =
.convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
---
