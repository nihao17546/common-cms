var validate = (rule, value, callback) => {
    if (!value) {
        if (rule.required) {
            return callback(new Error(rule.message))
        }
        return callback()
    }
    setTimeout(() => {
        var reg = new RegExp(rule.regularStr);
        if (!reg.test(value)) {
            callback(new Error(rule.message))
        } else {
            callback()
        }
    }, 100)
}
function searchForm(systemConfig) {
    let searchElements = []
    if (systemConfig && systemConfig.table && systemConfig.table.select
        && systemConfig.table.select.searchElements
        && systemConfig.table.select.searchElements.length > 0) {
        systemConfig.table.select.searchElements.forEach(element => {
            searchElements.push(element)
        })
    }
    if (systemConfig && systemConfig.table && systemConfig.table.select
        && systemConfig.table.select.leftJoins
        && systemConfig.table.select.leftJoins.length > 0) {
        systemConfig.table.select.leftJoins.forEach(leftJoin => {
            if (leftJoin.searchElements && leftJoin.searchElements.length > 0) {
                leftJoin.searchElements.forEach(element => {
                    searchElements.push(element)
                })
            }
        })
    }
    if (searchElements.length > 0) {
        let search = $('#search-card');
        let card = $('<el-card shadow="never" class="c-card"></el-card>')
        $(card).append('<div v-if="showSearchTitle" slot="header" style="margin-top: 5px;margin-bottom: 5px;font-size: 18px;">' +
            '<span>检索条件</span>' +
            '</div>')
        let form = $('<el-form :inline="true" :model="searchForm"></el-form>')
        let configSearchForm = {}
        let searchOthers = {}
        let searchElementCount = 0
        searchElements.forEach(element => {
            let show = ''
            if (element.show === false) {
                show = ' v-show="false" '
            } else {
                searchElementCount ++
            }
            let item = $('<el-form-item ' + show + ' label="' + element.label + ':"></el-form-item>')
            let clearable = '';
            if (element.clearable) {
                clearable = 'clearable'
            }
            switch (element.elType) {
                case 'INPUT':
                    let input = $('<el-input v-model.trim="searchForm.' + element.key + '" ' +
                        'placeholder="' + element.placeholder + '"' + ' ' + clearable + ' @keyup.enter.native="search" ' +
                        'v-on:clear="search" ' +
                        'style="width: '+ element.width +'px;" size="' + element.size + '" type="text"' +
                        '></el-input>')
                    $(item).append(input)
                    break;
                case 'SELECT':
                    let select = $('<el-select v-model.trim="searchForm.' + element.key + '" ' +
                        'placeholder="' + element.placeholder + '"' + ' ' + clearable + ' @change="search" ' +
                        'size="' + element.size + '">')
                    if (element.options && element.options.length > 0) {
                        element.options.forEach(option => {
                            let opt = $('<el-option label="' + option.label + '" value="' + option.value + '"></el-option>');
                            $(select).append(opt)
                        })
                    }
                    $(item).append(select)
                    break;
                case 'DATE_PICKER':
                    let DATE_PICKER = $('<el-date-picker v-model.trim="searchForm.' + element.key + '" ' +
                        'placeholder="' + element.placeholder + '"' + ' ' + clearable + ' @change="search" ' +
                        'type="daterange" start-placeholder="开始日期" end-placeholder="结束日期" range-separator="至" ' +
                        'value-format="' + element.format + '"' +
                        'size="' + element.size + '" format="' + element.format + '">' +
                        '</el-date-picker>')
                    $(item).append(DATE_PICKER)
                    break;
                case 'DATETIME_PICKER':
                    let DATETIME_PICKER = $('<el-date-picker v-model.trim="searchForm.' + element.key + '" ' +
                        'placeholder="' + element.placeholder + '"' + ' ' + clearable + ' @change="search" ' +
                        'type="datetimerange" start-placeholder="开始日期" end-placeholder="结束日期" range-separator="至" ' +
                        'value-format="' + element.format + '"' +
                        'size="' + element.size + '" format="' + element.format + '">' +
                        '</el-date-picker>')
                    $(item).append(DATETIME_PICKER)
                    break;

            }
            $(form).append(item)
            configSearchForm[element.key] = null
            if (element.defaultValue != null && typeof(element.defaultValue) != 'undefined') {
                configSearchForm[element.key] = element.defaultValue.toString()
            }
            window.config.searchForm = configSearchForm
            searchOthers[element.key] = {
                type: element.judgeType,
                alias: element.alias
            }
            window.config.searchOthers = searchOthers
        })
        let btn = $('<el-form-item>' +
            '<el-button size="small" :loading="loading" icon="el-icon-search" type="primary" @click="search">查找</el-button>\n' +
            '</el-form-item>')
        $(form).append(btn)
        $(card).append(form)
        $(search).append(card)
        if (searchElementCount === 0) {
            $(search).hide()
        }
    }
}
function table(systemConfig) {
    if (systemConfig && systemConfig.table
        && systemConfig.table.columns
        && systemConfig.table.columns.length > 0) {
        let table_card = $('#table-card');
        let card = $('<el-card shadow="never" class="c-card"></el-card>')
        let table = $('<el-table :data="list" ref="mainTable" stripe @selection-change="handleSelectionChange" @sort-change="sortChange" style="width: 100%; margin-top: 3px;"></el-table>')
        let selection = $('<el-table-column type="selection" width="55"></el-table-column>');
        $(table).append(selection)
        systemConfig.table.columns.forEach(column => {
            let sortable = ''
            if (column.sortable) {
                sortable = ' sortable="custom" '
            }
            let width = ''
            if (column.width) {
                width = ' width="' + column.width + '" '
            }
            let prop = ''
            if (!column.formatter) {
                prop = ' prop="' + column.prop + '" '
            }
            let col = $('<el-table-column' + sortable + width + prop + ' label="' + column.label + '"></el-table-column>')
            if (column.formatter) {
                switch (column.formatter.type) {
                    case 'TEXT':
                        if (column.formatter.map) {
                            let spans = '';
                            for (let key in column.formatter.map) {
                                let span = '<span v-if="props.row.' + column.prop + ' == ' + key + '">' + column.formatter.map[key] + '</span>';
                                spans = spans + span
                            }
                            let template = $('<template slot-scope="props">' + spans + '</template>')
                            $(col).append(template)
                        }
                        break;
                    case 'PIC':
                        let style = ''
                        if (column.formatter.width) {
                            style = style + 'width:' + column.formatter.width + 'px; '
                        }
                        if (column.formatter.height) {
                            style = style + 'height:' + column.formatter.height + 'px; '
                        }
                        let templateImg = $('<template slot-scope="props">' +
                            '<img v-if="props.row.' + column.prop + '" :src="props.row.' + column.prop + '" ' +
                            'style="' + style + '">' +
                            '</template>')
                        $(col).append(templateImg)
                        break;
                    case 'URL':
                        let text = '{{props.row.' + column.prop + '}}'
                        if (column.formatter.text) {
                            text = column.formatter.text
                        }
                        let templateUrl = $('<template slot-scope="props">' +
                            '<a v-if="props.row.' + column.prop + '" target="' + column.formatter.target +
                            '" :href="props.row.' + column.prop + '">' + text + '</a>' +
                            '</template>')
                        $(col).append(templateUrl)
                        break;
                    case 'SWITCH':
                        let templateSwitch = $('<template slot-scope="props">' +
                            '<el-switch v-model="props.row.' + column.prop + '" ' +
                            ':active-value="' + column.formatter.active.value + '" ' +
                            ':inactive-value="' + column.formatter.inactive.value + '" ' +
                            'active-text="' + column.formatter.active.label + '" ' +
                            'inactive-text="' + column.formatter.inactive.label + '" ' +
                            '@change="tableSwitch($event,props.row,' + '\'' + column.prop + '\'' + ')">' +
                            '</el-switch>' +
                            '</template>')
                        $(col).append(templateSwitch)
                        break;
                }
            }
            $(table).append(col)
        })
        $(card).append(table)
        window.config.pageSize = null
        window.config.curPage = null
        if (systemConfig.table.pagination) {
            let pagenation = $('<div style="text-align: right;">' +
                '<el-pagination small background ' +
                'layout="total, sizes, prev, pager, next, jumper" ' +
                ':total="totalCount" ' +
                ':page-size="pageSize" ' +
                ':page-sizes="[10, 20, 50, 100]"' +
                ':current-page="curPage" ' +
                '@current-change="currentChange" ' +
                '@size-change="sizeChange"> ' +
                '</el-pagination> ' +
                '</div>')
            $(card).append(pagenation)
            window.config.pageSize = 10
            window.config.curPage = 1
        }
        $(table_card).append(card)
        window.config.sortColumn = null
        window.config.order = null
        if (systemConfig.table.defaultSortColumn) {
            window.config.sortColumn = systemConfig.table.defaultSortColumn
        }
        if (systemConfig.table.defaultOrder) {
            window.config.order = systemConfig.table.defaultOrder
        }
        window.config.listJson = JSON.stringify(systemConfig.table.select)
    }
}
function followTable(systemConfig) {
    if (systemConfig && systemConfig.follow_tables
        && systemConfig.follow_tables.length > 0) {
        window.followTables = {}
        systemConfig.follow_tables.forEach(follow => {
            window.followTables[follow.bottomName] = follow
        })
    }
}
function addForm(systemConfig) {
    if (systemConfig && systemConfig.add_form
        && systemConfig.add_form.elements
        && systemConfig.add_form.elements.length > 0) {
        window.addFormWidth = '50%'
        if (systemConfig.add_form.width) {
            window.addFormWidth = systemConfig.add_form.width + '%'
        }
        let addColumns = []
        let otherColumnTypeColumns = []
        let addRules = {}
        let add = $('#add-form');
        let uuid = 1;
        systemConfig.add_form.elements.forEach(element => {
            let show = ''
            if (element.show === false) {
                show = ' v-show="false" '
            }
            if (element.columnType === 'COM') {
                let form_item = $('<el-form-item ' + show + ' label="' + element.label + ':" prop="' + element.key + '" :label-width="formLabelWidth"></el-form-item>');
                let clearable = '';
                if (element.clearable) {
                    clearable = ' clearable '
                }
                let style = ''
                if (element.width) {
                    style = style + ' width: ' + element.width + 'px; '
                } else {
                    style = style + ' width: 100%; '
                }
                let canNotEdit = ''
                if (element.canEdit === false) {
                    canNotEdit = ' disabled '
                }
                switch (element.elType) {
                    case 'INPUT':
                        let maxlength = ''
                        if (element.maxlength) {
                            maxlength = ' maxlength="' + element.maxlength + '" '
                        }
                        let minlength = ''
                        if (element.minlength) {
                            minlength = ' minlength="' + element.minlength + '" '
                        }
                        let input = $('<el-input v-if="!edit" type="' + element.type + '" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'autocomplete="off" clearable style="' + style + '" ' +
                            maxlength + minlength + 'size="' + element.size + '" '
                            + 'placeholder="' + element.placeholder + '"></el-input>');
                        $(form_item).append(input)
                        let input_edit = $('<el-input v-if="edit" type="' + element.type + '" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'autocomplete="off" clearable style="' + style + '" ' +
                            maxlength + minlength + 'size="' + element.size + '" ' + canNotEdit
                            + 'placeholder="' + element.placeholder + '"></el-input>');
                        $(form_item).append(input_edit)
                        break;
                    case 'SELECT':
                        let select = $('<el-select v-if="!edit" v-model.trim="addForm.' + element.key + '"' + clearable +
                            'size="' + element.size + '" style="' + style + '"' +
                            'placeholder="' + element.placeholder + '"></el-select>')
                        if (element.options && element.options.length > 0) {
                            element.options.forEach(option => {
                                let opt = $('<el-option label="' + option.label + '" :value="' + option.value + '"></el-option>');
                                $(select).append(opt)
                            })
                        }
                        $(form_item).append(select)
                        let select_edit = $('<el-select v-if="edit" v-model.trim="addForm.' + element.key + '"' + clearable +
                            'size="' + element.size + '" style="' + style + '"' + canNotEdit +
                            'placeholder="' + element.placeholder + '"></el-select>')
                        if (element.options && element.options.length > 0) {
                            element.options.forEach(option => {
                                let opt = $('<el-option label="' + option.label + '" :value="' + option.value + '"></el-option>');
                                $(select_edit).append(opt)
                            })
                        }
                        $(form_item).append(select_edit)
                        break;
                    // case 'CHECKBOX':
                    //     let max = ''
                    //     if (element.max) {
                    //         max = ' :max="' + element.max + '" '
                    //     }
                    //     let min = ''
                    //     if (element.min) {
                    //         min = ' :min="' + element.min + '" '
                    //     }
                    //     let checkbox = $('<el-checkbox-group v-if="!edit" v-model="addForm.' + element.key + '" ' + clearable +
                    //         ' size="' + element.size + '" style="' + style + '"' + min + max +
                    //         ' placeholder="' + element.placeholder + '"></el-checkbox-group>');
                    //     if (element.checkBoxes && element.checkBoxes.length > 0) {
                    //         element.checkBoxes.forEach(option => {
                    //             let opt = $('<el-checkbox :label="' + option.value + '">' + option.label + '</el-checkbox>')
                    //             $(checkbox).append(opt)
                    //         })
                    //     }
                    //     $(form_item).append(checkbox)
                    //     let checkbox_edit = $('<el-checkbox-group v-if="edit" v-model="addForm.' + element.key + '" ' + clearable +
                    //         ' size="' + element.size + '" style="' + style + '"' + min + max + canNotEdit +
                    //         ' placeholder="' + element.placeholder + '"></el-checkbox-group>');
                    //     if (element.checkBoxes && element.checkBoxes.length > 0) {
                    //         element.checkBoxes.forEach(option => {
                    //             let opt = $('<el-checkbox :label="' + option.value + '">' + option.label + '</el-checkbox>')
                    //             $(checkbox_edit).append(opt)
                    //         })
                    //     }
                    //     $(form_item).append(checkbox_edit)
                    //     break;
                    case 'RADIO':
                        let radio = $('<el-radio-group v-if="!edit" v-model="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' +
                            'placeholder="' + element.placeholder + '"></el-radio-group>');
                        if (element.radios && element.radios.length > 0) {
                            element.radios.forEach(option => {
                                let opt = $('<el-radio :label="' + option.value + '">' + option.label + '</el-radio>')
                                $(radio).append(opt)
                            })
                        }
                        $(form_item).append(radio)
                        let radio_edit = $('<el-radio-group v-if="edit" v-model="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + canNotEdit +
                            'placeholder="' + element.placeholder + '"></el-radio-group>');
                        if (element.radios && element.radios.length > 0) {
                            element.radios.forEach(option => {
                                let opt = $('<el-radio :label="' + option.value + '">' + option.label + '</el-radio>')
                                $(radio_edit).append(opt)
                            })
                        }
                        $(form_item).append(radio_edit)
                        break;
                    case 'TIME_PICKER':
                        let pp = ''
                        if (element.start && element.end && element.step) {
                            pp = ' :picker-options="{start:\'' + element.start + '\',end:\'' + element.end + '\',step:\'' + element.step + '\'}" '
                        }
                        let time_picker = $('<el-time-select v-if="!edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + pp +
                            'placeholder="' + element.placeholder + '"></el-time-select>');
                        $(form_item).append(time_picker)
                        let time_picker_edit = $('<el-time-select v-if="edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + pp + canNotEdit +
                            'placeholder="' + element.placeholder + '"></el-time-select>');
                        $(form_item).append(time_picker_edit)
                        break;
                    case 'DATE_PICKER':
                        let date_picker = $('<el-date-picker v-if="!edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' +
                            'type="date" ' +
                            'value-format="' + element.format + '" ' +
                            'format="' + element.format + '" placeholder="' + element.placeholder + '"></el-date-picker>');
                        $(form_item).append(date_picker)
                        let date_picker_edit = $('<el-date-picker v-if="edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + canNotEdit +
                            'type="date" ' +
                            'value-format="' + element.format + '" ' +
                            'format="' + element.format + '" placeholder="' + element.placeholder + '"></el-date-picker>');
                        $(form_item).append(date_picker_edit)
                        break;
                    case 'DATETIME_PICKER':
                        let datetime_picker = $('<el-date-picker v-if="!edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' +
                            'type="datetime" ' +
                            'value-format="' + element.format + '" ' +
                            'format="' + element.format + '" placeholder="' + element.placeholder + '"></el-date-picker>');
                        $(form_item).append(datetime_picker)
                        let datetime_picker_edit = $('<el-date-picker v-if="edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + canNotEdit +
                            'type="datetime" ' +
                            'value-format="' + element.format + '" ' +
                            'format="' + element.format + '" placeholder="' + element.placeholder + '"></el-date-picker>');
                        $(form_item).append(datetime_picker_edit)
                        break;
                    case 'INPUT_NUMBER':
                        let maxNumber = ''
                        if (element.max) {
                            maxNumber = ' :max="' + element.max + '" '
                        }
                        let minNumber = ''
                        if (element.min) {
                            minNumber = ' :min="' + element.min + '" '
                        }
                        let precision = ''
                        if (element.precision) {
                            precision = ' :precision="' + element.precision + '" '
                        }
                        let step = ''
                        if (element.step) {
                            step = ' :step="' + element.step + '" '
                        }
                        let input_number = $('<el-input-number v-if="!edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + maxNumber + minNumber + precision + step +
                            ' placeholder="' + element.placeholder + '"></el-input-number>');
                        $(form_item).append(input_number)
                        let input_number_edit = $('<el-input-number v-if="edit" v-model.trim="addForm.' + element.key + '" ' + clearable +
                            'size="' + element.size + '" style="' + style + '" ' + maxNumber + minNumber + canNotEdit + precision + step +
                            ' placeholder="' + element.placeholder + '"></el-input-number>');
                        $(form_item).append(input_number_edit)
                        break;
                    case 'UPLOAD_PIC':
                        let limitSize = ''
                        if (element.limitSize) {
                            limitSize = ' limit-size="' + element.limitSize + '" '
                        }
                        let accept = ' accept="image/*" '
                        if (element.acceptType) {
                            accept = ' accept="' + element.acceptType + '" '
                        }
                        uuid = uuid + 1
                        let id = 'img_upl_' + uuid
                        let el_row_1 = $('<el-row :gutter="24" v-if="addForm.' + element.key + '">' +
                            '<el-col :span="8">' +
                            '<img @click="showImg(\'' + element.key + '\')" style="width: 90%" :src="addForm.' + element.key + '"/>' +
                            '</el-col>' +
                            '<el-col :span="8">' +
                            '<label @click="removeImg(\'' + id + '\',\'' + element.key + '\')" v-if="addForm.' + element.key + '" class="el_btn">移除图片</label>' +
                            '</el-col>' +
                            '</el-row>')
                        let placeholder = ''
                        if (element.placeholder) {
                            placeholder = element.placeholder
                        }
                        let el_row_2 = $('<el-row :gutter="24" v-if="!addForm.' + element.key + '">' +
                            '<el-col :span="20">' +
                            '<label class="el_btn" for="' + id + '">选择图片</label>' +
                            '<form><input ' + accept + limitSize + ' @change="uploadImg(\'' + id + '\',\'' + element.key + '\')" class="img_upl" type="file" id="' + id + '" style="position:absolute;clip:rect(0 0 0 0);"></form>' +
                            '<span style="font-size: 11px;font-family: Arial;">' + placeholder + '</span>' +
                            '</el-col>' +
                            '</el-row>')
                        $(form_item).append(el_row_1)
                        $(form_item).append(el_row_2)
                        break;
                    case 'RICH':
                        if (!window.richConfig) {
                            Vue.component('vue-ueditor-wrap', VueUeditorWrap)
                            window.richConfig = {}
                        }
                        let el_rich_id = 'rich_' + (+new Date()).toString();
                        window.richConfig[el_rich_id] = {
                            UEDITOR_HOME_URL: window.contextPath + '/static/UEditor/',// 资源存放路径
                            autoHeightEnabled: true,// 编辑器自动被内容撑高
                            initialFrameHeight: 300,// 初始容器高度
                            initialFrameWidth: '100%',// 初始容器宽度
                            maximumWords: (element.maxlength && element.maxlength > 0) ? element.maxlength : 9999999,// 字数限制
                            zIndex : 3000,
                            toolbars: [
                                ['fullscreen',//全屏
                                    'source', //源码
                                    '|', 'undo', 'redo', '|',//撤销，重做
                                    'bold', //加粗
                                    'italic', //斜体
                                    'underline', //下划线
                                    'fontborder', //字符边框
                                    'strikethrough',//删除线
                                    'superscript',//上标
                                    'subscript',//下标
                                    'removeformat',//清除格式
                                    'formatmatch',//格式刷
                                    'autotypeset',//自动排版
                                    'blockquote', //引用
                                    'pasteplain',//纯文本粘贴模式
                                    '|', 'forecolor', //字体颜色
                                    'backcolor', //背景颜色
                                    'insertorderedlist', //有序列表
                                    'insertunorderedlist', //无序列表
                                    'selectall', //全选
                                    'cleardoc', '|',//清空文档
                                    'rowspacingtop', //段前距
                                    'rowspacingbottom', //段后距
                                    'lineheight', '|',//行间距
                                    'customstyle', //自定义标题
                                    'paragraph', //段落
                                    'fontfamily', 'fontsize', '|',//字体，字号
                                    'directionalityltr', //从左向右输入
                                    'directionalityrtl', //从右向左输入
                                    'indent', '|',// 首行缩进
                                    'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', //居左对齐，居中对齐，居右对齐，两端对齐
                                    'touppercase', 'tolowercase', '|',//字母大写，字母小写
                                    'link', 'unlink', //超链接，取消链接
                                    'anchor', '|',//锚点
                                    'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',// 默认浮动，左浮动，右浮动，居中
                                    'simpleupload',//单图上传
                                    'insertimage', //多图上传
                                    'emotion', //表情
                                    'scrawl', //涂鸦
                                    'insertvideo',//视频
                                    'music', //音乐
                                    'attachment',//附件
                                    // 'map',//百度地铁
                                    // 'gmap', //谷歌地图
                                    // 'insertframe',//插入iframe
                                    'insertcode',//代码语言
                                    // 'webapp',//百度应用
                                    'pagebreak', //分页
                                    'template', //模版
                                    'background', '|',//背景
                                    'horizontal', //分割线
                                    'date', //日期
                                    'time', //时间
                                    'spechars', //特殊字符
                                    'snapscreen',//截图
                                    'wordimage', '|',//图片转存
                                    'inserttable',//插入表格
                                    'deletetable',//删除表格
                                    'insertparagraphbeforetable',//表格前插入行
                                    'insertrow', 'deleterow',//前插入行，删除行
                                    'insertcol', 'deletecol',//前插入列，删除列
                                    'mergecells', 'mergeright', 'mergedown',//合并多个单元格，右合并，下合并
                                    'splittocells', 'splittorows', 'splittocols',//完全拆分单元格，拆分成行，拆分成列
                                    'charts', '|',//图表
                                    'print',//打印
                                    'preview',//预览
                                    'searchreplace',//查询替换
                                    'help',//帮助
                                    'drafts']//功能草稿箱加载
                            ]
                        }
                        let config = 'richConfig.' + el_rich_id;
                        let el_rich = $('<vue-ueditor-wrap ref="' + el_rich_id + '" v-model="addForm.' + element.key + '" :config="' + config + '"></vue-ueditor-wrap>')
                        $(form_item).append(el_rich);
                        break;
                }
                $(add).append(form_item)
                addColumns.push(element.key)
                if (element.rule) {
                    let required = false
                    if (element.rule.required === true) {
                        required = true
                    }
                    let message = '请填写'
                    if (element.rule.message) {
                        message = element.rule.message
                    }
                    let ru = {
                        required: required,
                        trigger: 'change',
                        message: message
                    }
                    if (element.rule.regular) {
                        ru.validator = validate;
                        ru.regularStr = element.rule.regular
                    }
                    addRules[element.key] = []
                    addRules[element.key].push(ru)
                }
            } else {
                otherColumnTypeColumns.push({
                    column: element.key,
                    columnType: element.columnType
                })
            }
        })
        let opt = $('<el-form-item style="text-align: right">' +
            '<el-button @click="cancelAdd" size="small" :disabled="loading">取 消</el-button>' +
            '<el-button type="primary" @click="add(\'addForm\')" size="small" :disabled="loading">确 定</el-button>' +
            '</el-form-item>');
        $(add).append(opt)
        window.config.addForm = systemConfig.add_form
        window.config.addColumns = addColumns
        window.config.otherColumnTypeColumns = otherColumnTypeColumns
        window.config.addRules = addRules
    }
}
function btn(systemConfig) {
    let btns = ''
    if (systemConfig) {
        if (systemConfig.add_btn === true) {
            let vIf = ''
            if (systemConfig.limit_size) {
                vIf = ' v-if="totalCount < ' + systemConfig.limit_size + '" '
            }
            btns = btns + '<el-button size="small" ' + vIf + ' @click="showAdd" type="info" plain icon="el-icon-plus">新增</el-button>'
        }
        if (systemConfig.edit_btn === true) {
            btns = btns + '<el-button size="small" icon="el-icon-edit" :disabled="loading || selections.length != 1" @click="showEdit()">修改</el-button>'
        }
        if (systemConfig.delete_btn === true) {
            btns = btns + '<el-button size="small" type="danger" icon="el-icon-delete" :disabled="loading || selections.length == 0" @click="del()">删除</el-button>'
        }
        if (systemConfig && systemConfig.follow_tables
            && systemConfig.follow_tables.length > 0) {
            systemConfig.follow_tables.forEach(follow => {
                btns = btns + '<el-button size="small" type="info" :disabled="loading || selections.length != 1" ' +
                    '@click="showFollow(\'' + follow.bottomName + '\',\'' + follow.relateKey + '\')">' + follow.bottomName + '</el-button>'
            })
        }
        if (systemConfig.table && systemConfig.table.bottoms && systemConfig.table.bottoms.length > 0) {
            systemConfig.table.bottoms.forEach(bottom => {
                if (bottom.type == 'EXTERNAL_LINKS') {
                    let p = '[]';
                    let disabled = '';
                    let style = 'primary';
                    let paramFormDb = false;
                    if (typeof bottom.paramFormDb != 'undefined') {
                        paramFormDb = bottom.paramFormDb;
                    }
                    if (bottom.style) {
                        style = bottom.style;
                    }
                    if (bottom.params && bottom.params.length > 0) {
                        p = JSON.stringify(bottom.params);
                        disabled = 'loading || selections.length != 1';
                    } else {
                        disabled = 'loading';
                    }
                    p = encodeURI(p);
                    btns = btns + '<el-button size="small" type="' + style + '" :disabled="' + disabled + '" @click="jump(' + paramFormDb + ',\'' + p + '\',\'' + bottom.url + '\')">' + bottom.name + '</el-button>'
                }
            })
        }
    }
    if (btns.length > 0) {
        let add_opt = $('<el-card shadow="never" class="c-card">' +
            '<el-row :gutter="12">' +
            '<el-col :span="12">' +
            btns +
            ' </el-col>' +
            '</el-row>' +
            '</el-card>');
        $('#btn-card').append(add_opt)
    }
}