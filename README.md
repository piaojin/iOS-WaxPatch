# iOS-WaxPatch
* wax基于阿里巴巴维护的版本！
* wax安装参考http://www.cnblogs.com/piaojin/p/5588433.html
* lua调用ios中的语法参考http://www.cnblogs.com/piaojin/p/5588465.html和https://github.com/alibaba/wax

# *调用注意点*
* wax不支持oc的点语法所以在调用@property修饰的属性时需要实现该属性的getter(有时候要setter),并且调用该属性是调用其对应的getter
* 例如：
      有@property(nonatomic,strong)PJModel *model，则调用时self:model()而不是self:model，并且model的getter方法已经实现。
* 要修改任意类参考http://www.cnblogs.com/piaojin/p/5591078.html
