[如果此项目能帮助到你，就请你给一颗星。谢谢！(If this project can help you, please give it a star. Thanks!)](https://github.com/chenxing640/HUD_Demo)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/chenxing640/HUD_Demo/raw/master/images/g614799921.jpg" width="30%" />
</div>

## Preview

<div align=left>
&emsp; <img src="https://github.com/chenxing640/HUD_Demo/raw/master/images/HudPreview.gif" width="30%" />
</div>

## HUD_Demo

MBProgressHUD 的使用演示，自定义 DYFIndefiniteAnimatedView，DYFDesignSpinner 和 DYFMaterialDesignSpinner 等指示器替换 MBProgressHUD 默认的指示器。

## Usage

- 导入头文件 (Import Headers)

```
#import "MBProgressHUD.h"
#import "DYFIndefiniteAnimatedView.h"
#import "DYFDesignSpinner.h"
#import "DYFMaterialDesignSpinner.h"
```

- MBProgressHUD

```
- (void)configureHUDAddedTo:(UIView *)view onlyText:(NSString *)onlyText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (view) {
        hud.mode       = MBProgressHUDModeCustomView;
        hud.customView = view;
    } else if (onlyText.length > 0) {
        hud.mode       = MBProgressHUDModeText;
        hud.yOffset    = 0.f;
    }

    hud.removeFromSuperViewOnHide = YES;

    if (onlyText.length > 0) {

        //hud.opacity     = 0.6f;
        hud.labelFont     = [UIFont boldSystemFontOfSize:14.f];
        hud.labelText     = onlyText;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.labelColor    = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
        hud.labelColor    = [UIColor whiteColor];

    } else {

        hud.opacity       = 0.75f;
        hud.labelFont     = [UIFont boldSystemFontOfSize:14.f];
        //hud.color       = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        hud.labelText     = @"支付请求中...";
        hud.labelColor    = [UIColor whiteColor];
        //hud.labelColor  = [UIColor blackColor];
        //hud.labelColor  = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
        hud.animationType = MBProgressHUDAnimationZoom;
    }
}
```

- DYFIndefiniteAnimatedView + MBProgressHUD

```
DYFIndefiniteAnimatedView *spinner = [[DYFIndefiniteAnimatedView alloc] init];
spinner.frame     = CGRectMake(0, 0, 40, 40);
spinner.radius    = CGRectGetWidth(spinner.bounds)/2;
spinner.lineWidth = 2.f;
spinner.lineColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
spinner.maskImage = [UIImage imageNamed:@"angle-mask"];
[self configureHUDAddedTo:spinner onlyText:nil];
```

- DYFDesignSpinner + MBProgressHUD

```
DYFDesignSpinner *spinner = [DYFDesignSpinner spinnerWithSize:DYFDesignSpinnerSizeLarge color:[UIColor whiteColor]];
spinner.isAnimating = YES;
spinner.hasGlow     = YES;
[self configureHUDAddedTo:spinner onlyText:nil];
```

- DYFMaterialDesignSpinner + MBProgressHUD

```
DYFMaterialDesignSpinner *spinner = [[DYFMaterialDesignSpinner alloc] init];
spinner.frame     = CGRectMake(0, 0, 40, 40);
spinner.lineColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
spinner.lineWidth = 2.f;
[spinner startAnimating];
[self configureHUDAddedTo:spinner onlyText:nil];
```

## Code Sample

- [Code Sample Portal](https://github.com/chenxing640/HUD_Demo/blob/master/HUD/Basic%20Files/RootViewController.m)
