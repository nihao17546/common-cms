<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>test</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        .slider-main {
            display: flex;
            flex-direction: column;
        }
        .slider-body {
            display: flex;
            flex-wrap: wrap;
        }
        .slider-menu {
            position: fixed;
            left: auto;
            width: 180px;
            overflow: auto;
            color: #000;
            height: auto;
            top: 10px;
        }
        .slider-menu-item {
            border-left: 2px solid #e8eaed;
            display: block;
            padding: 15px 0 0 30px;
            position: relative;
            line-height: 24px;
            color: inherit;
            cursor: pointer;
        }
        .slider-menu-item-active, .slider-menu-item:hover {
            color: #1a73e8;
        }
        .slider-menu-item-active {
            border-left: 2px solid #1a73e8;
        }
        .component-info {
            height: 100px;
            width: 600px;
            border: 1px solid #f0f0f0;
        }
        .slider-info {
            margin-left: 200px;
            display: flex;
            flex-direction: column;
            position: relative;
        }

    </style>
</head>
<body style="margin: 0px;">
<div id="app" v-loading="loading">
    <div class="slider-main">
        <div class="slider-body">
            <div ref="sliderMenu" class="slider-menu">
                <div class="slider-menu-item" v-for="(item, index) in data" :key='index' :style="item.style || {}"
                     :class="{'slider-menu-item-active': current === index}" @click="scrollToView(index)">
                    <span>{{item.name}}</span>
                </div>
            </div>
            <div class="slider-info">
                <div ref="scrollItem" class="component-info" v-for="(item, index) in data" :key="index + '-cmp'">
                    {{index}}
                    <component :is="item.component"></component>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
</script>
<script>
    window.vue = new Vue({
        name: 'test',
        el: '#app',
        props: {
            data: {
                type: [String, Number, Boolean, Object, Array],
                default: () => [
                    {name: '技术能力', style: {}, component: {}},
                    {name: '语音技术', style: {}, component: {}},
                    {name: '文字识别', style: {}, component: {}},
                    {name: '人脸与人体识别', style: {}, component: {}},
                    {name: '视频技术', style: {}, component: {}},
                    {name: 'AR与VR', style: {}, component: {}},
                    {name: '数据智能', style: {}, component: {}}
                ]
            }
        },
        data() {
            return {
                loading: false,
                current: 0
            }
        },
        watch: {
        },
        methods: {
            scrollToView (index) {
                let data = this.getScrollItems()
                if (index >= 0 && index < data.length) {
                    let item = data[index] || {}
                    const scrollTop = this.getScroll(window, true)
                    const elOffset = this.getOffset(item)
                    let top = elOffset.top - this.getStartTop()
                    window.scrollTo({top: top < 0 ? 0 : top, behavior: 'smooth'})
                }
            },
            handleScroll (e) {
                let data = this.getScrollItems()
                const scrollTop = this.getScroll(window, true)
                let maxTop = -99999
                data.forEach((target, index) => {
                    const elOffset = this.getOffset(target)
                    let realTop = elOffset.top - this.getStartTop() - scrollTop
                    if (realTop <= 0 && maxTop <= realTop) {
                        maxTop = realTop
                        this.current = index
                    }
                })
            },
            getStartTop () {
                if (this.$refs.sliderMenu) {
                    return this.$refs.sliderMenu.offsetTop || 0
                }
                return 0
            },
            getScrollItems () {
                let refs = []
                if (this.$refs.scrollItem && this.$refs.scrollItem.style) {
                    refs.push(this.$refs.scrollItem)
                } else if (this.$refs.scrollItem && this.$refs.scrollItem.length) {
                    refs = this.$refs.scrollItem
                }
                return refs
            },
            getScroll (target, top) {
                const prop = top ? 'pageYOffset' : 'pageXOffset'
                const method = top ? 'scrollTop' : 'scrollLeft'
                let ret = target[prop]
                if (typeof ret !== 'number') {
                    ret = window.document.documentElement[method]
                }
                return ret
            },
            getOffset (element) {
                const rect = element.getBoundingClientRect()
                const scrollTop = this.getScroll(window, true)
                const scrollLeft = this.getScroll(window)

                const docEl = window.document.body
                const clientTop = docEl.clientTop || 0
                const clientLeft = docEl.clientLeft || 0
                let height = rect.bottom - rect.top
                if (height === 0 && element.parentNode) {
                    let parentRect = element.parentNode.getBoundingClientRect()
                    height = parentRect ? parentRect.height || 0 : 0
                }
                return {
                    top: rect.top + scrollTop - clientTop,
                    left: rect.left + scrollLeft - clientLeft,
                    height: height,
                    width: rect.right - rect.left
                }
            }
        },
        beforeDestroy() {
            window.removeEventListener('scroll', this.handleScroll, false)
            window.removeEventListener('resize', this.handleScroll, false)
        },
        mounted() {
            window.addEventListener('scroll', this.handleScroll, false)
            window.addEventListener('resize', this.handleScroll, false)
        },
        created: function () {

        }
    })
</script>
</body>
</html>