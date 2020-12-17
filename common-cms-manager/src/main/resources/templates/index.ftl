<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
</head>
<body>
<div id="app" v-loading="loading">
    <el-card class="box-card">
        <div slot="header" class="clearfix">
            <span>主表配置</span>
        </div>
        <el-form :model="basic.form" :rules="basic.rules" ref="basicForm" size="small">
            <el-row :gutter="24">
                <el-col :span="10">
                    <el-form-item label="数据库:" prop="schema" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.schema" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="数据库表:" prop="table" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.table" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="4" style="text-align: center">
                    <el-button type="primary" plain size="mini" @click="getMainTable">校验</el-button>
                </el-col>
            </el-row>
            <el-row :gutter="24" v-if="basic.checked">
                <el-col :span="8">
                    <el-form-item label="主键:" prop="primaryKey" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.primaryKey" readOnly="true" placeholder="必须int且自增类型" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="页面标题:" prop="title" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.title" autocomplete="off" size="small" maxlength="200"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="允许新增:" prop="addBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.addBtn" @change="addOrEditBtnChange">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="允许编辑:" prop="editBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.editBtn" @change="addOrEditBtnChange">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="允许删除:" prop="deleteBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.deleteBtn">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="是否分页:" prop="pagination" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.pagination">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="8">
                    <el-form-item label="默认排序字段:" prop="defaultSortColumn" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.defaultSortColumn" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="8" v-if="basic.form.defaultSortColumn">
                    <el-form-item label="正序or倒序:" prop="defaultOrder" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.defaultOrder">
                            <el-option key="asc" label="正序" value="asc"></el-option>
                            <el-option key="desc" label="倒序" value="desc"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>
        </el-form>

        <el-collapse v-model="activeNames" v-if="basic.checked">
            <el-collapse-item title="主表查询列配置" name="1">
                <el-card style="margin-top: 10px;" shadow="hover"  v-if="basic.checked">
                    <el-form :model="mainTable.form" :rules="mainTable.rules" ref="mainTableForm" size="small">
                        <el-row :gutter="24">
                            <el-col :span="24" style="margin-bottom: 8px;">
                                <el-form-item label="查询列" prop="columns" :label-width="formLabelWidth">
                                    <el-button type="primary" plain size="mini" @click="showAddColumn">添加</el-button>
                                </el-form-item>
                            </el-col>
                            <span v-for="(item,index) in mainTable.form.columns">
                                <el-card shadow="hover" style="margin-top: 8px;">
                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                        <el-col :span="8">
                                    <el-form-item label="sql查询字段:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.key'" :rules="mainTable.rules.columnRules.key">
                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8">
                                    <el-form-item label="sql查询别名:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.prop'" :rules="mainTable.rules.columnRules.prop">
                                        <el-input v-model.trim="item.prop" placeholder="默认等于“sql查询字段”" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8">
                                    <el-form-item label="前端列头文案:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.label'" :rules="mainTable.rules.columnRules.label">
                                        <el-input v-model.trim="item.label" placeholder="" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8">
                                    <el-form-item label="前端列宽度（px）:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.width'" :rules="mainTable.rules.columnRules.width">
                                        <el-input v-model.trim="item.width" placeholder="" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8">
                                    <el-form-item label="是否可以排序:" :label-width="formLabelWidth">
                                        <el-select style="width: 100%" v-model="item.sortable" placeholder="默认否">
                                            <el-option :key="true" label="是" :value="true"></el-option>
                                            <el-option :key="false" label="否" :value="false"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                                    </el-row>
                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                        <el-col :span="8">
                                            <el-form-item label="格式化类型:" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" clearable v-model="item.formatterTypeIndex" @change="formatterTypeChange(index)">
                                                    <el-option v-for="(type,aIndex) in formatterTypes" :key="aIndex"
                                                       :label="type.name" :value="aIndex">
                                                    </el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterPicWidth') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="图片展示宽度（px）:" :prop="'columns.' + index + '.formatterPicWidth'" :rules="mainTable.rules.columnRules.width" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterPicWidth" placeholder="默认50" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterPicHeight') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="图片展示高度（px）:" :prop="'columns.' + index + '.formatterPicHeight'" :rules="mainTable.rules.columnRules.width" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterPicHeight" placeholder="默认50" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchActiveValue') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="选中选项的值:" :prop="'columns.' + index + '.formatterSwitchActiveValue'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchActiveValue" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchActiveLabel') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="选中选项的标签:" :prop="'columns.' + index + '.formatterSwitchActiveLabel'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchActiveLabel" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchInactiveValue') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="未选中选项的值:" :prop="'columns.' + index + '.formatterSwitchInactiveValue'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchInactiveValue" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchInactiveLabel') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="未选中选项的标签:" :prop="'columns.' + index + '.formatterSwitchInactiveLabel'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchInactiveLabel" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="16" v-if="item.hides.indexOf('formatterTextMap') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="文本格式化JSON:" :prop="'columns.' + index + '.formatterTextMap'" :rules="mainTable.rules.columnRules.formatterTextMap" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterTextMap" placeholder="格式要求对象类型的json,key value都必须为string" autocomplete="off" size="small" maxlength="1000"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterUrlTarget') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="链接打开方式:" :prop="'columns.' + index + '.formatterUrlTarget'" :rules="mainTable.rules.columnRules.formatterUrlTarget" :label-width="formLabelWidth">
                                        <el-select style="width: 100%" v-model="item.formatterUrlTarget" placeholder="默认新窗口">
                                            <el-option key="_blank" label="新开窗口" value="_blank"></el-option>
                                            <el-option key="_self" label="当前窗口" value="_self"></el-option>
                                            <el-option key="_parent" label="父级窗口" value="_parent"></el-option>
                                            <el-option key="_top" label="顶层窗口" value="_top"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('formatterUrlText') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="链接文案:" :prop="'columns.' + index + '.formatterUrlText'" :rules="mainTable.rules.columnRules.formatterUrlText" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterUrlText" placeholder="默认链接本身" autocomplete="off" size="small" maxlength="100"></el-input>
                                    </el-form-item>
                                </el-col>
                                        <el-col :span="24" style="text-align: right;">
                                    <el-button-group>
                                        <el-button type="primary" size="mini" icon="el-icon-arrow-up" v-if="index != 0" @click="upAddColumn(item, index)">上移</el-button>
                                        <el-button type="primary" size="mini" icon="el-icon-arrow-down" v-if="index != mainTable.form.columns.length - 1" @click="downAddColumn(item, index)">下移</el-button>
                                    </el-button-group>
                                    <el-button type="danger" plain size="mini" @click="removeAddColumn(item, index)">移除</el-button>
                                </el-col>
                                    </el-row>
                                </el-card>
                            </span>
                        </el-row>
                    </el-form>
                </el-card>
            </el-collapse-item>

            <el-collapse-item title="主表默认查询配置" name="2">
                <el-card style="margin-top: 10px;" shadow="hover"  v-if="basic.checked">
                    <el-form :model="mainWhere.form" :rules="mainTable.rules" ref="mainWhereForm" size="small">
                        <el-row :gutter="24">
                            <el-col :span="24" style="margin-bottom: 8px;">
                                <el-form-item label="查询条件" prop="wheres" :label-width="formLabelWidth">
                                    <el-button type="primary" plain size="mini" @click="showAddWhere">添加</el-button>
                                </el-form-item>
                            </el-col>
                            <span v-for="(item,index) in mainWhere.form.wheres">
                                <el-card shadow="hover" style="margin-top: 8px;">

                                </el-card>
                            </span>
                        </el-row>
                    </el-form>
                </el-card>
            </el-collapse-item>

            <el-collapse-item title="主表按钮配置" name="3">
                <el-card style="margin-top: 10px;" shadow="hover"  v-if="basic.checked">
                    <el-form :model="mainBottom.form" :rules="mainBottom.rules" ref="mainBottomForm" size="small">
                        <el-row :gutter="24">
                            <el-col :span="24" style="margin-bottom: 8px;">
                                <el-button type="primary" plain size="mini" @click="addBottom">添加</el-button>
                            </el-col>
                            <span v-for="(item,index) in mainBottom.form.list">
                                <el-card shadow="hover" style="margin-top: 8px;">
                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                        <el-col :span="8">
                                            <el-form-item label="按钮文案:" :label-width="formLabelWidth"
                                                          :prop="'list.' + index + '.name'" :rules="mainBottom.rules.name">
                                                <el-input v-model.trim="item.name" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="按钮类型类型:" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" clearable v-model="item.typeIndex" @change="bottomTypeChange(index)">
                                                    <el-option v-for="(type,aIndex) in bottomTypes" :key="aIndex"
                                                               :label="type.name" :value="aIndex">
                                                    </el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.shows.indexOf('externalLinksBottomUrl') != -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="跳转链接:" :prop="'list.' + index + '.externalLinksBottomUrl'" :rules="mainBottom.rules.externalLinksBottomUrl" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.externalLinksBottomUrl" placeholder="" autocomplete="off" size="small" maxlength="1000"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.shows.indexOf('externalLinksBottomParams') != -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="跳转参数:" :prop="'list.' + index + '.externalLinksBottomParams'"
                                                          :rules="mainBottom.rules.externalLinksBottomParams" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.externalLinksBottomParams" placeholder="多个直接使用英文逗号分隔" autocomplete="off" size="small" maxlength="1000"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.shows.indexOf('externalLinksBottomParamFormDb') != -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="跳转参数获取方式:" :prop="'list.' + index + '.externalLinksBottomParamFormDb'" :rules="mainBottom.rules.externalLinksBottomParamFormDb" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" v-model="item.externalLinksBottomParamFormDb" placeholder="默认当前行数据">
                                                    <el-option :key="true" label="查询数据库" :value="true"></el-option>
                                                    <el-option :key="false" label="当前行数据" :value="false"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="24" style="text-align: right;">
                                            <el-button-group>
                                                <el-button type="primary" size="mini" icon="el-icon-arrow-up" v-if="index != 0" @click="upAddBottom(item, index)">上移</el-button>
                                                <el-button type="primary" size="mini" icon="el-icon-arrow-down" v-if="index != mainBottom.form.list.length - 1" @click="downAddBottom(item, index)">下移</el-button>
                                            </el-button-group>
                                            <el-button type="danger" plain size="mini" @click="removeAddBottom(item, index)">移除</el-button>
                                        </el-col>
                                    </el-row>
                                </el-card>
                            </span>
                        </el-row>
                    </el-form>
                </el-card>
            </el-collapse-item>

            <el-collapse-item title="主表新增/编辑表单配置" name="4">
                <el-card style="margin-top: 10px;" shadow="hover"  v-if="basic.checked">
                    <el-form :model="mainAdd.form" :rules="mainAdd.rules" ref="mainAddForm" size="small">
                        <el-row :gutter="24">
                            <el-col :span="24" style="margin-bottom: 8px;">
                                <el-form-item label="表单项" prop="elements" :label-width="formLabelWidth">
                                    <el-button type="primary" plain size="mini" @click="showAddFormColumn">添加</el-button>
                                </el-form-item>
                            </el-col>
                            <span v-for="(item,index) in mainAdd.form.elements">
                                <el-card shadow="hover" style="margin-top: 8px;">
                                    <el-row style="border: 0px solid gray;" :gutter="24">
                                        <el-col :span="8">
                                            <el-form-item label="数据库字段:" :label-width="formLabelWidth"
                                                  :prop="'elements.' + index + '.key'" :rules="mainAdd.rules.key">
                                                <el-input v-model.trim="item.key" placeholder="" readOnly="true" autocomplete="off" size="small"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <el-form-item label="表单类型:" :label-width="formLabelWidth" :prop="'elements.' + index + '.typeIndex'"
                                                          :rules="mainAdd.rules.typeIndex">
                                                <el-select style="width: 100%" clearable v-model="item.typeIndex" @change="addElementTypeChange(index)">
                                                    <el-option v-for="(type,aIndex) in addElementTypes" :key="aIndex"
                                                               :label="type.name" :value="aIndex">
                                                    </el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('label') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="表单文案:" :prop="'elements.' + index + '.label'"
                                                          :rules="item.rules.label" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.label" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('type') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="普通文本框样式:" :prop="'elements.' + index + '.type'"
                                                          :rules="item.rules.type" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" v-model="item.type" placeholder="默认普通单行" clearable>
                                                    <el-option key="text" label="普通单行" value="text"></el-option>
                                                    <el-option key="textarea" label="多行" value="textarea"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('placeholder') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="提示文案:" :prop="'elements.' + index + '.placeholder'"
                                                          :rules="item.rules.placeholder" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.placeholder" autocomplete="off" size="small" maxlength="300"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('clearable') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="是否可清空:" :prop="'elements.' + index + '.clearable'"
                                                          :rules="item.rules.clearable" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" v-model="item.clearable" placeholder="默认是">
                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('size') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="输入框尺寸:" :prop="'elements.' + index + '.size'"
                                                          :rules="item.rules.size" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" v-model="item.size" placeholder="默认small">
                                                    <el-option key="medium" label="medium" value="medium"></el-option>
                                                    <el-option key="small" label="small" value="small"></el-option>
                                                    <el-option key="mini" label="mini" value="mini"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('width') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="指定宽度（px）:" :prop="'elements.' + index + '.width'"
                                                          placeholder="默认100%" :rules="item.rules.width" :label-width="formLabelWidth">
                                                <el-input-number size="small" v-model="item.width" style="width: 100%" :min="1"></el-input-number>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('maxlength') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="最大输入字符数:" :prop="'elements.' + index + '.maxlength'"
                                                          :rules="item.rules.maxlength" :label-width="formLabelWidth">
                                                <el-input-number size="small" v-model="item.maxlength" style="width: 100%" :min="1"></el-input-number>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('minlength') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="最小输入字符数:" :prop="'elements.' + index + '.minlength'"
                                                          :rules="item.rules.minlength" :label-width="formLabelWidth">
                                                <el-input-number size="small" v-model="item.minlength" style="width: 100%" :min="1"></el-input-number>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('canEdit') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="是否允许编辑:" :prop="'elements.' + index + '.canEdit'"
                                                          :rules="item.rules.canEdit" :label-width="formLabelWidth">
                                                <el-select style="width: 100%" v-model="item.canEdit" placeholder="默认是">
                                                    <el-option :key="true" label="是" :value="true"></el-option>
                                                    <el-option :key="false" label="否" :value="false"></el-option>
                                                </el-select>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('schema') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="远程数据表所在库:" :prop="'elements.' + index + '.schema'"
                                                          :rules="item.rules.schema" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.schema" placeholder="默认第一行“数据库”值" autocomplete="off" size="small" maxlength="300"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('table') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="远程数据表名:" :prop="'elements.' + index + '.table'"
                                                          :rules="item.rules.table" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.table" autocomplete="off" size="small" maxlength="300"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('keyColumn') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="键字段:" :prop="'elements.' + index + '.keyColumn'"
                                                          :rules="item.rules.keyColumn" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.keyColumn" autocomplete="off" size="small" maxlength="300"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('valueColumn') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="值字段:" :prop="'elements.' + index + '.valueColumn'"
                                                  :rules="item.rules.valueColumn" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.valueColumn" autocomplete="off" size="small" maxlength="300"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('min') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="计数器允许的最小值:" :prop="'elements.' + index + '.min'"
                                                          :rules="item.rules.min" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.min" placeholder="格式要求number" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('max') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="计数器允许的最大值:" :prop="'elements.' + index + '.max'"
                                                          :rules="item.rules.max" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.max" placeholder="格式要求number" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('precision') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="数值精度:" :prop="'elements.' + index + '.precision'"
                                                          :rules="item.rules.precision" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.precision" placeholder="格式要求非负整数,且不能小于'计数器步长'的小数位数" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('step') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="计数器步长:" :prop="'elements.' + index + '.step'"
                                                          :rules="item.rules.step" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.step" placeholder="格式要求number" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('start') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="开始时间:" :prop="'elements.' + index + '.start'" :rules="item.rules.start" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.start" placeholder="默认00:00" autocomplete="off" size="small" maxlength="5"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('end') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="结束时间:" :prop="'elements.' + index + '.end'"
                                                          :rules="item.rules.end" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.end" placeholder="默认23:59" autocomplete="off" size="small" maxlength="5"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('timeStep') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="间隔时间:" :prop="'elements.' + index + '.timeStep'"
                                                          :rules="item.rules.timeStep" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.step" placeholder="默认00:30" autocomplete="off" size="small" maxlength="5"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('acceptType') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="图片后缀类型:" :prop="'elements.' + index + '.acceptType'" :rules="item.rules.acceptType" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.acceptType" placeholder="例：'.jpg,.PNG',多个使用逗号分隔" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="8" v-if="item.hides.indexOf('limitSize') == -1 && (item.typeIndex || item.typeIndex == 0)">
                                            <el-form-item label="图片大小限制:" :prop="'elements.' + index + '.limitSize'"
                                                          :rules="item.rules.limitSize" :label-width="formLabelWidth">
                                                <el-input v-model.trim="item.limitSize" placeholder="格式要求正整数,单位：字节" autocomplete="off" size="small" maxlength="30"></el-input>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="24" style="text-align: right;">
                                            <el-button-group>
                                                <el-button type="primary" size="mini" icon="el-icon-arrow-up" v-if="index != 0" @click="upAddFormColumn(item, index)">上移</el-button>
                                                <el-button type="primary" size="mini" icon="el-icon-arrow-down" v-if="index != mainAdd.form.elements.length - 1" @click="downAddFormColumn(item, index)">下移</el-button>
                                            </el-button-group>
                                            <el-button type="danger" plain size="mini" @click="removeAddFormColumn(item, index)">移除</el-button>
                                        </el-col>
                                    </el-row>
                                </el-card>
                            </span>
                        </el-row>
                    </el-form>
                </el-card>
            </el-collapse-item>
        </el-collapse>
        <el-row :gutter="24" v-if="basic.checked">
            <el-col :span="24" style="margin-top: 10px;text-align: right;">
                <el-button type="primary" plain size="mini" @click="submit">提交</el-button>
            </el-col>
        </el-row>
    </el-card>

    <el-dialog title="添加列" :visible.sync="addColumn.visible" class="group-dialog" :before-close="closeAddColumn">
        <el-select v-model="addColumn.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addColumnFun">
            <el-option
                    v-for="item in mainColumns"
                    :key="item.name"
                    :label="'列名:' + item.name + '   类型:' + item.type"
                    :value="item.name">
            </el-option>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addColumnFun">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="添加列" :visible.sync="mainAdd.visible" class="group-dialog" :before-close="closeAddFormColumn">
        <el-select v-model="mainAdd.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addFormColumnFun">
            <el-option
                    v-for="item in mainAddColumns"
                    :key="item.name"
                    :label="'列名:' + item.name + '   类型:' + item.type"
                    :value="item.name">
            </el-option>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addFormColumnFun">确认</el-button>
        </div>
    </el-dialog>

    <el-dialog title="添加查询列" :visible.sync="mainWhere.visible" class="group-dialog" :before-close="closeAddWhere">
        <el-select v-model="mainWhere.item" placeholder="请选择" size="small"
                   style="width: 100%" @change="addWhereFun">
            <el-option
                    v-for="item in mainWhereColumns"
                    :key="item.name"
                    :label="'列名:' + item.name + '   类型:' + item.type"
                    :value="item.name">
            </el-option>
        </el-select>
        <div style="margin-top: 8px;text-align: right;">
            <el-button type="primary" plain size="mini" @click="addWhereFun">确认</el-button>
        </div>
    </el-dialog>
</div>

<script>
    window.contextPath = '${contextPath}'
    new Vue({
        name: 'config',
        el: '#app',
        data() {
            var validateColumns = (rule, value, callback) => {
                if (!value || value.length == 0) {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };
            var validateNum = (rule, value, callback) => {
                if (!value || value === '') {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    if (/(^[1-9]\d*$)/.test(value)) {
                        callback();
                    }else{
                        callback(new Error('格式要求正整数'));
                    };
                }
            };
            var validateMap = (rule, value, callback) => {
                if (!value || value === '') {
                    if (rule.required) {
                        callback(new Error(rule.message));
                    } else {
                        callback();
                    }
                } else {
                    try {
                        let obj = JSON.parse(value);
                        console.log(Object.keys(obj).length)
                        if (Object.keys(obj).length == 0) {
                            callback(new Error('格式要求map类型的json,key value都必须为string'));
                            return
                        }
                        for (let o in obj) {
                            if (typeof (o) != 'string' || typeof(obj[o]) != 'string') {
                                callback(new Error('格式要求map类型的json,key value都必须为string'));
                                return
                            }
                        }
                        callback();
                    } catch (e) {
                        callback(new Error('格式要求map类型的json,key value都必须为string'));
                    }
                }
            };
            return {
                loading: false,
                formLabelWidth: '150px',
                activeNames: [],
                addElementTypes: [],
                formatterTypes: [],
                bottomTypes: [],
                whereTypes: [],
                basic: {
                    form: {},
                    rules: {
                        title: [{required : true, message: '请输入', trigger: 'change' }],
                        schema: [{required : true, message: '请输入', trigger: 'change' }],
                        table: [{required : true, message: '请输入', trigger: 'change' }],
                        primaryKey: [{required : true, message: '请输入', trigger: 'change' }],
                        pagination: [{required : true, message: '请选择', trigger: 'change' }],
                    },
                    checked: false
                },
                mainColumns: [],
                mainAddColumns: [],
                mainWhereColumns: [],
                mainTable: {
                    form: {
                        columns: []
                    },
                    rules: {
                        columns: [{required : true, message: '查询列不能为空', validator: validateColumns, trigger: 'change' }],
                        columnRules: {
                            key: [{required : true, message: 'sql查询字段不能为空', trigger: 'change' }],
                            label: [{required : true, message: '前端列头文案不能为空', trigger: 'change' }],
                            width: [{required : false, message: '格式要求正整数', validator: validateNum, trigger: 'change' }],
                            formatterSwitchValue: [{required : true, message: '请输入', trigger: 'change' }],
                            formatterTextMap: [{required : true, message: '格式要求map类型的json,key value都必须为strin', validator: validateMap, trigger: 'change' }],
                        }
                    }
                },
                addColumn: {
                    visible: false,
                    item: null
                },
                mainBottom: {
                    form: {
                        list: []
                    },
                    rules: {
                        name: [{required : true, message: '请输入按钮文案', trigger: 'change' }],
                        externalLinksBottomUrl: [{required : true, message: '请输入跳转链接', trigger: 'change' }],
                    }
                },
                mainAdd: {
                    visible: false,
                    item: null,
                    form: {
                        elements: []
                    },
                    rules: {
                        typeIndex: [{required : true, message: '请选择表单类型', trigger: 'change' }],
                        key: [{required : true, message: '请填写数据库字段名', trigger: 'change' }],
                        elements: [{required : false, message: '表单项不能为空', validator: validateColumns, trigger: 'change' }],
                    }
                },
                mainWhere: {
                    visible: false,
                    item: null,
                    rules: {},
                    form: {
                        wheres: []
                    }
                }
            }
        },
        methods: {
            submit() {
                this.loading = true;
                this.activeNames = ["1","2","3","4"]

                let basicFormValid = null,
                        mainTableFormValid = null,
                        mainBottomFormValid = null,
                        mainAddFormValid = null,
                        mainWhereFormValid = null;

                this.$refs['basicForm'].validate((valid) => {
                    if (valid) {
                        basicFormValid = true
                    } else {
                        basicFormValid = false
                    }
                });

                this.$refs['mainTableForm'].validate((valid) => {
                    if (valid) {
                        mainTableFormValid = true
                    } else {
                        mainTableFormValid = false
                    }
                });

                this.$refs['mainBottomForm'].validate((valid) => {
                    if (valid) {
                        mainBottomFormValid = true
                    } else {
                        mainBottomFormValid = false
                    }
                });

                this.$refs['mainAddForm'].validate((valid) => {
                    if (valid) {
                        mainAddFormValid = true
                    } else {
                        mainAddFormValid = false
                    }
                });

                this.$refs['mainWhereForm'].validate((valid) => {
                    if (valid) {
                        mainWhereFormValid = true
                    } else {
                        mainWhereFormValid = false
                    }
                });

                let aaa = window.setInterval(() => {
                    if (basicFormValid != null
                            && mainBottomFormValid != null
                            && mainTableFormValid != null
                            && mainAddFormValid != null
                            && mainWhereFormValid != null) {
                        window.clearInterval(aaa)
                        if (basicFormValid
                                && mainBottomFormValid
                                && mainTableFormValid
                                && mainAddFormValid
                                && mainWhereFormValid) {
                            alert(1)
                        } else {
                            alert(0)
                        }
                        this.loading = false;
                    }
                }, 100)
            },
            addWhereFun() {
                this.loading = true
                if (this.mainWhere.item != null && typeof this.mainWhere.item != 'undefined') {
                    for (let i = 0; i < this.mainColumns.length; i ++) {
                        if (this.mainWhereColumns[i].name === this.mainWhere.item) {
                            this.mainWhere.form.wheres.push({
                                key: this.mainColumns[i].name,
                                dataType: this.mainColumns[i].type,
                                shows: []
                            })
                            this.$refs.mainWhereForm.validateField("wheres");
                            break
                        }
                    }
                }
                this.closeAddWhere()
                this.loading = false
            },
            closeAddWhere() {
                this.mainWhere.visible = false
                this.mainWhere.item = null
            },
            showAddWhere() {
                this.mainWhere.visible = true
            },
            addOrEditBtnChange() {
                if (this.basic.form.addBtn || this.basic.form.editBtn) {
                    this.mainAdd.rules.elements[0].required = true
                } else {
                    this.mainAdd.rules.elements[0].required = false
                }
            },
            upAddFormColumn(item, index) {
                this.mainAdd.form.elements[index] = this.mainAdd.form.elements.splice(index - 1, 1, this.mainAdd.form.elements[index])[0];
            },
            downAddFormColumn(item, index) {
                this.mainAdd.form.elements[index] = this.mainAdd.form.elements.splice(index + 1, 1, this.mainAdd.form.elements[index])[0];
            },
            removeAddFormColumn(item, index) {
                this.mainAdd.form.elements.splice(index, 1)
                this.mainAddColumns.push({
                    name: item.key,
                    type: item.dataType
                })
            },
            addElementTypeChange(index) {
                if (typeof this.mainAdd.form.elements[index].typeIndex == 'number') {
                    this.mainAdd.form.elements[index].hides = this.addElementTypes[this.mainAdd.form.elements[index].typeIndex].hides
                    this.mainAdd.form.elements[index].rules = this.addElementTypes[this.mainAdd.form.elements[index].typeIndex].rules
                } else {
                    delete this.mainAdd.form.elements[index].typeIndex
                }
            },
            addFormColumnFun() {
                this.loading = true
                if (this.mainAdd.item != null && typeof this.mainAdd.item != 'undefined') {
                    for (let i = 0; i < this.mainAddColumns.length; i ++) {
                        if (this.mainAddColumns[i].name === this.mainAdd.item) {
                            this.mainAdd.form.elements.push({
                                key: this.mainAddColumns[i].name,
                                dataType: this.mainAddColumns[i].type,
                                hides: []
                            })
                            this.mainAddColumns.splice(i,1)
                            this.$refs.mainAddForm.validateField("elements");
                            break
                        }
                    }
                }
                this.closeAddFormColumn()
                this.loading = false
            },
            closeAddFormColumn() {
                this.mainAdd.visible = false
                this.mainAdd.item = null
            },
            showAddFormColumn() {
                this.mainAdd.visible = true
            },
            upAddBottom(item, index) {
                this.mainBottom.form.list[index] = this.mainBottom.form.list.splice(index - 1, 1, this.mainBottom.form.list[index])[0];
            },
            downAddBottom(item, index) {
                this.mainBottom.form.list[index] = this.mainBottom.form.list.splice(index + 1, 1, this.mainBottom.form.list[index])[0];
            },
            removeAddBottom(item, index) {
                this.mainBottom.form.list.splice(index, 1)
            },
            bottomTypeChange(index) {
                if (typeof this.mainBottom.form.list[index].typeIndex == 'number') {
                    this.mainBottom.form.list[index].shows = this.bottomTypes[this.mainBottom.form.list[index].typeIndex].shows
                } else {
                    delete this.mainBottom.form.list[index].typeIndex
                }
            },
            addBottom() {
                this.loading = true
                this.mainBottom.form.list.push({
                    name: '',
                    shows: []
                })
                this.loading = false
            },
            upAddColumn(item, index) {
                this.mainTable.form.columns[index] = this.mainTable.form.columns.splice(index - 1, 1, this.mainTable.form.columns[index])[0];
            },
            downAddColumn(item, index) {
                this.mainTable.form.columns[index] = this.mainTable.form.columns.splice(index + 1, 1, this.mainTable.form.columns[index])[0];
            },
            removeAddColumn(item, index) {
                this.mainTable.form.columns.splice(index, 1)
                this.mainColumns.push({
                    name: item.key,
                    type: item.type
                })
            },
            formatterTypeChange(index) {
                if (typeof this.mainTable.form.columns[index].formatterTypeIndex == 'number') {
                    this.mainTable.form.columns[index].hides = this.formatterTypes[this.mainTable.form.columns[index].formatterTypeIndex].hides
                } else {
                    delete this.mainTable.form.columns[index].formatterTypeIndex
                }
            },
            addColumnFun() {
                this.loading = true
                if (this.addColumn.item != null && typeof this.addColumn.item != 'undefined') {
                    for (let i = 0; i < this.mainColumns.length; i ++) {
                        if (this.mainColumns[i].name === this.addColumn.item) {
                            this.mainTable.form.columns.push({
                                key: this.mainColumns[i].name,
                                type: this.mainColumns[i].type,
                                hides: []
                            })
                            this.mainColumns.splice(i,1)
                            this.$refs.mainTableForm.validateField("columns");
                            break
                        }
                    }
                }
                this.closeAddColumn()
                this.loading = false
            },
            closeAddColumn() {
                this.addColumn.visible = false
                this.addColumn.item = null
            },
            showAddColumn() {
                this.addColumn.visible = true
            },
            resetMainTable() {
                this.basic.form = {
                    schema: this.basic.form.schema,
                    table: this.basic.form.table
                }
                this.addOrEditBtnChange()
                this.mainTable.form.columns = []
                this.mainBottom.form.list = []
                this.mainColumns = []
                this.mainAddColumns = []
                this.activeNames = []
                this.mainAdd.form = {
                    elements: []
                }
                this.mainAdd.item = null
                delete this.basic.form.primaryKey
                this.basic.checked = false
            },
            getMainTable() {
                if (!this.basic.form.schema) {
                    this.$message.info('请填写数据库');
                    return
                }
                if (!this.basic.form.table) {
                    this.$message.info('请填写数据库表');
                    return
                }
                this.resetMainTable()
                this.loading = true
                axios.get(window.contextPath + '/api/getTable',{
                    params: {
                        schema: this.basic.form.schema,
                        table: this.basic.form.table
                    }
                }).then(res => {
                    if (res.data.status != 0) {
                        this.$message.error(res.data.msg);
                    }
                    else {
                        this.basic.form.primaryKey = res.data.content.table.primaryKey
                        this.mainColumns = JSON.parse(JSON.stringify(res.data.content.table.columns))
                        this.mainWhereColumns = JSON.parse(JSON.stringify(res.data.content.table.columns))
                        this.mainAddColumns = JSON.parse(JSON.stringify(res.data.content.table.columns))
                        for (let i = 0; i < this.mainAddColumns.length; i ++) {
                            if (this.mainAddColumns[i].name === res.data.content.table.primaryKey) {
                                this.mainAddColumns.splice(i,1)
                                break
                            }
                        }
                        this.basic.checked = true
                    }
                    this.loading = false;
                }).catch(res => {
                    console.error(res)
                    this.$message.error('服务异常');
                    this.loading = false;
                })
            }
        },
        created: function () {
            axios.get(window.contextPath + '/api/addElementTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.addElementTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })
            axios.get(window.contextPath + '/api/formatterTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.formatterTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })
            axios.get(window.contextPath + '/api/bottomTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.bottomTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })
            axios.get(window.contextPath + '/api/whereTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.whereTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })

            this.basic.form.schema = 'test_cms'
            this.basic.form.table = 'tb_main'
            // this.getMainTable()
        }
    })
</script>
</body>
</html>