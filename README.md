# 仓库描述

基于 extended_image 5.1.3 版本中 一个异常的最小 demo

#### 异常表现

<img src="异常表现.gif" alt="异常表现" style="zoom:33%;" />

#### 异常堆栈

```
The relevant error-causing widget was: 
  MaterialApp MaterialApp:file:///Users/kami/kamis/project/Flutter/extended_image_hero_issue_demo/lib/main.dart:15:12
When the exception was thrown, this was the stack: 
#2      ExtendedRawImage.createRenderObject (package:extended_image/src/image/raw_image.dart:50:9)
#3      RenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5533:28)
...     Normal element mounting (10 frames)
#13     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3673:14)
#14     Element.updateChild (package:flutter/src/widgets/framework.dart:3422:20)
#15     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4690:16)
#16     Element.rebuild (package:flutter/src/widgets/framework.dart:4355:5)
#17     ProxyElement.update (package:flutter/src/widgets/framework.dart:5020:5)
#18     Element.updateChild (package:flutter/src/widgets/framework.dart:3412:15)
#19     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4690:16)
#20     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:4840:11)
#21     Element.rebuild (package:flutter/src/widgets/framework.dart:4355:5)
#22     BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2620:33)
#23     WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:882:21)
#24     RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:319:5)
#25     SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1143:15)
#26     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1080:9)
#27     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:996:5)
#31     _invoke (dart:ui/hooks.dart:166:10)
#32     PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:270:5)
#33     _drawFrame (dart:ui/hooks.dart:129:31)
(elided 5 frames from class _AssertionError and dart:async)
```

#### 异常必备条件

1. 图片为gif图
2. 使用了 extended_image 提供的 `heroBuilderForSlidingPage` 设置 `hero`

#### 异常原因

1. gif 的每一帧都会触发重新创建 `ExtendedRawImage` ，`imageInfo` 储存在 `ExtendedRawImage` 中 , `heroBuilderForSlidingPage` 的参数 `Widget`(实际是ExtendedRawImage) 仅有某一帧的 gif 信息。

2. hero 本质上是用在新的节点用传入的 `child` 参数重新绘制视图

综上在使用 gif 图片的时候传递给 hero 的仅是某一帧的 `ExtendedRawImage` 在 hero 做动画的时候 `imageInfo` 因为原始图片已经播放到后面几帧，被dispose了(_ExtendedImageState#_replaceImage)，因此会报上述异常。

