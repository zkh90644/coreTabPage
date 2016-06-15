# CoreTabPage is a framework to support iOS basic ViewController switch 
--------
This is my first framework, it is the swift version of [PagerTab](https://github.com/ming1016/PagerTab)

**Different:**

1. auto resize the width of selectedLine
2. set the tabView as scrollView
3. I didnt set the scrollToTop function (Maybe coming soon...)

##usage
----
**Init class**

```
let tabPage = coreTabPage()

tabPage.delegate = self

view.addSubview(tabPage)
tabPage.frame = self.view.frame
        
tabPage.BuildIn()
tabPage.showRedDot(1)

```

**Protocol**

```
//add viewController to the class
func viewControllerOfIndex(index:Int) -> UIViewController

//set the cout of the scrollView and tab
func numBerOfPage() -> Int

//set the first page
func setFirstPageTag() -> Int?

```
----
###中文解释
CoreTabPager 是我的第一个framework（还没整合成包，大雾），这个是[PagerTab](https://github.com/ming1016/PagerTab)的swift版本，不过在原有的基础上有一定的修改

**不同：**

1. 下划线自动匹配按钮文字长度
2. tabView用scrollView写，从而方便增加多个按钮
3. 没有点击statusBar置顶效果，可能接下来会写。
4. 后期会增加自定义按钮的API？

##使用方法
----
**创建**

```
let tabPage = coreTabPage()

tabPage.delegate = self

view.addSubview(tabPage)
tabPage.frame = self.view.frame
        
tabPage.BuildIn()
tabPage.showRedDot(1)

```
**实现方法并解释**

```
//将ViewController加入类中
func viewControllerOfIndex(index:Int) -> UIViewController

//设置页码的数目
func numBerOfPage() -> Int

//设置初始页
func setFirstPageTag() -> Int?

```

