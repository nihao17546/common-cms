function jump(object) {
    let paramFormDb = object.paramFormDb,
        p = object.p,
        url = object.url;
    let vue = object.vue;

    function open(param, url, row) {
        let urlParam = '';
        if (param && row) {
            $(param).each(function(i,val){
                urlParam = urlParam + '&' + val + '=' + row[val]
            });
        }

        if (urlParam != '') {
            if (url.indexOf('?') != -1) {
                url = url + urlParam;
            } else {
                urlParam = '?' + urlParam.substr(1);
                url = url + urlParam;
            }
        }
        window.open(url)
    }

    let param = null;
    if (p) {
        p = decodeURI(p);
        if (p) {
            let obj = JSON.parse(p);
            if (obj && obj.length > 0) {
                param = obj;
            }
        }
    }

    if (param) {
        let row = null;
        if (vue.selections && vue.selections.length == 1) {
            row = vue.selections[0]
        }
        if (!row) {
            console.error("no selection")
            return
        }

        if (paramFormDb) {
            vue.loading = true;
            let form = {
                primaryKeyValue: row[window.config.addForm.primaryKey],
                addJson: JSON.stringify(window.config.addForm),
                columns: window.config.addColumns
            }
            axios.post(window.contextPath + '/web/api/info', form, {
                headers: {}
            }).then(res => {
                if (res.data.status != 0) {
                    vue.$message.error(res.data.msg);
                    vue.loading = false;
                }
                else {
                    vue.loading = false;
                    open(param, url, res.data.content.info)
                }
            }).catch(res => {
                console.error(res)
                vue.loading = false;
            })
        } else {
            open(param, url, row)
        }
    } else {
        open(null, url, null)
    }
}

function getParam(name) {
    var reg = new RegExp("[^\?&]?" + encodeURI(name) + "=[^&]+");
    var arr = window.location.search.match(reg);
    if (arr != null) {
        return decodeURI(arr[0].substring(arr[0].search("=") + 1));
    }
    return "";
}

function guid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function clearCookie(name) {
    setCookie(name, "", -1);
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}