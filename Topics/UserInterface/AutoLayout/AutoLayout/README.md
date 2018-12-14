**优先级**
```
height.priority = .required          // 1000
height.priority = .defaultHigh       // 750
height.priority = .defaultLow        // 250
height.priority = .fittingSizeLevel  // 50
```

---
####  content Hugging & content Compression Resistance

+ 这两个约束存在的条件则是UIView必须指定了 Intrinsic Content Size。 
+ UILabel，UIImageView，UIButton等这些组件及某些包含它们的系统组件都有 Intrinsic Content Size 属性, 尺寸根据具体内容变化,只需定义位置, 使用Intrinsic Content Size。
+ 上述系统控件都重写了UIView 中的 -(CGSize)intrinsicContentSize: 方法。 
并且在需要改变这个值的时候调用：invalidateIntrinsicContentSize 方法，通知系统这个值改变了。

+ 所以当我们在编写继承自UIView的自定义组件时，也想要有Intrinsic Content Size的时候，就可以通过这种方法来轻松实现

+  两个或多个可以使用Intrinsic Content Size的组件，因为组件中添加的其他约束，而无法同时使用 intrinsic Content Size  产生了“Intrinsic冲突”

1. Content Hugging 约束表示：
    如果组件的此属性优先级比另一个组件此属性优先级高的话，那么这个组件就保持不变，另一个可以在需要拉伸的时候拉伸。属性分横向和纵向2个方向。
2. Content Compression Resistance 约束表示：
    如果组件的此属性优先级比另一个组件此属性优先级高的话，那么这个组件就保持不变，另一个可以在需要压缩的时候压缩。属性分横向和纵向2个方向。 意思很明显。上面UIlabel这个例子中，很显然，如果某个UILabel使用Intrinsic Content Size的时候，另一个需要拉伸。 所以我们需要调整两个UILabel的 Content Hugging约束的优先级就可以

```
func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {}

func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {}
```

----
#### SafeArea
> 将视图布局在可访问区域内，不被一些特殊视图覆盖，如：状态栏，导航控制器的导航栏等，尤其是具有顶部头帘和底部横条的iPhone X非常有用
iOS 7 之后苹果给 UIViewController 引入了 topLayoutGuide 和 bottomLayoutGuide 
+ 如果状态栏可见，topLayoutGuide表示状态栏的底部，否则表示这个ViewController的上边缘
iOS 11 开始弃用了这两个属性， 并且引入了 Safe Area 这个概念。
苹果建议: 不要把 Control 放在 Safe Area 之外的地方

```
@available(iOS 11.0, *)
open var safeAreaInsets: UIEdgeInsets { get }

@available(iOS 11.0, *)
open func safeAreaInsetsDidChange()
```

#### UIView SafeArea
`safeAreaInsets`
> 相对于屏幕四个边的间距
```
override func layoutSubviews() {
    super.layoutSubviews()
    if #available(iOS 11.0, *) {
    label.frame = safeAreaLayoutGuide.layoutFrame
    }
}
```

#### UIViewController SafeArea
当 view controller 的子视图覆盖了嵌入的子 view controller 的视图的时候。比如说， 当 UINavigationController 和 UITabbarController 中的 bar 是半透明(translucent) 状态的时候, 就有 additionalSafeAreaInsets

```
available(iOS 11.0, *)
open var additionalSafeAreaInsets: UIEdgeInsets


```
这两个方法分别是 UIView 和 UIViewController 的 safe area insets 发生改变时调用的方法，
如果需要做一些处理，可以重写这个方法
```
// UIView
@available(iOS 11.0, *)
open func safeAreaInsetsDidChange()

//UIViewController
@available(iOS 11.0, *)
open func viewSafeAreaInsetsDidChange()
```


#### UIScrollView SafeArea

iOS 7 中引入 UIViewController 的 automaticallyAdjustsScrollViewInsets 属性在 iOS11 中被废弃掉了。取而代之的是 UIScrollView 的 contentInsetAdjustmentBehavior
```
@available(iOS 11.0, *)
public enum UIScrollViewContentInsetAdjustmentBehavior : Int {    
case automatic          //这是默认值。当下面的条件满足时， 它跟 always 是一个意思
case scrollableAxes     //scrollableAxes content insets 只会针对 scrollview 滚动方向做调整
case never              //
case always             //always content insets 会针对两个方向都做调整
}

@available(iOS 11.0, *)
open var contentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentBehavior
```
always
+ 能够水平滚动，不能垂直滚动
+ scroll view 是 当前 view controller 的第一个视图
+ 这个controller 是被navigation controller 或者 tab bar controller 管理的
+ automaticallyAdjustsScrollViewInsets 为 true

在 iOS 11 中 scroll view 实际的 content inset 可以通过 adjustedContentInset 获取。
这就是说如果你要适配 iOS 10 的话。这一部分的逻辑是不一样的

系统还提供了两个方法来监听这个属性的改变
```
//UIScrollView
@available(iOS 11.0, *)
open func adjustedContentInsetDidChange()

//UIScrollViewDelegate
@available(iOS 11.0, *)
optional public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
```

#### UITableView  SafeArea
```
@available(iOS 11.0, *)
open var insetsContentViewsToSafeArea: Bool
```
默认值是 true 自动适配


####  UICollectionView SafeArea

```
@available(iOS 11.0, *)
public enum UICollectionViewFlowLayoutSectionInsetReference : Int {
    case fromContentInset
    case fromSafeArea
    case fromLayoutMargins
}
@available(iOS 11.0, *)
open var sectionInsetReference: UICollectionViewFlowLayoutSectionInsetReference
```
系统默认是使用 .fromContentInset

