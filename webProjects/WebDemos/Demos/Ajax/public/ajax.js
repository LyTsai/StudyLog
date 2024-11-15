function ajax(options){
    // 默认数据，实际使用的时候，如果参数不全，使用这里的
    let defaults = {
        type: 'get',
        url: '',
        data: {},
        header: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        success: function() {},
        error: function() {}
    }
    // 使用options中的属性覆盖defaults中的属性，会影响原对象
    Object.assign(defaults, options)

    let xhr = new XMLHttpRequest()

    let params = ""
    for (const key in defaults.data) {
        params += key + "=" + defaults.data[key] + "&"
    }
    params = params.substring(0, params.length -1)
    if (defaults.type == 'get') {
        params = "?" + params
        xhr.open(defaults.type, defaults.url + params)
        xhr.send()
    } else {
        xhr.open(defaults.type, defaults.url)
        // 有-，不适合用点方式
        const contentType = defaults.header["Content-Type"]
        xhr.setRequestHeader('Content-Type', contentType)
        // JSON方式
        if (contentType == "application/json") {
            xhr.send(JSON.stringify(defaults.data))
        } else {
            xhr.send(params)
        }
    }

    xhr.onload = function() {
        //得到返回数据的类型
        const responseContentType = xhr.getResponseHeader('Content-Type')
        let responseText = xhr.responseText
        // 转成JSON格式
        if (responseContentType.includes('application/json')) {
            responseText = JSON.parse(responseText)
        }
        if (xhr.status == 200) {
            options.success(responseText, xhr)
        }else {
            options.error(responseText, xhr)
        }
    }
}