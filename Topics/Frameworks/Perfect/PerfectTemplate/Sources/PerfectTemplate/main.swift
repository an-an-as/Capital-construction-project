import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL

var routes = Routes()
routes.add(method: .get, uri: "/api") { request, response  in
    response.setBody(string: "hello world")
    response.completed()
}
// 路由变量
let valueKey = "key"
routes.add(method: .get, uri:"/api2/ {\(valueKey)} /detail") { respect, response in
    response.setBody(string: "Number->\(respect.urlVariables[valueKey]!)")
    response.completed()
}
// 使用*好来匹配通用的路径
routes.add(method: .get, uri:"/api3/*/detail") { respect, response in
    response.setBody(string: "path->\(respect.path)")
    response.completed()
}
routes.add(method: .get, uri: "/api3/**") { request, response in
    response.setBody(string: "tail path->\(request.urlVariables[routeTrailingWildcardKey]!)")
    response.completed()
}
//表单提交
func handler(request: HTTPRequest, response: HTTPResponse) throws {
    guard let userName = request.param(name: "userName") else { return }
    guard let passWord = request.param(name: "passWord") else { return }
    let result: [String: Any] = [
        "responseBody": ["userName": userName, "password": passWord],
        "result": "SUCESS"
    ]
    response.setHeader(.contentType, value: "application/json")
    do {
        try response.setBody(json: result)
    } catch {
        response.setBody(string: "json error")
    }
    response.completed()
}

routes.add(method: .post, uri: "/login") { request, response in
   // response.setHeader(.contentType, value: "application/json")
    guard let userName = request.param(name: "userName") else { return }
    guard let passWord = request.param(name: "passWord") else { return }
    let result: [String: Any] = [
        "responseBody": ["userName": userName, "password": passWord],
        "result": "Susscs"
    ]
    do {
        try response.setBody(json: result)
    } catch {
        response.setBody(string: "json error")
    }
    response.completed()
}
//启动
do {
    try HTTPServer.launch(
        .server(name: "localhost", port: 8181, routes: routes),
        .server(name: "localhost", port: 8080, documentRoot:  "webroot")
    )
} catch {
    fatalError("error")
}

