msc lib说明 

ui组件，要求实现一组方便定制皮肤。
ui属于表现层，【注意】mUI强制：在被添加到显示列表时执行本身的init()，在被移除出显示列表时执行destroy()。

mConsole说明
一个简单的控制台程序。
使用时，首先自定义一个mIConsoleDelegate接口的类，这个类里的方法就是mConsole的“命令库”了。
然后在主程序里面通过mConsole.addDelegate(new CustomDelegate());把它添加进去。
打开mConsoleMonitor.swf，就可以用命令行的方式调用CustomDelegate里面的方法了。

TODO List:太多太多了。
BUG List:还没有测试过。