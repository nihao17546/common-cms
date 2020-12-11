$.jump = function (object) {
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