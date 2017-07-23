![](http://upload-images.jianshu.io/upload_images/2069062-71f45a10b6969e90.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 前言

最近在学习`swift`和`MVVM`架构模式，目的只是将自己的学习笔记记录下来，方便自己日后查找，仅此而已！！！

本来打算一篇全部搞定的，但是简书每篇文章只能写大约不超过15000字的内容，因此只能分开写了。

如果有任何问题，欢迎和我一起讨论。当然如果有什么存在的问题，欢迎批评指正，我会积极改造的！

---

## 这篇文章都写啥

- 自定义`NavgationBar`
- 抽取便利构造函数
- 初步的下拉刷新/上拉加载的简单处理
- 未登录逻辑的处理
- 苹果原生布局`NSLayoutConstraint`
- 如何用`VFL`布局`(VisualFormatLanguage)`
- 模拟网络加载应用程序的一些配置`tabBar`的标题和图片样式
- 简单的网络工具单例的封装
- 隔离项目中的网络请求方法
- 初步的视图模型的体验
- 以及一些遇到的语法问题的简单探究

---

## GitHub 上创建项目

如有需要，请移步下面两篇文章

- [iOS-将项目上传到 GitHub 上](http://www.jianshu.com/p/bcfb95f34a10)
- [iOS-将项目上传到 Git.OSChina 上，创建自己的私有项目](http://www.jianshu.com/p/72d51400bfac)

---

## 项目配置

- 删除`ViewController.swift`、`Main.storyboard`和`LaunchScreen.storyboard`
- 设置`APPIcon`和`LaunchImage`
- 设置项目目录结构
    - `HQMainViewController`继承自`UITabBarController`
    - `HQNavigationController`继承自`UINavigationController`
    - `HQBaseViewController`继承自`UIViewController`(基类控制器)

![](http://upload-images.jianshu.io/upload_images/2069062-1802e4575e0c59d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 设置子控制器

在`HQMainViewController`中设置四个子控制器

- 用`extension`将代码拆分
- 通过反射机制，获取子控制器类名，创建子控制器
- 设置每个子控制的`tabBar`图片及标题

`HQMainViewController`中代码如下所示

```swift
class HQMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
    }
}

/*
 extension 类似于 OC 中的分类,在 Swift 中还可以用来切分代码块
 可以把功能相近的函数,放在一个extension中
 */
extension HQMainViewController {
    
    /// 设置所有子控制器
    fileprivate func setupChildControllers() {
        
        let array = [
            ["className": "HQAViewController", "title": "首页", "imageName": "a"],
            ["className": "HQBViewController", "title": "消息", "imageName": "b"],
            ["className": "HQCViewController", "title": "发现", "imageName": "c"],
            ["className": "HQDViewController", "title": "我", "imageName": "d"]
        ]
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    /*
     ## 关于 fileprvita 和 private
     
     - 在`swift 3.0`，新增加了一个`fileprivate`，这个元素的访问权限为文件内私有
     - 过去的`private`相当于现在的`fileprivate`
     - 现在的`private`是真正的私有，离开了这个类或者结构体的作用域外面就无法访问了
     */
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典[className, title, imageName]
    /// - Returns: 子控制器
    private func controller(dict: [String: String]) -> UIViewController {
        
        // 1. 获取字典内容
        guard let className = dict["className"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else {
                
                return UIViewController()
        }
        
        // 2. 创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 3. 设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        // 设置`tabBar`标题颜色
        vc.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.orange],
            for: .selected)
        // 设置`tabBar`标题字体大小,系统默认是`12`号字
        vc.tabBarItem.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
            for: .normal)
        
        let nav = HQNavigationController(rootViewController: vc)
        return nav
    }
}
```

#### 设置中间加号按钮

- 通过增加`tabBarItem`的方式，给中间留出一个`+`按钮的位置
- 自定义一个`UIButton`的分类`HQButton+Extension`，封装快速创建自定义按钮的方法

`HQButton.swift`

```swift
extension UIButton {
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - backImageName: 背景图像名称
    convenience init(hq_imageName: String, backImageName: String?) {
        self.init()
        
        setImage(UIImage(named: hq_imageName), for: .normal)
        setImage(UIImage(named: hq_imageName + "_highlighted"), for: .highlighted)
        
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        }
        
        // 根据背景图片大小调整尺寸
        sizeToFit()
    }
}
```

`HQMainViewController.swift`

```swift
/// 设置撰写按钮
fileprivate func setupComposeButton() {
    tabBar.addSubview(composeButton)
    
    // 设置按钮的位置
    let count = CGFloat(childViewControllers.count)
    // 减`1`是为了是按钮变宽,覆盖住系统的容错点
    let w = tabBar.bounds.size.width / count - 1
    composeButton.frame = tabBar.bounds.insetBy(dx: w * 2, dy: 0)
    
    composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
}
```

```swift
// MARK: - 监听方法
// @objc 允许这个函数在运行时通过`OC`消息的消息机制被调用
@objc fileprivate func composeStatus() {
    print("点击加号按钮")
}

// MARK: - 撰写按钮
fileprivate lazy var composeButton = UIButton(hq_imageName: "tabbar_compose_icon_add",
                                          backImageName: "tabbar_compose_button")
```

---

## 自定义顶部导航栏

- 系统本身的绝大多数情况下不能满足我们的日常需求
- 有一些系统的样式本身处理的不好，比如侧滑返回的时候，系统的会出现渐溶的效果，这种用户体验不太好
- 需要解决`push`出一个控制器后，底部`TabBar`隐藏/显示问题

#### Push 出控制器后，底部 TabBar 隐藏/显示问题

- 在导航控制器的基类里面重写一下`push`方法
- 判断如果不是根控制器，那么`push`的时候就隐藏`BottomBar`
- 注意调用`super.pushViewController`要在重写方法之后

`HQNavigationController.swift`

```swfit
override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    
    if childViewControllers.count > 0 {
        viewController.hidesBottomBarWhenPushed = true
    }
    super.pushViewController(viewController, animated: true)
}
```

#### 抽取 BarButtonItem 便利构造函数

- 系统的`UIBarButtonItem`方法不能方便的满足我们创建所需的`leftBarButtonItem`或`rightBarButtonItem`
- 如果自定义创建需要些好几行代码
- 而这些代码又可能在很多地方用到，所以尽量抽取个便利构造函数

一般自定义`ftBarButtonItem`时候可能会写如下代码

- 最讨厌的就是`btn.sizeToFit()`这句,如果不加,`rightBarButtonItem`就显示不出来
- 如果封装起来，就再也不用考虑这问题了

```swift
let btn = UIButton()
btn.setTitle("下一个", for: .normal)
btn.setTitleColor(UIColor.lightGray, for: .normal)
btn.setTitleColor(UIColor.orange, for: .highlighted)
btn.addTarget(self, action: #selector(showNext), for: .touchUpInside)
// 最讨厌的就是这句,如果不加,`rightBarButtonItem`就显示不出来
btn.sizeToFit()
navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
```

如果抽取一个便利构造函数，代码可能会简化成如下

- 一行代码搞定，简单了许多

```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(hq_title: "下一个", target: self, action: #selector(showNext))
```

> 便利构造函数的作用：**简化控件的创建**

---

## 解决导航栏侧滑返回过程中，按钮及标题的融合问题

- 因为侧滑返回的时候，`leftBarButtonItem`及`title`的字体有渐融的问题，我们又想解决这样的问题。
- 于是乎就要自定义`NavigationBar`
- 要想实现这些功能，一定尽量要少动很多控制器的代码。如果在某一个地方就可以写好，对其它控制器的代码入侵的越少越好，这是一个程序好的架构的原则

首先，在`HQNavigationController`中隐藏系统的`navigationBar`

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBar.isHidden = true
}
```

其次，在基类控制器`HQBaseViewController`里自定义

```swfit
class HQBaseViewController: UIViewController {
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.hq_screenWidth(), height: 64))
    /// 自定义导航条目 - 以后设置导航栏内容,统一使用`navItem`
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
}

// MARK: - 设置界面
extension HQBaseViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.hq_randomColor()
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
    }
}
```

注意：这里有一个小`bug`

- 在`push`出下一个控制器的时候，导航栏右侧会有一段`白色`的样式出现
- 原因是：系统默认的导航栏的透明度太高，自定义设置一个颜色就好了

`HQBaseViewController.swift`
 
```swfit
// 设置`navigationBar`的渲染颜色
navigationBar.barTintColor = UIColor.hq_color(withHex: 0xF6F6F6)
```

#### 设置左侧 leftBarButtonItem

- 左侧都是返回(第二级页面以下)
- 或者是上一级`title`的名称(只在第二级页面这样显示)

在重写`pushViewController`的方法里面去判断，如果子控制器的个数`childViewControllers.count` == `1`的时候，就设置返回按钮`文字`为根控制器的`title`

```swift
override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    
    if childViewControllers.count > 0 {
        viewController.hidesBottomBarWhenPushed = true
        
        /*
         判断控制器的类型
         - 如果是第一级页面,不显示`leftBarButtonItem`
         - 只有第二级页面以后才显示`leftBarButtonItem`
         */
        if let vc = viewController as? HQBaseViewController {
            
            var title = "返回"
            
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title ?? "返回"
            }
            
            vc.navItem.leftBarButtonItem = UIBarButtonItem(hq_title: title, target: self, action: #selector(popToParent))
        }
    }
    
    super.pushViewController(viewController, animated: true)
}
```

#### 给 leftBarButtonItem 加上 icon

还是之前的原则，**当改动某一处的代码时候，尽量对原有代码做尽可能小的改动**

- 之前我们已经设置好`leftbarButtonItem`文字显示的状态问题
- 我们的需求又是在此基础上直接加一个返回的`icon`而已
- 因此，我们如果对自定义快速创建`leftBarButtonItem`这里如果能直接改好了就最好

> 小技巧：
> - 当你想查看某一个方法都在哪个文件内被哪些方法调用的时候
> - 你可以在这个方法的方法明上`右键`->`Find Call Hierarchy`
> Hierarchy : 层级

![](http://upload-images.jianshu.io/upload_images/2069062-f60734562a040f9e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

将`UIBarButtonItem`的自定义快速创建`leftbarButtonItem`的方法扩展一下，增加一个参数`isBack`，默认值是`false`

```swift
/// 字体+target+action
///
/// - Parameters:
///   - hq_title: title
///   - fontSize: fontSize
///   - target: target
///   - action: action
///   - isBack: 是否是返回按钮,如果是就加上箭头的`icon`
convenience init(hq_title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
    
    let btn = UIButton(hq_title: hq_title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
    
    if isBack {
        let imageName = "nav_back"
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
    }
    
    btn.addTarget(target, action: action, for: .touchUpInside)
    // self.init 实例化 UIBarButtonItem
    self.init(customView: btn)
}
```

在之前判断返回按钮显示文字的地方重新设置一下，只需要增加一个参数`isBack: true`

```swift
vc.navItem.leftBarButtonItem = UIBarButtonItem(hq_title: title, target: self, action: #selector(popToParent), isBack: true)
```

经过这样的演进，我突然发现`swift`在这里是比`objective-c`友好很多的，如果你给参数设置了一个默认值。那么，就可以不对原方法造成侵害，不影响原方法的调用。

但是，`objective-c`就没有这么友好，如果在原方法上增加参数，那么之前调用过此方法的地方，就会全部报错。如果不想对原方法有改动，那么就要重新写一个完全一样的只是最后面增加了这个**需要的参数**而已的一个新的方法。

你看`swift`是不是真的简洁了许多。

#### 设置 navigationBar 的 title 的颜色

`navigationBar.tintColor = UIColor.red`这样是不对的，因为`tintColor`不是设置标题颜色的。

> `barTintColor`是管理整个导航条的背景色
> 
> `tintColor`是管理导航条上`item`文字的颜色
> 
> `titleTextAttributes`是设置导航栏`title`的颜色

如果你找不到设置的方法，最好去`UINavigationItem`的头文件里面去找一下，你可以`control + 6`快速搜索`color`关键字，如果没有的话，建议你搜索`attribute`试试，因为一般设置属性的方法都可以解决多数你想解决的问题的。

```swift
// 设置`navigationBar`的渲染颜色
navigationBar.barTintColor = UIColor.hq_color(withHex: 0xF6F6F6)
// 设置导航栏`title`的颜色
navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
// 设置系统`leftBarButtonItem`渲染颜色
navigationBar.tintColor = UIColor.orange
```

---

## 设置设备方向

有些时候我们的`APP`可能会在某个界面里面需要支持**横屏**但是其它的地方又希望它只支持竖屏，这就需要我们用代码去设置

```swift
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
}
```

设置支持的方向之后,当前的控制器及子控制器都会遵守这个方向,因此写在`HQMainViewController`里面

---

## 利用 extension 隔离 TableView 数据源方法

在基类设置`datasource`和`delegate`，这样子类就可以直接实现方法就可以了，不用每个`tableView`的页面都去设置`tableView?.dataSource = self`和`tableView?.delegate = self`了。

- 基类只是实现方法,子类负责具体的实现
- 子类的数据源方法不需要`super`
- 返回`UITableViewCell()`只是为了没有语法错误

在`HQBaseViewController`里，实现如下代码

```swift
extension HQBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
```

设置一个加载数据的方法`loadData`，在这里并不去做任何事情，只是为了方便子类重写此方法加载数据就可以了。

```swift
/// 加载数据,具体的实现由子类负责
func loadData() {
    
}
```

#### 绑定假数据测试

由于`HQBaseViewController`里面实现了`tableView`的`tableViewDataSource`和`tableViewDelegate`以及`loadData(自定义加载数据的方法)`，下一步我们就要在子控制器里面测试一下效果了。

- 制造一些假数据

```swift
fileprivate lazy var statusList = [String]()

/// 加载数据
override func loadData() {
    
    for i in 0..<10 {
        statusList.insert(i.description, at: 0)
    }
}
```

- 实现数据源方法

```swift
// MARK: - tableViewDataSource
extension HQAViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = statusList[indexPath.row]
        return cell
    }
}
```

至此，界面上应该可以显示出数据了，如下所示

![](http://upload-images.jianshu.io/upload_images/2069062-128012de907180e0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是仔细观察是存在问题的

- 第一行应该是从`9`开始的，说明`tableView`的起始位置不对
- 如果数据足够多的情况下(多到可以超过一个屏幕的数据)，可以发现下面也是停在`tabBar`的后面，底部位置也有问题

#### 解决 TableView 的位置问题

主要在`HQBaseViewController`里，重新设置`tableView`的`ContentInsets`

```swift
/*
 取消自动缩进,当导航栏遇到`scrollView`的时候,一般都要设置这个属性
 默认是`true`,会使`scrollView`向下移动`20`个点
 */
automaticallyAdjustsScrollViewInsets = false
```

```swift
tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                       left: 0,
                                       bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                       right: 0)
```

因为一般的公司里，页面多数都是`ViewController + TableView`。所以，类似的需求，直接在基类控制器设置好就可以了。

---

## 添加下拉刷新控件

- 在基类控制器中定义下拉刷新控件，这样就不用每个子控制器页面单独设置了
- 给`refreshControl`添加监听方法，监听`refreshControl`的`valueChange`事件
- 当值改变的时候，重新执行`loadData`方法
- 子类会重写基类的`loadData`方法，因此不用在去子类重写此方法

```swift
// 设置刷新控件
refreshControl = UIRefreshControl()
tableView?.addSubview(refreshControl!)
refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
```

#### 模拟延时加载数据

- 一般网络请求都会有延时，为了模拟的逼真一点，这里我们也做了模拟延时加载数据。
- 并且对比一下`swift`和`objective-c`的延迟加载异同点

模拟延迟加载数据

```swift
/// 加载数据
override func loadData() {
    
    // 模拟`延时`加载数据
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
        for i in 0..<15 {
            self.statusList.insert(i.description, at: 0)
        }
        self.refreshControl?.endRefreshing()
        self.tableView?.reloadData()
    }
}
```

swift 延迟加载

```swift
// 模拟`延时`加载数据
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    
    print("5 秒后,执行闭包内的代码")
}
```

objective-c 延迟加载

```objective-c
/*
 dispatch_time_t when,      从现在开始,经过多少纳秒(delayInSeconds * 1000000000)
 dispatch_queue_t queue,    由队列调度任务执行
 dispatch_block_t block     执行任务的 block
 */
dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));

dispatch_after(when, dispatch_get_main_queue(), ^{
    // code to be executed after a specified delay
    NSLog(@"5 秒后,执行 Block 内的代码");
});
```

虽然都是一句话，但是`swift`语法的可读性明显比`objective-c`要好一些。

---

## 上拉刷新

现在多数`APP`做无缝的上拉刷新，就是当`tableView`滚动到最后一行`cell`的时候，自动刷新加载数据。

用一个属性来记录是否是上拉加载数据

```swift
/// 上拉刷新标记
var isPullup = false
```

滚动到最后一行 cell 的时候加载数据

```swift
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    let row = indexPath.row
    let section = tableView.numberOfSections - 1
    
    if row < 0 || section < 0 {
        return
    }
    
    let count = tableView.numberOfRows(inSection: section)
    
    if row == (count - 1) && !isPullup {
        
        isPullup = true
        loadData()
    }
}
```

在首页控制器里面模拟加载数据的时候，根据属性`isPullup`判断是上拉加载，还是下拉刷新

```swift
/// 加载数据
override func loadData() {
    
    // 模拟`延时`加载数据
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
        for i in 0..<15 {
            
            if self.isPullup {
                self.statusList.append("上拉 \(i)")
            } else {
                self.statusList.insert(i.description, at: 0)
            }
        }
        self.refreshControl?.endRefreshing()
        self.isPullup = false
        self.tableView?.reloadData()
    }
}
```

---

## 未登录视图显示(访客视图)

现实中经常会遇到一些临时增加的需求，比如登录后显示的是一种视图，未登录又显示另外一种视图，如果你的公司是面向公司内部的`APP`，那么你可能会面对更多的用户角色。这里我们暂时只讨论**已登录**和**未登录**两种状态下的情况。

还是之前的原则，不管做什么新功能，增加什么临时的需求，我们要做的都是想办法对原来的代码及架构做最小的调整，特别是对原来的`Controller`里面的代码入侵的越小越好。

在基类控制器的`setupUI(设置界面)`的方法里面，我们直接创建了`tableView`，那么我们如果有一个标记，能根据这个标记来选择是创建普通视图，还是创建访客视图。就可以很好的解决此类问题了。

- 增加一个用户登录标记

```swift
/// 用户登录标记
var userLogon = false
```

- 根据标记判断视图显示

```swift
userLogon ? setupTableView() : setupVistorView()
```

- 创建访客视图的代码

```swift
/// 设置访客视图
fileprivate func setupVistorView() {
    
    let vistorView = UIView(frame: view.bounds)
    vistorView.backgroundColor = UIColor.hq_randomColor()
    view.insertSubview(vistorView, belowSubview: navigationBar)
}
```

自定义一个 View，继承自`UIView`，在里面设置访客视图的界面

```swift
class HQVistorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置访客视图界面
extension HQVistorView {
    
    func setupUI() {
        backgroundColor = UIColor.white
    }
}
```

#### 利用原生布局系统定义访客视图界面

在自定义访客视图`HQVistorView`中布局各个子控件

- 懒加载控件

```swift
/// 图像视图
fileprivate lazy var iconImageView: UIImageView = UIImageView(hq_imageName: "visitordiscover_feed_image_smallicon")
/// 遮罩视图
fileprivate lazy var maskImageView: UIImageView = UIImageView(hq_imageName: "visitordiscover_feed_mask_smallicon")
/// 小房子
fileprivate lazy var houseImageView: UIImageView = UIImageView(hq_imageName: "visitordiscover_feed_image_house")
/// 提示标签
fileprivate lazy var tipLabel: UILabel = UILabel(hq_title: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜")
/// 注册按钮
fileprivate lazy var registerButton: UIButton = UIButton(hq_title: "注册", color: UIColor.orange, backImageName: "common_button_white_disable")
/// 登录按钮
fileprivate lazy var loginButton: UIButton = UIButton(hq_title: "登录", color: UIColor.darkGray, backImageName: "common_button_white_disable")
```

- 添加视图

```swift
addSubview(iconImageView)
addSubview(maskImageView)
addSubview(houseImageView)
addSubview(tipLabel)
addSubview(registerButton)
addSubview(loginButton)

// 取消 autoresizing
for v in subviews {
    v.translatesAutoresizingMaskIntoConstraints = false
}
```

- 原生布局

自动布局本质公式 : A控件的属性a = B控件的属性b * 常数 + 约束 

```swift
firstItem.firstAttribute {==,<=,>=} secondItem.secondAttribute * multiplier + constant
```

```swift
let margin: CGFloat = 20.0

/// 图像视图
addConstraint(NSLayoutConstraint(item: iconImageView,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .centerX,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: iconImageView,
                                 attribute: .centerY,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .centerY,
                                 multiplier: 1.0,
                                 constant: -60))
/// 小房子
addConstraint(NSLayoutConstraint(item: houseImageView,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: iconImageView,
                                 attribute: .centerX,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: houseImageView,
                                 attribute: .centerY,
                                 relatedBy: .equal,
                                 toItem: iconImageView,
                                 attribute: .centerY,
                                 multiplier: 1.0,
                                 constant: 0))
/// 提示标签
addConstraint(NSLayoutConstraint(item: tipLabel,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: iconImageView,
                                 attribute: .centerX,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: tipLabel,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: iconImageView,
                                 attribute: .bottom,
                                 multiplier: 1.0,
                                 constant: margin))
addConstraint(NSLayoutConstraint(item: tipLabel,
                                 attribute: .width,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: 236))
/// 注册按钮
addConstraint(NSLayoutConstraint(item: registerButton,
                                 attribute: .left,
                                 relatedBy: .equal,
                                 toItem: tipLabel,
                                 attribute: .left,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: registerButton,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: tipLabel,
                                 attribute: .bottom,
                                 multiplier: 1.0,
                                 constant: margin))
addConstraint(NSLayoutConstraint(item: registerButton,
                                 attribute: .width,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: 100))
/// 登录按钮
addConstraint(NSLayoutConstraint(item: loginButton,
                                 attribute: .right,
                                 relatedBy: .equal,
                                 toItem: tipLabel,
                                 attribute: .right,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: loginButton,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: registerButton,
                                 attribute: .top,
                                 multiplier: 1.0,
                                 constant: 0))
addConstraint(NSLayoutConstraint(item: loginButton,
                                 attribute: .width,
                                 relatedBy: .equal,
                                 toItem: registerButton,
                                 attribute: .width,
                                 multiplier: 1.0,
                                 constant: 0))
```

#### 采用 VFL 布局子控件

- VFL 可视化语言，多用于连续参照关系，如遇到居中对其，通常多使用参照
- `H`水平方向
- `V`竖直方向
- `|`边界
- `[]`包含控件的名称字符串,对应关系在`views`字典中定义
- `()`定义控件的宽/高,可以在`metrics`中指定
    
VFL 参数的解释 :

- views: 定义 VFL 中控件名称和实际名称的映射关系
- metrics: 定义 VFL 中 () 内指定的常数映射关系，防止在代码中出现魔法数字

```swift
let viewDict: [String: Any] = ["maskImageView": maskImageView,
                "registerButton": registerButton]
let metrics = ["spacing": -35]

addConstraints(NSLayoutConstraint.constraints(
    withVisualFormat: "H:|-0-[maskImageView]-0-|",
    options: [],
    metrics: nil,
    views: viewDict))
addConstraints(NSLayoutConstraint.constraints(
    withVisualFormat: "V:|-0-[maskImageView]-(spacing)-[registerButton]",
    options: [],
    metrics: metrics,
    views: viewDict))
```

---

## 处理每个子控制器访客视图显示问题

到目前为止，虽然我们只是在基类控制器里面创建了访客视图`setupVistorView`，只有一个访客视图的`HQVistorView`，但是实际上当我们点击不同的子控制器的时候，每个子控制器都会创建一个**访客视图**。点击四个子控制器的时候，访客视图打印的地址都不一样。

```swift
<HQSwiftMVVM.HQVistorView: 0x7fea6970ed30; frame = (0 0; 375 667); layer = <CALayer: 0x608000036ec0>>
<HQSwiftMVVM.HQVistorView: 0x7fea6940d3b0; frame = (0 0; 375 667); layer = <CALayer: 0x600000421e60>>
<HQSwiftMVVM.HQVistorView: 0x7fea6973cf60; frame = (0 0; 375 667); layer = <CALayer: 0x608000036a40>>
<HQSwiftMVVM.HQVistorView: 0x7fea6943d990; frame = (0 0; 375 667); layer = <CALayer: 0x600000423760>>
```

定义一个属性字典，把图片名称和提示标语传入到`HQVistorView`中，通过重写`didSet`方法设置

```swift
/// 设置访客视图信息字典[imageName / message]
var vistorInfo: [String: String]? {
    didSet {
        guard let imageName = vistorInfo?["imageName"],
            let message = vistorInfo?["message"]
        else {
            return
        }
        tipLabel.text = message
        if imageName == "" {
            return
        }
        iconImageView.image = UIImage(named: imageName)
    }
}
```

在`HQBaseViewController`定义一个同样的访客视图信息字典，方便外界传入。这样做的目的是外界传入到`HQBaseViewController`中信息字典，可以通过`setupVistorView`方法传到`HQVistorView`中，再重写`HQVistorView`中的访客视图信息字典的`didSet`方法以达到设置的目的。

```swift
/// 设置访客视图信息字典
var visitorInfoDictionary: [String: String]?
```

```swift
/// 设置访客视图
fileprivate func setupVistorView() {
    
    let vistorView = HQVistorView(frame: view.bounds)
    view.insertSubview(vistorView, belowSubview: navigationBar)
    vistorView.vistorInfo = visitorInfoDictionary
}
```

下一步就是研究在哪里给访客视图信息字典传值的问题了。


#### 修改设置子控制器的参数配置

- 修改设置子控制器的配置

```swift
fileprivate func setupChildControllers() {
    
    let array: [[String: Any]] = [
        [
            "className": "HQAViewController",
            "title": "首页",
            "imageName": "a",
            "visitorInfo": [
                "imageName": "",
                "message": "关注一些人，回这里看看有什么惊喜"
            ]
        ],
        [
            "className": "HQBViewController",
            "title": "消息",
            "imageName": "b",
            "visitorInfo": [
                "imageName": "visitordiscover_image_message",
                "message": "登录后，别人评论你的微博，发给你的信息，都会在这里收到通知"
            ]
        ],
        [
            "className": "UIViewController"
        ],
        [
            "className": "HQCViewController",
            "title": "发现",
            "imageName": "c",
            "visitorInfo": [
                "imageName": "visitordiscover_image_message",
                "message": "登录后，最新、最热微博尽在掌握，不再会与时事潮流擦肩而过"
            ]
        ],
        [
            "className": "HQDViewController",
            "title": "我",
            "imageName": "d",
            "visitorInfo": [
                "imageName": "visitordiscover_image_profile",
                "message": "登录后，你的微博、相册，个人资料会显示在这里，显示给别人"
            ]
        ]
    ]
    
    (array as NSArray).write(toFile: "/Users/wanghongqing/Desktop/demo.plist", atomically: true)
    
    var arrayM = [UIViewController]()
    for dict in array {
        arrayM.append(controller(dict: dict))
    }
    viewControllers = arrayM
}
```

```swift
fileprivate func controller(dict: [String: Any]) -> UIViewController {
    
    // 1. 获取字典内容
    guard let className = dict["className"] as? String,
        let title = dict["title"] as? String,
        let imageName = dict["imageName"] as? String,
        let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? HQBaseViewController.Type,
        let vistorDict = dict["visitorInfo"] as? [String: String]
    
        else {
            
            return UIViewController()
    }
    
    // 2. 创建视图控制器
    let vc = cls.init()
    vc.title = title
    vc.visitorInfoDictionary = vistorDict
}
```

#### 将数组写入`plist`并保存到本地

在`swfit`语法里，并没有直接将`array`通过`write(toFile:)`的方法。因此，这里需要转一下，方便查看数据格式。

```swift
(array as NSArray).write(toFile: "/Users/wanghongqing/Desktop/demo.plist", atomically: true)
```

#### 设置首页动画旋转效果

有几点需要注意的

- 动画旋转需要一直保持，切换到其它控制器或者退到后台再回来，要保证动画仍然能继续转动
- 设置动画的旋转周数`tiValue`的`M_PI`在`swift 3.0`以后已经不能再用了，需要用`Double.pi`替代

```swift
if imageName == "" {
    startAnimation()
    return
}
```

```swift
/// 旋转视图动画
fileprivate func startAnimation() {
    
    let anim = CABasicAnimation(keyPath: "transform.rotation")
    anim.toValue = 2 * Double.pi
    anim.repeatCount = MAXFLOAT
    anim.duration = 15
    
    // 设置动画一直保持转动,如果`iconImageView`被释放,动画会被一起释放
    anim.isRemovedOnCompletion = false
    // 将动画添加到图层
    iconImageView.layer.add(anim, forKey: nil)
}
```

#### 使用 json 配置文件设置界面控制器内容

将之前`HQMainViewController`写好的配置内容(控制各个控制器标题等内容的数组)输出`main.json`文件，并保存。

```swift
let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
(data as NSData).write(toFile: "/Users/wanghongqing/Desktop/main.json", atomically: true)
```

将`main.json`拖入到文件中，通过加载这个`main.json`配置界面控制器内容。

```swift
/// 设置所有子控制器
fileprivate func setupChildControllers() {
    
    // 从`Bundle`加载配置的`json`
    guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
        let data = NSData(contentsOfFile: path),
    let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: Any]]
        else {
        return
    }
    
    var arrayM = [UIViewController]()
    for dict in array! {
        arrayM.append(controller(dict: dict))
    }
    viewControllers = arrayM
}
```

---

## 模拟网络加载应用程序配置

现在很多应用程序都是带有一个配置文件的`.json`文件，当应用程序启动的时候去查看沙盒里面有没有该`.json`文件。
- 如果没有
    - 通过网络请求加载默认的`.json`文件
- 如果有
    - 直接使用沙盒里面保存的`.json`文件
    - 网络请求异步加载新的`.json`文件，等下一次用户再次启动`APP`的时候就可以显示比较新的配置文件了

在`AppDelegate`中模拟加载数据

```swift
extension AppDelegate {
    
    fileprivate func loadAppInfo() {
        
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData(contentsOf: url!)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (path as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}
```

在`HQMainViewController`中设置

```swift
/// 设置所有子控制器
fileprivate func setupChildControllers() {
    
    /// 获取沙盒`json`路径
    let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let jsonPath = (docPath as NSString).appendingPathComponent("main.json")
    
    /// 加载 `data`
    var data = NSData(contentsOfFile: jsonPath)
    
    /// 如果`data`没有内容,说明沙盒没有内容
    if data == nil {
        // 从`bundle`加载`data`
        let path = Bundle.main.path(forResource: "main.json", ofType: nil)
        data = NSData(contentsOfFile: path!)
    }
    
    // 从`Bundle`加载配置的`json`
    guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: Any]]
        else {
        return
    }
    
    var arrayM = [UIViewController]()
    for dict in array! {
        arrayM.append(controller(dict: dict))
    }
    viewControllers = arrayM
}
```

---

## 解释一下 try

在之前的代码中，`json`的反序列化的时候，我们遇到了`try`，下面用几个简单的例子说明一下

#### 推荐用法，弱 try->`try?`

```swift
let jsonString = "{\"name\": \"zhang\"}"
let data = jsonString.data(using: .utf8)

let json = try? JSONSerialization.jsonObject(with: data!, options: [])
print(json ?? "nil")

// 输出结果
{
    name = zhang;
}
```

如果`jsonString`的格式有问题的话，比如改成下面这样

```swift
let jsonString = "{\"name\": \"zhang\"]"
```

则输出

```swift
nil
```

#### 不推荐用法 强 try->`try!`

当我们改成强`try!`并且`jsonString`有问题的时候

```swift
let jsonString = "{\"name\": \"zhang\"]"
let data = jsonString.data(using: .utf8)

let json = try! JSONSerialization.jsonObject(with: data!, options: [])
print(json)
```

则会直接崩溃，崩溃到`try!`的地方

![](http://upload-images.jianshu.io/upload_images/2069062-4bfc8018212badbf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```error
Error Domain=NSCocoaErrorDomain Code=3840 "Badly formed object around character 16." UserInfo={NSDebugDescription=Badly formed object around character 16.}: file /Library/Caches/com.apple.xbs/Sources/swiftlang/swiftlang-802.0.53/src/swift/stdlib/public/core/ErrorType.swift, line 182
```

虽然会将错误信息完整的打印出来，但是程序崩溃对于用户来说是很不友好的，因此不建议。

#### do...catch...

对于第二种情况，我们可以采用`do...catch...`避免程序崩溃。

```swift
let jsonString = "{\"name\": \"zhang\"]"
let data = jsonString.data(using: .utf8)

do {
    let json = try JSONSerialization.jsonObject(with: data!, options: [])
    print(json)
} catch {
    print(error)
}
```

程序可以免于崩溃，但是会增加语法结构的复杂性，并且`ARC`开发中，编译器自动添加`retain`、`release`、`autorelease`，如果用`do...catch...`一旦不平衡，就会出现内存泄露的问题。所以如果当真用的时候要慎重！

---

## 监听注册和登录按钮的点击事件

在`HQVistorView`里将两个按钮暴露出来，然后直接在`HQBaseViewController`中添加监听方法即可。

```swift
/// 注册按钮
lazy var registerButton: UIButton = UIButton(hq_title: "注册", color: UIColor.orange, backImageName: "common_button_white_disable")
/// 登录按钮
lazy var loginButton: UIButton = UIButton(hq_title: "登录", color: UIColor.darkGray, backImageName: "common_button_white_disable")
```

```swift
vistorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
vistorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
```

```swift
// MARK: - 注册/登录 点击事件
extension HQBaseViewController {
    
    @objc fileprivate func login() {
        print(#function)
    }
    @objc fileprivate func register() {
        print("bbb")
    }
}
```

这里之所以选择直接`addTarget`方法，是因为这样最简单，如果用**代理** / **闭包**等方式会增加很多代码。代理的合核心是**解耦**，当一个控件可以不停的被复用的时候就选择**代理**，比如`TableViewDelegate`中的`didSelectRowAt indexPath:`该方法是可以在任何地方只要创建`TableView`都可能被用到的方法。因此，设置成`Delegate`。

在这里`HQVistorView`和`HQBaseViewController`是紧耦合的关系，`HQVistorView`可以看成是从属于`HQBaseViewController`。基本不会被在其它地方被用到。虽然是紧耦合，但是添加监听方法特别简单。是否需要解耦需要根据实际情况判断，没必要为了解耦而解耦，为了模式而模式。

总结

- 使用代理传递消息是为了在控制器和视图之间解耦，让视图能够被多个控制器复用，如`TableView`
- 但是，如果视图仅仅是为了封装代码，而从控制器中剥离出来的，并且能够确认该视图不会被其它控制器引用，则可以直接通过`addTarget`的方式为该视图中的按钮添加监听方法
- 这样做的代价是耦合度高，控制器和视图绑定在一起，但是省略部分冗余代码

---

## 调整未登录时导航按钮

如果单纯的在`setupVistorView`中设置`leftBarButtonItem`和`rightBarButtonItem`，那么在首页就会出现左侧的`leftBarButtonItem`变成了`好友`了，再点击`好友`按钮`push`出来的控制器的所有的返回按钮都变成了`注册`。

而在未登录状态下，导航栏上面的按钮都是显示`注册`和`登录`。登录之后才显示别的，因此，我们可以将`HQBaseViewController`中的`setupUI`方法设置成`fileprivate`不让外界访问到，并且将`setupTableView`设置成外界可以访问，如果需要在登录后的控制器里面显示所需的样式，只需要在各子类重写`setupTableView`的方法里重新设置`leftBarButtonItem`就可以了。

```swift
/// 设置访客视图
fileprivate func setupVistorView() {
    
    navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
    navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
}
```

---

使用`CocoaPods`管理一些我们需要用到的第三方工具，这里跳过。

---

## 封装网络工具单例

`swift`单例写法

```swift
static let shared = HQNetWorkManager()
```

`objective-c`单例写法

```objective-c
+ (instancetype)sharedTools {
    
    static HQNetworkTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:HQBaseURL];
        tools = [[self alloc] initWithBaseURL:baseURL];

        tools.requestSerializer = [AFJSONRequestSerializer serializer];
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    return tools;
}
```

到此，我们不要急于包装网络请求方法，应该先测试一下网络请求通不通，实际中我们也是一样，先把要实现的主要目标先完成，然后再进行深层次的探究。

在`HQAViewController`中加载数据测试

```swift
/// 加载数据
override func loadData() {
    
    let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
    let para = ["access_token": "2.00It5tsGQ6eDJE4ecbf2d825DCpbBD"]
    
    HQNetWorkManager.shared.get(urlString, parameters: para, progress: nil, success: { (_, json) in
        print(json ?? "")
    }) { (_, error) in
        print(error)
    }
```

请求到的数据

```data
{
    ad =     (
    );
    advertises =     (
    );
    "has_unread" = 0;
    hasvisible = 0;
    interval = 2000;
    "max_id" = 4130532835237793;
    "next_cursor" = 4130532835237793;
    "previous_cursor" = 0;
    "since_id" = 4130540976425281;
    statuses =     (
                {
            "attitudes_count" = 0;
            "biz_feature" = 0;
            "bmiddle_pic" = "http://wx3.sinaimg.cn/bmiddle/9603cdd7ly1fhmz6ui42tj20l414a0w7.jpg";
            "comment_manage_info" =             {
                "comment_permission_type" = "-1";
            };
            "comments_count" = 0;
            "created_at" = "Mon Jul 17 16:46:13 +0800 2017";
```

#### 封装`AFNetworking`的`GET`和`POST`请求

注意：

如果你的闭包是这样的写法

```swift
func request(method: HQHTTPMethod = .GET, URLString: String, parameters: [String: Any], completion: (json: Any?, isSuccess: Bool)->()) {
```

那么在你调用`completion`这个闭包的时候，你可能会遇到下面的错误

```error
Closure use of non-escaping parameter 'completion' may allow it to escape
```

解决办法直接按照`Xcode`的提示就可以改正了，应该是下面的样子

```swift
func request(method: HQHTTPMethod = .GET, URLString: String, parameters: [String: Any], completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
```

From the [Apple Developer docs](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html)

> A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns. When you declare a function that takes a closure as one of its parameters, you can write @escaping before the parameter’s type to indicate that the closure is allowed to escape.

简单总结：

因为该函数中的网络请求方法，有一个参数`completion: (json: Any?, isSuccess: Bool)->()`是闭包。是在网络请求方法执**行完以后**的完成回调。即闭包在函数执行完以后被调用了，调用的地方超过了`request`函数的范围，这种闭包叫做`逃逸闭包`。

`swift 3.0`中对闭包做了改变，默认请款下都是`非逃逸闭包`，不再需要`@noescape`修饰。而如果你的闭包是在函数执行完以后再调用的，比如我举例子的网络请求完成回调，这种`逃逸闭包`，就需要用`@escaping`修饰。

如果你先仔细了解这方便的问题请阅读[Swift 3必看：@noescape走了， @escaping来了](http://www.jianshu.com/p/120069d493f5)

网络工具类`HQNetWorkManager`中的代码

```swift
enum HQHTTPMethod {
    case GET
    case POST
}

class HQNetWorkManager: AFHTTPSessionManager {
    
    static let shared = HQNetWorkManager()
    
    /// 封装 AFN 的 GET/POST 请求
    ///
    /// - Parameters:
    ///   - method: GET/POST
    ///   - URLString: URLString
    ///   - parameters: parameters
    ///   - completion: 完成回调(json, isSuccess)
    func request(method: HQHTTPMethod = .GET, URLString: String, parameters: [String: Any], completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        
        let success = { (task: URLSessionDataTask, json: Any?)->() in
            completion(json, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            print("网络请求错误 \(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }
}
```

调整后的`HQAViewController`中加载数据的代码

```swift
let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
let para = ["access_token": "2.00It5tsGQ6eDJE4ecbf2d825DCpbBD"]

//        HQNetWorkManager.shared.get(urlString, parameters: para, progress: nil, success: { (_, json) in
//            print(json ?? "")
//        }) { (_, error) in
//            print(error)
//        }
HQNetWorkManager.shared.request(URLString: urlString, parameters: para) { (json, isSuccess) in
    print(json ?? "")
}
```

#### 利用`extension`封装项目中网络请求方法

在`HQAViewController`中的网络请求方法虽然进行了一些封装，但是还是要在控制器中填写`urlString`和`para`，如果能把这些也直接封装到一个便于管理的地方，就更好了。这样，当我们偶一个网络接口的`url`或者`para`有变化的话，我们不用花费很长的时间去苦苦寻找到底是在那个`Controller`中。

还有就是，返回的数据格式是这样的

```data
{
    ad =     (
    );
    advertises =     (
    );
    "has_unread" = 0;
    hasvisible = 0;
    interval = 2000;
    "max_id" = 4130532835237793;
    "next_cursor" = 4130532835237793;
    "previous_cursor" = 0;
    "since_id" = 4130540976425281;
    statuses =     (
                {
            "attitudes_count" = 0;
            "biz_feature" = 0;
            "bmiddle_pic" = "http://wx3.sinaimg.cn/bmiddle/9603cdd7ly1fhmz6ui42tj20l414a0w7.jpg";
            "comment_manage_info" =             {
                "comment_permission_type" = "-1";
            };
            "comments_count" = 0;
            "created_at" = "Mon Jul 17 16:46:13 +0800 2017";
```

其实，只有`statuses`对应的数组才是我们需要的微博数据，其它的对于我们来说，暂时都是没有用的。一般的公司开发中，也返回类似的格式，只不过没有微博这么复杂罢了。

因此，如果能直接给控制器提供`statuses`的数据就最好了，`controller`直接拿到最有用的数据，而且包装又少了一层。字典转模型也方便一层。

```swift
extension HQNetWorkManager {
    
    /// 微博数据字典数组
    ///
    /// - Parameter completion: 微博字典数组/是否成功
    func statusList(completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let para = ["access_token": "2.00It5tsGQ6eDJE4ecbf2d825DCpbBD"]
        
        request(URLString: urlString, parameters: para) { (json, isSuccess) in
            /*
             从`json`中获取`statuses`字典数组
             如果`as?`失败,`result = nil`
             */
            let result = (json as AnyObject)["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
}
```

注意：

如果你下面这句话这样写，像`objective-c`那样写`json["statuses"]`就会报错的。

```swift
let result = json["statuses"] as? [[String: AnyObject]]
```

报如下错误：

```error
Type 'Any?' has no subscript members
```

需要改成这样

```swift
let result = (json as AnyObject)["statuses"] as? [[String: AnyObject]]
```

接下来，控制器中`HQAViewController`的代码就可以简化成这样

```swift
HQNetWorkManager.shared.statusList { (list, isSuccess) in
    print(list ?? "")
}
```

至此，`HQAViewController`中拿到的就是最有用的数组数据，下一步就直接字典转模型就可以了。和之前把网络请求`url`和`para`都放在`controller`相比，是不是，控制器轻松了一点呢！

#### 封装`Token`

项目中，所有的网络请求，除了登陆以外，基本都需要`token`，因此，如果我们能将`token`封装起来，以后传参数的时候，不用再考虑`token`相关的问题就最好了。

`HQNetWorkManager`中新建一个`tokenRequest`方法，该方法只是把之前的`request`方法调用一下，同时把`token`增加到该方法里。使得在专门处理网络请求的方法里`HQNetWorkManager+Extension`不用再去考虑`token`相关的问题了。

```swift
/// token
var accessToken: String? = "2.00It5tsGQ6eDJE4ecbf2d825DCpbBD"

/// 带`token`的网络请求方法
func tokenRequest(method: HQHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
    
    guard let token = accessToken else {
        print("没有 token 需要重新登录")
        completion(nil, false)
        return
    }
    
    var parameters = parameters
    
    if parameters == nil {
        parameters = [String: AnyObject]()
    }
    
    parameters!["access_token"] = token as AnyObject
    
    request(URLString: URLString, parameters: parameters, completion: completion)
}
```

这样封装以后，在`HQNetWorkManager+Extension`中不再需要考虑`token`相关的问题，并且对`controller`代码无侵害。

#### token 过期处理

因为`token`存在时效性，因此我们需要对其判断是否有效，如果`token`过期需要让用户重新登录，或者进行其它页面的跳转等操作。

假如`token`过期，我们仍然向服务器请求数据，那么就会报错

```response
Error Domain=com.alamofire.error.serialization.response Code=-1011 
"Request failed: forbidden (403)"
UserInfo={
    com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x608000225bc0> 
        { 
            URL: https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00It5tsGQ6eDJE4ecbf2d825DCpbBD111 
            
        } 
{ 
    status code: 403, 
        headers {
            "Content-Encoding" = gzip;
            "Content-Type" = "application/json;charset=UTF-8";
            Date = "Tue, 18 Jul 2017 07:54:51 GMT";
            Server = "nginx/1.6.1";
            Vary = "Accept-Encoding";
    }
}, 
NSErrorFailingURLKey=https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00It5tsGQ6eDJE4ecbf2d825DCpbBD111,
com.alamofire.serialization.response.error.data=<7b226572 726f7222 3a22696e 76616c69 645f6163 63657373 5f746f6b 656e222c 22657272 6f725f63 6f646522 3a323133 33322c22 72657175 65737422 3a222f32 2f737461 74757365 732f686f 6d655f74 696d656c 696e652e 6a736f6e 227d>, 
NSLocalizedDescription=Request failed: forbidden (403)}
```

我们需要在网络请求失败的时候做个处理

```swift
let failure = { (task: URLSessionDataTask?, error: Error)->() in
    
    if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
        print("token 过期了")
        
        // FIXME: 发送通知,提示用户再次登录
    }
    
    print("网络请求错误 \(error)")
    completion(nil, false)
}
```

#### 建立微博数据模型

`HQStatus.swift`中简单定义两个属性

```swift
import YYModel

/// 微博数据模型
class HQStatus: NSObject {
    
    /*
     `Int`类型,在`64`位的机器是`64`位,在`32`位的机器是`32`位
     如果不写明`Int 64`在 iPad 2 / iPhone 5/5c/4s/4 都无法正常运行
     */
    /// 微博ID
    var id: Int64 = 0
    
    /// 微博信息内容
    var text: String?
    
    override var description: String {
        
        return yy_modelDescription()
    }
}
```

#### 建立视图模型，封装加载微博数据方法

`viewModel`的使命

- 字典转模型逻辑
- 上拉 / 下拉数据处理逻辑
- 下拉刷新数据数量
- 本地缓存数据处理

初体验

因为`MVVM`在`swift`中都是没有父类的，所以先说下关于父类的选择问题

- 如果分类需要使用`KVC`或者字典转模型框架设置对象时,类就需要继承自`NSObject`
- 如果类只是包装一些代码逻辑(写了一些函数),可以不用继承任何父类,好处: 更加轻量级

`HQStatusListViewModel.swift`不继承任何父类

```swift
/// 微博数据列表视图模型
class HQStatusListViewModel {
    
    lazy var statusList = [HQStatus]()
    
    func loadStatus(completion: @escaping (_ isSuccess: Bool)->()) {
        
        HQNetWorkManager.shared.statusList { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: HQStatus.classForCoder(), json: list ?? []) as? [HQStatus] else {
                
                completion(isSuccess)
                
                return
            }
            
            self.statusList += array
            
            completion(isSuccess)
        }
    }
}
```

然后`HQAViewController`中加载数据的代码就可以简化成这样

```swift
fileprivate lazy var listViewModel = HQStatusListViewModel()

/// 加载数据
override func loadData() {

    listViewModel.loadStatus { (isSuccess) in
        self.refreshControl?.endRefreshing()
        self.isPullup = false
        self.tableView?.reloadData()
    }
}
```

`tableViewDataSource`中直接调用`HQStatusListViewModel`中数据即可

```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listViewModel.statusList.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
    return cell
}
```

接下来运行程序应该能看到这样的界面，目前由于没有处理下拉/下拉加载处理，因此只能看到20条微博数据。

![](http://upload-images.jianshu.io/upload_images/2069062-94c4e8903b4893b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**DEMO传送门：[HQSwiftMVVM](https://github.com/hongqingWang/HQSwiftMVVM)**

参考：
1. [Swift 3 :Closure use of non-escaping parameter may allow it to escape](https://stackoverflow.com/questions/42214840/swift-3-closure-use-of-non-escaping-parameter-may-allow-it-to-escape)
2. [Swift 3必看：@noescape走了， @escaping来了](http://www.jianshu.com/p/120069d493f5)
