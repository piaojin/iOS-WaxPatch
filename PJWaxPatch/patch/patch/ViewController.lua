waxClass{"ViewController", UIViewController}

function initView(self)

    self:textView():setBackgroundColor(UIColor:orangeColor())
    self:textView():setText("通过waxpatch修改颜色后")

end

function updateCustomeView(self)

    self:pjView():updateView()
    self:pjView():showPrompt(self:model())
    --动态添加label
    local label = UILabel:initWithFrame(CGRect(0,65,200,60))
    label:setText("动态添加的label")
    self:pjView():addSubview(label)
    
end